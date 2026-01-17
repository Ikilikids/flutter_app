import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// getWeekNumber はHighScoreManagerとRankingManagerの両方で使うのでトップレベルに配置
int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final daysOffset = firstDayOfYear.weekday - DateTime.monday;
  final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
  return ((date.difference(firstMonday).inDays) / 7).ceil();
}

bool isBetter(num newScore, num prevScore) {
  if (prevScore == 0) return true;
  return newScore < prevScore; // タイム系
}

class CommonHighScoreManager {
  static final _firestore = FirebaseFirestore.instance;

  /// ユーザーの自己ベスト（users配下はそのまま）
  static Future<double> getHighScore(
    String quizId, {
    required bool isLimitedMode,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final jName = isLimitedMode ? 'highscores_g' : 'highscores_t';

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection(jName)
        .doc(quizId)
        .get();

    final score = doc.data()?['score'];
    return score is num ? score.toDouble() : 0.0;
  }

  /// ランキング upsert（v2）
  static Future<void> _upsertRanking({
    required String rankingType,
    required String quizId,
    required String period,
    required int year,
    int? month,
    int? week,
    required String uid,
    required String userName,
    required double score,
  }) async {
    final query = await _firestore
        .collection('rankings_v2')
        .where('rankingType', isEqualTo: rankingType)
        .where('quizId', isEqualTo: quizId)
        .where('period', isEqualTo: period)
        .where('year', isEqualTo: year)
        .where(month != null ? 'month' : 'week', isEqualTo: month ?? week)
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      await _firestore.collection('rankings_v2').add({
        'rankingType': rankingType,
        'quizId': quizId,
        'period': period,
        'year': year,
        'month': month,
        'week': week,
        'uid': uid,
        'userName': userName,
        'score': score,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      final doc = query.docs.first;
      final prev = (doc['score'] as num).toDouble();
      if (isBetter(score, prev)) {
        await doc.reference.update({
          'score': score,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  /// ハイスコア & ランキング更新（完全v2）
  static Future<void> setHighScoreSafe(
    String quizId,
    num score,
    String userName, {
    required bool isLimitedMode,
    required int roundingFactor,
  }) async {
    if (score <= 0) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final rounded = (score * roundingFactor).roundToDouble() / roundingFactor;

    final rankingType = isLimitedMode ? 'g' : 't';
    final jName = isLimitedMode ? 'highscores_g' : 'highscores_t';

    // 🔹 自己ベスト保存
    final userHighScoreRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection(jName)
        .doc(quizId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(userHighScoreRef);
      final prev = (snap.data()?['score'] as num?)?.toDouble() ?? 0.0;

      if (isBetter(rounded, prev)) {
        tx.set(userHighScoreRef, {
          'score': rounded,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });

    // 🔹 rankings_v2（3種）
    await _upsertRanking(
      rankingType: rankingType,
      quizId: quizId,
      period: 'all',
      year: now.year,
      uid: user.uid,
      userName: userName,
      score: rounded,
    );

    await _upsertRanking(
      rankingType: rankingType,
      quizId: quizId,
      period: 'monthly',
      year: now.year,
      month: now.month,
      uid: user.uid,
      userName: userName,
      score: rounded,
    );

    await _upsertRanking(
      rankingType: rankingType,
      quizId: quizId,
      period: 'weekly',
      year: now.year,
      week: getWeekNumber(now),
      uid: user.uid,
      userName: userName,
      score: rounded,
    );

    // 🔁 制限 → 通常へ昇格
    if (isLimitedMode) {
      final normal = await getHighScore(quizId, isLimitedMode: false);
      if (isBetter(rounded, normal)) {
        await setHighScoreSafe(
          quizId,
          rounded,
          userName,
          isLimitedMode: false,
          roundingFactor: roundingFactor,
        );
      }
    }
  }
}

class CommonRankingManager {
  static final _firestore = FirebaseFirestore.instance;

  /// period: "all" | "monthly" | "weekly"
  static Future<List<Map<String, dynamic>>> getRanking(
    String quizId,
    String period, {
    required bool isLimitedMode,
  }) async {
    final now = DateTime.now();

    Query q = _firestore
        .collection('rankings_v2')
        .where('rankingType', isEqualTo: isLimitedMode ? 'g' : 't')
        .where('quizId', isEqualTo: quizId)
        .where('period', isEqualTo: period)
        .where('year', isEqualTo: now.year);

    if (period == 'monthly') {
      q = q.where('month', isEqualTo: now.month);
    }
    if (period == 'weekly') {
      q = q.where('week', isEqualTo: getWeekNumber(now));
    }

    final snap = await q.orderBy('score').limit(50).get();

    return snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      return {
        'userName': data['userName'],
        'score': (data['score'] as num).toDouble(),
        'date': (data['updatedAt'] as Timestamp?)?.toDate(),
      };
    }).toList();
  }

  static Future<int> getMyRank(
    String quizId,
    String period,
    num myScore, {
    required bool isLimitedMode,
  }) async {
    if (myScore <= 0) return 0;

    final now = DateTime.now();

    Query q = _firestore
        .collection('rankings_v2')
        .where('rankingType', isEqualTo: isLimitedMode ? 'g' : 't')
        .where('quizId', isEqualTo: quizId)
        .where('period', isEqualTo: period)
        .where('year', isEqualTo: now.year);

    if (period == 'monthly') {
      q = q.where('month', isEqualTo: now.month);
    }
    if (period == 'weekly') {
      q = q.where('week', isEqualTo: getWeekNumber(now));
    }

    final snap = await q.where('score', isLessThan: myScore).count().get();

    return (snap.count ?? 0) + 1;
  }
}

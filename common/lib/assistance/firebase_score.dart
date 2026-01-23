import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// getWeekNumber はHighScoreManagerとRankingManagerの両方で使うのでトップレベルに配置
int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final daysOffset = firstDayOfYear.weekday - DateTime.monday;
  final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
  return ((date.difference(firstMonday).inDays) / 7).ceil();
}

bool isBetter(num newScore, num prevScore, bool isDescending) {
  if (prevScore == 0) return true;
  print(isDescending);
  return isDescending
      ? newScore > prevScore // タイム系（小さい方が良い）
      : newScore < prevScore; // スコア系（大きい方が良い）
}

class CommonHighScoreManager {
  static final _firestore = FirebaseFirestore.instance;

  /// ユーザーの自己ベスト（users配下はそのまま）
  static Future<double> getHighScore(
    String quizId,
    String rankingType,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final jName = 'highscores_${rankingType}';

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
    required bool isDescending,
    required bool isbattle,
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
      if (!isbattle) {
        await doc.reference.update({
          'score': score + prev,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (isBetter(score, prev, isDescending)) {
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
    String rankingId,
    num score,
    String userName,
    String rankingType, {
    required bool isLimitedMode,
    required int roundingFactor,
    required bool isDescending,
    required bool isbattle,
  }) async {
    if (score <= 0) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final now = DateTime.now();
    final rounded = (score * roundingFactor).roundToDouble() / roundingFactor;

    final jName = 'highscores_${rankingType}';

    // 🔹 自己ベスト保存
    final userHighScoreRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection(jName)
        .doc(quizId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(userHighScoreRef);
      final prev = (snap.data()?['score'] as num?)?.toDouble() ?? 0.0;
      if (!isbattle) {
        tx.set(userHighScoreRef, {
          'score': rounded + prev,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (isBetter(rounded, prev, isDescending)) {
        tx.set(userHighScoreRef, {
          'score': rounded,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });

    // 🔹 rankings_v2（3種）
    await _upsertRanking(
      rankingType: rankingType,
      quizId: rankingId,
      period: 'all',
      year: now.year,
      uid: user.uid,
      userName: userName,
      score: rounded,
      isDescending: isDescending,
      isbattle: isbattle,
    );

    await _upsertRanking(
      rankingType: rankingType,
      quizId: rankingId,
      period: 'monthly',
      year: now.year,
      month: now.month,
      uid: user.uid,
      userName: userName,
      score: rounded,
      isDescending: isDescending,
      isbattle: isbattle,
    );

    await _upsertRanking(
      rankingType: rankingType,
      quizId: rankingId,
      period: 'weekly',
      year: now.year,
      week: getWeekNumber(now),
      uid: user.uid,
      userName: userName,
      score: rounded,
      isDescending: isDescending,
      isbattle: isbattle,
    );

    // 🔁 制限 → 通常へ昇格
    if (isLimitedMode) {
      final normal = await getHighScore(quizId, "t");
      if (isBetter(rounded, normal, isDescending)) {
        await setHighScoreSafe(
          quizId,
          rankingId,
          rounded,
          userName,
          "t",
          isLimitedMode: false,
          roundingFactor: roundingFactor,
          isDescending: isDescending,
          isbattle: isbattle,
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
    required String rankingtype,
    required bool isDescending,
  }) async {
    final now = DateTime.now();

    Query q = _firestore
        .collection('rankings_v2')
        .where('rankingType', isEqualTo: rankingtype)
        .where('quizId', isEqualTo: quizId)
        .where('period', isEqualTo: period)
        .where('year', isEqualTo: now.year);

    if (period == 'monthly') {
      q = q.where('month', isEqualTo: now.month);
    }
    if (period == 'weekly') {
      q = q.where('week', isEqualTo: getWeekNumber(now));
    }

    final snap =
        await q.orderBy('score', descending: isDescending).limit(50).get();

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
    num myScore,
    String quiztype, {
    required bool isDescending,
  }) async {
    if (myScore <= 0) return 0;

    final now = DateTime.now();

    Query q = _firestore
        .collection('rankings_v2')
        .where('rankingType', isEqualTo: quiztype)
        .where('quizId', isEqualTo: quizId)
        .where('period', isEqualTo: period)
        .where('year', isEqualTo: now.year);

    if (period == 'monthly') q = q.where('month', isEqualTo: now.month);
    if (period == 'weekly') q = q.where('week', isEqualTo: getWeekNumber(now));

    try {
      final snap = isDescending
          ? await q.where('score', isGreaterThan: myScore).count().get()
          : await q.where('score', isLessThan: myScore).count().get();

      print(
          "Query executed. Count of entries matching condition: ${snap.count ?? 0}");
      final rank = (snap.count ?? 0) + 1;
      print("Calculated rank: $rank");
      return rank;
    } catch (e, st) {
      print("Error during Firestore query: $e");
      print(st);
      return 0;
    }
  }
}

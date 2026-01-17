import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// getWeekNumber はHighScoreManagerとRankingManagerの両方で使うのでトップレベルに配置
int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final daysOffset = firstDayOfYear.weekday - DateTime.monday;
  final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
  return ((date.difference(firstMonday).inDays) / 7).ceil();
}

class CommonHighScoreManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ユーザーのハイスコアを取得
  static Future<double> getHighScore(String quizTitle,
      {required bool isLimitedMode}) async {
    String jName = isLimitedMode ? 'highscores_g' : 'highscores_t';
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection(jName)
          .doc(quizTitle)
          .get();

      final score = doc.data()?['score'];
      return score is num ? score.toDouble() : 0.0;
    } catch (e) {
      debugPrint('ハイスコア取得失敗: $e');
      return 0.0;
    }
  }

  /// ハイスコアとランキング（全期間・月間・週間）を同時に更新
  /// ハイスコア更新
  static Future<void> setHighScoreSafe(
      String quizTitle, num score, String userName,
      {required bool isLimitedMode, required int roundingFactor}) async {
    if (score <= 0) {
      // タイムアタックで0秒は無意味 → 保存しない
      debugPrint("タイムアタック: score=0 は保存しません");
      return;
    }

    String jName = isLimitedMode ? 'highscores_g' : 'highscores_t';
    String rankingName = isLimitedMode ? 'rankings_g' : 'rankings_t';
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final now = DateTime.now();
    final monthKey = "${now.year}-${now.month}";
    final weekKey = "${now.year}-${getWeekNumber(now)}";

    final userHighScoreRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection(jName)
        .doc(quizTitle);

    final alltimeRef = _firestore
        .collection(rankingName)
        .doc(quizTitle)
        .collection('alltime')
        .doc(user.uid);

    final monthlyRef = _firestore
        .collection(rankingName)
        .doc(quizTitle)
        .collection('monthly-$monthKey')
        .doc(user.uid);

    final weeklyRef = _firestore
        .collection(rankingName)
        .doc(quizTitle)
        .collection('weekly-$weekKey')
        .doc(user.uid);

    // 指定された単位で丸める
    final roundedScore =
        (score * roundingFactor).roundToDouble() / roundingFactor;

    await _firestore.runTransaction((tx) async {
      final userSnap = await tx.get(userHighScoreRef);
      final alltimeSnap = await tx.get(alltimeRef);
      final monthSnap = await tx.get(monthlyRef);
      final weekSnap = await tx.get(weeklyRef);

      final prevScore = (userSnap.data()?['score'] as num?)?.toDouble() ?? 0.0;
      final prevAll = (alltimeSnap.data()?['score'] as num?)?.toDouble() ?? 0.0;
      final prevMonth = (monthSnap.data()?['score'] as num?)?.toDouble() ?? 0.0;
      final prevWeek = (weekSnap.data()?['score'] as num?)?.toDouble() ?? 0.0;

      if (isBetter(roundedScore, prevScore)) {
        tx.set(userHighScoreRef, {
          'score': roundedScore,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      if (isBetter(roundedScore, prevAll)) {
        tx.set(alltimeRef, {
          'userName': userName,
          'score': roundedScore,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      if (isBetter(roundedScore, prevMonth)) {
        tx.set(monthlyRef, {
          'userName': userName,
          'score': roundedScore,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      if (isBetter(roundedScore, prevWeek)) {
        tx.set(weeklyRef, {
          'userName': userName,
          'score': roundedScore,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });

    if (isLimitedMode) {
      final normalHighScore =
          await getHighScore(quizTitle, isLimitedMode: false);
      if (isBetter(roundedScore, normalHighScore)) {
        await setHighScoreSafe(quizTitle, roundedScore, userName,
            isLimitedMode: false,
            roundingFactor: roundingFactor); // 再帰呼び出し時もroundingFactorを渡す
      }
    }
  }
}

bool isBetter(num newScore, num prevScore) {
  if (prevScore == 0.0) return true; // 初回登録
  return newScore < prevScore; // タイムは小さい方
}

class CommonRankingManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// period: '月間' / '全期間' / '週間'
  static Future<List<Map<String, dynamic>>> getRanking(
      String quizTitle, String period,
      {required bool isLimitedMode}) async {
    String rankingName = isLimitedMode ? 'rankings_g' : 'rankings_t';
    try {
      CollectionReference col;

      if (period == '月間') {
        final now = DateTime.now();
        final monthKey = "${now.year}-${now.month}";
        col = _firestore
            .collection(rankingName)
            .doc(quizTitle)
            .collection('monthly-$monthKey');
      } else if (period == '週間') {
        final now = DateTime.now();
        final weekOfYear = getWeekNumber(now);
        final weekKey = "${now.year}-$weekOfYear";
        col = _firestore
            .collection(rankingName)
            .doc(quizTitle)
            .collection('weekly-$weekKey');
      } else {
        // 全期間
        col = _firestore
            .collection(rankingName)
            .doc(quizTitle)
            .collection('alltime');
      }

      final snapshot = await col
          .orderBy('score', descending: false)
          .limit(50) // ← 上位50件だけ
          .get();

      final ranking = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'userName': data['userName'] ?? '名無し',
          'score': (data['score'] as num?)?.toDouble() ?? 0.0,
          'date': (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      return ranking;
    } catch (e) {
      debugPrint('ランキング取得失敗: $e');
      return [];
    }
  }

  static Future<int> getMyRank(
    String quizTitle,
    String period,
    num myScore, {
    required bool isLimitedMode,
  }) async {
    if (myScore <= 0) return 0;

    String rankingName = isLimitedMode ? 'rankings_g' : 'rankings_t';
    CollectionReference col;

    final now = DateTime.now();

    if (period == '月間') {
      final monthKey = "${now.year}-${now.month}";
      col = FirebaseFirestore.instance
          .collection(rankingName)
          .doc(quizTitle)
          .collection('monthly-$monthKey');
    } else if (period == '週間') {
      final weekKey = "${now.year}-${getWeekNumber(now)}";
      col = FirebaseFirestore.instance
          .collection(rankingName)
          .doc(quizTitle)
          .collection('weekly-$weekKey');
    } else {
      col = FirebaseFirestore.instance
          .collection(rankingName)
          .doc(quizTitle)
          .collection('alltime');
    }

    // 自分より良いスコアの人数を数える
    final snap = await col.where('score', isLessThan: myScore).count().get();

    return (snap.count ?? 0) + 1;
  }
}

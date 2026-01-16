import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HighScoreManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ユーザーのハイスコアを取得
  static Future<int> getHighScore(String quizTitle, bool j) async {
    String jName = j ? 'highscores' : 'correctcsores';
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection(jName)
          .doc(quizTitle)
          .get();

      return doc.data()?['score'] ?? 0;
    } catch (e) {
      debugPrint('ハイスコア取得失敗: $e');
      return 0;
    }
  }

  /// ハイスコアとランキング（全期間・月間・週間）を同時に更新
  static Future<void> setHighScore(
      String quizTitle, int score, String userName, bool j) async {
    String jName = j ? 'highscores' : 'correctcsores';
    String rankingName = j ? 'rankings' : 'rankings_r';
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

    await _firestore.runTransaction((tx) async {
      // 1. まず全て read
      final userSnap = await tx.get(userHighScoreRef);
      final alltimeSnap = await tx.get(alltimeRef);
      final monthSnap = await tx.get(monthlyRef);
      final weekSnap = await tx.get(weeklyRef);

      final prevScore = userSnap.data()?['score'] ?? 0;
      final prevAll = alltimeSnap.data()?['score'] ?? 0;
      final prevMonth = monthSnap.data()?['score'] ?? 0;
      final prevWeek = weekSnap.data()?['score'] ?? 0;

      // 2. まとめて write（より高いスコアのみ更新）
      if (j) {
        if (score > prevScore) {
          tx.set(userHighScoreRef, {
            'score': score,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
        if (score > prevAll) {
          tx.set(alltimeRef, {
            'userName': userName,
            'score': score,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
        if (score > prevMonth) {
          tx.set(monthlyRef, {
            'userName': userName,
            'score': score,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
        if (score > prevWeek) {
          tx.set(weeklyRef, {
            'userName': userName,
            'score': score,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
      if (!j) {
        tx.set(userHighScoreRef, {
          'score': prevScore + score,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        tx.set(alltimeRef, {
          'userName': userName,
          'score': prevAll + score,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        tx.set(monthlyRef, {
          'userName': userName,
          'score': prevMonth + score,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        tx.set(weeklyRef, {
          'userName': userName,
          'score': prevWeek + score,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}

class RankingManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// period: '月間' / '全期間' / '週間'
  static Future<List<Map<String, dynamic>>> getRanking(
      String quizTitle, String period, bool j) async {
    String rankingName = j ? 'rankings' : 'rankings_r';
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

      final snapshot = await col.get();
      final ranking = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'userName': data['userName'] ?? '名無し',
          'score': data['score'] ?? 0,
          'date': (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      ranking.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
      return ranking;
    } catch (e) {
      debugPrint('ランキング取得失敗: $e');
      return [];
    }
  }
}

int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final daysOffset = firstDayOfYear.weekday - DateTime.monday;
  final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
  return ((date.difference(firstMonday).inDays) / 7).ceil();
}

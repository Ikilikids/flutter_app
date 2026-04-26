import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz.dart';

import '../common.dart';

int getWeekNumber(DateTime date) {
  final firstThursday = DateTime(date.year, 1, 4);
  final diff = date.difference(
    firstThursday.subtract(
      Duration(days: firstThursday.weekday - 1),
    ),
  );
  return (diff.inDays / 7).floor() + 1;
}

bool isBetter(num newScore, num prevScore, bool isSmallerBetter) {
  if (prevScore == 0) return true;
  return isSmallerBetter ? newScore < prevScore : newScore > prevScore;
}

// --- 1. 期間管理の整理 ---
enum PeriodType {
  all,
  month,
  week;

  // enum自身に文字列を返すメソッドを持たせる
  String get value {
    final now = DateTime.now();
    return switch (this) {
      PeriodType.all => 'all',
      PeriodType.month =>
        '${now.year}_m${now.month.toString().padLeft(2, '0')}',
      PeriodType.week =>
        '${now.year}_w${getWeekNumber(now).toString().padLeft(2, '0')}',
    };
  }
}

// --- 2. 登録データクラス ---
class ResisterData {
  final String id;
  final PeriodType periodType;
  final double score;
  final bool forceAdd;

  ResisterData({
    required this.id,
    required this.periodType,
    required this.score,
    required this.forceAdd,
  });
}

class ScoreManager {
  static Future<void> updateAllScores({required WidgetRef ref}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;

    final quizinfo = ref.read(currentDetailConfigProvider);
    final modeName = quizinfo.detail.quizId.modeType;
    final resister = quizinfo.detail.quizId.resisterOrigin;
    final isBattle = quizinfo.modeData.isbattle;
    final isSmallerBetter = quizinfo.modeData.isSmallerBetter;
    final userName = ref.read(appUserNameProvider).requireValue;
    final session = ref.read(quizSessionNotifierProvider);

    // 1. スコア準備
    final double mainScore = switch (quizinfo.timeMode) {
      TimeMode.timeAttack => ref.read(quizElapsedTimerProvider).toDouble(),
      _ => session.totalScore.toDouble(),
    };
    final roundedMain = (mainScore * 100).roundToDouble() / 100;

    // カテゴリスコアの計算（全合計を含む）
    final total = session.categortScore.values.fold(0.0, (s, v) => s + v);
    final allScores = {...session.categortScore, '全合計': total};

    try {
      final batch = FirebaseFirestore.instance.batch();

      // A. メインスコアの保存
      // 順位取得時に使うため、最新の計算後スコアを保持する変数
      double latestMainTotal = 0.0;

      for (var type in PeriodType.values) {
        final rankRef = AppPath.rankingLog(modeName, resister, type, uid);
        final snap = await rankRef.get();
        double prev = (snap.data()?['score'] as num?)?.toDouble() ?? 0.0;

        // バトル以外なら加算、バトル（記録更新系）ならisBetterで判定
        double newScore = !isBattle
            ? (prev + roundedMain)
            : (isBetter(roundedMain, prev, isSmallerBetter)
                ? roundedMain
                : prev);

        if (type == PeriodType.all) latestMainTotal = newScore;

        batch.set(
            rankRef,
            {
              'score': newScore,
              'userName': userName,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));

        if (type == PeriodType.all) {
          batch.set(
              AppPath.userScore(uid, modeName, resister),
              {
                'score': newScore,
                'updatedAt': FieldValue.serverTimestamp(),
              },
              SetOptions(merge: true));
        }
      }

      // B. カテゴリスコアの保存
      final Map<String, double> latestCatTotals = {};

      for (var entry in allScores.entries) {
        final catId = entry.key;
        final catScore = (entry.value * 100).roundToDouble() / 100;

        for (var type in PeriodType.values) {
          // カテゴリ累計は "count" モードの階層に固定
          final rankRef = AppPath.rankingLog("count", catId, type, uid);
          final snap = await rankRef.get();
          double prev = (snap.data()?['score'] as num?)?.toDouble() ?? 0.0;
          double newTotal = prev + catScore;

          if (type == PeriodType.all) latestCatTotals[catId] = newTotal;

          batch.set(
              rankRef,
              {
                'score': newTotal,
                'userName': userName,
                'updatedAt': FieldValue.serverTimestamp(),
              },
              SetOptions(merge: true));

          if (type == PeriodType.all) {
            batch.set(
                AppPath.userScore(uid, "count", catId),
                {
                  'score': newTotal,
                  'updatedAt': FieldValue.serverTimestamp(),
                },
                SetOptions(merge: true));
          }
        }
      }

      // 書き込み実行
      await batch.commit();

      // C. 順位取得 & Provider更新
      final Map<PeriodType, double> finalScores = {};
      final Map<PeriodType, int> finalRanks = {};

      // 順位を計算する対象を決定
      final targetId = isBattle ? resister : '全合計';
      final targetMode = isBattle ? modeName : 'count';
      final targetScoreForRank =
          isBattle ? latestMainTotal : latestCatTotals['全合計']!;

      await Future.wait(PeriodType.values.map((type) async {
        final rankCol =
            AppPath.rankingLog(targetMode, targetId, type, uid).parent;

        final countSnap = isSmallerBetter
            ? await rankCol
                .where('score', isLessThan: targetScoreForRank)
                .count()
                .get()
            : await rankCol
                .where('score', isGreaterThan: targetScoreForRank)
                .count()
                .get();

        final myRank = (countSnap.count ?? 0) + 1;

        finalScores[type] = targetScoreForRank;
        finalRanks[type] = myRank;

        // ローカル更新 (メインスコアかつ全期間のみ)
        if (type == PeriodType.all && isBattle) {
          ref
              .read(scoreNotifierProvider.notifier)
              .updateScoreLocally(quizinfo.detail.quizId, latestMainTotal);
        }
      }));

      // Providerへ最終反映
      ref.read(myScoreMapProvider.notifier).setMap(finalScores);
      ref.read(myRankMapProvider.notifier).setMap(finalRanks);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  static Future<List<RankingEntry>> getRanking({
    required String modeType,
    required String subjectId,
    required PeriodType periodType,
    required bool isSmallerBetter,
  }) async {
    // rankings_v6/{mode}/quizzes/{quizId}/periods/{period}/users コレクションを取得
    final snap =
        await AppPath.rankingLog(modeType, subjectId, periodType, 'dummy')
            .parent // doc(uid) の親である 'users' コレクションを参照
            .orderBy('score', descending: !isSmallerBetter)
            .limit(30)
            .get();

    return snap.docs.map((d) {
      final data = d.data();
      return RankingEntry(
        uid: d.id,
        score: (data['score'] as num).toDouble(),
        userName: data['userName'] ?? 'Unknown',
        date: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  static Future<UserDialogData> getRankingSummary({
    required String uid,
    required String mode, // modeを追加
    required String quizId,
    required bool isSmallerBetter,
  }) async {
    try {
      // 1. 自分のデータを新階層(users2/{uid}/modes/{mode}/quizzes/{quizId})から取得
      final doc = await AppPath.userScore(uid, mode, quizId).get();
      final data = doc.exists ? doc.data() : null;

      final myScore = (data?['score'] as num?)?.toDouble() ?? 0.0;
      final updatedAt = (data?['updatedAt'] as Timestamp?)?.toDate();

      // 2. ランキング（PeriodType.all）の参照
      final rankCol =
          AppPath.rankingLog(mode, quizId, PeriodType.all, 'dummy').parent;

      final futures = <Future>[
        // トップスコア取得
        rankCol.orderBy('score', descending: !isSmallerBetter).limit(1).get(),
      ];

      if (myScore > 0) {
        // 順位カウント
        final rankQuery = isSmallerBetter
            ? rankCol.where('score', isLessThan: myScore).count().get()
            : rankCol.where('score', isGreaterThan: myScore).count().get();
        futures.add(rankQuery);
      }

      final results = await Future.wait(futures);
      final topSnap = results[0] as QuerySnapshot<Map<String, dynamic>>;
      final topScore = topSnap.docs.isNotEmpty
          ? (topSnap.docs.first.data()['score'] as num?)?.toDouble() ?? 0.0
          : 0.0;

      int rank = 0;
      if (myScore > 0 && results.length > 1) {
        final rankSnap = results[1] as AggregateQuerySnapshot;
        rank = (rankSnap.count ?? 0) + 1;
      }

      return UserDialogData(
        score: myScore,
        updatedAt: updatedAt,
        rank: rank,
        topScore: topScore,
      );
    } catch (e) {
      debugPrint('Error in getRankingSummary: $e');
      return UserDialogData.empty();
    }
  }

  // 必要なスコアIDのリストを受け取って、それらだけを一括取得する
  static Future<Map<QuizId, double>> getScoresAll() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final uid = user.uid;
    final Map<QuizId, double> scores = {};

    // アプリで使う可能性のあるモードを「決め打ち」で定義しておく
    // ※ここに含まれていれば、親ドキュメントが空（斜体）でも中身を拾える
    final possibleModes = ['t', 'g', 'battle', 'timeAttack'];

    try {
      await Future.wait(possibleModes.map((mode) async {
        // 親の doc(mode) が空でも、直接その下の collection('quizzes') は叩ける
        final quizzesSnap = await FirebaseFirestore.instance
            .collection('users7')
            .doc(uid)
            .collection('modes')
            .doc(mode) // ここが斜体でもお構いなし
            .collection('quizzes')
            .get();

        for (var doc in quizzesSnap.docs) {
          final score = (doc.data()['score'] as num?)?.toDouble() ?? 0.0;
          scores[QuizId(resisterOrigin: doc.id, modeType: mode)] = score;
        }
      }));
    } catch (e) {
      debugPrint('Error: $e');
    }

    return scores;
  }
}

class UserDialogData {
  final double score;
  final DateTime? updatedAt;
  final int rank;
  final double topScore;

  UserDialogData({
    required this.score,
    this.updatedAt,
    required this.rank,
    required this.topScore,
  });

  // データがない場合のデフォルト値
  factory UserDialogData.empty() => UserDialogData(
        score: 0.0,
        updatedAt: null,
        rank: 0,
        topScore: 0.0,
      );
}

class AppPath {
  // ランキング側のパス: rankings_v6/{mode}/quizzes/{quizId}/periods/{period}/users/{uid}
  static DocumentReference<Map<String, dynamic>> rankingLog(
      String mode, String quizId, PeriodType period, String uid) {
    return FirebaseFirestore.instance
        .collection('rankings_v7')
        .doc(mode)
        .collection('quizzes')
        .doc(quizId)
        .collection('periods')
        .doc(period.value)
        .collection('users')
        .doc(uid);
  }

  // ユーザー側のパス: users2/{uid}/modes/{mode}/quizzes/{quizId}
  static DocumentReference<Map<String, dynamic>> userScore(
      String uid, String mode, String quizId) {
    return FirebaseFirestore.instance
        .collection('users7')
        .doc(uid)
        .collection('modes')
        .doc(mode)
        .collection('quizzes')
        .doc(quizId);
  }
}

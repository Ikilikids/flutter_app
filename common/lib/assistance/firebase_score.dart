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

CollectionReference<Map<String, dynamic>> commonRank(
    String id, PeriodType periodType) {
  return FirebaseFirestore.instance
      .collection('rankings_v5')
      .doc("${id}_${periodType.value}")
      .collection('users');
}

CollectionReference<Map<String, dynamic>> commonUser(String uid) {
  return FirebaseFirestore.instance
      .collection('users2')
      .doc(uid)
      .collection('scores');
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

  // enumのプロパティを直接使うので、外部のMapが不要になる
  DocumentReference<Map<String, dynamic>> rankRef(String uid) {
    return commonRank(id, periodType).doc(uid);
  }

  DocumentReference<Map<String, dynamic>> userRef(String uid) {
    return commonUser(uid).doc(id);
  }
}

class ScoreManager {
  static Future<void> updateAllScores({required WidgetRef ref}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;

    // 基本情報取得
    final quizinfo = ref.read(currentDetailConfigProvider);
    final quizId = quizinfo.detail.quizId;
    final isBattle = quizinfo.modeData.isbattle;
    final isSmallerBetter = quizinfo.modeData.isSmallerBetter;
    final userName = ref.read(appUserNameProvider).requireValue;
    final session = ref.read(quizSessionNotifierProvider);

    final double mainScore = switch (quizinfo.timeMode) {
      TimeMode.timeAttack => ref.read(quizElapsedTimerProvider).toDouble(),
      TimeMode.countDown => session.totalScore.toDouble(),
      TimeMode.learning => session.correctCount.toDouble(),
    };

    final List<ResisterData> registers = [];

    // --- A. データ構築フェーズ (全部リストに詰める) ---

    // 1. メインスコア (クイズ単位)
    final roundedMain = (mainScore * 100).roundToDouble() / 100;
    for (var type in PeriodType.values) {
      registers.add(ResisterData(
        id: quizId.toString(),
        periodType: type,
        score: roundedMain,
        forceAdd: !isBattle,
      ));
    }

    // 2. カテゴリスコア (カテゴリ別 + 全合計をまとめて処理)

    final total = session.categortScore.values.fold(0.0, (s, v) => s + v);
    final allScores = {...session.categortScore, '全合計': total};

    allScores.forEach((catName, catScore) {
      final roundedCat = (catScore * 100).roundToDouble() / 100;
      for (var type in PeriodType.values) {
        registers.add(ResisterData(
          id: '${catName}_t',
          periodType: type,
          score: roundedCat,
          forceAdd: true,
        ));
      }
    });

    // --- B. 書き込み・順位取得フェーズ ---
    final Map<PeriodType, double> scores = {};
    final Map<PeriodType, int> ranks = {};
    final targetIdForReturn = isBattle ? quizId.toString() : '全合計_t';

    try {
      // 全てのリクエストを並列で実行
      await Future.wait(registers.map((data) async {
        // 1. 現在のスコアを取得
        final snap = await data.rankRef(uid).get();
        double prev = (snap.data()?['score'] as num?)?.toDouble() ?? 0.0;
        double newScore = prev;

        if (mainScore > 0) {
          // 2. スコア計算
          newScore = data.forceAdd
              ? prev + data.score
              : (isBetter(data.score, prev, isSmallerBetter)
                  ? data.score
                  : prev);

          // 3. 保存 (Future.wait内なのでこれらも並列)
          final rankSet = data.rankRef(uid).set({
            'score': newScore,
            'userName': userName,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          Future<void>? userSet;

          if (data.periodType == PeriodType.all) {
            userSet = data.userRef(uid).set({
              'score': newScore,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          }

          await Future.wait([
            rankSet,
            if (userSet != null) userSet,
          ]);
        }

        // 4. 順位取得 (targetId かつ PeriodType.all の時だけに限定)
        // もし月間・週間の順位も欲しければ、ここを調整
        if (data.id == targetIdForReturn) {
          final q = commonRank(data.id, data.periodType);
          final countSnap = isSmallerBetter
              ? await q.where('score', isLessThan: newScore).count().get()
              : await q.where('score', isGreaterThan: newScore).count().get();

          scores[data.periodType] = newScore;
          ranks[data.periodType] = (countSnap.count ?? 0) + 1;
        }

        // 5. ローカル更新
        if (data.id == quizId.toString() && data.periodType == PeriodType.all) {
          ref
              .read(userStatusNotifierProvider.notifier)
              .updateScoreLocally(quizId, newScore);
        }
      }));

      // プロバイダー更新
      ref.read(myScoreMapProvider.notifier).setMap(scores);
      ref.read(myRankMapProvider.notifier).setMap(ranks);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  static Future<List<RankingEntry>> getRanking({
    required String rankingId,
    required PeriodType periodType,
    required bool isSmallerBetter,
  }) async {
    final snap = await commonRank(rankingId, periodType)
        .orderBy('score', descending: !isSmallerBetter)
        .limit(30)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      return RankingEntry(
        uid: d.id,
        score: (data['score'] as num).toDouble(),
        userName: data['userName'] ?? 'defaultUsername',
        date: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  static Future<UserDialogData> getRankingSummary({
    required String uid,
    required QuizId quizId,
    required bool isSmallerBetter,
  }) async {
    final docId = quizId.toString();

    try {
      // 1. 自分のデータを取得
      final doc = await commonUser(uid).doc(docId).get();
      final data = doc.exists ? doc.data() : null;

      final myScore = (data?['score'] as num?)?.toDouble() ?? 0.0;
      final updatedAt = (data?['updatedAt'] as Timestamp?)?.toDate();

      // 2. クエリの準備
      final rankingId = quizId.toString();
      final q = commonRank(rankingId, PeriodType.all);

      // 並列実行するリスト
      final futures = <Future>[
        // トップスコアは常に取得する
        q.orderBy('score', descending: !isSmallerBetter).limit(1).get(),
      ];

      // 自分のスコアがある場合のみ、順位計算を追加
      if (myScore > 0) {
        final rankQuery = isSmallerBetter
            ? q.where('score', isLessThan: myScore).count().get()
            : q.where('score', isGreaterThan: myScore).count().get();
        futures.add(rankQuery);
      }

      final results = await Future.wait(futures);

      // 結果の抽出
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
  static Future<Map<String, double>> getScoresByIds(List<String> docIds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || docIds.isEmpty) return {};

    final Map<String, double> scores = {};

    // Firestore の whereIn は一度に 30 件までなので分割して取得
    for (var i = 0; i < docIds.length; i += 30) {
      final chunk =
          docIds.sublist(i, i + 30 > docIds.length ? docIds.length : i + 30);

      final snap = await commonUser(user.uid)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var doc in snap.docs) {
        scores[doc.id] = (doc.data()['score'] as num?)?.toDouble() ?? 0.0;
        print("Fetched score for ${doc.id}: ${scores[doc.id]}");
      }
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

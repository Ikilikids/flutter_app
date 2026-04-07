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

  // enumのプロパティを直接使うので、外部のMapが不要になる
  DocumentReference<Map<String, dynamic>> rankRef(String uid) {
    return FirebaseFirestore.instance
        .collection('rankings_v5')
        .doc("${id}_${periodType.value}") // ここが最高にスッキリする
        .collection('users')
        .doc(uid);
  }

  DocumentReference<Map<String, dynamic>> userRef(String uid) {
    return FirebaseFirestore.instance
        .collection('users2')
        .doc(uid)
        .collection('scores')
        .doc(id);
  }
}

class ScoreManager {
  static final _firestore = FirebaseFirestore.instance;

  static Future<double> getScore(
      {required String resisterOriginOrSub, required String modeType}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final jName = '${resisterOriginOrSub}_$modeType';

    final doc = await FirebaseFirestore.instance
        .collection('users2')
        .doc(user.uid)
        .collection('scores')
        .doc(jName)
        .get();

    if (!doc.exists) return 0;

    return (doc.data()?['score'] as num?)?.toDouble() ?? 0;
  }

  static Future<double> getTopScore({
    required String resisterOrigin,
    required String modeType,
    required bool isSmallerBetter,
  }) async {
    final rankingId = "${resisterOrigin}_${modeType}_all";
    final snap = await _firestore
        .collection('rankings_v5')
        .doc(rankingId)
        .collection('users')
        .orderBy('score', descending: !isSmallerBetter)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return 1000.0;
    return (snap.docs.first.data()['score'] as num).toDouble();
  }

  static Future<Map<PeriodType, double>> updateAllScores(
      {required WidgetRef ref}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {for (var t in PeriodType.values) t: 0.0};
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
    if (session.categortScore.isNotEmpty) {
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
    }

    // --- B. 書き込みフェーズ (トランザクション) ---
    // 結果格納用のMap
    final Map<PeriodType, double> results = {};
    // どのIDの結果を返すべきか決めておく
    final targetIdForReturn = isBattle ? quizId.toString() : '全合計_t';

    try {
      await _firestore.runTransaction((tx) async {
        // --- Readフェーズ (一括) ---
        final Map<ResisterData, DocumentSnapshot<Map<String, dynamic>>>
            snapshots = {};
        for (final data in registers) {
          snapshots[data] = await tx.get(data.rankRef(uid));
        }

        // --- Write & Map詰め込みフェーズ ---
        for (final data in registers) {
          final snap = snapshots[data]!;
          double prev = (snap.data()?['score'] as num?)?.toDouble() ?? 0.0;
          double newScore = prev;

          if (mainScore > 0) {
            // 更新ロジック
            newScore = data.forceAdd
                ? prev + data.score
                : (isBetter(data.score, prev, isSmallerBetter)
                    ? data.score
                    : prev);

            // Firestoreへ書き込み
            tx.set(
                data.rankRef(uid),
                {
                  'score': newScore,
                  'userName': userName,
                  'updatedAt': FieldValue.serverTimestamp(),
                },
                SetOptions(merge: true));

            tx.set(
                data.userRef(uid),
                {
                  'score': newScore,
                  'updatedAt': FieldValue.serverTimestamp(),
                },
                SetOptions(merge: true));
          }

          // ★ ここで結果のMapを埋める (targetIdForReturnに一致するものだけ)
          if (data.id == targetIdForReturn) {
            results[data.periodType] = newScore;
          }

          // ローカル更新 (全期間のメインスコアのみ)
          if (data.id == quizId.toString() &&
              data.periodType == PeriodType.all) {
            ref
                .read(userStatusNotifierProvider.notifier)
                .updateScoreLocally(quizId, newScore);
          }
        }
      });

      return results;
    } catch (e) {
      debugPrint('Error: $e');
      return {for (var t in PeriodType.values) t: 0.0};
    }
  }

  static Future<List<RankingEntry>> getRanking({
    required String rankingId,
    required bool isSmallerBetter,
  }) async {
    final snap = await FirebaseFirestore.instance
        .collection('rankings_v5')
        .doc(rankingId)
        .collection('users')
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

  static Future<Map<PeriodType, int>> getMyRank({
    required QuizId quizId,
    required Map<PeriodType, double> myScoreMap,
    bool isBattle = true,
    required bool isSmallerBetter,
    List<PeriodType>? targetPeriods, // Enumのリストとして復活
  }) async {
    final Map<PeriodType, int> ranks = {};

    // 指定があればそれを使う、なければEnumの全種類を使う
    final periodsToCalculate = targetPeriods ?? PeriodType.values;

    for (var type in periodsToCalculate) {
      final myScore = myScoreMap[type] ?? 0.0;

      // スコアが0の場合は順位を計測せず0とする
      if (myScore <= 0) {
        ranks[type] = 0;
        continue;
      }

      // ID構築
      final rankingId = isBattle
          ? "${quizId.toString()}_${type.value}"
          : "全合計_t_${type.value}";

      final q = _firestore
          .collection('rankings_v5')
          .doc(rankingId)
          .collection('users');

      // カウント実行
      final snap = isSmallerBetter
          ? await q.where('score', isLessThan: myScore).count().get()
          : await q.where('score', isGreaterThan: myScore).count().get();

      ranks[type] = (snap.count ?? 0) + 1;
    }

    return ranks;
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

      final snap = await _firestore
          .collection('users2')
          .doc(user.uid)
          .collection('scores')
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

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

List<String> buildPeriod() {
  final now = DateTime.now();
  int year = now.year;
  int month = now.month;
  int week = getWeekNumber(now);

  String periodMonth = '${year}_m${month.toString().padLeft(2, '0')}';
  String periodWeek = '${year}_w${week.toString().padLeft(2, '0')}';
  String periodAll = 'all';

  return [
    periodAll,
    periodMonth,
    periodWeek,
  ];
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

  static Future<List<double>> updateAllScores({
    required double score,
    required String resisterOrigin,
    required String modeType,
    required bool isBattle,
    required bool isSmallerBetter,
    required bool isLimitedMode,
    required int fix,
    required String userName,
    Map<String, int>? categoryScores,
  }) async {
    if (score <= 0 && (categoryScores == null || categoryScores.isEmpty)) {
      return [0, 0, 0];
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [0, 0, 0];

    final uid = user.uid;
    final periods = buildPeriod();

    final Map<DocumentReference, Map<String, dynamic>> refData = {};

    // 👇 追加（結果保持）
    double resultAll = 0;
    double resultMonth = 0;
    double resultWeek = 0;
    double totalAll = 0;
    double totalMonth = 0;
    double totalWeek = 0;

    // --- 1. メイン ---
    final roundedMainScore = (score * fix).roundToDouble() / fix;

    final docId = '${resisterOrigin}_$modeType';
    final userRef = _firestore
        .collection('users2')
        .doc(uid)
        .collection('scores')
        .doc(docId);

    refData[userRef] = {
      'score': roundedMainScore,
      'forceAdd': !isBattle,
    };

    // 👇 ここで period ごとに ref を保持（後で判定に使う）
    final Map<DocumentReference, String> periodMap = {};

    for (var period in periods) {
      final rankRef = _firestore
          .collection('rankings_v5')
          .doc("${docId}_$period")
          .collection('users')
          .doc(uid);

      refData[rankRef] = {
        'score': roundedMainScore,
        'forceAdd': !isBattle,
      };

      periodMap[rankRef] = period; // 👈 追加
    }

    // --- 2. カテゴリ ---
    if (categoryScores != null) {
      double total =
          categoryScores.values.fold(0, (sum, value) => sum + value).toDouble();

      final totalUserRef = _firestore
          .collection('users2')
          .doc(uid)
          .collection('scores')
          .doc('全合計_t');
      refData[totalUserRef] = {'score': total, 'forceAdd': true};

      for (var period in periods) {
        final totalRankRef = _firestore
            .collection('rankings_v5')
            .doc("全合計_t_$period")
            .collection('users')
            .doc(uid);

        refData[totalRankRef] = {'score': total, 'forceAdd': true};

        periodMap[totalRankRef] = period; // 👈 追加
      }

      categoryScores.forEach((catName, catScore) {
        final roundedCatScore = (catScore * fix).roundToDouble() / fix;

        final catUserRef = _firestore
            .collection('users2')
            .doc(uid)
            .collection('scores')
            .doc('${catName}_t');

        refData[catUserRef] = {'score': roundedCatScore, 'forceAdd': true};

        for (var period in periods) {
          final rankRef = _firestore
              .collection('rankings_v5')
              .doc("${catName}_t_$period")
              .collection('users')
              .doc(uid);

          refData[rankRef] = {'score': roundedCatScore, 'forceAdd': true};

          periodMap[rankRef] = period; // 👈 追加
        }
      });
    }

    final allRefs = refData.keys.toList();

    try {
      await _firestore.runTransaction((tx) async {
        final snapshots = <DocumentReference, DocumentSnapshot>{};

        for (final ref in allRefs) {
          snapshots[ref] = await tx.get(ref);
        }

        for (final ref in allRefs) {
          final snapshot = snapshots[ref]!;
          final info = refData[ref]!;

          final targetScore = info['score'] as double;
          final forceAdd = info['forceAdd'] as bool;

          double newScore;

          if (!snapshot.exists) {
            newScore = targetScore;

            tx.set(ref, {
              'score': newScore,
              'userName': userName,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          } else {
            final prev = (snapshot.data() as Map<String, dynamic>?)?['score']
                    ?.toDouble() ??
                0.0;

            if (forceAdd) {
              newScore = prev + targetScore;
            } else if (isBetter(targetScore, prev, isSmallerBetter)) {
              newScore = targetScore;
            } else {
              newScore = prev;
            }

            tx.update(ref, {
              'score': newScore,
              'userName': userName,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          }

          // 👇 ここだけ追加（3種拾う）
          final period = periodMap[ref];

          if (period != null) {
            // 通常
            if (ref.path.contains('${resisterOrigin}_$modeType')) {
              if (period == 'all') resultAll = newScore;
              if (period.contains('_m')) resultMonth = newScore;
              if (period.contains('_w')) resultWeek = newScore;
            }

            // 👇 全合計_t
            if (ref.path.contains('全合計_t')) {
              if (period == 'all') totalAll = newScore;
              if (period.contains('_m')) totalMonth = newScore;
              if (period.contains('_w')) totalWeek = newScore;
            }
          }
        }
      });

      if (!isBattle) {
        return [totalAll, totalMonth, totalWeek];
      }

      return [resultAll, resultMonth, resultWeek];
    } catch (e) {
      return [0, 0, 0];
    }
  }

  static Future<List<Map<String, dynamic>>> getRanking({
    required BuildContext context,
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
      return {
        'uid': d.id, // uidを追加
        'score': (data['score'] as num).toDouble(),
        'userName': data['userName'] ?? l10n(context, 'defaultUsername'),
        'date': (data['updatedAt'] as Timestamp?)?.toDate(),
      };
    }).toList();
  }

  static Future<List<int>> getMyRank({
    required String resisterOrigin,
    required String modeType,
    required num myScore,
    required bool isSmallerBetter,
    List<String>? targetPeriods,
  }) async {
    if (myScore <= 0) return [0, 0, 0];

    final periods = targetPeriods ?? buildPeriod();
    final List<int> ranks = [];

    for (final period in periods) {
      final rankingId = "${resisterOrigin}_${modeType}_$period";

      final q = FirebaseFirestore.instance
          .collection('rankings_v5')
          .doc(rankingId)
          .collection('users');

      final snap = isSmallerBetter
          ? await q.where('score', isLessThan: myScore).count().get()
          : await q.where('score', isGreaterThan: myScore).count().get();

      // 自分より良いスコアの人数 + 1 を順位とする
      ranks.add((snap.count ?? 0) + 1);
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

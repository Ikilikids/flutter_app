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

  static Future<double?> updateAllScores({
    required double score,
    required String resisterOrigin,
    required String resisterSub,
    required String modeType,
    required bool isBattle,
    required bool isSmallerBetter,
    required bool isLimitedMode,
    required int fix,
    required String userName,
  }) async {
    if (score <= 0) return null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ Firebase Error: User not logged in.");
      return null;
    }

    final uid = user.uid;
    final rounded = (score * fix).roundToDouble() / fix;

    // 参照リストを整理
    final resisterTypes = isBattle
        ? [resisterOrigin]
        : (resisterOrigin == resisterSub
            ? [resisterOrigin, "全合計"]
            : [resisterOrigin, resisterSub, "全合計"]);
    print(resisterTypes);

    final periods = buildPeriod();
    final List<DocumentReference> userScoreRefs = [];
    final List<DocumentReference> rankingRefs = [];

    for (var rType in resisterTypes) {
      userScoreRefs.add(_firestore
          .collection('users2')
          .doc(uid)
          .collection('scores')
          .doc('${rType}_$modeType'));
      for (var period in periods) {
        rankingRefs.add(_firestore
            .collection('rankings_v5')
            .doc("${rType}_${modeType}_$period")
            .collection('users')
            .doc(uid));
      }
    }

    final allRefs = [...userScoreRefs, ...rankingRefs];
    double? finalUpdatedScore;

    try {
      await _firestore.runTransaction((tx) async {
        // --- 1. 読み取りフェーズ（全てのGetを先に！） ---
        final snapshots = <DocumentReference, DocumentSnapshot>{};
        for (final ref in allRefs) {
          snapshots[ref] = await tx.get(ref);
        }

        // --- 2. 書き込みフェーズ（ここからSet/Updateのみ） ---
        for (final ref in allRefs) {
          final snapshot = snapshots[ref]!;

          if (!snapshot.exists) {
            tx.set(ref, {
              'score': rounded,
              'userName': userName,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            finalUpdatedScore = rounded;
          } else {
            final data = snapshot.data() as Map<String, dynamic>?;
            final prev = (data?['score'] as num?)?.toDouble() ?? 0.0;

            if (!isBattle) {
              // 加算モード（全合計など）
              final newTotal = prev + rounded;
              tx.update(ref, {
                'score': newTotal,
                'userName': userName,
                'updatedAt': FieldValue.serverTimestamp(),
              });
              finalUpdatedScore = newTotal;
            } else if (isBetter(rounded, prev, isSmallerBetter)) {
              // ハイスコア更新モード
              tx.update(ref, {
                'score': rounded,
                'userName': userName,
                'updatedAt': FieldValue.serverTimestamp(),
              });
              finalUpdatedScore = rounded;
            }
          }
        }
      });
      print("✅ Transaction Success!");
      return finalUpdatedScore;
    } catch (e, stack) {
      // ここで何が起きたか100%分かります
      print("❌ Transaction Failed: $e");
      print("StackTrace: $stack");
      return null;
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
  }) async {
    if (myScore <= 0) return [0, 0, 0];

    final periods = buildPeriod();
    final List<int> ranks = [];

    for (final period in periods) {
      final rankingId = "${resisterOrigin}_${modeType}_$period";

      final q = FirebaseFirestore.instance
          .collection('rankings_v5')
          .doc(rankingId)
          .collection('users');

      final snap = isSmallerBetter
          ? await q.where('score', isLessThanOrEqualTo: myScore).count().get()
          : await q
              .where('score', isGreaterThanOrEqualTo: myScore)
              .count()
              .get();

      // 自分も含まれるので +1 しない
      ranks.add(snap.count ?? 0);
    }

    return ranks;
  }

  // 全スコアをMap形式で一括取得する
  static Future<Map<String, double>> getAllScores() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final snap = await _firestore
        .collection('users2')
        .doc(user.uid)
        .collection('scores')
        .get(); // .doc()を指定せず、コレクション全体を取得

    // {'resisterOrigin_modeType': score} の形でMapを作る
    return {
      for (var doc in snap.docs)
        doc.id: (doc.data()['score'] as num?)?.toDouble() ?? 0.0
    };
  }
}

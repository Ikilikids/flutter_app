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

  static Future<void> updateAllScores({
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
    // 0. バリデーション
    if (score <= 0 && (categoryScores == null || categoryScores.isEmpty))
      return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final periods = buildPeriod();

    // パスをキーにして、スコアと「加算フラグ」を保存するMap
    final Map<DocumentReference, Map<String, dynamic>> refData = {};

// --- 1. メインの設定 ---
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
    }

    // --- 2. カテゴリ別スコア & 全合計の登録先設定 ---
    if (categoryScores != null) {
      double total =
          categoryScores.values.fold(0, (sum, value) => sum + value).toDouble();

      // 全合計_t を登録
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
      }

      categoryScores.forEach((catName, catScore) {
        final roundedCatScore = (catScore * fix).roundToDouble() / fix;

        // カテゴリ個別の保存先のみ作成
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
        }
      });
    }

    final allRefs = refData.keys.toList();

    // --- 3. トランザクション実行 ---
    try {
      await _firestore.runTransaction((tx) async {
        // 読み取りフェーズ
        final snapshots = <DocumentReference, DocumentSnapshot>{};
        for (final ref in allRefs) {
          snapshots[ref] = await tx.get(ref);
        }

        // 書き込みフェーズ
        for (final ref in allRefs) {
          final snapshot = snapshots[ref]!;
          final info = refData[ref]!;
          final targetScore = info['score'] as double;
          final forceAdd = info['forceAdd'] as bool;

          if (!snapshot.exists) {
            tx.set(ref, {
              'score': targetScore,
              'userName': userName,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          } else {
            final prev = (snapshot.data() as Map<String, dynamic>?)?['score']
                    ?.toDouble() ??
                0.0;

            if (forceAdd) {
              // 加算モード（!isBattle の時、またはカテゴリ別スコアの時）
              tx.update(ref, {
                'score': prev + targetScore,
                'userName': userName,
                'updatedAt': FieldValue.serverTimestamp(),
              });
            } else if (isBetter(targetScore, prev, isSmallerBetter)) {
              // ハイスコア更新モード（isBattle が true かつ メインスコアの時）
              tx.update(ref, {
                'score': targetScore,
                'userName': userName,
                'updatedAt': FieldValue.serverTimestamp(),
              });
            }
          }
        }
      });
      print("✅ Update Success!");
    } catch (e, stack) {
      print("❌ Update Failed: $e\n$stack");
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

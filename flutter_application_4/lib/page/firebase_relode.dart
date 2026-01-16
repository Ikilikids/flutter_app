import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScoreHalverScreen extends StatefulWidget {
  const ScoreHalverScreen({super.key});

  @override
  State<ScoreHalverScreen> createState() => _ScoreHalverScreenState();
}

class _ScoreHalverScreenState extends State<ScoreHalverScreen> {
  bool isProcessing = false;
  String statusMessage = '';

  // ユーザーの対象クイズ名
  final List<String> quizTitles = [
    '数Ⅰ・数A',
    '数Ⅱ・数B',
    '数Ⅲ・数C',
    // '全範囲', // 必要なら追加
  ];

  // ランキングサブコレクション名
  final List<String> rankingSubCollections = [
    'monthly-2025-10',
    'weekly-43',
    // 必要に応じて追加
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スコア半分更新')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() {
                        isProcessing = true;
                        statusMessage = 'ランキングスコア処理中…';
                      });

                      try {
                        for (var quiz in quizTitles) {
                          await halveRankingScores(quiz);
                        }

                        setState(() {
                          statusMessage = 'ランキングスコアを半分に更新しました！';
                        });
                      } catch (e) {
                        setState(() {
                          statusMessage = 'エラー発生: $e';
                        });
                      } finally {
                        setState(() {
                          isProcessing = false;
                        });
                      }
                    },
              child: Text(isProcessing ? '処理中…' : 'ランキング全スコアを半分にする'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() {
                        isProcessing = true;
                        statusMessage = 'ユーザーハイスコア処理中…';
                      });

                      try {
                        for (var quiz in quizTitles) {
                          await halveUserHighScores(quiz);
                        }

                        setState(() {
                          statusMessage = '全ユーザーのハイスコアを半分に更新しました！';
                        });
                      } catch (e) {
                        setState(() {
                          statusMessage = 'エラー発生: $e';
                        });
                      } finally {
                        setState(() {
                          isProcessing = false;
                        });
                      }
                    },
              child: Text(isProcessing ? '処理中…' : 'ユーザーハイスコア全て半分にする'),
            ),
            const SizedBox(height: 20),
            Text(statusMessage),
          ],
        ),
      ),
    );
  }

  /// Firestore ランキングスコアを半分にする
  Future<void> halveRankingScores(String quizTitle) async {
    final firestore = FirebaseFirestore.instance;

    for (var colName in rankingSubCollections) {
      final colRef =
          firestore.collection('rankings').doc(quizTitle).collection(colName);
      final snapshot = await colRef.get();
      if (snapshot.docs.isEmpty) continue;

      WriteBatch batch = firestore.batch();
      int batchCount = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final currentScore = (data['score'] ?? 0) as int;
        final newScore = (currentScore / 2).round(); // 四捨五入

        batch.update(doc.reference, {'score': newScore});
        batchCount++;

        if (batchCount == 500) {
          await batch.commit();
          batch = firestore.batch();
          batchCount = 0;
        }
      }

      if (batchCount > 0) {
        await batch.commit();
      }
    }
  }

  /// users/{uid}/highscores/{quizTitle} を全ユーザー分半分にする
  Future<void> halveUserHighScores(String quizTitle) async {
    final firestore = FirebaseFirestore.instance;
    final usersCollection = firestore.collection('users');

    final usersSnapshot = await usersCollection.get();

    for (var userDoc in usersSnapshot.docs) {
      final highscoreRef = usersCollection
          .doc(userDoc.id)
          .collection('highscores')
          .doc(quizTitle);

      final highscoreSnap = await highscoreRef.get();
      if (!highscoreSnap.exists) continue;

      final currentScore = (highscoreSnap.data()?['score'] ?? 0) as int;
      final newScore = (currentScore / 2).round(); // 四捨五入

      await highscoreRef.update({'score': newScore});
    }
  }
}

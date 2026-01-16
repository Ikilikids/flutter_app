import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/firebase_score.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/main.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  String currentUserName = "名無し";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("⚙設定")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text("現在のユーザー名: "),
                Text(currentUserName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "新しいユーザー名",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveUserName,
              child: const Text("保存"),
            ),
            const SizedBox(height: 24),

            // 🌓 ダークモード切り替え
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ライトモード
                GestureDetector(
                  onTap: () => themeNotifier.setTheme(ThemeMode.light),
                  child: Row(
                    children: [
                      const Text("ライトモード"),
                      const SizedBox(width: 8),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: textColor1(context)),
                        ),
                        child: !isDarkMode
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: textColor1(context),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),

                // ダークモード
                GestureDetector(
                  onTap: () => themeNotifier.setTheme(ThemeMode.dark),
                  child: Row(
                    children: [
                      const Text("ダークモード"),
                      const SizedBox(width: 8),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: textColor1(context)),
                        ),
                        child: isDarkMode
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: textColor1(context),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text("お問い合わせ先 : tokoton.math@gmail.com"),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (doc.exists && doc.data()?["userName"] != null) {
      currentUserName = doc["userName"];
    }

    if (!mounted) return;
    _nameController.text = currentUserName;
    setState(() {});
  }

  Future<void> _saveUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";
    final newName = _nameController.text.trim();

    if (newName.isEmpty || newName == currentUserName) return;

    // 1. 名前変更だけ先に反映
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "userName": newName,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // UI 即時更新
    if (!mounted) return;
    setState(() => currentUserName = newName);

    // 2. 別処理としてランキング更新をバックグラウンドに投げる
    Future(() => _updateRankingsAfterNameChange(uid, newName));

    // 完了メッセージだけ表示
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("完了"),
          content: const Text("保存しました！"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}

Future<void> _updateRankingsAfterNameChange(String uid, String newName) async {
  final firestore = FirebaseFirestore.instance;

  final rankingsRef = firestore.collection('rankings');
  final rankingsRRef = firestore.collection('rankings_r');

  final now = DateTime.now();
  final monthKey = "monthly-${now.year}-${now.month}";
  final weekKey = "weekly-${now.year}-${getWeekNumber(now)}";

  final quizTabs = ['数Ⅰ・数A', '数Ⅱ・数B', '数Ⅲ・数C', '全範囲'];
  final quizTabsr = subjects
      .map((e) => e[2])
      .where((name) => !quizTabs.contains(name))
      .toList();

  final allQuizNames = <Map<String,
      dynamic>>[]; // { 'base': CollectionReference, 'quizName': String }

  for (var q in quizTabs) {
    allQuizNames.add({'base': rankingsRef, 'quizName': q});
  }
  for (var q in quizTabsr) {
    allQuizNames.add({'base': rankingsRRef, 'quizName': q});
  }

  const int maxRetries = 3;
  int attempt = 0;
  while (attempt < maxRetries) {
    attempt++;
    WriteBatch batch = firestore.batch();
    int opsInBatch = 0;
    try {
      for (var entry in allQuizNames) {
        final CollectionReference baseCol =
            entry['base'] as CollectionReference;
        final String quizName = entry['quizName'] as String;
        final docRef = baseCol.doc(quizName);

        // check paths: alltime, monthly, weekly
        final List<DocumentReference> targets = [
          docRef.collection('alltime').doc(uid),
          docRef.collection(monthKey).doc(uid),
          docRef.collection(weekKey).doc(uid),
        ];

        for (var target in targets) {
          // read exists (注意: 追加読み込みが発生するためコストに注意)
          final snap = await target.get();
          if (snap.exists) {
            // update via batch
            batch.update(target, {'userName': newName});
            opsInBatch++;
            // Firestore の batch は 500 ops まで
            if (opsInBatch >= 450) {
              // commit early to be safe
              await batch.commit();
              batch = firestore.batch();
              opsInBatch = 0;
            }
          }
        }
      }

      if (opsInBatch > 0) {
        await batch.commit();
      }

      // 成功したらループを抜ける
      return;
    } catch (e) {
      // 少し待ってリトライ（指数バックオフ的に）
      await Future.delayed(Duration(milliseconds: 500 * attempt));
      // 次の attempt で再実行
    }
  }

  // 全部失敗した場合のフォールバック（ログ出力のみ）
}

Future<void> migrateUsersToRankingR() async {
  final firestore = FirebaseFirestore.instance;
  final usersSnapshot = await firestore.collection('users').get();

  for (var userDoc in usersSnapshot.docs) {
    final uid = userDoc.id;

    // ユーザー名（users ドキュメント側に保存されている想定）
    final userData = userDoc.data();
    final userName = userData['userName'] ?? '名無し';

    final highscoresRef =
        firestore.collection('users').doc(uid).collection('correctcsores');
    final highscoresSnap = await highscoresRef.get();

    WriteBatch batch = firestore.batch();
    int batchCount = 0;

    int totalScore = 0; // 全合計用
    Timestamp? latestUpdatedAt; // 最新の updatedAt を追跡

    for (var scoreDoc in highscoresSnap.docs) {
      final quizTitle = scoreDoc.id;
      final data = scoreDoc.data();

      // score を int に変換
      final score = (data['score'] ?? 0) as int;
      totalScore += score;

      // 更新日時を取得
      final updatedAtValue = data['updatedAt'] as Timestamp? ?? Timestamp.now();

      // 最新日時を追跡
      if (latestUpdatedAt == null ||
          updatedAtValue.compareTo(latestUpdatedAt) > 0) {
        latestUpdatedAt = updatedAtValue;
      }

      final newRef = firestore
          .collection('rankings_r')
          .doc(quizTitle)
          .collection('alltime')
          .doc(uid);

      batch.set(newRef, {
        'userName': userName,
        'score': score,
        'updatedAt': updatedAtValue,
      });

      batchCount++;
      if (batchCount == 500) {
        await batch.commit();
        batch = firestore.batch();
        batchCount = 0;
      }
    }

    // 全合計用ドキュメント作成
    final allTotalRef = firestore
        .collection('rankings_r')
        .doc('全合計')
        .collection('alltime')
        .doc(uid);

    batch.set(allTotalRef, {
      'userName': userName,
      'score': totalScore,
      'updatedAt': latestUpdatedAt ?? FieldValue.serverTimestamp(),
    });

    if (batchCount > 0) {
      await batch.commit();
    }
  }
}

Future<void> copyTotalScoreToUser() async {
  final firestore = FirebaseFirestore.instance;
  final usersSnapshot = await firestore.collection('users').get();

  for (var userDoc in usersSnapshot.docs) {
    final uid = userDoc.id;

    // 元データの参照
    final sourceDocRef = firestore
        .collection('rankings_r')
        .doc('全合計')
        .collection('alltime')
        .doc(uid);

    // コピー先の参照
    final targetDocRef = firestore
        .collection('users')
        .doc(uid)
        .collection('correctcsores')
        .doc('全合計'); // 例: ドキュメント名に 'total' を使う

    final snapshot = await sourceDocRef.get();

    if (snapshot.exists) {
      final data = snapshot.data();

      if (data != null) {
        // 必要なフィールドだけ抽出
        final score = data['score'];
        final updatedAt = data['updatedAt'];

        // コピー実行
        await targetDocRef.set({
          'score': score,
          'updatedAt': updatedAt,
        });
      }
    }
  }
}

Future<void> deleteCorrectCountCollection() async {
  final firestore = FirebaseFirestore.instance;
  final usersSnapshot = await firestore.collection('users').get();

  for (var userDoc in usersSnapshot.docs) {
    final uid = userDoc.id;
    final totalDocRef = firestore
        .collection('users')
        .doc(uid)
        .collection('correctcsores')
        .doc("total");

    await totalDocRef.delete();
  }
}

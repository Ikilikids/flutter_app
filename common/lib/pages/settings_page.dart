import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/assistance/firebase_score.dart';
import 'package:common/assistance/theme_notifier.dart';
import 'package:common/config/app_config.dart';
import 'package:common/widgets/app_ad_scaffold.dart';
import 'package:common/widgets/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  String currentUserName = "名無し";
  bool _nameSaved = false;
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
        if (isKeyboardVisible) {
          FocusScope.of(context).unfocus();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: AppAdScaffold(
        advisible: false,
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
              GestureDetector(
                onTap: () {
                  if (_nameSaved) {
                    setState(() {
                      _nameSaved = false;
                    });

                    // 次フレームで「その TextField の FocusNode」にフォーカス
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _nameFocusNode.requestFocus();
                    });
                  }
                },
                child: TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode, // ★ これ
                  enabled: !_nameSaved,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: "新しいユーザー名",
                    border: OutlineInputBorder(),
                  ),
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
    FocusScope.of(context).unfocus();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";
    final newName = _nameController.text.trim();

    if (newName.isEmpty || newName == currentUserName) return;

    final appConfig = Provider.of<AppConfig>(context, listen: false);

    // 1. 名前変更だけ先に反映
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "userName": newName,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // UI 即時更新
    if (!mounted) return;
    setState(() {
      currentUserName = newName;
      _nameSaved = true; // ★ フォーカス不能
    });

    // 2. 別処理としてランキング更新をバックグラウンドに投げる
    Future(
        () => _updateRankingsAfterNameChange(uid, newName, appConfig.sortData));

    // 完了メッセージだけ表示
    if (mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
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

Future<void> _updateRankingsAfterNameChange(
    String uid, String newName, List<Map<String, String>> sortData) async {
  final firestore = FirebaseFirestore.instance;
  final quizTabs = sortData.map((s) => s['label']!).toList();
  final periods = ['all', 'monthly', 'weekly'];

  for (var quizId in quizTabs) {
    for (var period in periods) {
      Query q = firestore
          .collection("rankings_v2")
          .where("quizId", isEqualTo: quizId)
          .where("uid", isEqualTo: uid)
          .where("period", isEqualTo: period);

      // monthly / weekly の場合は year/month/week も追加条件
      final now = DateTime.now();
      if (period == 'monthly') {
        q = q
            .where("year", isEqualTo: now.year)
            .where("month", isEqualTo: now.month);
      } else if (period == 'weekly') {
        q = q
            .where("year", isEqualTo: now.year)
            .where("week", isEqualTo: getWeekNumber(now));
      }

      final snap = await q.get();
      for (var doc in snap.docs) {
        await doc.reference.update({"userName": newName});
      }
    }
  }
}

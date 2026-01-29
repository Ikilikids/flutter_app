import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/generated/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  String currentUserName = "";
  bool _isEditingName = false;
  final FocusNode _nameFocusNode = FocusNode();
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();
    // initStateではl10nを呼ばない
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      currentUserName = l10n(context, 'defaultUsername');
      _loadUserName();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    final appConfig = Provider.of<AppConfig>(context, listen: false);
    final settingWidgets = appConfig.settingWidgets;
    return AppAdScaffold(
      advisible: false,
      appBar: AppBar(
        title: Text(l10n(context, 'settingsTitle')),
      ),
      body: ListView(
        children: [
          buildSectionHeader(l10n(context, 'accountSectionTitle')),
          _buildUserNameTile(context),
          const Divider(height: 1),
          buildSectionHeader(l10n(context, 'appearanceSectionTitle')),
          SwitchListTile(
            title: Text(l10n(context, 'darkModeLabel')),
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            value: isDarkMode,
            onChanged: (value) {
              themeNotifier.setTheme(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          if (appConfig.title != "とことん高校数学") ...[
            const Divider(height: 1),
            buildSectionHeader(l10n(context, 'languageSectionTitle')),
            _buildLanguageTile(context),
          ],
          ...?settingWidgets?.call(context),
          const Divider(height: 1),
          buildSectionHeader(l10n(context, 'aboutSectionTitle')),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n(context, 'contactLabel')),
          ),
        ],
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserNameTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: Text(l10n(context, 'usernameLabel')),
      subtitle: _isEditingName
          ? TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n(context, 'newUsernameLabel'),
              ),
              onSubmitted: (_) => _saveUserName(),
            )
          : Text(currentUserName),
      trailing: _isEditingName
          ? IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveUserName,
            )
          : IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditingName = true;
                  _nameController.text = currentUserName;
                });
                _nameFocusNode.requestFocus();
              },
            ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final currentLocale =
        localeNotifier.locale ?? Localizations.localeOf(context);
    final languageName = _getLanguageName(currentLocale);

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n(context, 'languageLabel')),
      subtitle: Text(languageName),
      onTap: () => _showLanguagePicker(context),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n(context, 'languageSelectionTitle')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppLocalizations.supportedLocales.map((locale) {
                return RadioListTile<Locale>(
                  title: Text(_getLanguageName(locale)),
                  value: locale,
                  groupValue: localeNotifier.locale,
                  onChanged: (newLocale) {
                    if (newLocale != null) {
                      localeNotifier.setLocale(newLocale);
                      Navigator.of(context).pop();
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text(l10n(context, 'cancelButton')),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  String _getLanguageName(Locale locale) {
    // この部分はl10nの生成ファイルに依存するか、手動でマッピングを維持する必要があります。
    // ここでは簡単のためにハードコードします。
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Português';
      case 'ko':
        return '한국어';
      default:
        return locale.languageCode;
    }
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

    if (newName.isEmpty || newName == currentUserName) {
      if (mounted) {
        setState(() {
          _isEditingName = false;
        });
      }
      return;
    }

    final appConfig = Provider.of<AppConfig>(context, listen: false);
    final labels = appConfig.title == "とことん高校数学"
        ? [
            "全合計",
            "数Ⅰ・数A",
            "数Ⅱ・数B",
            "数Ⅲ・数C",
          ]
        : appConfig.data
            // dataの各要素のdetailリストを展開
            .expand((gameData) => gameData.detail)
            // detailのlabelだけを取り出す
            .map((detail) => detail.label)
            // Setで重複を排除
            .toSet()
            // 必要ならListに変換
            .toList();
    // 1. 名前変更だけ先に反映
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "userName": newName,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // UI 即時更新
    if (!mounted) return;
    setState(() {
      currentUserName = newName;
      _isEditingName = false;
// ★ フォーカス不能
    });

    // 2. 別処理としてランキング更新をバックグラウンドに投げる
    Future(() => _updateRankingsAfterNameChange(uid, newName, labels));

    // 完了メッセージだけ表示
    if (mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n(context, 'saveUsernameSuccessTitle')),
          content: Text(l10n(context, 'saveUsernameSuccessContent')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n(context, 'okButton')),
            ),
          ],
        ),
      );
    }
  }
}

Future<void> _updateRankingsAfterNameChange(
    String uid, String newName, List<String> labels) async {
  print(labels);
  final firestore = FirebaseFirestore.instance;
  final quizTabs = labels;
  final periods = ['all', 'monthly', 'weekly'];

  for (var quizId in quizTabs) {
    print(quizId);
    for (var period in periods) {
      Query q = firestore
          .collection("rankings_v2")
          .where("quizId",
              isEqualTo: JapaneseTranslator.translateKeyToJapanese(quizId))
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

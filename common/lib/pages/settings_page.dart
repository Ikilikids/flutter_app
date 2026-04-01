import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ---------- 1. Providers (すべて同期) ----------
    final currentTheme = ref.watch(appThemeProvider);
    final currentLocale = ref.watch(appLocaleProvider);
    final currentNumber = ref.watch(appNumberProvider);
    final currentUserName = ref.watch(appUserNameProvider).requireValue;

    // ---------- 2. Hooks (UI状態のみ) ----------
    final nameController = useTextEditingController(text: currentUserName);
    final nameFocusNode = useFocusNode();
    final isEditingName = useState<bool>(false);

    // ---------- 3. 保存アクション ----------
    Future<void> handleSaveName() async {
      final newName = nameController.text.trim();
      if (newName.isNotEmpty && newName != currentUserName) {
        // Notifierのメソッドを呼ぶだけ。中身（ランキング更新等）はあっちでやる。
        await ref.read(appUserNameProvider.notifier).updateName(newName);
        if (context.mounted) _showSuccessDialog(context);
      }
      isEditingName.value = false;
      FocusScope.of(context).unfocus();
    }

    final bool isDarkMode = currentTheme == ThemeMode.dark;

    return AppAdScaffold(
      appBar: AppBar(title: Text(l10n(context, 'settingsTitle'))),
      body: ListView(
        children: [
          /// ユーザーネーム設定
          _sectionHeader(context, l10n(context, 'accountSectionTitle')),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(l10n(context, 'usernameLabel')),
            subtitle: isEditingName.value
                ? TextField(
                    controller: nameController,
                    focusNode: nameFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: l10n(context, 'newUsernameLabel')),
                    onSubmitted: (_) => handleSaveName(),
                  )
                : Text(currentUserName),
            trailing: IconButton(
              icon: Icon(isEditingName.value ? Icons.check : Icons.edit),
              onPressed: () {
                if (isEditingName.value) {
                  handleSaveName();
                } else {
                  isEditingName.value = true;
                  nameController.text = currentUserName;
                  nameFocusNode.requestFocus();
                }
              },
            ),
          ),
          const Divider(height: 1),

          /// テーマ設定
          _sectionHeader(context, l10n(context, 'appearanceSectionTitle')),
          SwitchListTile(
            title: Text(
                l10n(context, isDarkMode ? 'darkModeLabel' : 'lightModeLabel')),
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            value: isDarkMode,
            onChanged: (newValue) => ref
                .read(appThemeProvider.notifier)
                .setTheme(newValue ? ThemeMode.dark : ThemeMode.light),
          ),

          /// 言語設定
          if (allData.appTitle == "appTitle" ||
              allData.appTitle == "reflectTitle") ...[
            const Divider(height: 1),
            _sectionHeader(context, l10n(context, 'languageSectionTitle')),
            _languageTile(
              context: context,
              currentLocale: currentLocale,
              onSelect: (newLoc) =>
                  ref.read(appLocaleProvider.notifier).setLocale(newLoc),
            ),
          ],

          /// その他 (カスタムWidget)
          ...?allData.settingWidgets?.call(context, currentNumber,
              (val) => ref.read(appNumberProvider.notifier).setNumber(val)),

          const Divider(height: 1),
          _sectionHeader(context, l10n(context, 'aboutSectionTitle')),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n(context, 'contactLabel')),
          ),
        ],
      ),
    );
  }

  // --- ヘルパーWidget ---
  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold)),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n(context, 'saveUsernameSuccessTitle')),
        content: Text(l10n(context, 'saveUsernameSuccessContent')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n(context, 'okButton')))
        ],
      ),
    );
  }
}

// 言語ダイアログのタイル部分はそのまま移植
Widget _languageTile(
    {required BuildContext context,
    required Locale currentLocale,
    required void Function(Locale) onSelect}) {
  return ListTile(
    leading: const Icon(Icons.language),
    title: Text(l10n(context, 'languageLabel')),
    subtitle: Text(_getLanguageName(currentLocale)),
    onTap: () => _showLanguageDialog(context, currentLocale, onSelect),
  );
}

void _showLanguageDialog(BuildContext context, Locale currentLocale,
    void Function(Locale) onSelect) {
  showDialog(
    context: context,
    builder: (context) {
      Locale temp = currentLocale;
      return AlertDialog(
        title: Text(l10n(context, 'languageSelectionTitle')),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppLocalizations.supportedLocales.map((locale) {
                return RadioListTile<Locale>(
                  title: Text(_getLanguageName(locale)),
                  value: locale,
                  groupValue: temp,
                  onChanged: (val) {
                    if (val != null) setState(() => temp = val);
                  },
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                onSelect(temp);
                Navigator.pop(context);
              },
              child: Text(l10n(context, 'okButton')))
        ],
      );
    },
  );
}

String _getLanguageName(Locale locale) {
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

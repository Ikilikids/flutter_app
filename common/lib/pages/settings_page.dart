import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../src/generated/l10n/app_localizations.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ---------- Providers ----------
    final themeAsync = ref.watch(appThemeProvider);
    final localeAsync = ref.watch(appLocaleProvider);
    final numberAsync = ref.watch(appNumberProvider);

    // ---------- Callbacks ----------
    void onLocaleChanged(Locale newLocale) {
      ref.read(appLocaleProvider.notifier).setLocale(newLocale);
    }

    void onThemeChanged(ThemeMode newTheme) {
      ref.read(appThemeProvider.notifier).setTheme(newTheme);
    }

    void onNumberChanged(String newNumber) {
      ref.read(appNumberProvider.notifier).setNumber(newNumber);
    }

    // ---------- Hooks ----------
    final nameController = useTextEditingController();
    final nameFocusNode = useFocusNode();
    final currentUserName = useState<String>(l10n(context, 'defaultUsername'));
    final isEditingName = useState<bool>(false);
    final isInitialized = useState<bool>(false);

    // ---------- Init ----------
    useEffect(() {
      if (!isInitialized.value) {
        _loadUserName(
          controller: nameController,
          currentUserName: currentUserName,
        );
        isInitialized.value = true;
      }
      return null;
    }, const []);

    // ---------- UI ----------
    return AppAdScaffold(
      advisible: false,
      appBar: AppBar(
        title: Text(l10n(context, 'settingsTitle')),
      ),
      body: themeAsync.when(
        data: (currentTheme) => localeAsync.when(
          data: (currentLocale) => numberAsync.when(
            data: (currentNumber) {
              final isDarkMode = currentTheme == ThemeMode.dark;

              return ListView(
                children: [
                  /// Username
                  _sectionHeader(
                    context,
                    l10n(context, 'accountSectionTitle'),
                  ),
                  _userNameTile(
                    context,
                    controller: nameController,
                    focusNode: nameFocusNode,
                    currentUserName: currentUserName,
                    isEditingName: isEditingName,
                  ),
                  const Divider(height: 1),

                  /// Theme
                  _sectionHeader(
                      context, l10n(context, 'appearanceSectionTitle')),
                  SwitchListTile(
                    title: Text(l10n(context, 'darkModeLabel')),
                    secondary:
                        Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                    value: isDarkMode,
                    onChanged: (newValue) {
                      onThemeChanged(
                          newValue ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),

                  /// Language
                  if (allData.appTitle != "とことん高校数学") ...[
                    const Divider(height: 1),
                    _sectionHeader(
                        context, l10n(context, 'languageSectionTitle')),
                    _languageTile(
                      context: context,
                      currentLocale: currentLocale,
                      onSelect: onLocaleChanged,
                    ),
                  ],

                  /// Other
                  ...?allData.settingWidgets
                      ?.call(context, currentNumber, onNumberChanged),

                  const Divider(height: 1),

                  /// About
                  _sectionHeader(context, l10n(context, 'aboutSectionTitle')),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n(context, 'contactLabel')),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Number Error: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Locale Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Theme Error: $e')),
      ),
    );
  }
}

/// --- ヘッダー ---
Widget _sectionHeader(
  BuildContext context,
  String title,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/// --- ユーザーネームの編集 ---
Widget _userNameTile(
  BuildContext context, {
  required TextEditingController controller,
  required FocusNode focusNode,
  required ValueNotifier<String> currentUserName,
  required ValueNotifier<bool> isEditingName,
}) {
  return ListTile(
    leading: const Icon(Icons.account_circle),
    title: Text(
      l10n(context, 'usernameLabel'),
    ),
    subtitle: isEditingName.value
        ? TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n(
                context,
                'newUsernameLabel',
              ),
            ),
            onSubmitted: (_) => _saveUserName(
              context,
              controller,
              currentUserName,
              isEditingName,
            ),
          )
        : Text(
            currentUserName.value,
          ),
    trailing: isEditingName.value
        ? IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveUserName(
              context,
              controller,
              currentUserName,
              isEditingName,
            ),
          )
        : IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              isEditingName.value = true;
              controller.text = currentUserName.value;
              focusNode.requestFocus();
            },
          ),
  );
}

// --- 言語切り替え ---
Widget _languageTile({
  required BuildContext context,
  required Locale currentLocale,
  required void Function(Locale) onSelect,
}) {
  final languageName = _getLanguageName(currentLocale);

  return ListTile(
    leading: const Icon(Icons.language),
    title: Text(l10n(context, 'languageLabel')),
    subtitle: Text(languageName),
    onTap: () {
      showDialog(
        context: context,
        builder: (_) {
          Locale tempSelected = currentLocale; // ダイアログ用の一時状態

          return AlertDialog(
            title: Text(l10n(context, 'languageSelectionTitle')),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: AppLocalizations.supportedLocales.map((locale) {
                      return RadioListTile<Locale>(
                        title: Text(_getLanguageName(locale)),
                        value: locale,
                        groupValue: tempSelected,
                        onChanged: (newLocale) {
                          if (newLocale != null) {
                            setState(() {
                              tempSelected = newLocale; // ダイアログ内で更新
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                child: Text(l10n(context, 'okButton')),
                onPressed: () {
                  onSelect(tempSelected); // 親で Hook + ref 更新
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

/// --- 言語コードから表示名を取得 ---
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

/// --- ユーザーネームの読み込みと保存 ---
Future<void> _loadUserName({
  required TextEditingController controller,
  required ValueNotifier<String> currentUserName,
}) async {
  final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";

  final doc =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

  if (doc.exists && doc.data()?["userName"] != null) {
    currentUserName.value = doc["userName"];
  }

  controller.text = currentUserName.value;
}

Future<void> _saveUserName(
  BuildContext context,
  TextEditingController controller,
  ValueNotifier<String> currentUserName,
  ValueNotifier<bool> isEditingName,
) async {
  FocusScope.of(context).unfocus();

  final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";

  final newName = controller.text.trim();

  if (newName.isEmpty || newName == currentUserName.value) {
    isEditingName.value = false;
    return;
  }

  final labels = allData.appTitle == "とことん高校数学"
      ? [
          "全合計",
          "数Ⅰ・数A",
          "数Ⅱ・数B",
          "数Ⅲ・数C",
        ]
      : allData.mid
          .expand((g) => g.detail)
          .map((d) => d.label)
          .toSet()
          .toList();

  await FirebaseFirestore.instance.collection("users").doc(uid).set({
    "userName": newName,
    "updatedAt": FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  currentUserName.value = newName;
  isEditingName.value = false;

  Future(() => _updateRankingsAfterNameChange(uid, newName, labels));

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(l10n(context, 'saveUsernameSuccessTitle')),
      content: Text(l10n(context, 'saveUsernameSuccessContent')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n(context, 'okButton'),
          ),
        ),
      ],
    ),
  );
}

/// ユーザーネーム変更後にランキングのユーザーネームも更新する
Future<void> _updateRankingsAfterNameChange(
  String uid,
  String newName,
  List<String> labels,
) async {
  final firestore = FirebaseFirestore.instance;

  final periods = ['all', 'monthly', 'weekly'];

  for (var quizId in labels) {
    for (var period in periods) {
      Query q = firestore
          .collection("rankings_v2")
          .where(
            "quizId",
            isEqualTo: JapaneseTranslator.translateKeyToJapanese(quizId),
          )
          .where("uid", isEqualTo: uid)
          .where("period", isEqualTo: period);

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

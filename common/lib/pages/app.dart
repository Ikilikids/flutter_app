import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common.dart';
import '../providers/app_sound.dart';

class CommonApp extends ConsumerWidget {
  final Widget home;

  const CommonApp({super.key, required this.home});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. SoundManager も追加で監視
    final themeAsync = ref.watch(appThemeProvider);
    final localeAsync = ref.watch(appLocaleProvider);
    final uidAsync = ref.watch(appUidProvider);
    final soundAsync = ref.watch(appSoundProvider); // ★追加

    // 2. 全てデータが揃っているかチェック（SoundManager も含める）
    final bool isReady = themeAsync.hasValue &&
        localeAsync.hasValue &&
        uidAsync.hasValue &&
        soundAsync.hasValue; // ★追加

    // appTitle が特定文字列なら日本語固定
    final isJapaneseTitle = allData.appData.appTitle == "とことん高校数学";
    final localeToUse =
        isJapaneseTitle ? const Locale('ja') : localeAsync.valueOrNull;

    return MaterialApp(
      locale: localeToUse,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeAsync.valueOrNull ?? ThemeMode.system,

      // ★ ここで一括ガード
      home: isReady
          ? home
          : Scaffold(
              backgroundColor: _getInitialBgColor(),
              body: const SizedBox.shrink(),
            ),
    );
  }

  Color _getInitialBgColor() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? Colors.black : Colors.white;
  }
}

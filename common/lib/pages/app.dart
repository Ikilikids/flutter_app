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
    final soundAsync = ref.watch(appSoundProvider);

    // 2. 最低限必要なものだけチェック（テーマとロケールのみ）
    final bool isReady = themeAsync.hasValue && localeAsync.hasValue;

    // appTitle が特定文字列なら日本語固定
    final isJapaneseTitle = allData.appData.appTitle == "とことん高校数学";
    final localeToUse =
        isJapaneseTitle ? const Locale('ja') : localeAsync.valueOrNull;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localeToUse,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeAsync.valueOrNull ?? ThemeMode.system,

      // ★ 最低限（テーマと言語）が揃ったらタイトルを出し、他は裏で待つ
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

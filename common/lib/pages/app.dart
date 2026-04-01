import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common.dart';

class CommonApp extends ConsumerWidget {
  final Widget home;

  const CommonApp({super.key, required this.home});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 同期 Provider (Locale)
    final Locale currentLocale = ref.watch(appLocaleProvider);

    // 2. 非同期 Provider (Theme)
    final ThemeMode themeAsync = ref.watch(appThemeProvider);

    // その他の監視
    ref.watch(appSoundProvider);

    // 特定のタイトルなら日本語固定、そうでなければ現在の設定(Locale)を使う
    final bool isJapaneseTitle = allData.appData.appTitle == "とことん高校数学";
    final Locale localeToUse =
        isJapaneseTitle ? const Locale('ja') : currentLocale;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: localeToUse,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeAsync,

        // テーマが揃ったら中身を表示
        home: home);
  }
}

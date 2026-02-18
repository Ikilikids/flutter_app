import 'package:common/providers/app_locale.dart';
import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_theme.dart';
import '../providers/app_uid.dart';

class CommonApp extends ConsumerWidget {
  final Widget home;

  const CommonApp({super.key, required this.home});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3つの状態を監視
    final themeAsync = ref.watch(appThemeProvider);
    final localeAsync = ref.watch(appLocaleProvider);
    final uidAsync = ref.watch(appUidProvider);

    // 全てデータが揃っているかチェック
    final bool isReady =
        themeAsync.hasValue && localeAsync.hasValue && uidAsync.hasValue;

    // 外枠（MaterialApp）は常に返す
    return MaterialApp(
      locale: localeAsync.valueOrNull, // まだ無ければnull（システム既定）
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeAsync.valueOrNull ?? ThemeMode.system,

      // 中身だけをロード状況で切り替える
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

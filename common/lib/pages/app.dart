import 'package:common/assistance/locale_notifier.dart';
import 'package:common/assistance/theme_notifier.dart';
import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonApp extends StatelessWidget {
  final Widget home;

  const CommonApp({
    super.key,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, themeNotifier, localeNotifier, _) {
        return MaterialApp(
          locale: localeNotifier.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.themeMode,
          home: home,
        );
      },
    );
  }
}

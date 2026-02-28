// app_locale.dart
import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_locale.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  // サポート言語リスト
  static const _supportedLanguages = ['en', 'ja', 'ko', 'es', 'pt'];

  @override
  Future<Locale> build() async {
    print(
        'AppLocale: Building and loading locale from SharedPreferences or device settings...');
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('languageCode');
    print('Loaded languageCode from SharedPreferences: $savedCode');
    // 1. 保存済み設定があれば優先
    if (savedCode != null && _supportedLanguages.contains(savedCode)) {
      return Locale(savedCode);
    }

    // 2. 端末の言語を確認
    final deviceLocale = PlatformDispatcher.instance.locale.languageCode;
    if (_supportedLanguages.contains(deviceLocale)) {
      return Locale(deviceLocale);
    }

    // 3. いずれも該当しなければ英語
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (!_supportedLanguages.contains(locale.languageCode)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    state = AsyncValue.data(locale);
  }
}

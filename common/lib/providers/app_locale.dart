import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

part 'app_locale.g.dart';

@Riverpod(keepAlive: true)
Locale initialLocale(Ref ref) => throw UnimplementedError();

@Riverpod(keepAlive: true, dependencies: [initialLocale])
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    return ref.watch(initialLocaleProvider);
  }

  Future<void> setLocale(Locale locale) async {
    final SharedPreferences prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('languageCode', locale.languageCode);

    state = locale;
  }
}

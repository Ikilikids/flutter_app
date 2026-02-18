import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_locale.g.dart';

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('languageCode');
    return Locale(code ?? 'en');
  }

  /// 言語変更 + 保存
  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);

    // 保存完了後に state 更新
    state = AsyncData(locale);
  }
}

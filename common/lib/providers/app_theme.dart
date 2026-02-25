import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme.g.dart';

@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('ThemeMode');
    return code == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  /// 言語変更 + 保存
  Future<void> setTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'ThemeMode', themeMode == ThemeMode.dark ? 'dark' : 'light');

    // 保存完了後に state 更新
    state = AsyncData(themeMode);
  }
}

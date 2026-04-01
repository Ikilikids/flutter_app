import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

part 'app_theme.g.dart';

@Riverpod(keepAlive: true)
ThemeMode initialTheme(Ref ref) => throw UnimplementedError();

@Riverpod(keepAlive: true, dependencies: [initialTheme])
class AppTheme extends _$AppTheme {
  @override
  ThemeMode build() {
    return ref.watch(initialThemeProvider);
  }

  Future<void> setTheme(ThemeMode theme) async {
    final SharedPreferences prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('ThemeMode', theme.name);

    state = theme;
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:common/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 初期化結果をまとめる型
class _InitResult {
  final SharedPreferences prefs;
  final Locale locale;
  final String number;
  final ThemeMode themeMode;

  final SoundManager soundManager;

  _InitResult(
    this.prefs,
    this.locale,
    this.number,
    this.themeMode,
    this.soundManager,
  );
}

class Bootstrap extends HookConsumerWidget {
  final AllData appConfig;
  final FirebaseOptions firebaseOptions;

  const Bootstrap({
    super.key,
    required this.appConfig,
    required this.firebaseOptions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1回だけ実行される初期化処理を useMemoized で定義
    final Future<_InitResult> initFuture = useMemoized(() async {
      allData = appConfig;
      // SharedPreferences の取得
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // 言語判定ロジック
      const List<String> supported = ['en', 'ja', 'ko', 'es', 'pt'];
      final String deviceCode = PlatformDispatcher.instance.locale.languageCode;
      final String? savedCode = prefs.getString('languageCode');
      final String finalCode = savedCode != null
          ? savedCode
          : supported.contains(deviceCode)
              ? deviceCode
              : 'en';
      final Locale locale = Locale(finalCode);

      // ボタン判定
      final String? savedNumber = prefs.getString('Number');
      final String finalNumber = savedNumber != null ? savedNumber : "mobile";

      //ライト・ダーク判定
      final String? savedTheme = prefs.getString('ThemeMode');
      final String finalTheme = savedTheme != null ? savedTheme : "system";
      final ThemeMode themeMode = ThemeMode.values.byName(finalTheme);
      // Firebase とその他の初期化
      await Firebase.initializeApp(options: firebaseOptions);

      //音ロード
      final manager = SoundManager();
      await manager.firstLoadSounds();
      unawaited(manager.secondloadSounds());

      return _InitResult(prefs, locale, finalNumber, themeMode, manager);
    });

    // Future の状態を監視
    final AsyncSnapshot<_InitResult> snapshot = useFuture(initFuture);

    // 完了するまではローディング画面
    if (!snapshot.hasData) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final _InitResult result = snapshot.data!;

    // 完了したら ProviderScope で上書きしてアプリを開始
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(result.prefs),
        initialLocaleProvider.overrideWithValue(result.locale),
        initialNumberProvider.overrideWithValue(result.number),
        initialThemeProvider.overrideWithValue(result.themeMode),
        appSoundProvider.overrideWithValue(result.soundManager)
      ],
      child: CommonApp(
        home: const CommonFirstPage(),
      ),
    );
  }
}

late AllData allData;

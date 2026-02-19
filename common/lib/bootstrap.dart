import 'package:common/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class Bootstrap extends StatefulWidget {
  final AllData appConfig;
  final FirebaseOptions firebaseOptions;

  const Bootstrap({
    super.key,
    required this.appConfig,
    required this.firebaseOptions,
  });

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  final _soundManager = SoundManager();

  bool _isThemeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('🟢 Bootstrap initState');
    // ★ 起動時に注入
    allData = widget.appConfig;
    _preloadThemeAndInit();
  }

  Future<void> _preloadThemeAndInit() async {
    print('① 初期化プロセス開始');

    // 1. まず Firebase と 必須設定を確実に終わらせる
    await _initBackground();

    print('④ 全ての必須初期化が完了');

    // 2. 終わってから初めてフラグを立てて再描画
    if (mounted) {
      setState(() {
        _isThemeLoaded = true;
      });
    }
  }

  Future<void> _initBackground() async {
    print('③ Background init start');
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: widget.firebaseOptions);
    }

    // Sounds
    if (!kIsWeb) {
      _soundManager.loadSounds();
    }

    // Ads
    if (!kIsWeb) {
      AdManager.initialize();

      // Interstitial 設定 + 初期ロード
      InterstitialAdHelper.configure(widget.appConfig);
      InterstitialAdHelper.init();

      // Rewarded 設定 + 初期ロード
      RewardedAdManager.configure(widget.appConfig);
      RewardedAdManager.loadAd();
    }
    print('④ Background init end');
  }

  @override
  void dispose() {
    _soundManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔴 重要：初期化が終わるまでは絶対 ProviderScope を出さない
    if (!_isThemeLoaded) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return MaterialApp(
        home: Scaffold(
          backgroundColor:
              brightness == Brightness.dark ? Colors.black : Colors.white,
          body: const SizedBox.shrink(),
        ),
      );
    }

    // 初期化完了後のみ Riverpod / Provider を開始する
    return ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.Provider.value(value: _soundManager),
        ],
        child: CommonApp(
          home: CommonFirstPage(),
        ),
      ),
    );
  }
}

late AllData allData;

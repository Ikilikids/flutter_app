import 'package:common/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Bootstrap extends ConsumerStatefulWidget {
  final AllData appConfig;
  final FirebaseOptions firebaseOptions;

  const Bootstrap({
    super.key,
    required this.appConfig,
    required this.firebaseOptions,
  });

  @override
  ConsumerState<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends ConsumerState<Bootstrap> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    allData = widget.appConfig;
    _initialize();
  }

  Future<void> _initialize() async {
    // 最小限の初期化。Firebase.initializeApp() だけは
    // インスタンスを確実に準備するためだけに行い、チェックは後回しにする。
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: widget.firebaseOptions);
    }

    // 他の初期化（広告やアップデートチェック）はバックグラウンドで開始 (待たない)
    _initBackgroundServices();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _initBackgroundServices() {
    // バージョンチェックをバックグラウンドで開始
    UpdateManager.checkUpdate();
    ref.read(appThemeProvider);
    ref.read(appLocaleProvider);
    ref.read(appUidProvider);
    ref.read(appSoundProvider);
    ref.read(userStatusNotifierProvider);
    if (!kIsWeb) {
      AdManager.initialize();
      InterstitialAdHelper.configure(widget.appConfig);
      InterstitialAdHelper.init();
      RewardedAdManager.configure(widget.appConfig);
      RewardedAdManager.loadAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 最小限の初期化が終わるまで待つ (この間はプラットフォームの背景色を表示)
    if (!_isInitialized) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor:
              brightness == Brightness.dark ? Colors.black : Colors.white,
          body: const SizedBox.shrink(),
        ),
      );
    }

    return CommonApp(
      home: const CommonFirstPage(),
    );
  }
}

late AllData allData;

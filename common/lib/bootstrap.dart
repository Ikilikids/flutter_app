import 'package:common/common.dart';
import 'package:firebase_core/firebase_core.dart';
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
    // 最小限の初期化

    await Firebase.initializeApp(options: widget.firebaseOptions);

    // アップデートチェックと基本設定の読み込みを先に行う
    await Future.wait([
      UpdateManager.checkUpdate(),
      ref.read(appThemeProvider.future),
      ref.read(appLocaleProvider.future),
    ]);

    // ユーザーデータの読み込みを開始 (await しないことで、タイトル画面をすぐに出しつつ裏で通信する)
    ref.read(userStatusNotifierProvider.notifier).initializeData();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
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

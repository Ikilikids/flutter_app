import 'package:common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assistance/string_notifier.dart';

class Bootstrap extends StatefulWidget {
  final AppConfig appConfig;
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
  final _userProvider = UserProvider();
  late final ThemeNotifier _themeNotifier;
  late final LocaleNotifier _localeNotifier;
  bool _isThemeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('🟢 Bootstrap initState');

    _themeNotifier = ThemeNotifier(initialThemeMode: ThemeMode.system);
    _localeNotifier = LocaleNotifier();
    _preloadThemeAndInit();
  }

  Future<void> _preloadThemeAndInit() async {
    print('① Theme load start');
    // 1. Load theme synchronously (await) to prevent flash
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode') ?? 'light';
    final mode = savedThemeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;

    _themeNotifier.setTheme(mode);

    if (mounted) {
      setState(() {
        _isThemeLoaded = true;
      });
    }
    print('② Theme loaded: $mode');

    // 2. Initialize others in background
    _initBackground();
  }

  Future<void> _initBackground() async {
    print('③ Background init start');

    // Firebase
    Firebase.initializeApp(
      options: widget.firebaseOptions,
    ).then((_) async {
      print('④ Firebase initialized');
      final userCred = await FirebaseAuth.instance.signInAnonymously();
      final uid = userCred.user?.uid;

      if (uid != null) {
        _userProvider.uid = uid;
        createUserRecord(uid);
      }
    });

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
  }

  @override
  void dispose() {
    _soundManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If theme is not loaded yet, show a plain screen matching system brightness.
    // No spinner, just a solid color to minimize flash.
    if (!_isThemeLoaded) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final bgColor =
          brightness == Brightness.dark ? Colors.black : Colors.white;

      return MaterialApp(
        home: Scaffold(
          backgroundColor: bgColor,
          body: const SizedBox.shrink(),
        ),
      );
    }

    print('🟢 build app (Theme ready)');

    return MultiProvider(
      providers: [
        Provider.value(value: widget.appConfig),
        Provider.value(value: _soundManager),
        ChangeNotifierProvider.value(value: _userProvider),
        ChangeNotifierProvider.value(value: _themeNotifier),
        ChangeNotifierProvider.value(value: _localeNotifier),
        ChangeNotifierProvider(create: (_) => QuizStateProvider()),
        ChangeNotifierProvider(create: (_) => MidStateProvider()),
        ChangeNotifierProvider(create: (_) => NumberChoiceNotifier()),
      ],
      child: const CommonApp(
        home: CommonFirstPage(),
      ),
    );
  }
}

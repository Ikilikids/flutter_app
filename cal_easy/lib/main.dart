import 'package:common/assistance/ad_manager.dart';
import 'package:common/assistance/firebase_utils.dart';
import 'package:common/assistance/quiz_state_provider.dart';
import 'package:common/assistance/sound_manager.dart';
import 'package:common/assistance/theme_notifier.dart';
import 'package:common/assistance/user_provider.dart';
import 'package:common/config/app_config.dart';
import 'package:common/pages/first_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assistance/quiz_logic.dart';
import 'firebase_options.dart';
import 'page/quiz_screen.dart';

final bool isWeb = kIsWeb;

final _appConfig = AppConfig(
  title: "とことん四則演算",
  icon: Icons.calculate,
  symbols: ["+", "-", "×", "÷"],
  isRotation: false,
  fix: 2,
  unit: "秒",
  sortData: [
    {
      "sort": "12",
      "label": "足し算・引き算",
      "method": "20問の正解タイムで競う",
      "description": "足し算・引き算、気軽にプレイ!!",
      "normalColor": "2",
      "limitColor": "1"
    },
    {
      "sort": "1234",
      "label": "四則演算",
      "method": "20問の正解タイムで競う",
      "description": "足し算・引き算・掛け算・割り算、素早く判断!!",
      "normalColor": "3",
      "limitColor": "4"
    },
    {
      "sort": "56",
      "label": "2桁の足し算・引き算",
      "method": "10問の正解タイムで競う",
      "description": "2桁の足し算・引き算、計算力を鍛えよう!!",
      "normalColor": "6",
      "limitColor": "5"
    },
  ],
  mainGame: (BuildContext context, List<dynamic> quizinfo) => Quizscreen(
    quizDirectives: prepareQuizDirectives(quizinfo[0]),
    quizinfo: quizinfo,
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferencesからテーマモードを先行読み込み
  final prefs = await SharedPreferences.getInstance();
  final savedThemeMode = prefs.getString('themeMode') ?? 'light';
  final initialThemeMode =
      savedThemeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _appConfig),
        Provider(create: (_) => SoundManager()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeNotifier(initialThemeMode: initialThemeMode)),
        ChangeNotifierProvider(create: (_) => QuizStateProvider()),
      ],
      child: MyApp(initialThemeMode: initialThemeMode), // 読み込んだテーマを渡す
    ),
  );
}

/// ===========================
/// MyApp
/// ===========================
class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode; // 追加
  const MyApp({super.key, required this.initialThemeMode}); // 変更

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late SoundManager soundManager;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    soundManager = Provider.of<SoundManager>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // 👇 起動後に全部やる
    Future.microtask(() async {
      // Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      // Auth
      final userCred = await FirebaseAuth.instance.signInAnonymously();
      final uid = userCred.user?.uid;
      if (uid != null) await createUserRecord(uid);
      userProvider.setUid(uid);
      await userProvider.load();

      // クイズ & サウンド
      await soundManager.loadSounds();

      // 広告
      await AdManager.initialize();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 必要なら停止処理だけ
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    soundManager.dispose(); // ← ここだけでOK
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ja', 'JP')],
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.themeMode,
          home: const CommonFirstPage(),
        );
      },
    );
  }
}

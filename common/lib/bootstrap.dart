import 'package:common/assistance/ad_manager.dart';
import 'package:common/assistance/firebase_utils.dart';
import 'package:common/assistance/quiz_state_provider.dart';
import 'package:common/assistance/sound_manager.dart';
import 'package:common/assistance/theme_notifier.dart';
import 'package:common/assistance/user_provider.dart';
import 'package:common/config/app_config.dart';
import 'package:common/pages/app.dart';
import 'package:common/pages/first_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// FirebaseOptions は各プロジェクトから渡してもらう必要がある
Future<void> runCommonApp({
  required AppConfig appConfig,
  required Widget destinationPage,
  required FirebaseOptions firebaseOptions,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- 初期化処理 ---
  // Firebase
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  final userCred = await FirebaseAuth.instance.signInAnonymously();
  final uid = userCred.user?.uid;
  if (uid != null) await createUserRecord(uid);

  // その他
  await AdManager.initialize();
  final soundManager = SoundManager();
  await soundManager.loadSounds();
  final prefs = await SharedPreferences.getInstance();
  final savedThemeMode = prefs.getString('themeMode') ?? 'light';
  final initialThemeMode =
      savedThemeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  // --- 初期化処理ここまで ---

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: appConfig),
        Provider(create: (_) => soundManager, dispose: (_, sm) => sm.dispose()),
        ChangeNotifierProvider(
          create: (_) => UserProvider()..uid = uid,
        ),
        ChangeNotifierProvider(
            create: (_) => ThemeNotifier(initialThemeMode: initialThemeMode)),
        ChangeNotifierProvider(create: (_) => QuizStateProvider()),
      ],
      child: CommonApp(
        home: CommonFirstPage(),
      ),
    ),
  );
}

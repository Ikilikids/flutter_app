import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/page/commmon_quiz.dart';
import 'package:flutter_application_4/page/firstpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import 'assistance/firebase_options.dart';

final bool isWeb = kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 画面向き固定・フルスクリーン
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Firebase 初期化
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // 広告初期設定
  if (!isWeb) {
    RequestConfiguration configuration = RequestConfiguration(
      testDeviceIds: ['DA34F3C355304EAE7619DEDA6D44319F'],
    );
    MobileAds.instance.updateRequestConfiguration(configuration);
  }

  // クイズデータロード

  // runApp
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SoundManager()), // create に変更
        ChangeNotifierProvider(create: (_) => UserProvider()), // create に変更
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => QuizProvider()), // create に変更
        ChangeNotifierProvider(create: (_) => QuizStateProvider()), // 追加
      ],
      child: const MyApp(),
    ),
  );
}

/// ===========================
/// MyApp
/// ===========================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late SoundManager soundManager;
  late UserProvider userProvider;
  late QuizProvider quizProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Provider を参照
    soundManager = Provider.of<SoundManager>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    quizProvider = Provider.of<QuizProvider>(context, listen: false);

    // 非同期初期化
    Future.microtask(() async {
      // 匿名サインイン
      String? uid;
      try {
        final userCred = await FirebaseAuth.instance.signInAnonymously();
        uid = userCred.user?.uid;
        if (uid != null) await createUserRecord(uid);
      } catch (e) {
        debugPrint("Firebase に接続できません: $e");
      }
      userProvider.setUid(uid);

      // クイズデータロード & サウンド読み込み
      await quizProvider.initAll();
      await soundManager.loadSounds();

      if (!kIsWeb) await MobileAds.instance.initialize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    soundManager.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      soundManager.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return ScreenUtilInit(
          designSize: const Size(406, 856),
          minTextAdapt: true,
          builder: (context, child) {
            return MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('ja', 'JP')],
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme.light(
                  surface: Color(0xfff0f0f0),
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme.dark(
                  surface: Color(0xff141920),
                ),
              ),
              themeMode: themeNotifier.themeMode,
              home: const FirstPage(),
            );
          },
        );
      },
    );
  }
}

// Firebase ユーザー作成
Future<void> createUserRecord(String uid) async {
  final ref = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await ref.get();
  if (!snapshot.exists) {
    await ref.set({'createdAt': FieldValue.serverTimestamp()});
  }
}

/// ===========================
/// SoundManager
/// ===========================
class SoundManager {
  late Soundpool _soundpool;
  final Map<String, int> _soundIds = {};

  SoundManager() {
    _soundpool = Soundpool.fromOptions(
      options:
          const SoundpoolOptions(streamType: StreamType.music, maxStreams: 6),
    );
  }

  Future<void> loadSounds() async {
    final soundFiles = <String>{
      'countdown1.mp3',
      'countdown2.mp3',
      'marumaru.mp3',
      'maru.mp3',
      'peke.mp3',
      'ry.mp3',
      for (int i = 0; i <= 9; i++) '$i.mp3',
    };
    for (var file in soundFiles) {
      final data = await rootBundle.load('assets/sounds/$file');
      final id = await _soundpool.load(data);
      _soundIds[file] = id;
    }
  }

  void playSound(String name) {
    final id = _soundIds[name];
    if (id != null) _soundpool.play(id);
  }

  void dispose() {
    _soundpool.release();
  }
}

/// ===========================
/// ThemeNotifier
/// ===========================
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadTheme(); // 起動時に保存済みテーマを読み込む
  }

  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    // SharedPreferences に保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'themeMode', mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode') ?? 'light';
    _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

/// ===========================
/// UserProvider
/// ===========================
class UserProvider extends ChangeNotifier {
  String? _uid;
  String? get uid => _uid;

  void setUid(String? uid) {
    _uid = uid;
    notifyListeners();
  }
}

/// ===========================
/// QuizProvider
/// ===========================
class QuizProvider extends ChangeNotifier {
  List<Map<String, String>> quizData = [];
  Map<String, List<Map<String, String>>> scoreIndexMap = {};

  Future<void> initAll() async {
    await loadQuiz();
    await setQuizData();
    await buildScoreIndex();
  }

  Future<void> loadQuiz() async {
    final csvString = await rootBundle.loadString("assets/csv/quizdata.csv");
    final rows = const CsvToListConverter().convert(csvString);

    quizData.clear();
    for (var row in rows) {
      if (row.length < 17) continue;
      quizData.add({
        "lc": row[0].toString(),
        "st1": row[1].toString(),
        "st2": row[2].toString(),
        "st3": row[3].toString(),
        "dt": row[4].toString(),
        "fi1": row[5].toString(),
        "fi2": row[6].toString(),
        "fi3": row[7].toString(),
        "fb": row[8].toString(),
        "b1": row[9].toString(),
        "b2": row[10].toString(),
        "b3": row[11].toString(),
        "b4": row[12].toString(),
        "scoreA": row[13].toString(),
        "scoreB": row[14].toString(),
        "scoreC": row[15].toString(),
        "scoreD": row[16].toString(),
      });
    }
  }

  Future<void> setQuizData() async {
    const keys = ["A", "B", "C", "D"];
    for (var map in quizData) {
      List<String?> scores = [
        map["scoreA"],
        map["scoreB"],
        map["scoreC"],
        map["scoreD"]
      ];
      List<int> validIndices = [
        for (int i = 0; i < 4; i++)
          if (scores[i]?.isNotEmpty ?? false) i
      ];
      Set<int> aIndices = {
        for (int i in validIndices)
          if (scores[i]!.contains("a")) i
      };
      Set<int> bIndices = {
        for (int i in validIndices)
          if (scores[i]!.contains("b")) i
      };

      int parseScore(int i) =>
          int.parse(scores[i]!.replaceAll(RegExp(r"[ab]"), ""));

      int n = validIndices.length;
      for (int mask = 1; mask < (1 << n); mask++) {
        Set<int> subset = {
          for (int j = 0; j < n; j++)
            if ((mask & (1 << j)) != 0) validIndices[j]
        };
        if (!subset.containsAll(aIndices)) continue;
        if (bIndices.isNotEmpty) {
          bool containsB = subset.any((i) => bIndices.contains(i));
          if (containsB && !bIndices.every((i) => subset.contains(i))) continue;
        }
        int total = subset.fold(0, (summ, i) => summ + parseScore(i));
        String keyStr = subset.map((i) => keys[i]).toList().join();
        map["score$keyStr"] = total.toString();
      }
    }
  }

  Future<void> buildScoreIndex() async {
    scoreIndexMap.clear();
    for (var q in quizData) {
      for (var entry in q.entries) {
        if (entry.key.startsWith("score")) {
          int? score = int.tryParse(entry.value);
          if (score != null) {
            scoreIndexMap.putIfAbsent(score.toString(), () => []).add({
              ...q,
              "usedScore": entry.key,
              "usedScoreValue": entry.value,
            });
          }
        }
      }
    }
  }
}

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }
    return _NativeBannerAdWidget();
  }
}

class _NativeBannerAdWidget extends StatefulWidget {
  @override
  State<_NativeBannerAdWidget> createState() => _NativeBannerAdWidgetState();
}

class _NativeBannerAdWidgetState extends State<_NativeBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bannerAd = BannerAd(
        adUnitId: kDebugMode
            ? 'ca-app-pub-3940256099942544/6300978111' // ← テスト広告ID
            : 'ca-app-pub-1440692612851416/6568630311', // ← 本番広告ID
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _isLoaded = true),
          onAdFailedToLoad: (ad, error) {
            debugPrint('Ad failed to load: $error');
            ad.dispose();
          },
        ),
      )..load();
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox.shrink();
    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class AdScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final double adHeight;
  final Color? color;

  const AdScaffold(
      {super.key,
      this.appBar,
      required this.body,
      this.adHeight = 60, // 広告枠の高さ
      this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Expanded(child: body),
          Container(
            color: color,
            height: adHeight,
            width: double.infinity,
            child: const BannerAdWidget(),
          ),
        ],
      ),
    );
  }
}

class InterstitialAdHelper {
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;

  /// 初期化して広告をロード
  static void init() {
    if (!kIsWeb) _loadAd();
  }

  /// 広告ロード
  static Future<void> _loadAd() async {
    if (_isLoading) return;
    _isLoading = true;

    await InterstitialAd.load(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712' // ← Google公式のテスト用インタースティシャル広告ID
          : 'ca-app-pub-1440692612851416/7404533363', // ← あなたの本番ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint("InterstitialAd loaded");
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint("InterstitialAd failed to load: $error");
          _isLoading = false;
        },
      ),
    );
  }

  static Future<void> showAdThenNavigate(
      BuildContext context, Widget nextScreen) async {
    if (kIsWeb) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      }
      return;
    }

    const timeout = Duration(seconds: 3);
    final stopwatch = Stopwatch()..start();

    while (_interstitialAd == null && stopwatch.elapsed < timeout) {
      if (!_isLoading) _loadAd();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final ad = _interstitialAd;
    _interstitialAd = null;

    if (ad == null) {
      // 広告が間に合わなかったので即遷移
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      }
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (_) => nextScreen),
          );
        }
        _loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (_) => nextScreen),
          );
        }
      },
    );

    ad.show();
  }
}

class AdInterstitialNavigator extends StatefulWidget {
  final Widget nextScreen;

  const AdInterstitialNavigator({super.key, required this.nextScreen});

  @override
  State<AdInterstitialNavigator> createState() =>
      _AdInterstitialNavigatorState();
}

class _AdInterstitialNavigatorState extends State<AdInterstitialNavigator> {
  @override
  void initState() {
    super.initState();
    _checkAd();
  }

  Future<void> _checkAd() async {
    bool showAd = await AdCounter.shouldShowAd();
    if (showAd) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await InterstitialAdHelper.showAdThenNavigate(
            context, widget.nextScreen);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => widget.nextScreen),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 戻る操作禁止
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("読み込み中"),
              Text("少々お待ちください..."),
            ],
          ),
        ),
      ),
    );
  }
}

class AdCounter {
  static const _key = 'ad_counter';

  /// 回数取得
  static Future<int> getCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  /// 回数を増やす
  static Future<void> increment() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_key) ?? 0;
    count++;
    await prefs.setInt(_key, count);
  }

  /// 3回ごとにtrueを返す
  static Future<bool> shouldShowAd() async {
    int count = await getCount();
    bool show = count % 3 == 1; // 3回に1回
    await increment();
    return show;
  }
}

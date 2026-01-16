import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakuraku_amedas/amedasmap.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // impor
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// ← kIsWebを使うために必要

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  if (!kIsWeb) {
    RequestConfiguration configuration = RequestConfiguration(
      testDeviceIds: ['DA34F3C355304EAE7619DEDA6D44319F'],
    );
    MobileAds.instance.updateRequestConfiguration(configuration);

    Future.microtask(() async {
      await MobileAds.instance.initialize();
    });
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
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
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 240, 240, 240),
              foregroundColor: Colors.black,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Color.fromARGB(255, 17, 17, 17),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 17, 17, 17),
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: _themeMode, // ← ここが切り替わる
          home: Scaffold(
            body: MainPage(themeMode: _themeMode, onThemeChanged: _changeTheme),
          ),
        );
      },
    );
  }
}

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox.shrink(); // Webは広告非表示
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
        adUnitId: kReleaseMode
            ? 'ca-app-pub-1440692612851416/7892114330' // 本番用
            : 'ca-app-pub-3940256099942544/6300978111', // テスト用
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

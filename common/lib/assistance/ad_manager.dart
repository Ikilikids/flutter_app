import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 広告関連の初期化を行うクラス
class AdManager {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || kIsWeb || !kReleaseMode) {
      return;
    }
    await MobileAds.instance.initialize();
    _initialized = true;
  }
}

/// ===========================
/// バナー広告
/// ===========================
class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }
    return const _NativeBannerAdWidget();
  }
}

class _NativeBannerAdWidget extends StatefulWidget {
  const _NativeBannerAdWidget();

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
        adUnitId: 'ca-app-pub-3940256099942544/6300978111', // ← テスト広告ID
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

/// ===========================
/// インタースティシャル広告
/// ===========================
class InterstitialAdHelper {
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;

  /// 初期化して広告をロード
  static void init() {
    if (!kIsWeb) _loadAd();
  }

  /// 広告ロード
  static Future<void> _loadAd() async {
    // 既に広告がある or 読み込み中なら何もしない
    if (_interstitialAd != null || _isLoading) return;

    _isLoading = true;

    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;

          // 広告が閉じられたら dispose & null に
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
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

class RewardedAdManager {
  static RewardedAd? _rewardedAd;
  static bool _isAdReady = false;
  static bool get isAdReady => _isAdReady;
  static bool _isLoading = false; // 追加

  static const String _adUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // テスト用

  static void loadAd() {
    if (_rewardedAd != null || _isLoading) return; // 変更

    _isLoading = true; // 追加
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdReady = true;
          _isLoading = false; // 追加
          debugPrint('Rewarded Ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded Ad failed to load: $error');
          _rewardedAd = null;
          _isAdReady = false;
          _isLoading = false; // 追加
        },
      ),
    );
  }

  static void showAd(
      {required VoidCallback onReward, VoidCallback? onAdDismissed}) {
    if (!_isAdReady || _rewardedAd == null) {
      debugPrint('Tried to show a rewarded ad that was not ready.');
      loadAd(); // 念のため再ロード
      if (onAdDismissed != null) {
        onAdDismissed(); // 広告が表示できなかった場合もdismiss扱い
      }
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;
        loadAd(); // 次の広告をロード
        if (onAdDismissed != null) {
          onAdDismissed();
        }
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;
        loadAd(); // 次の広告をロード
        if (onAdDismissed != null) {
          onAdDismissed(); // 表示失敗もdismiss扱い
        }
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        onReward();
      },
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
    bool show = count % 4 == 1; // 3回に1回
    await increment();
    return show;
  }
}

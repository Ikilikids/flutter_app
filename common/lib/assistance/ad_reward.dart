import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// ===========================
/// リワード広告（Widget 側変更不要）
/// ===========================
class RewardedAdManager {
  static RewardedAd? _rewardedAd;
  static bool _isAdReady = false;
  static bool get isAdReady => _isAdReady;
  static bool _isLoading = false;

  /// AppConfig を static に保持
  static AllData? _config;

  /// AppConfig をセット（必須）
  static void configure(AllData config) {
    _config = config;
  }

  /// 広告ロード
  static void loadAd() {
    if (_rewardedAd != null || _isLoading) return;
    if (_config == null) return;

    _isLoading = true;

    final adUnitId = _config!.appData.rewardId ??
        'ca-app-pub-3940256099942544/5224354917'; // テストID fallback
    print('Loading Rewarded Ad: $adUnitId');
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdReady = true;
          _isLoading = false;
          debugPrint('Rewarded Ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded Ad failed to load: $error');
          _rewardedAd = null;
          _isAdReady = false;
          _isLoading = false;
        },
      ),
    );
  }

  /// 広告表示
  static void showAd(
      {required VoidCallback onReward, VoidCallback? onAdDismissed}) {
    if (!_isAdReady || _rewardedAd == null) {
      debugPrint('Tried to show a rewarded ad that was not ready.');
      loadAd(); // 念のため再ロード
      if (onAdDismissed != null) onAdDismissed();
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
        loadAd(); // 次の広告をプリロード
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;
        loadAd(); // 次の広告をプリロード
        if (onAdDismissed != null) onAdDismissed();
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

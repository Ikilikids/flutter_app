import 'dart:async';

import 'package:common/common.dart';
import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterstitialAdHelper {
  static InterstitialAd? _ad;
  static bool _loading = false;
  static AllData? _config;
  static const _key = 'ad_counter';

  static void configure(AllData config) => _config = config;

  static void init() {
    if (!kIsWeb) _load();
  }

  static Future<void> navigate(BuildContext context, Widget? nextScreen) async {
    final navigator = Navigator.of(context);
    if (!context.mounted) return;

    // ---- カウント判定（3回に1回）----
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_key) ?? 0;
    bool shouldShow = count % 90 == 0;
    await prefs.setInt(_key, count + 1);

    // ---- 広告タイミングじゃない ----
    if (!shouldShow) {
      nextScreen != null
          ? navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => nextScreen),
            )
          : navigator.pop();
      return;
    }

    InterstitialAd? adToDispose;

    // ---- まずローディング画面に遷移 ----
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (context) => PopScope(
          canPop: false,
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.loadingProblem),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // 遷移アニメーションの完了を待つことで、広告表示の安定性を高める
    await Future.delayed(const Duration(milliseconds: 100));

    // ---- 広告ある場合 ----
    if (_ad != null) {
      final ad = _ad;
      adToDispose = ad; // 後でdisposeするために保持
      _ad = null;

      final c = Completer<void>();

      ad!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          // disposeせずに、すぐに遷移処理に移る
          c.complete();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          // 表示に失敗した場合は、ここでdisposeする
          ad.dispose();
          c.complete();
        },
      );

      ad.show();
      await c.future;
    } else {
      // ---- 広告ない → 3秒罰 ----
      await Future.delayed(const Duration(seconds: 3));
    }

    // ---- 遷移 ----
    {
      nextScreen != null
          ? navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => nextScreen),
            )
          : navigator.pop();
    }

    // ---- 後片付けと次広告ロード ----
    // 画面遷移を最優先し、その後に後片付けを行う
    adToDispose?.dispose();

    // 描画処理を優先させるため、少し待ってから次の広告をロードする
    await Future.delayed(const Duration(milliseconds: 200));

    _load();
  }

  static Future<void> _load() async {
    if (_ad != null || _loading || _config == null) return;
    _loading = true;

    await InterstitialAd.load(
      adUnitId:
          _config!.appData.interId ?? 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
        },
        onAdFailedToLoad: (_) => _loading = false,
      ),
    );
  }
}

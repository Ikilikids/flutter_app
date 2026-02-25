import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

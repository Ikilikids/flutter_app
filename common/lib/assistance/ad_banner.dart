import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

class _NativeBannerAdWidget extends ConsumerStatefulWidget {
  const _NativeBannerAdWidget();

  @override
  ConsumerState<_NativeBannerAdWidget> createState() =>
      _NativeBannerAdWidgetState();
}

class _NativeBannerAdWidgetState extends ConsumerState<_NativeBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adUnitId =
          allData.appData.bannerId ?? 'ca-app-pub-3940256099942544/6300978111';

      print('Loading Banner Ad: $adUnitId');

      _bannerAd = BannerAd(
        adUnitId: adUnitId,
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

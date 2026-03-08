import 'package:common/common.dart';
import 'package:flutter/material.dart';

class AppAdScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar; // ← 追加：ナビゲーションバーを受け取る
  final double adHeight;
  final Color? color;
  final bool advisible;

  const AppAdScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar, // ← 追加
    this.adHeight = 60,
    this.color,
    this.advisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      body: MathBackground(child: body),

      // Column全体をSafeAreaで包むことで、OSの干渉を防ぐ
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 広告エリア
            if (advisible)
              Container(
                color: color,
                height: adHeight,
                width: double.infinity,
                alignment: Alignment.center,
                child: const BannerAdWidget(),
              ),
            // ナビゲーションバーがある場合は表示
            if (bottomNavigationBar != null) bottomNavigationBar!,
          ],
        ),
      ),
    );
  }
}

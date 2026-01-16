import 'package:common/assistance/ad_manager.dart';
import 'package:common/widgets/math_background.dart';
import 'package:flutter/material.dart';

class AppAdScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final double adHeight;
  final Color? color;
  final bool advisible;

  const AppAdScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.adHeight = 60, // 広告枠の高さ
    this.color,
    this.advisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // ★これ
      appBar: appBar,
      body: MathBackground(
        child: Column(
          children: [
            Expanded(child: body),
            if (advisible)
              Container(
                color: color,
                height: adHeight,
                width: double.infinity,
                child: const BannerAdWidget(),
              ),
          ],
        ),
      ),
    );
  }
}

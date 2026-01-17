import 'dart:math' as math;

import 'package:common/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MathBackground extends StatelessWidget {
  final Widget child;
  const MathBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final _appconfig = Provider.of<AppConfig>(context);
    final symbols = _appconfig.symbols;
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _MathPainter(symbols: symbols),
          ),
        ),
        child,
      ],
    );
  }
}

class _MathPainter extends CustomPainter {
  final List<String> symbols;

  _MathPainter({required this.symbols});

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    );

    // シードを外すとホットリロードのたびに位置が変わります
    final random = math.Random(42);

    for (int i = 0; i < 60; i++) {
      // 60個くらいが程よいかもしれません
      final String symbol = symbols[random.nextInt(symbols.length)];
      final double fontSize = 20.0 + random.nextDouble() * 30.0;

      final tp = TextPainter(
        text: TextSpan(
          text: symbol,
          style: textStyle.copyWith(
            color: const Color.fromARGB(255, 131, 131, 131)
                .withAlpha(80), // 透明度を低めに設定
            fontSize: fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // 画面の端で切れてもいいように、少し外側まで範囲を広げる
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final rotation = random.nextDouble() * 2 * math.pi;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // 記号の中心を(x,y)に合わせることで、偏りを防ぐ
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

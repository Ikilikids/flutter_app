// time_circle_painter.dart
import 'dart:math';

import 'package:flutter/material.dart';

class TimeCirclePainter extends CustomPainter {
  final bool isDark;
  final int remainingTime;

  TimeCirclePainter({required this.isDark, required this.remainingTime});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.05;

    final Paint circlePaint = Paint()
      ..color = isDark
          ? const Color.fromARGB(255, 187, 187, 187) // ダーク: 深緑
          : const Color.fromARGB(255, 226, 226, 226) // ライト: 通常グリーン
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    // 進捗の色を変えるロジック
    Color progressColor;

    if (remainingTime > 20) {
      progressColor = isDark
          ? const Color(0xFF388E3C) // ダーク: 深緑
          : const Color(0xFF4CAF50); // ライト: 通常グリーン
    } else if (remainingTime > 10) {
      progressColor = isDark
          ? const Color(0xFFF57C00) // ダーク: 落ち着いたオレンジ
          : const Color(0xFFFF9800); // ライト: 通常オレンジ
    } else {
      progressColor = isDark
          ? const Color(0xFFD32F2F) // ダーク: 落ち着いた赤
          : const Color(0xFFF44336); // ライト: 通常レッド
    }

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    double progress = (remainingTime / 60); // 60秒を基準にした進行状況

    // 中心と半径を計算
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // 背景の円を描画
    canvas.drawCircle(center, radius, circlePaint);

    // 進捗の円を描画
    double angle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, progressPaint);

    // 残り時間のテキストを円の中央に描画
    final double fontSize = size.width * 0.5; // 円の幅の20%を文字サイズにする

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: remainingTime.toString(),
        style: TextStyle(
          fontSize: fontSize,
          color: progressColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 常に再描画
  }
}

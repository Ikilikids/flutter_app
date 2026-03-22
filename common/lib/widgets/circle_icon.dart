import 'package:common/widgets/color.dart';
import 'package:flutter/material.dart';

// 塗りつぶし扇型を描く CustomPainter
class FilledCirclePartsPainter extends CustomPainter {
  final List<String> parts;
  final BuildContext context;

  FilledCirclePartsPainter({required this.parts, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2; // 外側いっぱい
    final sweepAngle = 2 * 3.1415926 / parts.length;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < parts.length; i++) {
      paint.color = getQuizColor2(parts[i], context, 1, 0.35, 0.95);
      final startAngle = -3.1415926 / 4 + sweepAngle * i;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

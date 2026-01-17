import 'package:common/widgets/color.dart';
import 'package:flutter/material.dart';

Widget buildCircleWidget(
  List<String> parts,
  BuildContext context,
  double circleSize,
  Color bgColor,
  bool isLimitedMode,
) {
  return SizedBox(
    width: circleSize,
    height: circleSize,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // 背景円

        // 塗りつぶし部分
        CustomPaint(
          size: Size(circleSize, circleSize),
          painter: _FilledCirclePartsPainter(parts: parts, context: context),
        ),
        // 中央アイコン
        SizedBox(
          width: circleSize * 0.4,
          height: circleSize * 0.4,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Icon(
              isLimitedMode ? Icons.timer : Icons.all_inclusive,
              color: bgColor1(context),
            ),
          ),
        ),
      ],
    ),
  );
}

// 塗りつぶし扇型を描く CustomPainter
class _FilledCirclePartsPainter extends CustomPainter {
  final List<String> parts;
  final BuildContext context;

  _FilledCirclePartsPainter({required this.parts, required this.context});

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

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CircleIcon extends HookConsumerWidget {
  final QuizId quizId;

  const CircleIcon({
    required this.quizId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(quizDetailProvider(quizId));
    final mode = config.modeData;
    final detail = config.detail;

    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxHeight,
            height: constraints.maxHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 塗りつぶし部分
                CustomPaint(
                  size: Size(constraints.maxHeight, constraints.maxHeight),
                  painter: FilledCirclePartsPainter(
                      parts: detail.circleColor.split(""), context: context),
                ),
                // 中央アイコン
                SizedBox(
                  width: constraints.maxHeight * 0.4,
                  height: constraints.maxHeight * 0.4,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      detail.detailIcon ?? mode.modeIcon,
                      color: bgColor1(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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

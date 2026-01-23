import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class GraphLabels extends StatelessWidget {
  final double size;

  const GraphLabels({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LineChart(
          LineChartData(
            backgroundColor:
                const Color.fromARGB(194, 228, 228, 228), // 背景を白に設定
            gridData: const FlGridData(
              show: true, horizontalInterval: 1, // ← 明示的に指定（必要なら0.5など）
              verticalInterval: 1,
            ),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: true),
            minX: -5,
            maxX: 5,
            minY: -5,
            maxY: 5,
          ),
        ),
        // X軸のベクトル線
        CustomPaint(
          size: Size(size, size),
          painter: VectorPainter(startX: -5, startY: 0, endX: 5, endY: 0),
        ),
        // Y軸のベクトル線
        CustomPaint(
          size: Size(size, size),
          painter: VectorPainter(startX: 0, startY: -5, endX: 0, endY: 5),
        ),

        // 原点Oラベル
        Positioned(
          left: (-0.4 + 4.9) * (size / 10),
          top: size - (-0.2 + 5.1) * (size / 10),
          child: Text(
            'O',
            style: TextStyle(
              color: Colors.black,
              fontSize: size / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // X軸ラベル5
        Positioned(
          left: (4.5 + 4.9) * (size / 10),
          top: size - (0.4 + 5.1) * (size / 10),
          child: Text(
            '5',
            style: TextStyle(
              color: Colors.black,
              fontSize: size / 400 * 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // X軸ラベル-5
        Positioned(
          left: (-4.6 + 4.9) * (size / 10),
          top: size - (0.4 + 5.1) * (size / 10),
          child: Text(
            '-5',
            style: TextStyle(
              color: Colors.black,
              fontSize: size / 400 * 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // X軸の「x」
        Positioned(
          left: (4.5 + 4.9) * (size / 10),
          top: size - (-0.3 + 5.1) * (size / 10),
          child: Math.tex(
            r'\mathit x',
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size / 400 * 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Y軸ラベル5
        Positioned(
          left: (0.3 + 4.9) * (size / 10),
          top: size - (4.6 + 5.1) * (size / 10),
          child: Text(
            '5',
            style: TextStyle(
              color: Colors.black,
              fontSize: size / 400 * 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Y軸ラベル-5
        Positioned(
          left: (0.3 + 4.9) * (size / 10),
          top: size - (-4.6 + 5.1) * (size / 10),
          child: Text(
            '-5',
            style: TextStyle(
              color: Colors.black,
              fontSize: size / 400 * 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Y軸の「y」
        Positioned(
          left: (-0.3 + 4.9) * (size / 10),
          top: size - (4.5 + 5.1) * (size / 10),
          child: Math.tex(
            r'\mathit y',
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size / 400 * 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class VectorPainter extends CustomPainter {
  final double startX, startY, endX, endY;
  final Paint vectorPaint; // 名前を変更

  VectorPainter(
      {required this.startX,
      required this.startY,
      required this.endX,
      required this.endY})
      : vectorPaint = Paint()
          ..color = const Color.fromARGB(169, 0, 0, 0)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // 座標変換 (グラフ範囲[-5, 5] -> [0, size])
    double x1 = (startX + 5) * (size.width / 10);
    double y1 = size.height - (startY + 5) * (size.height / 10);
    double x2 = (endX + 5) * (size.width / 10);
    double y2 = size.height - (endY + 5) * (size.height / 10);

    // 矢印の線を描く
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), vectorPaint);

    // 矢印の先端を描く
    double arrowSize = 10;
    double angle = atan2(y2 - y1, x2 - x1);
    Path path = Path()
      ..moveTo(x2, y2)
      ..lineTo(x2 - arrowSize * cos(angle - pi / 6),
          y2 - arrowSize * sin(angle - pi / 6))
      ..moveTo(x2, y2)
      ..lineTo(x2 - arrowSize * cos(angle + pi / 6),
          y2 - arrowSize * sin(angle + pi / 6));
    canvas.drawPath(path, vectorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math_expressions/math_expressions.dart' hide Stack;
import 'package:math_quiz/math_quiz.dart';

class OriginPointlined {
  final Map<String, dynamic> deta;

  OriginPointlined({required this.deta});
}

class ResultPointlined {
  final String? graph1, graph2;
  final String? ss1;
  final double x, y, kx, ky;
  final String sx, sy;

  ResultPointlined({
    this.graph1,
    this.graph2,
    this.ss1,
    required this.x,
    required this.y,
    required this.sx,
    required this.sy,
    required this.kx,
    required this.ky,
  });
}

class CalculatePointlined {
  ResultPointlined convert(OriginPointlined origin) {
    final sx = origin.deta["x"];
    final sy = origin.deta["y"];
    final x = latextonumber(sx);
    final y = latextonumber(sy);
    final sa = origin.deta["a"];
    final aa = latextonumber(sa);
    final sb = origin.deta["b"];
    final bb = latextonumber(sb);
    final sc = origin.deta["c"];
    final cc = latextonumber(sc);
    final graph1 = plusminusreplace("${-(aa / bb)}*x-${(cc / bb)}");
    final graph2 = plusminusreplace("${(bb / aa)}*x-${(bb / aa) * x}+$y");
    final ss1 = makingFanctionLine(sa, sb, sc);
    final kx = (bb * bb * x - aa * cc - aa * bb * y) / (aa * aa + bb * bb);
    final ky = (-aa / bb) * kx - (cc / bb);

    return ResultPointlined(
        graph1: graph1,
        graph2: graph2,
        ss1: ss1,
        x: x,
        y: y,
        sx: sx,
        sy: sy,
        kx: kx,
        ky: ky);
  }

  List<LineChartBarData> generateGraphData(
      String input, Color lineColor, double min, double max) {
    List<LineChartBarData> barDataList = [];
    List<FlSpot> currentLine = [];
    ShuntingYardParser parser = ShuntingYardParser();
    Expression exp = parser.parse(input);

    ContextModel cm = ContextModel();
    final evaluator = RealEvaluator(cm);
    double previousY = 0;
    bool firstPoint = true;

    // xの範囲を-5から5までに設定して関数を評価
    for (double x = min; x <= max; x += 0.03) {
      cm.bindVariable(Variable("x"), Number(x));
      double y = evaluator.evaluate(exp).toDouble(); // eval を使用

      if (y >= -5 && y <= 5) {
        if (firstPoint) {
          currentLine.add(FlSpot(x, y));
          firstPoint = false;
          previousY = y;
        } else {
          if ((previousY - y).abs() > 3) {
            if (currentLine.isNotEmpty) {
              barDataList.add(LineChartBarData(
                spots: List.from(currentLine),
                isCurved: true,
                color: lineColor,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ));
            }
            currentLine.clear();
            currentLine.add(FlSpot(x, y));
          } else {
            currentLine.add(FlSpot(x, y));
          }
        }
        previousY = y;
      }
    }

    if (currentLine.isNotEmpty) {
      barDataList.add(LineChartBarData(
        spots: List.from(currentLine),
        isCurved: true,
        color: lineColor,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
    }

    return barDataList;
  }
}

class KaigaPointlined extends StatelessWidget {
  final OriginPointlined origin;
  final CalculatePointlined calculate = CalculatePointlined();
  final double height;
  final double width;

  KaigaPointlined(
      {super.key,
      required this.origin,
      required this.width,
      required this.height});
  @override
  Widget build(BuildContext context) {
    final converted = CalculatePointlined().convert(origin);
    final graph1 = converted.graph1;
    final graph2 = converted.graph2;
    final ss1 = converted.ss1;
    final x = converted.x;
    final y = converted.y;
    final sx1 = converted.sx;
    final sy1 = converted.sy;
    final kx = converted.kx;
    final ky = converted.ky;

    return LayoutBuilder(builder: (context, constraints) {
      double size = min(height, width);

      return Center(
          child: SizedBox(
              width: size,
              height: size,
              child: Stack(children: [
                GraphLabels(size: size),
                LineChart(
                  LineChartData(
                    backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      ...calculate.generateGraphData(graph1!,
                          const Color.fromARGB(197, 33, 149, 243), -5, 5),
                      if (kx < x)
                        ...calculate.generateGraphData(graph2!,
                            const Color.fromARGB(214, 244, 67, 54), kx, x)
                      else
                        ...calculate.generateGraphData(graph2!,
                            const Color.fromARGB(214, 244, 67, 54), x, kx),
                    ],
                    minX: -5,
                    maxX: 5,
                    minY: -5,
                    maxY: 5,
                  ),
                ),
                CustomPaint(
                  size: Size(size, size),
                  painter: RightAnglePainter(
                      x: kx, y: ky, angle: atan2((x - kx), (y - ky))),
                ),
                Positioned(
                  left: (4.9 - 4.7) * (size / 10),
                  top: size - (5.1 - 1.6) * (size / 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(148, 255, 255, 255),
                          borderRadius: BorderRadius.circular(6), // ← 同様に角丸
                          border: Border.all(
                              color: const Color.fromARGB(
                                  179, 33, 149, 243)), // ← 薄い枠線を追加
                        ),
                        child: Math.tex(
                          'l:$ss1' "=0",
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: size / 400 * 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      // 座標点の表示
                    ],
                  ),
                ),
                Positioned(
                  left: (x + 4.9) * (size / 10),
                  top: size - (y + 5.1) * (size / 10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.circle,
                          size: size / 300 * 8,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      Positioned(
                        top: 0.5 * size / 10,
                        left: -0.4 * size / 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(148, 255, 255, 255),
                            borderRadius: BorderRadius.circular(6), // 角を丸める
                            border: Border.all(
                                color: const Color.fromARGB(171, 0, 0, 0)),
                          ),
                          child: Math.tex(
                            "($sx1,$sy1)", // 座標を表示
                            textStyle: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: size / 300 * 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ])));
    });
  }
}

class RightAnglePainter extends CustomPainter {
  final double x;
  final double y;
  final double angle; // ラジアン

  RightAnglePainter({
    required this.x,
    required this.y,
    required this.angle, // デフォルトは回転なし
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scale = size.width / 10;
    double px = (x + 5) * scale;
    double py = size.height - (y + 5) * scale;

    const double markSize = 10;

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    // 相対座標（L字の形）
    const p1 = Offset(markSize, 0);
    const p2 = Offset(markSize, -markSize);
    const p3 = Offset(0, -markSize);

    // 回転関数
    Offset rotate(Offset point, double angle) {
      final cosA = cos(angle);
      final sinA = sin(angle);
      return Offset(
        point.dx * cosA - point.dy * sinA,
        point.dx * sinA + point.dy * cosA,
      );
    }

    final center = Offset(px, py);
    final a = center + rotate(p1, angle);
    final b = center + rotate(p2, angle);
    final c = center + rotate(p3, angle);

    // 2本の線を描く（直角記号）
    canvas.drawLine(a, b, paint);
    canvas.drawLine(c, b, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


// 修正後の VectorPainter クラス



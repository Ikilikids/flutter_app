import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math_expressions/math_expressions.dart' hide Stack;
import '../quiz.dart';

class ResultSekibunmenseki {
  final String? graph1;
  final String? graph2;
  final String? graph3;
  final String? ss1;
  final String? ss2;
  final String? ss3;
  final double x1, y1, x2, y2;
  final String sx1, sy1, sx2, sy2;

  ResultSekibunmenseki({
    this.graph1,
    this.graph2,
    this.graph3,
    this.ss1,
    this.ss2,
    this.ss3,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.sx1,
    required this.sy1,
    required this.sx2,
    required this.sy2,
  });
}

class CalculateSekibunMenseki {
  ResultSekibunmenseki convert(SekimenMakingData origin) {
    final sx1 = origin.data.x1;
    final sy1 = origin.data.y1;
    final sx2 = origin.data.x2;
    final sy2 = origin.data.y2;
    final x1 = latextonumber(sx1);
    final y1 = latextonumber(sy1);
    final x2 = latextonumber(sx2);
    final y2 = latextonumber(sy2);

    String? graph1, graph2, graph3, ss1, ss2, ss3;

    final sort = origin.making[1];

    if (sort == "pd") {
      final sa = origin.data.a1;
      final sb = lc("(($sy1-$sy2)/($sx1-$sx2))-$sa*($sx1+$sx2)");
      final sc = lc("$sy1-$sa*$sx1*$sx1-($sb)*$sx1");
      ss1 = makingFanction2D(sa, sb, sc);
      final a = latextonumber(sa);
      final aa = zeroIfClose(a.toDouble());
      final bb = zeroIfClose(((y1 - y2) / (x1 - x2)) - aa * (x1 + x2));
      final cc = zeroIfClose(y1 - aa * x1 * x1 - bb * x1);
      graph1 = "$aa*x*x+$bb*x+$cc";
    } else if (sort == "pp") {
      final sa1 = origin.data.a1;
      final sa2 = origin.data.a2;
      final sb1 = lc("(($sy1-$sy2)/($sx1-$sx2))-$sa1*($sx1+$sx2)");
      final sb2 = lc("(($sy1-$sy2)/($sx1-$sx2))-$sa2*($sx1+$sx2)");
      final sc1 = lc("$sy1-$sa1*$sx1*$sx1-($sb1)*$sx1");
      final sc2 = lc("$sy1-$sa2*$sx1*$sx1-($sb2)*$sx1");
      ss1 = makingFanction2D(sa1, sb1, sc1);
      ss2 = makingFanction2D(sa2, sb2, sc2);
      final a1 = latextonumber(sa1);
      final a2 = latextonumber(sa2);
      final aa1 = zeroIfClose(a1.toDouble());
      final aa2 = zeroIfClose(a2.toDouble());
      final bb1 = zeroIfClose(((y1 - y2) / (x1 - x2)) - aa1 * (x1 + x2));
      final bb2 = zeroIfClose(((y1 - y2) / (x1 - x2)) - aa2 * (x1 + x2));
      final cc1 = zeroIfClose(y1 - aa1 * x1 * x1 - bb1 * x1);
      final cc2 = zeroIfClose(y1 - aa2 * x1 * x1 - bb2 * x1);
      graph1 = "$aa1*x*x+$bb1*x+$cc1";
      graph2 = "$aa2*x*x+$bb2*x+$cc2";
    } else if (sort == "psd") {
      final sa = origin.data.a1;
      final sb = lc("(($sy1-$sy2)/($sx1-$sx2))-2*$sa*$sx1");
      final sc = lc("$sy1-$sa*$sx1*$sx1-($sb)*$sx1");
      ss1 = makingFanction2D(sa, sb, sc);
      final a = latextonumber(sa);
      final aa = zeroIfClose(a.toDouble());
      final bb = zeroIfClose(((y1 - y2) / (x1 - x2)) - 2 * aa * x1);
      final cc = zeroIfClose(y1 - aa * x1 * x1 - bb * x1);
      graph1 = "$aa*x*x+$bb*x+$cc";
      ss1 = makingFanction2D(sa, sb, sc);
    } else if (sort == "pps") {
      final sa = origin.data.a1;
      final sb1 = lc("(($sy1-$sy2)/($sx1-$sx2))-2*$sa*$sx1");
      final sb2 = lc("(($sy1-$sy2)/($sx1-$sx2))-2*$sa*$sx2");
      final sc1 = lc("$sy1-$sa*$sx1*$sx1-($sb1)*$sx1");
      final sc2 = lc("$sy2-$sa*$sx2*$sx2-($sb2)*$sx2");
      ss1 = makingFanction2D(sa, sb1, sc1);
      ss3 = makingFanction2D(sa, sb2, sc2);
      final a = latextonumber(sa);
      final aa = zeroIfClose(a.toDouble());
      final bb1 = zeroIfClose(((y1 - y2) / (x1 - x2)) - 2 * aa * x1);
      final cc1 = zeroIfClose(y1 - aa * x1 * x1 - bb1 * x1);
      final bb2 = zeroIfClose(((y1 - y2) / (x1 - x2)) - 2 * aa * x2);
      final cc2 = zeroIfClose(y2 - aa * x2 * x2 - bb2 * x2);
      graph1 = "$aa*x*x+$bb1*x+$cc1";
      graph3 = "$aa*x*x+$bb2*x+$cc2";
    } else if (sort == "pss") {
      final sa = origin.data.a1;
      final sb = lc("(($sy1-$sy2)/($sx1-$sx2))-$sa*($sx1+$sx2)");
      final sc = lc("$sy1-$sa*$sx1*$sx1-($sb)*$sx1");
      final sm1 = lc("2*$sa*$sx1+($sb)");
      final sm2 = lc("2*$sa*$sx2+($sb)");
      final sn1 = lc("$sy1-($sm1)*$sx1");
      final sn2 = lc("$sy2-($sm2)*$sx2");
      ss2 = makingFanction2D(sa, sb, sc);
      ss1 = makingFanction1D(sm1, sn1);
      ss3 = makingFanction1D(sm2, sn2);
      final a = latextonumber(sa);
      final aa = zeroIfClose(a.toDouble());
      final bb = zeroIfClose(((y1 - y2) / (x1 - x2)) - aa * (x2 + x1));
      final cc = zeroIfClose(y1 - aa * x1 * x1 - bb * x1);
      final mm1 = zeroIfClose(2 * aa * x1 + bb);
      final nn1 = zeroIfClose(y1 - mm1 * x1);
      final mm2 = zeroIfClose(2 * aa * x2 + bb);
      final nn2 = zeroIfClose(y2 - mm2 * x2);
      graph2 = "$aa*x*x+$bb*x+$cc";
      graph1 = "$mm1*x+$nn1";
      graph3 = "$mm2*x+$nn2";
    } else if (sort == "cs") {
      final sa = origin.data.a1;
      final sb = lc("-$sa*(2*$sx1+$sx2)");
      final sc =
          lc("($sa*($sx1^3+$sx1^2*$sx2-2*$sx1*$sx2^2)+$sy1-$sy2)/($sx1-$sx2)");
      final sd = lc(
          "(-$sa*$sx1^3*$sx2+$sa*$sx1^2*$sx2^2+$sx1*$sy2-$sx2*$sy1)/($sx1-$sx2)");
      ss1 = makingFanction3D(sa, sb, sc, sd);
      final a = latextonumber(sa);
      final aa = zeroIfClose(a.toDouble());
      final bb = zeroIfClose(-aa * (2 * x1 + x2));
      final cc = zeroIfClose(
          (a * (x1 * x1 * x1 + x1 * x1 * x2 - 2 * x1 * x2 * x2) + y1 - y2) /
              (x1 - x2));
      final dd = zeroIfClose(
          (-a * x1 * x1 * x1 * x2 + a * x1 * x1 * x2 * x2 + x1 * y2 - x2 * y1) /
              (x1 - x2));
      graph1 = "$aa*x*x*x+$bb*x*x+$cc*x+$dd";
    }

    if (["pd", "pps", "psd", "cs"].contains(sort)) {
      final mm = zeroIfClose((y2 - y1) / (x2 - x1));
      final nn = zeroIfClose((x2 * y1 - x1 * y2) / (x2 - x1));
      graph2 = "$mm*x+$nn";
      final sm = lc("($sy2-$sy1)/($sx2-$sx1)");
      final sn = lc("($sx2*$sy1-$sx1*$sy2)/($sx2-$sx1)");
      ss2 = makingFanction1D(sm, sn);
    }

    // 演算子整理
    graph1 = graph1?.replaceAll("+-", "-");
    graph2 = graph2?.replaceAll("+-", "-");
    return ResultSekibunmenseki(
      graph1: graph1,
      graph2: graph2,
      graph3: graph3,
      ss1: ss1,
      ss2: ss2,
      ss3: ss3,
      x1: x1,
      y1: y1,
      x2: x2,
      y2: y2,
      sx1: sx1,
      sy1: sy1,
      sx2: sx2,
      sy2: sy2,
    );
  }

  // グラフデータを生成するメソッド
  List<LineChartBarData> generateGraphData(String input, Color lineColor) {
    List<LineChartBarData> barDataList = [];
    List<FlSpot> currentLine = [];
    ShuntingYardParser parser = ShuntingYardParser();
    ContextModel cm = ContextModel();
    Expression exp = parser.parse(input);
    double previousY = 0;
    bool firstPoint = true;
    final evaluator = RealEvaluator(cm);

    // xの範囲を-5から5までに設定して関数を評価
    for (double x = -5; x <= 5; x += 0.03) {
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
// 座標をフォーマットするメソッド

class Sekimen extends StatelessWidget {
  final SekimenMakingData origin;

  final double height;
  final double width;

  const Sekimen(
      {super.key,
      required this.origin,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    final CalculateSekibunMenseki calculate = CalculateSekibunMenseki();
    final converted = CalculateSekibunMenseki().convert(origin);

    final graph1 = converted.graph1;
    final graph2 = converted.graph2;
    final graph3 = converted.graph3;
    final ss1 = converted.ss1;
    final ss2 = converted.ss2;
    final ss3 = converted.ss3;
    final x1 = converted.x1;
    final y1 = converted.y1;
    final x2 = converted.x2;
    final y2 = converted.y2;
    final sx1 = converted.sx1;
    final sy1 = converted.sy1;
    final sx2 = converted.sx2;
    final sy2 = converted.sy2;

    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(height, width);
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                GraphLabels(size: size),
                LineChart(
                  LineChartData(
                    backgroundColor:
                        const Color.fromARGB(0, 255, 255, 255), // 背景を白に設定
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      ...calculate.generateGraphData(
                          graph1!, const Color.fromARGB(197, 33, 149, 243)),
                      ...calculate.generateGraphData(
                          graph2!, const Color.fromARGB(214, 244, 67, 54)),
                      if (graph3 != null)
                        ...calculate.generateGraphData(
                          graph3,
                          const Color.fromARGB(197, 33, 149, 243),
                        ),
                    ],
                    minX: -5,
                    maxX: 5,
                    minY: -5,
                    maxY: 5,
                  ),
                ),
                // 原点に「O」を配置
                CustomPaint(
                    size: Size(size, size),
                    painter: AreaPainter(
                        graph1: graph1,
                        graph2: graph2,
                        graph3: graph3,
                        x1: x1,
                        x2: x2)),
                Positioned(
                  left: (4.9 - 4.7) * (size / 10),
                  top: size - (5.1 - 1.0) * (size / 10),
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
                          'f(x)=$ss1',
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: graph3 == null
                                ? size / 400 * 19
                                : size / 400 * 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size / 30,
                      ),
                      if (graph3 != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(148, 255, 255, 255),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color.fromARGB(179, 33, 149, 243),
                            ),
                          ),
                          child: Math.tex(
                            'g(x)=$ss3',
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: size / 400 * 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: size / 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(148, 255, 255, 255),
                          borderRadius: BorderRadius.circular(6), // ← 同様に角丸
                          border: Border.all(
                              color: const Color.fromARGB(
                                  176, 244, 67, 54)), // ← 薄い枠線を追加
                        ),
                        child: Math.tex(
                          'l(x)=$ss2',
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: graph3 == null
                                ? size / 400 * 19
                                : size / 400 * 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // x と y の座標値を表示
                Positioned(
                  left: (x1 + 4.9) * (size / 10),
                  top: size - (y1 + 5.1) * (size / 10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.circle,
                          size: size / 300 * 8,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      Positioned(
                        top: 0.4 * size / 10,
                        left: x2 > x1 ? -1.1 * size / 10 : -0.1 * size / 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(148, 255, 255, 255),
                            borderRadius: BorderRadius.circular(6), // 角を丸める
                            border: Border.all(
                                color: const Color.fromARGB(174, 0, 0, 0)),
                          ),
                          child: Math.tex(
                            "($sx1,$sy1)", // 座標を表示
                            textStyle: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: sx1.contains("sqrt")
                                  ? size / 300 * 10
                                  : size / 300 * 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: (x2 + 4.9) * (size / 10),
                  top: size - (y2 + 5.1) * (size / 10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.circle,
                          size: size / 300 * 8,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      Positioned(
                        top: 0.4 * size / 10,
                        left: x2 < x1 ? -1.1 * size / 10 : -0.1 * size / 10,
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
                            "($sx2,$sy2)", // 座標を表示
                            textStyle: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: sx1.contains("sqrt")
                                  ? size / 300 * 10
                                  : size / 300 * 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AreaPainter extends CustomPainter {
  final String graph1;
  final String graph2;
  final String? graph3;
  final double x1;
  final double x2;

  AreaPainter({
    required this.graph1,
    required this.graph2,
    required this.graph3,
    required this.x1,
    required this.x2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // スケーリング
    double scaleX = size.width / 10;
    double scaleY = size.height / 10;
    double offsetX = size.width / 2;
    double offsetY = size.height / 2;

    Path areaPath = Path();
    ShuntingYardParser parser = ShuntingYardParser();
    ContextModel cm = ContextModel();
    final evaluator = RealEvaluator(cm); // 修正：RealEvaluator を使用

    Expression exp1 = parser.parse(graph1);
    Expression exp2 = parser.parse(graph2);

    List<Offset> upper = [];
    List<Offset> lower = [];

    double step = 0.03;
    double dir = x1 < x2 ? 1 : -1;

    if (graph3 != null) {
      Expression exp3 = parser.parse(graph3!);
      for (double x = x1;
          (dir > 0 ? x <= (x1 + x2) / 2 : x >= (x1 + x2) / 2);
          x += dir * step) {
        cm.bindVariable(Variable("x"), Number(x));
        double y = evaluator.evaluate(exp1).toDouble(); // 修正：evaluate メソッドを使用
        double px = offsetX + x * scaleX;
        double py = offsetY - y * scaleY;
        upper.add(Offset(px, py));
      }
      for (double x = (x1 + x2) / 2;
          (dir > 0 ? x <= x2 : x >= x2);
          x += dir * step) {
        cm.bindVariable(Variable("x"), Number(x));
        double y = evaluator.evaluate(exp3).toDouble(); // 修正：evaluate メソッドを使用
        double px = offsetX + x * scaleX;
        double py = offsetY - y * scaleY;
        upper.add(Offset(px, py));
      }

      for (double x = x2; (dir > 0 ? x >= x1 : x <= x1); x -= dir * step) {
        cm.bindVariable(Variable("x"), Number(x));
        double y = evaluator.evaluate(exp2).toDouble(); // 修正：evaluate メソッドを使用
        double px = offsetX + x * scaleX;
        double py = offsetY - y * scaleY;
        lower.add(Offset(px, py));
      }
    } else {
      for (double x = x1; (dir > 0 ? x <= x2 : x >= x2); x += dir * step) {
        cm.bindVariable(Variable("x"), Number(x));
        double y = evaluator.evaluate(exp1).toDouble(); // 修正：evaluate メソッドを使用
        double px = offsetX + x * scaleX;
        double py = offsetY - y * scaleY;
        upper.add(Offset(px, py));
      }

      for (double x = x2; (dir > 0 ? x >= x1 : x <= x1); x -= dir * step) {
        cm.bindVariable(Variable("x"), Number(x));
        double y = evaluator.evaluate(exp2).toDouble(); // 修正：evaluate メソッドを使用
        double px = offsetX + x * scaleX;
        double py = offsetY - y * scaleY;
        lower.add(Offset(px, py));
      }
    }

    if (upper.isNotEmpty) {
      areaPath.moveTo(upper.first.dx, upper.first.dy);
      for (var p in upper) {
        areaPath.lineTo(p.dx, p.dy);
      }
      for (var p in lower) {
        areaPath.lineTo(p.dx, p.dy);
      }
      areaPath.close();
      canvas.drawPath(areaPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

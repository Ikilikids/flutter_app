import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math_quiz/assistance/makingdata_latex.dart';

class Triangle extends StatelessWidget {
  final TriangleMakingData origin;
  final double height;
  final double width;
  const Triangle(
      {super.key,
      required this.origin,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    double size = min(height, width);

    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      body: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Column(
            children: [
              // 上ラベル (sinC, cosC)
              Expanded(
                flex: 1,
                child: Builder(
                  builder: (_) {
                    if (!origin.data.ff.contains("f") &&
                        !origin.data.ff.contains("c")) {
                      return const SizedBox.shrink();
                    }

                    // a と b の比を取得（文字列 → double に変換）
                    final int a = int.parse(origin.data.a.toString());
                    final int b = int.parse(origin.data.b.toString());
                    int total = a + b;
                    // 比率に基づく左右スペーサー
                    final double leftFlex = b / total * 50;
                    final double rightFlex = a / total * 50;

                    final Widget label = Math.tex(
                      origin.data.ff.contains("f")
                          ? '\\sin{C}=${origin.data.sinC}'
                          : '\\cos{C}=${origin.data.cosC}',
                      textStyle:
                          TextStyle(fontSize: 14, color: textColor1(context)),
                    );

                    return Row(
                      children: [
                        Expanded(
                            flex: leftFlex.round(), child: const SizedBox()),
                        label,
                        Expanded(
                            flex: rightFlex.round(), child: const SizedBox()),
                      ],
                    );
                  },
                ),
              ),

              // 中央三角形
              Expanded(
                flex: 3,
                child: CustomPaint(
                  painter: TrianglePainter(
                      origin: origin,
                      height: size * 0.5,
                      width: size,
                      context: context),
                ),
              ),

              // 下ラベル1 (sinA, sinB)
              Expanded(
                flex: 1,
                child: Builder(
                  builder: (_) {
                    // 左と右のラベルを選択（存在する場合のみ）
                    Widget? leftLabel;
                    Widget? rightLabel;

                    // sinラベル
                    if (origin.data.ff.contains("d")) {
                      leftLabel = Math.tex('\\sin{A}=${origin.data.sinA}',
                          textStyle: TextStyle(
                              fontSize: 14, color: textColor1(context)));
                    } else if (origin.data.ff.contains("a")) {
                      leftLabel = Math.tex('\\cos{A}=${origin.data.cosA}',
                          textStyle: TextStyle(
                              fontSize: 14, color: textColor1(context)));
                    }

                    if (origin.data.ff.contains("e")) {
                      rightLabel = Math.tex('\\sin{B}=${origin.data.sinB}',
                          textStyle: TextStyle(
                              fontSize: 14, color: textColor1(context)));
                    } else if (origin.data.ff.contains("b")) {
                      rightLabel = Math.tex('\\cos{B}=${origin.data.cosB}',
                          textStyle: TextStyle(
                              fontSize: 14, color: textColor1(context)));
                    }

                    // Rowで左右に配置
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        leftLabel ?? const SizedBox(width: 0),
                        const Spacer(),
                        if (rightLabel != null) rightLabel,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final TriangleMakingData origin;
  final double height;
  final double width;
  final BuildContext context; // ← 追加
  TrianglePainter({
    required this.origin,
    required this.height,
    required this.width,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 入力データ
    int a = origin.data.a;
    int b = origin.data.b;
    int c = origin.data.c;

    // 2. 仮の三角形座標を計算

// 点AとBを固定
    Offset A = const Offset(0, 0);
    Offset B = Offset(c.toDouble(), 0);

// 余弦定理で angleC（角C = ∠ACB）を求める
    double cosA = ((b * b + c * c - a * a) / (2 * b * c));
    double angleA = acos(cosA);

// 点Cの位置（A原点から角度angleCで距離b進む）
    Offset C = Offset(
      b * cos(angleA),
      b * -sin(angleA),
    );

    Offset canvasCenter = Offset(size.width / 2, size.height / 2);
    // 3. スケール決定（Y方向が±70以内に収まるように）
    List<double> xs = [A.dx, B.dx, C.dx];

// 2. xのmin/maxと範囲
    double xMin = xs.reduce(min);
    double xMax = xs.reduce(max);
    double gx = (xMax + xMin) / 2;

// 3. yのmin/maxと範囲（既にある）
    List<double> ys = [A.dy, B.dy, C.dy];
    double yMin = ys.reduce(min);
    double yMax = ys.reduce(max);
    double gy = (yMax + yMin) / 2;

// 4. 目標の描画領域（マージン考慮）
    double targetWidth = width * 0.8;
    double targetHeight = height * 0.7;

    Offset m = Offset(canvasCenter.dx - gx, canvasCenter.dy - gy);

    Offset ap = A + m;
    Offset bp = B + m;
    Offset cp = C + m;

    double kx = ((targetWidth / 2) / (bp.dx - canvasCenter.dx));
    double ky = ((targetHeight / 2) / -(cp.dy - canvasCenter.dy));
    double k = min(kx, ky);
    ap = (ap - canvasCenter) * k + canvasCenter;
    bp = (bp - canvasCenter) * k + canvasCenter;
    cp = (cp - canvasCenter) * k + canvasCenter;
    final Paint paint = Paint()
      ..color = textColor1(context)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..moveTo(ap.dx, ap.dy)
      ..lineTo(bp.dx, bp.dy)
      ..lineTo(cp.dx, cp.dy)
      ..close();
    canvas.drawPath(path, paint);

    Offset topaint(Offset P, Offset Q, int value) {
      Offset midpoint = (P + Q) / 2;

      Offset direction = Q - P;

      // AB の法線ベクトル（90度回転: 反時計回り）
      Offset normal = Offset(-direction.dy, direction.dx);

      // direction.distance が 0 のときを防ぐ
      if (normal.distance == 0) return midpoint;

      // 正規化して value 倍する
      Offset offset = normal / normal.distance * value.toDouble();

      return midpoint + offset;
    }

    // 7. ラベル描画（スケール補正済み位置、文字サイズも補正）
    void drawPoint(
      Canvas canvas,
      Offset p,
      String label, {
      double fontSize = 15.0,
    }) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: textColor1(context), fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final textOffset = p - Offset(tp.width / 2, tp.height / 2);
      tp.paint(canvas, textOffset);
    }

    drawPoint(canvas, topaint(ap, bp, 10), '$c', fontSize: 15);
    drawPoint(canvas, topaint(bp, cp, 15), '$a', fontSize: 15);
    drawPoint(canvas, topaint(cp, ap, 15), '$b', fontSize: 15);
    drawPoint(canvas, ap - const Offset(15, 0), 'A', fontSize: 15);
    drawPoint(canvas, cp - const Offset(0, 10), 'C', fontSize: 15);
    drawPoint(canvas, bp - const Offset(-15, 0), 'B', fontSize: 15);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.origin != origin;
  }
}

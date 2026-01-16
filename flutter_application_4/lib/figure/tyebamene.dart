import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/formula.dart';

class CevaDemo extends StatelessWidget {
  final Map<String, dynamic> deta;
  final double height;
  final double width;
  const CevaDemo(
      {super.key,
      required this.deta,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    double size = min(height, width);
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      body: Center(
        child: CustomPaint(
          size: Size(size, size),
          painter: CevaPainter(deta: deta, context: context),
        ),
      ),
    );
  }
}

class CevaPainter extends CustomPainter {
  final Map<String, dynamic> deta;
  final BuildContext context; // ← 追加
  const CevaPainter({
    required this.deta,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pA = Offset(size.width * 0.5, size.height * 0.2); // 頂点 A
    final pB = Offset(size.width * 0.1, size.height * 0.9); // 頂点 B
    final pC = Offset(size.width * 0.9, size.height * 0.9); // 頂点 C

    // それぞれの対辺上の点 D, E, F を “比” で決める（ここでは固定で 2:3）
    Offset onSegment(Offset p, Offset q, double t) => Offset(
          p.dx + (q.dx - p.dx) * t,
          p.dy + (q.dy - p.dy) * t,
        );

    double zd = deta["zbd"] / (deta["zbd"] + deta["zdc"]);
    double ze = deta["zce"] / (deta["zce"] + deta["zea"]);
    double zf = deta["zaf"] / (deta["zaf"] + deta["zfb"]);
    final pD = onSegment(pB, pC, zd); // 点 D は BC 上
    final pE = onSegment(pC, pA, ze); // 点 E は CA 上
    final pF = onSegment(pA, pB, zf); // 点 F は AB 上
    final pP = lineIntersection(pA, pD, pB, pE); // 交点 P

    // -------- 描画設定 --------
    final triPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = textColor1(context);
    final cevianPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.blueGrey;

    // 三角形
    final triPath = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..close();
    canvas.drawPath(triPath, triPaint);

    // セバ線 AD, BE, CF
    canvas.drawLine(pA, pD, cevianPaint);
    canvas.drawLine(pB, pE, cevianPaint);
    canvas.drawLine(pC, pF, cevianPaint);

    // 点を目立たせる
    void drawPoint(
      Canvas canvas,
      Offset p,
      String label, {
      Offset labelOffset = const Offset(0, 0),
      Color pointColor = Colors.red,
      double pointRadius = 10,
      Color? strokeColor,
      double strokeWidth = 1,
      TextStyle? labelStyle,
    }) {
      strokeColor ??= textColor1(context); // デフォルト色はここで決定
      labelStyle ??= TextStyle(
        color: textColor1(context),
        fontSize: 15,
      );
      // 1. 塗りつぶし（塗りたい場合のみ）
      if (pointColor.a > 0) {
        canvas.drawCircle(
          p,
          pointRadius,
          Paint()
            ..style = PaintingStyle.fill
            ..color = pointColor,
        );
      }

      // 2. 枠線（指定があれば描く）

      canvas.drawCircle(
        p,
        pointRadius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = strokeColor,
      );

      // 3. ラベル
      final tp = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final textOffset = p - Offset(tp.width / 2, tp.height / 2) + labelOffset;
      tp.paint(canvas, textOffset);
    }

    drawPoint(canvas, pA, 'A',
        labelOffset: const Offset(6, -12), pointRadius: 4, strokeColor: null);
    drawPoint(canvas, pB, 'B',
        labelOffset: const Offset(0, 14), pointRadius: 4, strokeColor: null);
    drawPoint(canvas, pC, 'C',
        labelOffset: const Offset(0, 14), pointRadius: 4, strokeColor: null);
    drawPoint(canvas, pD, 'D',
        labelOffset: const Offset(0, 14), pointRadius: 4, strokeColor: null);
    drawPoint(canvas, pE, 'E',
        labelOffset: const Offset(6, -12), pointRadius: 4, strokeColor: null);
    drawPoint(canvas, pF, 'F',
        labelOffset: const Offset(-14, -8), pointRadius: 4, strokeColor: null);
    drawPoint(canvas, pP, 'P',
        pointColor: Colors.green, // 他と区別しやすい色
        labelOffset: const Offset(6, 10),
        pointRadius: 4,
        strokeColor: null);
    if (deta["tf"] != null && deta["tf"].toString().contains("c")) {
      drawPoint(
        canvas,
        const Offset(-12, -10) + (pF + pA) / 2,
        deta["zaf"].toString(),
        pointColor: const Color.fromARGB(100, 255, 0, 0),
        pointRadius: 10,
        labelStyle: TextStyle(color: textColor1(context), fontSize: 15),
      );
      drawPoint(
        canvas,
        const Offset(-12, -10) + (pF + pB) / 2,
        deta["zfb"].toString(),
        pointColor: const Color.fromARGB(100, 255, 0, 0),
        pointRadius: 10,
        labelStyle: TextStyle(color: textColor1(context), fontSize: 15),
      );
    }
    if (deta["tf"] != null && deta["tf"].toString().contains("b")) {
      drawPoint(
          canvas, const Offset(12, -10) + (pA + pE) / 2, deta["zea"].toString(),
          pointColor: const Color.fromARGB(128, 255, 200, 0),
          pointRadius: 10,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 15));
      drawPoint(
          canvas, const Offset(12, -10) + (pE + pC) / 2, deta["zce"].toString(),
          pointColor: const Color.fromARGB(128, 255, 200, 0),
          pointRadius: 10,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 15));
    }
    if (deta["tf"] != null && deta["tf"].toString().contains("a")) {
      drawPoint(
          canvas, const Offset(2, 12) + (pB + pD) / 2, deta["zbd"].toString(),
          pointColor: const Color.fromARGB(100, 72, 255, 0),
          pointRadius: 10,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 15));
      drawPoint(
          canvas, const Offset(2, 12) + (pD + pC) / 2, deta["zdc"].toString(),
          pointColor: const Color.fromARGB(100, 72, 255, 0),
          pointRadius: 10,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 15));
    }
    if (deta["tf"] != null && deta["tf"].toString().contains("f")) {
      drawPoint(
          canvas, const Offset(0, 0) + (pF + pP) / 2, deta["zpf"].toString(),
          pointColor: const Color.fromARGB(255, 0, 255, 221),
          pointRadius: 8,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 12));
      drawPoint(
          canvas, const Offset(0, 0) + (pC + pP) / 2, deta["zcp"].toString(),
          pointColor: const Color.fromARGB(255, 0, 255, 221),
          pointRadius: 8,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 12));
    }
    if (deta["tf"] != null && deta["tf"].toString().contains("e")) {
      drawPoint(
          canvas, const Offset(0, 0) + (pB + pP) / 2, deta["zbp"].toString(),
          pointColor: const Color.fromARGB(255, 0, 34, 255),
          pointRadius: 8,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 12));
      drawPoint(
          canvas, const Offset(0, 0) + (pE + pP) / 2, deta["zpe"].toString(),
          pointColor: const Color.fromARGB(255, 0, 34, 255),
          pointRadius: 8,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 12));
    }
    if (deta["tf"] != null && deta["tf"].toString().contains("d")) {
      drawPoint(
          canvas, const Offset(0, 0) + (pA + pP) / 2, deta["zap"].toString(),
          pointColor: const Color.fromARGB(255, 217, 0, 255),
          pointRadius: 8,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 12));
      drawPoint(
          canvas, const Offset(0, 0) + (pD + pP) / 2, deta["zpd"].toString(),
          pointColor: const Color.fromARGB(255, 217, 0, 255),
          pointRadius: 8,
          labelStyle: TextStyle(color: textColor1(context), fontSize: 12));
    }
  }

  @override
  bool shouldRepaint(CevaPainter oldDelegate) => false;
}

Offset lineIntersection(
  Offset p1,
  Offset p2,
  Offset p3,
  Offset p4,
) {
  final s1 = Offset(p2.dx - p1.dx, p2.dy - p1.dy);
  final s2 = Offset(p4.dx - p3.dx, p4.dy - p3.dy);
  final denom = (-s2.dx * s1.dy + s1.dx * s2.dy);

  if (denom.abs() < 1e-6) {
    // 平行（理論上あり得ないけど念のため）
    return Offset.zero;
  }
  final s = (-s1.dy * (p1.dx - p3.dx) + s1.dx * (p1.dy - p3.dy)) / denom;
  return Offset(p3.dx + s * s2.dx, p3.dy + s * s2.dy);
}
/**/
import 'package:common/widgets/color.dart';
import 'package:flutter/material.dart';

Widget buildCircleWidget(
  List<String> parts,
  BuildContext context,
  double circleSize,
  String main,
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
              getIconForCategory(main) ??
                  (isLimitedMode ? Icons.timer : Icons.all_inclusive),
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

IconData? getIconForCategory(String category) {
  switch (category) {
    case '二次関数':
      return Icons.superscript; // 関数のアイコン
    case '数と式':
      return Icons.calculate; // 計算のアイコン
    case '三角比':
      return Icons.change_history; // 三角形アイコン
    case '図形と方程式':
      return Icons.square_foot; // 図形っぽいアイコン
    case '解と方程式':
      return Icons.low_priority; // 図形っぽいアイコン
    case '積分':
      return Icons.line_axis; // 積分アイコン（Flutterにない場合は代替アイコン）
    case '微分':
      return Icons.exposure; // 微分っぽいアイコンとして代用
    case '三角関数':
      return Icons.waves; // 三角関数向けに波っぽいイメージ
    case '論証':
      return Icons.gavel; // 論証→裁判のハンマーアイコン
    case '確率':
      return Icons.casino; // 確率 → ギャンブル系アイコン
    case '数列':
      return Icons.format_list_numbered; // 数列 → 番号付きリストアイコン
    case '指数・対数':
      return Icons.turn_sharp_right; // 指数っぽいイメージ
    case 'データ':
      return Icons.bar_chart; // データ→棒グラフ
    case '統計':
      return Icons.pie_chart; // 統計→円グラフ
    case '幾何':
      return Icons.architecture; // 図形→三角形アイコン
    case '整数':
      return Icons.looks_one; // 整数→番号的なアイコン
    case '複素数平面':
      return Icons.format_italic; // 複素数平面→散布図アイコン
    case 'ベクトル':
      return Icons.text_rotation_none; // ベクトル→矢印アイコン
    case '極限':
      return Icons.all_inclusive; // 極限→∞マーク風アイコン
    case '数Ⅲ　関数':
      return Icons.functions; // 数Ⅲ 関数も関数アイコンでよし
    case '二次曲線':
      return Icons.vignette; // 二次曲線→時間軸風
    case 'その他':
      return Icons.more_horiz; // その他→「…」のアイコン
    default:
      return null;
  }
}

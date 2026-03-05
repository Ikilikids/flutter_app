import 'dart:math';
import 'package:flutter/material.dart';

class ARankPainter extends CustomPainter {
  final double radius;

  ARankPainter({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius2 = radius * 1.02;
// 七角形の半径

    // 七角形のパスを描く
    Path path = Path();
    int sides = 7; // 7 sides instead of 8
    for (int i = 0; i < sides; i++) {
      double angle = (i * (360 / sides)) *
          (pi / 180); // 360° / 7 sides to get the correct angle
      double x = centerX + radius2 * cos(angle);
      double y = centerY + radius2 * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // 紫色の七角形を描く
    Paint paintPurple = Paint()
      ..color = const Color.fromARGB(255, 255, 55, 228);
    canvas.drawPath(path, paintPurple);

    // メダルの中心部分に円を描く（紫色の濃い円）
    Paint paintCircle = Paint()
      ..color = const Color.fromARGB(255, 255, 110, 224);
    canvas.drawCircle(Offset(centerX, centerY), radius2 * 0.7, paintCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 255, 110, 224); // 点々の色
    double dotRadius = radius * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius2 * 0.82; // 点々の半径（内側に配置するため）

    int dotCount = sides * 6; // 点々の数（七角形に合わせて21つ）
    for (int i = 0; i < dotCount; i++) {
      double angle = (i * (360 / dotCount)) * (pi / 180); // 点々の間隔を調整
      double x = centerX + dotRadiusFromCenter * cos(angle);
      double y = centerY + dotRadiusFromCenter * sin(angle);

      // 点々を描く
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots); // 点々を描く
    }

    // 「S」の文字を白色に変更
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'A',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 55, 228), // 内側の文字色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'A',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画
    double offset = radius * 0.01; // 縁取りの大きさ（調整）

    // 縁取りを4方向に描画
    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BRankPainter extends CustomPainter {
  final double radius;

  BRankPainter({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius2 = radius * 1.12; // 六角形の半径

    // 六角形のパスを描く
    Path path = Path();
    for (int i = 0; i < 6; i++) {
      double angle = (i * 60) * (pi / 180) + (pi / 6); // 60度ごとに頂点を作成
      double x = centerX + radius2 * cos(angle);
      double y = centerY + radius2 * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // 紫色の六角形を描く
    Paint paintPurple = Paint()..color = const Color.fromARGB(255, 255, 19, 19);
    canvas.drawPath(path, paintPurple);

    // メダルの中心部分に円を描く（紫色の濃い円）
    Paint paintCircle = Paint()..color = const Color.fromARGB(255, 255, 87, 87);
    canvas.drawCircle(Offset(centerX, centerY), radius2 * 0.65, paintCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 255, 87, 87); // 点々の色
    double dotRadius = radius2 * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius2 * 0.75; // 点々の半径（内側に配置するため）

    int dotCount = 36; // 点々の数（六角形に合わせて36つ）

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * 10) * (pi / 180); // 10度ごとに配置
      double x = centerX + dotRadiusFromCenter * cos(angle);
      double y = centerY + dotRadiusFromCenter * sin(angle);

      // 点々を描く
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots); // 点々を描く
    }

    // 「S」の文字を白色に変更
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'B',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 19, 19), // 内側の文字色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'B',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画
    double offset = radius * 0.01; // 縁取りの大きさ（調整）

    // 縁取りを4方向に描画
    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CRankPainter extends CustomPainter {
  final double radius;

  CRankPainter({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius2 = radius * 1.1;

    // 五角形のパスを描く
    Path path = Path();
    for (int i = 0; i < 5; i++) {
      double angle = (i * 72) * (pi / 180); // 72度ごとに頂点を作成
      double x = centerX + radius2 * cos(angle);
      double y = centerY + radius2 * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // 紫色の五角形を描く
    Paint paintPurple = Paint()..color = const Color.fromARGB(255, 255, 145, 0);
    canvas.drawPath(path, paintPurple);

    // メダルの中心部分に円を描く（紫色の濃い円）
    Paint paintCircle = Paint()
      ..color = const Color.fromARGB(255, 255, 186, 96);
    canvas.drawCircle(Offset(centerX, centerY), radius2 * 0.65, paintCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 255, 186, 96); // 点々の色
    double dotRadius = radius2 * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius2 * 0.75; // 点々の半径（内側に配置するため）

    int dotCount = 36; // 点々の数（五角形に合わせて36つ）

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * 10) * (pi / 180); // 10度ごとに配置
      double x = centerX + dotRadiusFromCenter * cos(angle);
      double y = centerY + dotRadiusFromCenter * sin(angle);

      // 点々を描く
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots); // 点々を描く
    }

    // 「B」の文字を白色に変更
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'C',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 145, 0), // 内側の文字色
          fontSize: radius2 * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'C',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius2 * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画
    double offset = radius2 * 0.01; // 縁取りの大きさ（調整）

    // 縁取りを4方向に描画
    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DRankPainter extends CustomPainter {
  final double radius;

  DRankPainter({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // 円を描く
    Paint paintCircle = Paint()
      ..color = const Color.fromARGB(255, 255, 217, 0); // 円の色
    canvas.drawCircle(Offset(centerX, centerY), radius, paintCircle);

    // メダルの中心部分に小さな円を描く
    Paint paintSmallCircle = Paint()
      ..color = const Color.fromARGB(255, 255, 232, 103); // 小さい円の色
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.7, paintSmallCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 255, 232, 103); // 点々の色
    double dotRadius = radius * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius * 0.85; // 点々の配置半径

    int dotCount = 36; // 点々の数（36個に設定）

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * 10) * (pi / 180); // 10度ごとに配置
      double x = centerX + dotRadiusFromCenter * cos(angle);
      double y = centerY + dotRadiusFromCenter * sin(angle);

      // 点々を描く
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots);
    }

    // 「D」の文字を白色に変更
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'D',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 217, 0), // 内側の文字色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'D',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画
    double offset = radius / 100; // 縁取りの大きさ（調整）

    // 縁取りを4方向に描画
    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ERankPainter extends CustomPainter {
  final double radius;

  ERankPainter({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // 円を描く
    Paint paintCircle = Paint()
      ..color = const Color.fromARGB(255, 2, 206, 46); // 円の色
    canvas.drawCircle(Offset(centerX, centerY), radius, paintCircle);

    // メダルの中心部分に小さな円を描く
    Paint paintSmallCircle = Paint()
      ..color = const Color.fromARGB(255, 105, 224, 131); // 小さい円の色
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.7, paintSmallCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 105, 224, 131); // 点々の色
    double dotRadius = radius * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius * 0.85; // 点々の配置半径

    int dotCount = 36; // 点々の数（36個に設定）

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * 10) * (pi / 180); // 10度ごとに配置
      double x = centerX + dotRadiusFromCenter * cos(angle);
      double y = centerY + dotRadiusFromCenter * sin(angle);

      // 点々を描く
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots);
    }

    // 「D」の文字を白色に変更
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'E',
        style: TextStyle(
          color: const Color.fromARGB(255, 2, 206, 46), // 内側の文字色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'E',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画
    double offset = radius / 100; // 縁取りの大きさ（調整）

    // 縁取りを4方向に描画
    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class FRankPainter extends CustomPainter {
  final double radius;

  FRankPainter({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // 円を描く
    Paint paintCircle = Paint()
      ..color = const Color.fromARGB(255, 2, 192, 206); // 円の色
    canvas.drawCircle(Offset(centerX, centerY), radius, paintCircle);

    // メダルの中心部分に小さな円を描く
    Paint paintSmallCircle = Paint()
      ..color = const Color.fromARGB(255, 89, 212, 228); // 小さい円の色
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.7, paintSmallCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 89, 212, 228); // 点々の色
    double dotRadius = radius * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius * 0.85; // 点々の配置半径

    int dotCount = 36; // 点々の数（36個に設定）

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * 10) * (pi / 180); // 10度ごとに配置
      double x = centerX + dotRadiusFromCenter * cos(angle);
      double y = centerY + dotRadiusFromCenter * sin(angle);

      // 点々を描く
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots);
    }

    // 「D」の文字を白色に変更
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'F',
        style: TextStyle(
          color: const Color.fromARGB(255, 2, 192, 206), // 内側の文字色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'F',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画
    double offset = radius / 100; // 縁取りの大きさ（調整）

    // 縁取りを4方向に描画
    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class GRankPainter extends CustomPainter {
  final double radius; // radiusをクラスの変数として追加

  GRankPainter({required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // 円を描く
    Paint paintCircle = Paint()
      ..color = const Color.fromARGB(255, 133, 133, 133); // 円の色
    canvas.drawCircle(Offset(centerX, centerY), radius, paintCircle);

    // メダルの中心部分に小さな円を描く
    Paint paintSmallCircle = Paint()
      ..color = const Color.fromARGB(255, 179, 179, 179); // 小さい円の色
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.7, paintSmallCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 179, 179, 179); // 点々の色
    double dotRadius = radius * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius * 0.85; // 点々の配置半径

    int dotCount = 36; // 点々の数（36個に設定）

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * 10) * (pi / 180); // 10度ごとに配置
      double x = centerX + dotRadiusFromCenter * cos(angle);
      double y = centerY + dotRadiusFromCenter * sin(angle);

      // 点々を描く
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots);
    }

    // 「D」の文字を白色に変更
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'G',
        style: TextStyle(
          color: const Color.fromARGB(255, 133, 133, 133), // 内側の文字色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'G',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画
    double offset = radius * 0.01; // 縁取りの大きさ（調整）

    // 縁取りを4方向に描画
    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SRankPainter extends CustomPainter {
  final double radius; // radiusをクラスの変数として追加

  SRankPainter({required this.radius}); // コンストラクタでradiusを受け取る

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2; // キャンバスの中心X座標
    double centerY = size.height / 2;
    double radius2 = radius * 1.05; // キャンバスの中心Y座標

    // 紫色の八角形を描く
    Path path = Path();
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * (pi / 180); // 45度ごとに頂点を計算
      double x = centerX + radius2 * cos(angle); // X座標
      double y = centerY + radius2 * sin(angle); // Y座標
      if (i == 0) {
        path.moveTo(x, y); // 最初の点に移動
      } else {
        path.lineTo(x, y); // 次の点に線を引く
      }
    }
    path.close(); // 八角形を閉じる

    Paint paintPurple = Paint()
      ..color = const Color.fromARGB(255, 140, 0, 255); // 紫色の塗りつぶし
    canvas.drawPath(path, paintPurple); // 八角形を描画

    // メダルの中心部分に濃い紫色の円を描く
    Paint paintCircle = Paint()
      ..color = const Color.fromARGB(255, 169, 64, 255);
    canvas.drawCircle(Offset(centerX, centerY), radius2 * 0.7, paintCircle);

    // 外枠に丸い点々を追加（内側に配置）
    Paint paintDots = Paint()
      ..color = const Color.fromARGB(255, 169, 64, 255); // 点々の色
    double dotRadius = radius2 * 0.033; // 点々の半径
    double dotRadiusFromCenter = radius2 * 0.85; // 点々の半径（内側に配置）

    int dotCount = 24; // 点々の数（八角形に合わせて24つ）

    for (int i = 0; i < dotCount; i++) {
      double angle = (i * 15) * (pi / 180); // 15度ごとに配置
      double x = centerX + dotRadiusFromCenter * cos(angle); // X座標
      double y = centerY + dotRadiusFromCenter * sin(angle); // Y座標
      canvas.drawCircle(Offset(x, y), dotRadius, paintDots); // 点々を描く
    }

    // 王冠の光沢を追加
    Paint crownPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color.fromARGB(255, 235, 255, 59),
          Color.fromARGB(255, 255, 145, 0)
        ],
        stops: [0.0, 1.0],
        center: Alignment.center,
        radius: 1.0,
      ).createShader(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius2));

    // 王冠の三角形部分を描画
    Path crownPath = Path();
    crownPath.moveTo(
        centerX - radius2 * 0.3, centerY - radius2 + radius2 * 0.2);
    crownPath.lineTo(centerX, centerY - radius2 - radius2 * 0.4);
    crownPath.lineTo(
        centerX + radius2 * 0.3, centerY - radius2 + radius2 * 0.2);
    crownPath.close();

    // 王冠の左右の三角形部分
    Path leftTriangle = Path();
    leftTriangle.moveTo(
        centerX - radius2 * 0.5, centerY - radius2 + radius2 * 0.2);
    leftTriangle.lineTo(
        centerX - radius2 * 0.6, centerY - radius2 - radius2 * 0.25);
    leftTriangle.lineTo(
        centerX - radius2 * 0.1, centerY - radius2 + radius2 * 0.2);
    leftTriangle.close();

    Path rightTriangle = Path();
    rightTriangle.moveTo(
        centerX + radius2 * 0.5, centerY - radius2 + radius2 * 0.2);
    rightTriangle.lineTo(
        centerX + radius2 * 0.6, centerY - radius2 - radius2 * 0.25);
    rightTriangle.lineTo(
        centerX + radius2 * 0.1, centerY - radius2 + radius2 * 0.2);
    rightTriangle.close();

    // 王冠を描く
    canvas.drawPath(crownPath, crownPaint);
    canvas.drawPath(leftTriangle, crownPaint);
    canvas.drawPath(rightTriangle, crownPaint);

    // 王冠の中央にダイヤモンド型を追加
    Paint diamondPaint = Paint()..color = Colors.blue; // 青いダイヤ
    Path diamondPath = Path();
    diamondPath.moveTo(centerX, centerY - radius2 - radius2 * 0.15); // 上頂点
    diamondPath.lineTo(centerX - radius2 * 0.08, centerY - radius2); // 左頂点
    diamondPath.lineTo(centerX, centerY - radius2 + radius2 * 0.15); // 下頂点
    diamondPath.lineTo(centerX + radius2 * 0.08, centerY - radius2); // 右頂点
    diamondPath.close();

    // ダイヤモンド型を描く
    canvas.drawPath(diamondPath, diamondPaint);

    // 「S」の文字を白色に変更して描く
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'S',
        style: TextStyle(
          color: const Color.fromARGB(255, 140, 0, 255), // 内側の文字色
          fontSize: radius2 * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    TextPainter outlineTextPainter = TextPainter(
      text: TextSpan(
        text: 'S',
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255), // 縁取りの色
          fontSize: radius2 * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    outlineTextPainter.layout();

    // 文字の縁取りを描画（4方向に描画して縁を作る）
    double offset = radius2 * 0.01; // 縁取りの大きさ（調整）

    for (double dx = -offset; dx <= offset; dx += offset * 2) {
      for (double dy = -offset; dy <= offset; dy += offset * 2) {
        outlineTextPainter.paint(
          canvas,
          Offset(centerX - outlineTextPainter.width / 2 + dx,
              centerY - outlineTextPainter.height / 2 + dy),
        );
      }
    }

    // 本来の文字を描画
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // 再描画不要
  }
}

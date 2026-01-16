import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/firebase_score.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/assistance/latex_to_latex2.dart';
import 'package:flutter_application_4/assistance/rank.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/commmon_quiz.dart';
import 'package:flutter_application_4/page/countdown_screen.dart';
import 'package:flutter_application_4/page/datail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EndScreen extends StatefulWidget {
  final int correctCount;
  final int totalScore;

  const EndScreen({
    super.key,
    required this.correctCount,
    required this.totalScore,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EndScreenState createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  late String rank;
  late int highScore;
  late List quizinfo;
  late QuizStateProvider quizState;

  @override
  void initState() {
    super.initState();
    InterstitialAdHelper.init(); // ← ここで広告をロード
    quizState = Provider.of<QuizStateProvider>(context, listen: false);
    quizinfo = quizState.quizinfo;

    rank = getRank(widget.totalScore, quizinfo[0]);

    // 最高得点の取得
    _getHighScore();
  }

  String getsort(String st1) {
    if (st1 == "1A") {
      return "★数Ⅰ・数A(実践)";
    } else if (st1 == "2B") {
      return "★数Ⅱ・数B(実践)";
    } else if (st1 == "3C") {
      return "★数Ⅲ・数C(実践)";
    } else {
      return "★全分野(実践)";
    }
  }

  Future<void> _getHighScore() async {
    try {
      // 現在の最高得点を取得
      int currentHighScore =
          await HighScoreManager.getHighScore(quizinfo[2], true);

      // Firebase からユーザー名を取得（なければ '匿名'）
      final uid = FirebaseAuth.instance.currentUser?.uid;
      String userName = '名無し';

      if (uid != null) {
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists && doc.data()?['userName'] != null) {
          userName = doc['userName'];
        }
      }

      // 新しいスコアが過去の最高得点よりも高ければ更新
      if (widget.totalScore > currentHighScore) {
        await HighScoreManager.setHighScore(
            quizinfo[2],
            widget.totalScore,
            userName, // ← ここに userName を渡す
            true);
      }
    } catch (e) {
      debugPrint('オフラインのためスコア保存できません: $e');
      // ここでは何もしない（スコア保存スキップ）
    }
  }

  Color getForeColor(String rank) {
    switch (rank) {
      case 'S':
        return const Color.fromARGB(255, 171, 111, 219); // 明るい色
      case 'A':
        return const Color.fromARGB(255, 211, 103, 188); // 青系
      case 'B':
        return const Color.fromARGB(255, 212, 101, 101); // 黄色系
      case 'C':
        return const Color.fromARGB(255, 214, 165, 104); // 緑系
      case 'D':
        return const Color.fromARGB(255, 206, 190, 98); // 赤系
      case 'E':
        return const Color.fromARGB(255, 93, 202, 116); // 濃い赤系
      case 'F':
        return const Color.fromARGB(255, 95, 178, 199); // 暗めの赤系
      case 'G':
        return const Color.fromARGB(255, 128, 128, 128); // グレー
      default:
        return const Color.fromARGB(255, 255, 255, 255); // 白
    }
  }

  Widget getRankIconAndImage(String rank) {
    final painters = <String, CustomPainter>{
      'S': SRankPainter(radius: min(120.w, 120.h)),
      'A': ARankPainter(radius: min(120.w, 120.h)),
      'B': BRankPainter(radius: min(120.w, 120.h)),
      'C': CRankPainter(radius: min(120.w, 120.h)),
      'D': DRankPainter(radius: min(120.w, 120.h)),
      'E': ERankPainter(radius: min(120.w, 120.h)),
      'F': FRankPainter(radius: min(120.w, 120.h)),
      'G': GRankPainter(radius: min(120.w, 120.h)),
    };

    final painter = painters[rank] ?? GRankPainter(radius: 100);

    return CustomPaint(
      size: const Size(160, 160),
      painter: painter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 戻る操作禁止
      child: AdScaffold(
        body: Stack(
          children: [
            // 波線を追加
            Align(
              alignment: Alignment.topLeft,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight / 3),
                    painter: WavePainter(context),
                  );
                },
              ),
            ),
            // 正解数とスコアを波線の上に配置
            Align(
              alignment: Alignment(-1, -0.85), // 上側の Container の位置
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: getQuizColor2(quizinfo[0], context, 1, 0.55, 0.85),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Text(
                  getsort(quizinfo[0]),
                  style: TextStyle(
                    fontSize: min(20.sp, 20.h),
                    fontWeight: FontWeight.w600,
                    color: textColor1(context),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-1, -0.2), // 下側の Container の位置
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: getQuizColor2(quizinfo[0], context, 1, 0.55, 0.85),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Text(
                  "★スコア",
                  style: TextStyle(
                    fontSize: min(20.sp, 20.h),
                    fontWeight: FontWeight.w600,
                    color: textColor1(context),
                  ),
                ),
              ),
            ),
            // 正解数とスコア
            Align(
              alignment: Alignment(0, -0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        '正解数 : ${widget.correctCount}',
                        style: TextStyle(
                          fontSize: min(45.sp, 45.h),
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'スコア : ${widget.totalScore}',
                        style: TextStyle(
                          fontSize: min(45.sp, 45.h),
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ランクのアイコン画像
            Align(
              alignment: Alignment(0, 0.3),
              child: getRankIconAndImage(rank),
            ),
            // メニューへボタン
            Align(
              alignment: Alignment(0.85, 0.90),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'メニューへ',
                    style: TextStyle(
                      fontSize: min(20.sp, 20.h),
                      fontWeight: FontWeight.bold,
                      color: textColor1(context),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdInterstitialNavigator(
                                nextScreen: DetailCard(title: "jissen"))),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.r),
                      backgroundColor:
                          getQuizColor2(quizinfo[0], context, 1, 0.55, 0.85),
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.home,
                      size: min(50.sp, 50.h),
                      color: textColor1(context),
                    ),
                  ),
                ],
              ),
            ),
            // もう一度ボタン
            Align(
              alignment: Alignment(-0.85, 0.90),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'もう一度',
                    style: TextStyle(
                      fontSize: min(20.sp, 20.h),
                      fontWeight: FontWeight.bold,
                      color: textColor1(context),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdInterstitialNavigator(
                            nextScreen: CountdownScreen(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.r),
                      backgroundColor:
                          getQuizColor2(quizinfo[0], context, 1, 0.55, 0.85),
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.refresh,
                      size: min(50.sp, 50.h),
                      color: textColor1(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final BuildContext context;

  WavePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    // コンテキストからダークモードかどうか判定
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ダークモードかどうかで色を変える
    final waveColor = isDark
        ? const Color.fromARGB(255, 71, 71, 71)
        : const Color.fromARGB(255, 229, 229, 229);

    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    double h = size.height;
    double amp = h * 0.1; // 振幅10%

    path.quadraticBezierTo(size.width / 8, h - amp, size.width / 4, h);
    path.quadraticBezierTo(size.width * 3 / 8, h + amp, size.width / 2, h);
    path.quadraticBezierTo(size.width * 5 / 8, h - amp, size.width * 3 / 4, h);
    path.quadraticBezierTo(size.width * 7 / 8, h + amp, size.width, h);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    // ダークモードが変わった時に再描画されるよう設定
    return oldDelegate.context != context;
  }
}

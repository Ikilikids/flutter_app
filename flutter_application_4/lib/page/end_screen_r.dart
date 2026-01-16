import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/firebase_score.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/assistance/latex_to_latex2.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/commmon_quiz.dart';
import 'package:flutter_application_4/page/common_widget.dart';
import 'package:flutter_application_4/page/countdown_screen.dart';
import 'package:flutter_application_4/page/datail.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NtEndScreen extends StatefulWidget {
  final int correctCount;
  final List<Map<String, dynamic>> P;
  const NtEndScreen({super.key, required this.correctCount, required this.P});

  @override
  // ignore: library_private_types_in_public_api
  _NtEndScreenState createState() => _NtEndScreenState();
}

class _NtEndScreenState extends State<NtEndScreen> {
  late Color backgroundColor;
  late Color forecolor;
  late int highScore;
  late List quizinfo;
  late QuizStateProvider quizState;

  @override
  void initState() {
    super.initState();
    quizState = Provider.of<QuizStateProvider>(context, listen: false);
    quizinfo = quizState.quizinfo;
    _getHighScore();
  }

  Future<void> _getHighScore() async {
    try {
      // 現在の最高得点を取得

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

      await HighScoreManager.setHighScore(
          quizinfo[2], widget.correctCount, userName, false);
      await HighScoreManager.setHighScore(
          "全合計", widget.correctCount, userName, false);
    } catch (e) {
      debugPrint('オフラインのためスコア保存できません: $e');
      // ここでは何もしない（スコア保存スキップ）
    }
  }

  List<String> parts(String P, List<int> unindex) {
    P = removeBracketsFromElements(P, unindex);
    P = P
        .replaceAll('[+]', '\\textcolor{orange}{+}')
        .replaceAll('[-]', '\\textcolor{orange}{-}')
        .replaceAll('[\\cos]', '\\textcolor{blue}{\\cos}')
        .replaceAll('[\\sin]', '\\textcolor{blue}{\\sin}');
    P = P.replaceAll('[', '\\textcolor{red}{').replaceAll(']', '}');
    return P.split(';');
  }

  String removeBracketsFromElements(String input, List<int> unindex) {
    // [ ] で囲まれた部分を抽出
    RegExp elementRegex = RegExp(r'\[[^\[\]]*\]');
    Iterable<RegExpMatch> matches = elementRegex.allMatches(input);

    StringBuffer sb = StringBuffer();
    int lastEnd = 0;
    int index = 0;

    for (final match in matches) {
      // [ ] で囲まれていない前の文字列をそのまま追加
      sb.write(input.substring(lastEnd, match.start));

      String element = match.group(0)!; // 例: "[2]"
      if (unindex.contains(index)) {
        // 括弧を削除
        sb.write(element.substring(1, element.length - 1));
      } else {
        sb.write(element); // そのまま
      }

      lastEnd = match.end;
      index++;
    }

    // 最後に残りの文字列を追加
    if (lastEnd < input.length) {
      sb.write(input.substring(lastEnd));
    }

    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = getQuizColor2(quizinfo[0], context, 1, 0.55, 0.70);
    forecolor = getQuizColor2(quizinfo[0], context, 1, 0.55, 0.85);
    return PopScope(
      canPop: false, // 戻る操作禁止
      child: AdScaffold(
        body: Stack(
          children: [
            // 波線を追加
            Align(
              alignment: Alignment.topCenter,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height / 4),
                painter: WavePainter(context),
              ),
            ),
            // 正解数とスコアを波線の上に配置
            Align(
              alignment: Alignment(-1, -0.85),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: forecolor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(getIconForCategory(quizinfo[1]),
                            size: min(20.sp, 20.h), color: textColor1(context)),
                        SizedBox(width: 4.w),
                        Text(
                          quizinfo[1],
                          style: TextStyle(
                              fontSize: min(20.sp, 20.h),
                              fontWeight: FontWeight.w600,
                              color: textColor1(context)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      "★${quizinfo[2]}",
                      style: TextStyle(
                          fontSize: min(14.sp, 14.h),
                          fontWeight: FontWeight.w500,
                          color: textColor1(context)),
                    ),
                  ),
                  SizedBox(height: 115.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: forecolor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit,
                            size: min(20.sp, 20.h), color: textColor1(context)),
                        SizedBox(width: 4.w),
                        Text(
                          "復習",
                          style: TextStyle(
                              fontSize: min(20.sp, 20.h),
                              fontWeight: FontWeight.w600,
                              color: textColor1(context)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 正解数とスコア
            Align(
              alignment: Alignment(0, -0.7),
              child: Text(
                '正解数 : ${widget.correctCount}/5',
                style: TextStyle(
                    fontSize: min(45.sp, 45.h),
                    fontWeight: FontWeight.w600,
                    color: textColor1(context)),
              ),
            ),

            // ランクのアイコン画像
            Align(
              alignment: Alignment(0, 0.3),
              child: Padding(
                padding: EdgeInsets.all(5.r),
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  height: 410.h,
                  width: double.infinity,
                  child: DefaultTabController(
                    length: min(widget.P.length, 5), // P の長さに応じてタブ数調整
                    child: Column(
                      children: [
                        TabBar(
                          labelPadding: EdgeInsets.zero,
                          tabs: List.generate(
                            min(widget.P.length, 5),
                            (index) {
                              String isCorrect =
                                  widget.P[index]["marks"] ?? "×";
                              return Tab(
                                height: 40.h,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('問題${index + 1}'),
                                    isCorrect == "◯"
                                        ? Image.asset(
                                            'assets/images/circle.png',
                                            height: 20.h,
                                          )
                                        : isCorrect == "×"
                                            ? Image.asset(
                                                'assets/images/cross.png',
                                                height: 20.h,
                                              )
                                            : Container(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: List.generate(
                              min(widget.P.length, 5),
                              (index) => Column(
                                children: [
                                  SizedBox(
                                      height: 240.h,
                                      width: double.infinity,
                                      child: buildChildWidget(
                                          context, widget.P[index])),
                                  Container(
                                    height: 120.h,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: getQuizColor2(
                                          quizinfo[0], context, 0.4, 0.2, 0.95),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown, // 親に収める
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          parts(widget.P[index]["all1"],
                                                  widget.P[index]["unindex"])
                                              .length,
                                          (index2) => Column(
                                            children: [
                                              if (parts(
                                                      widget.P[index]["all1"],
                                                      widget.P[index]
                                                          ["unindex"])[index2]
                                                  .trim()
                                                  .isNotEmpty)
                                                Math.tex(
                                                  parts(
                                                      widget.P[index]["all1"],
                                                      widget.P[index]
                                                          ["unindex"])[index2],
                                                  textStyle: TextStyle(
                                                      fontSize:
                                                          min(30.sp, 30.h),
                                                      color:
                                                          textColor1(context)),
                                                ),
                                              if (index2 <
                                                  parts(
                                                              widget.P[index]
                                                                  ["all1"],
                                                              widget.P[index]
                                                                  ["unindex"])
                                                          .length -
                                                      1)
                                                SizedBox(height: 10.h),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // メニューへボタン
            Align(
              alignment: Alignment(0.85, 0.95),
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
                  SizedBox(height: 5.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdInterstitialNavigator(
                            nextScreen: DetailCard(title: quizinfo[0]),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.r),
                      backgroundColor: forecolor,
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
              alignment: Alignment(-0.85, 0.95),
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
                  SizedBox(height: 5.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdInterstitialNavigator(
                            nextScreen: CountdownScreen(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.r),
                      backgroundColor: forecolor,
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

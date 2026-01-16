import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/assistance/latex_to_latex2.dart';
import 'package:flutter_application_4/assistance/makingdata.dart';
import 'package:flutter_application_4/assistance/makingdata_ch.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/commmon_quiz.dart';
import 'package:flutter_application_4/page/common_widget.dart';
import 'package:flutter_application_4/page/latex.dart';
import 'package:flutter_application_4/page/optionscreen.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

import 'end_screen_j.dart';
import 'end_screen_r.dart';
import 'time_circle_painter.dart';

class Quizscreen extends StatefulWidget {
  final Map<String, dynamic> numberData;
  final List<Map<String, String>> chosedData;

  const Quizscreen({
    super.key,
    required this.numberData,
    required this.chosedData,
  });

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<Quizscreen> {
  late List quizinfo;
  late QuizStateProvider quizState;
  late Map<String, List<Map<String, String>>> scoreIndexMap;
  late QuizProvider quizProvider;
  DateTime? startTime;
  Map<String, dynamic> P = {};
  String? selectedAnswer;
  String result = '';
  bool isAnswerChecked = false;
  int correctCount = 0; // 正解数
  bool isGameOver = false;
  Timer? _timer;
  int remainingTime = 60;
  int totalScore = 0; // 現時点での獲得点数
  String scoreIncrement1 = ''; // +点数表示のための変数
  String scoreIncrement2 = ''; // +点数表示のための変数
  int qcount = 0; // 問題数
  List<String> marks = ["", "", "", "", ""];
  List<Map<String, dynamic>> plist = [];
  late SoundManager soundManager;
  // LateXInputScreenのキーを作成
  final GlobalKey<LatexInputScreenState> _latexInputKey =
      GlobalKey<LatexInputScreenState>();
  bool _initialized = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 750), () {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      soundManager = Provider.of<SoundManager>(context, listen: false);
      quizState = Provider.of<QuizStateProvider>(context, listen: false);
      quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizinfo = quizState.quizinfo;
      scoreIndexMap = quizProvider.scoreIndexMap;
      if (quizinfo[3] == "time") startTimer(); // タイマー開始
      updateQuestion();
      _initialized = true;
    }
  }

  // 次の問題に移行する際にLatexInputScreenもリセット
  void updateQuestion() async {
    ChooseQuizData chooseQuizData = ChooseQuizData(
      correctCount: correctCount,
      chosedData: widget.chosedData,
      scoreIndexMap: scoreIndexMap,
    );
    Map<String, String> ct = chooseQuizData.chooseRandombyScoreRange(context);

    Map<String, dynamic> numberData = widget.numberData;
    if (ct["lc"] == "latex") {
      OriginCentral originCentral =
          OriginCentral(ct: ct, numberData: numberData);
      Map<String, dynamic> variable = originCentral.makingvariable();
      MakingDeta makingDeta = MakingDeta(
        calculatedresult: variable,
      );
      Map<String, dynamic> endResult = makingDeta.deta();

      result = '';
      isAnswerChecked = false;

      variable.addAll(endResult);
      P = variable;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _latexInputKey.currentState?.resetLatexOutputs();
      });
    } else {
      OriginCentral2 originCentral =
          OriginCentral2(ct: ct, numberData: numberData);
      Map<String, dynamic> variable = originCentral.makingvariable();
      P = variable;
    }
    startTime = DateTime.now();
  }

  void partpoints(int ctpoint) {
    int lastScore = ctpoint;
    lastScore = lastScore * 10;

    setState(() {
      totalScore += lastScore;
      scoreIncrement1 = "+$lastScore点";
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          scoreIncrement1 = ''; // 点数表示を消す
        });
      });
    });
  }

  void judge(String seigo) async {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (isGameOver) return; // ←これを追加
        setState(() {
          scoreIncrement1 = '';
          scoreIncrement2 = '';
          selectedAnswer = null;
          isAnswerChecked = false;
        });

        if (remainingTime > 0 && quizinfo[3] == "time") {
          updateQuestion();
        }
        if (quizinfo[3] == "notime") {
          marks[qcount] = result;
          P["marks"] = result;
          plist.add(P);
          if (qcount == 4) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NtEndScreen(correctCount: correctCount, P: plist),
              ),
            );
            return;
          } else {
            qcount++;
            updateQuestion();
          }
        }
      },
    );
    if (isGameOver) return;

    if (seigo == "peke") {
      setState(() {
        result = '×';
        isAnswerChecked = true;
        totalScore = max(0, totalScore - 10);
        scoreIncrement1 = '-10点';
      });
      soundManager.playSound('peke.mp3');
    } else if (seigo == "maru") {
      final List<dynamic> ctScoreList = P["ctscore"];
      int lastScore = (ctScoreList.last as int) * 10;
      int sumscore = ctScoreList.fold(0, (sum, e) => sum + (e as int) * 10);
      DateTime endTime = DateTime.now();
      Duration elapsed = endTime.difference(startTime!);
      int elapsedTenth = elapsed.inMilliseconds;
      double decrease = elapsedTenth * 0.002 / sumscore;
      double timebonus = 1 - decrease;

      if (timebonus < 0) {
        timebonus = 0;
      }

      int bonuspoint = (sumscore * timebonus).round();

      setState(() {
        result = "◯";
        isAnswerChecked = true;
        totalScore += bonuspoint + lastScore;
        scoreIncrement1 = '+$lastScore点';
        scoreIncrement2 = '+$bonuspoint点';

        correctCount += 1;
      });

      if (ctScoreList.length > 1) {
        soundManager.playSound('marumaru.mp3');
      } else {
        soundManager.playSound('maru.mp3');
      }
    }
  }

  void startTimer() {
    setState(() {
      remainingTime = quizinfo[0] == "1A2B3C" ? 120 : 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 1 && !isGameOver) {
        soundManager.playSound('ry.mp3');
        setState(() {
          remainingTime--;
        });

        // 🔔 ちょうど119秒（開始1秒後）で再生する
      } else if (remainingTime == 1 && !isGameOver) {
        setState(() {
          isGameOver = true;
        });
        _timer?.cancel();

        // 結果画面に遷移
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EndScreen(
              correctCount: correctCount,
              totalScore: totalScore,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Widget childWidget = buildChildWidget(context, P);

    return PopScope(
        canPop: false, // デフォルトの戻りはキャンセル
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          showMenuDialog(
            context,
            quizinfo,
            () => setState(() {
              isGameOver = true;
            }),
          );
        },
        child: AdScaffold(
          body: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 40,
            ),
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-0.7, -0.7),
                  child: Transform.rotate(
                    angle: -0.4,
                    child: Math.tex(
                      getIntegralText(P["fi2"]),
                      textStyle: TextStyle(
                        fontSize: 50,
                        color: isDark
                            ? textColor1(context).withAlpha(20)
                            : textColor1(context).withAlpha(20),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.7, 0),
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Icon(
                      getIconForCategory(P["fi2"]),
                      size: 100,
                      color: isDark
                          ? textColor1(context).withAlpha(20)
                          : textColor1(context).withAlpha(20),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          if (quizinfo[3] == "time")
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: CustomPaint(
                                    size: const Size(100, 100),
                                    painter: TimeCirclePainter(
                                        remainingTime: remainingTime,
                                        isDark: isDark),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            flex: 2,
                            child:
                                Expanded(flex: 2, child: quizInfo(context, P)),
                          ),
                          Expanded(
                            flex: 1,
                            child: menuButton(
                              context,
                              quizinfo,
                              () => setState(() {
                                isGameOver = true;
                              }),
                            ),
                          ),
                          if (quizinfo[3] == "time")
                            Expanded(
                                flex: 2,
                                child: pointwidget(
                                    remainingTime, totalScore, context)),
                          if (quizinfo[3] == "time")
                            Expanded(
                                flex: 1,
                                child: increasewidget(
                                    scoreIncrement1, scoreIncrement2)),
                          if (quizinfo[3] == "notime")
                            Expanded(
                                flex: 4, child: marupekelist(context, marks))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: childWidget,
                      ),
                    ),
                    if (P["lc"] == "latex")
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: LatexInputScreen3(
                            key: _latexInputKey,
                            shubetu: P['fb'],
                            marusikaku: P['latex'],
                            alist: P['alist'],
                            blist: P['blist'],
                            button2: P['button'],
                            ctscore: P['ctscore'],
                            categoly: P["fi1"],
                            pekepeke: (String ddd) {
                              judge(ddd);
                            },
                            partpoint: (int ctscore) {
                              partpoints(ctscore);
                            },
                          ),
                        ),
                      ),
                    if (P["lc"] == "choose")
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: QuizOptions(
                            quizData: P,
                            onCorrect: (String ddd) {
                              judge(ddd);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                Center(
                  child: isAnswerChecked
                      ? result == "◯"
                          ? Image.asset(
                              isDark
                                  ? 'assets/images/circle_dark.png'
                                  : 'assets/images/circle.png',
                              height: 300,
                            )
                          : result == '×'
                              ? Image.asset(
                                  isDark
                                      ? 'assets/images/cross_dark.png'
                                      : 'assets/images/cross.png',
                                  height: 300,
                                )
                              : Container()
                      : Container(),
                ),
              ],
            ),
          ),
        ));
  }
}

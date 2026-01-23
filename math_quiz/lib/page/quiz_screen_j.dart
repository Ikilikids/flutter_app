import 'dart:async';
import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:math_quiz/math_quiz.dart' hide QuizStateProvider;
import 'package:provider/provider.dart';

import '../assistance/quiz_download.dart';

class Quizscreen extends StatefulWidget {
  final QuizData quizinfo;

  const Quizscreen({
    super.key,
    required this.quizinfo,
  });

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<Quizscreen> {
  late QuizData quizinfo;
  late QuizStateProvider quizState;
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
  late List<String> marks;
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

      quizinfo = widget.quizinfo;
      if (!quizinfo.isbattle && quizinfo.questionCount != null) {
        marks = List.filled(quizinfo.questionCount!, "");
      } else {
        marks = [];
      }
      if (quizinfo.isbattle == true) startTimer(); // タイマー開始
      updateQuestion();
      _initialized = true;
    }
  }

  // 次の問題に移行する際にLatexInputScreenもリセット
  void updateQuestion() async {
    ChooseQuizData chooseQuizData = ChooseQuizData(
      correctCount: correctCount,
      quizinfo: quizinfo,
      scoreIndexMap:
          Provider.of<QuizProvider>(context, listen: false).scoreIndexMap,
    );
    Map<String, String> ct = chooseQuizData.chooseRandombyScoreRange(context);

    if (ct["lc"] == "latex") {
      OriginCentral originCentral = OriginCentral(ct: ct);
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
      OriginCentral2 originCentral = OriginCentral2(
        ct: ct,
      );
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

        if (remainingTime > 0 && quizinfo.isbattle == true) {
          updateQuestion();
        }
        if (quizinfo.isbattle == false) {
          marks[qcount] = result;
          P["marks"] = result;
          plist.add(P);
          if (qcount == quizinfo.questionCount! - 1) {
            if (!mounted) return;

            soundManager.playSound('hoi.mp3');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => quizinfo.isbattle
                      ? PipiScreen(totalScore: totalScore)
                      : PipiScreen(
                          totalScore: correctCount, originalData: plist)),
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
      remainingTime = 60;
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
        soundManager.playSound('hoi.mp3');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PipiScreen(totalScore: totalScore)),
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
              () => setState(() {
                    isGameOver = true;
                  }),
              false);
        },
        child: AppAdScaffold(
          body: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 40,
            ),
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          if (quizinfo.isbattle == true)
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
                            child: quizInfo(context, P),
                          ),
                          Expanded(
                            flex: 1,
                            child: menuButton(
                                context,
                                () => setState(() {
                                      isGameOver = true;
                                    }),
                                false),
                          ),
                          if (quizinfo.isbattle == true)
                            Expanded(
                                flex: 2,
                                child: pointwidget(context, totalScore,
                                    remainingTime: remainingTime)),
                          if (quizinfo.isbattle == true)
                            Expanded(
                                flex: 1,
                                child: increasewidget(
                                    scoreIncrement1, scoreIncrement2)),
                          if (quizinfo.isbattle == false)
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

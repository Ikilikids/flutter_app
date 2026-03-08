import 'dart:async';
import 'dart:math';

import 'package:cal_easy/assistance/latex_formatter.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../assistance/makingdata.dart';
import '../page/common_widget.dart';
import '../page/latex.dart';

class Quizscreen extends ConsumerStatefulWidget {
  final List<String> quizDirectives;
  final DetailConfig quizinfo;

  const Quizscreen({
    super.key,
    required this.quizDirectives,
    required this.quizinfo,
  });

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends ConsumerState<Quizscreen> {
  late DetailConfig quizinfo;
  DateTime? startTime;
  Map<String, dynamic> P = {};
  String? selectedAnswer;
  String result = '';
  bool isAnswerChecked = false;
  int correctCount = 0;
  int _currentQuestionIndex = 0;
  bool isGameOver = false;
  Timer? _timer;
  double elapsedTime = 0.0;
  int count = 20;

  final GlobalKey<LatexInputScreenState> _latexInputKey =
      GlobalKey<LatexInputScreenState>();
  bool _initialized = false;
  bool _isQuestionReady = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      quizinfo = widget.quizinfo;
      count = quizinfo.detail.sort == "4867" ? 10 : 20;
      startWatch();

      if (widget.quizDirectives.isNotEmpty) {
        updateQuestion().then((_) {
          if (mounted) {
            setState(() {
              _isQuestionReady = true;
            });
          }
        });
      } else {
        setState(() {
          _isQuestionReady = true;
          isGameOver = true;
        });
      }
    }
  }

  Future<void> updateQuestion() async {
    String mainsort;

    if (_currentQuestionIndex < widget.quizDirectives.length) {
      // Use the predefined sequence for the first 20 questions.
      mainsort = widget.quizDirectives[_currentQuestionIndex];
    } else {
      // After 20 questions, select a random question type.
      final uniqueDirectives = widget.quizDirectives.toSet().toList();
      if (uniqueDirectives.isEmpty) {
        // Fallback in case directives are empty, though unlikely.
        setState(() {
          isGameOver = true;
        });
        return;
      }
      final random = Random();
      mainsort = uniqueDirectives[random.nextInt(uniqueDirectives.length)];
    }

    OriginCentral originCentral = OriginCentral(mainsort: mainsort);
    Map<String, dynamic> variable = originCentral.makingvariable();
    LatexQuizFormatter makingDeta = LatexQuizFormatter(
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
  }

  void judge(String seigo) async {
    if (isGameOver) return;

    if (seigo == "peke") {
      setState(() {
        result = '×';
        isAnswerChecked = true;
      });
      ref.read(appSoundProvider).requireValue.playSound('peke.mp3');
    } else if (seigo == "maru") {
      setState(() {
        result = "◯";
        isAnswerChecked = true;
        correctCount += 1;
      });

      ref.read(appSoundProvider).requireValue.playSound('maru.mp3');

      if (correctCount == count) {
        setState(() {
          isGameOver = true;
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(appSoundProvider).requireValue.playSound('hoi.mp3');
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PipiScreen(
                totalScore: elapsedTime,
              ),
            ),
          );
        });
      }
    }

    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        if (isGameOver) return;
        setState(() {
          _currentQuestionIndex++;
          selectedAnswer = null;
          isAnswerChecked = false;
        });

        updateQuestion();
      },
    );
  }

  void startWatch() {
    _timer?.cancel();
    isGameOver = false;
    startTime = DateTime.now();

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (isGameOver) {
        timer.cancel();
        return;
      }
      setState(() {
        elapsedTime =
            DateTime.now().difference(startTime!).inMilliseconds / 1000;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isQuestionReady) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Widget childWidget = buildChildWidget(context, P);

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          isGameOver
              ? null
              : showMenuDialog(
                  context,
                  isLimitedMode: quizinfo.modeData.islimited,
                );
        },
        child: AppAdScaffold(
          body: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 40,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: timewidget(
                              quizinfo.detail.sort,
                              elapsedTime,
                              correctCount,
                              context,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: menuButton(
                              context,
                              isLimitedMode: quizinfo.modeData.islimited,
                              istap: !isGameOver,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: pointwidget(context, correctCount)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: childWidget,
                    ),
                    Expanded(
                      flex: 12,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: LatexInputScreen3(
                          key: _latexInputKey,
                          marusikaku: P['latex'],
                          alist: P['alist'],
                          categoly: P["fi1"],
                          pekepeke: (String ddd) {
                            judge(ddd);
                          },
                          shubetu: '',
                          blist: null,
                          button2: const [""],
                          ctscore: const [],
                          partpoint: (int a) {},
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
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

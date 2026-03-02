import 'dart:async';
import 'dart:math';

import 'package:common/common.dart';
import 'package:common/freezed/ui_config.dart';
import 'package:common/providers/app_sound.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../assistance/makingdata.dart';
import '../page/common_widget.dart';

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
  String result = '';
  bool isAnswerChecked = false;
  int correctCount = 0;
  int _currentQuestionIndex = 0;
  bool isGameOver = false;
  Timer? _timer;
  double elapsedTime = 0.0;
  int count = 20;

  bool _initialized = false;
  bool _isQuestionReady = false;

  String currentSpelling = "";

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
        initDataAndQuestion().then((_) {
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

  Future<void> initDataAndQuestion() async {
    await OriginCentral.loadCSV();
    await updateQuestion();
  }

  Future<void> updateQuestion() async {
    String mainsort;

    if (_currentQuestionIndex < widget.quizDirectives.length) {
      mainsort = widget.quizDirectives[_currentQuestionIndex];
    } else {
      final uniqueDirectives = widget.quizDirectives.toSet().toList();
      if (uniqueDirectives.isEmpty) {
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

    setState(() {
      P = variable;
      currentSpelling = "";
      result = '';
      isAnswerChecked = false;
    });
  }

  void handleLetterTap(String letter) {
    if (isAnswerChecked || isGameOver) return;

    String targetWord = P["all1"];
    String nextSpelling = currentSpelling + letter;

    if (targetWord.startsWith(nextSpelling)) {
      setState(() {
        currentSpelling = nextSpelling;
      });

      if (currentSpelling == targetWord) {
        judge("maru");
      }
    } else {
      judge("peke");
    }
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
        return;
      }
    }

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (isGameOver || !mounted) return;
        setState(() {
          _currentQuestionIndex++;
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
      if (mounted) {
        setState(() {
          elapsedTime =
              DateTime.now().difference(startTime!).inMilliseconds / 1000;
        });
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
                  () => setState(() {
                    isGameOver = true;
                  }),
                  quizinfo.modeData.islimited,
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
                              () => setState(() {
                                isGameOver = true;
                              }),
                              quizinfo.modeData.islimited,
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
                      flex: 5,
                      child: childWidget,
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          currentSpelling.split('').join(' ') +
                              (currentSpelling.length < (P["all1"]?.length ?? 0)
                                  ? ' _' *
                                      ((P["all1"]?.length ?? 0) -
                                          currentSpelling.length)
                                  : ''),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: EnglishWordInput(
                          letters: P['letters'] ?? [],
                          onTap: handleLetterTap,
                          category: P["fi1"] ?? "1",
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

class EnglishWordInput extends StatelessWidget {
  final List<String> letters;
  final Function(String) onTap;
  final String category;

  const EnglishWordInput({
    super.key,
    required this.letters,
    required this.onTap,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color buttonColor = isDark
        ? getQuizColor2(category, context, 0.8, 0.4, 0.65)
        : getQuizColor2(category, context, 0.6, 0.4, 0.95);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () => onTap(letters[index]),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor1(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            letters[index],
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

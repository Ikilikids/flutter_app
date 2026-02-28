import 'dart:async';
import 'dart:math';

import 'package:common/common.dart';
import 'package:common/freezed/ui_config.dart';
import 'package:common/providers/app_sound.dart';
import 'package:common/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quiz/math_quiz.dart' hide QuizStateProvider;

import '../providers/quiz_data_provider.dart';

class Quizscreen extends ConsumerStatefulWidget {
  final DetailConfig quizinfo;
  final Map<int, List<PartData>> filteredMap;

  const Quizscreen({
    super.key,
    required this.quizinfo,
    required this.filteredMap,
  });

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends ConsumerState<Quizscreen> {
  DateTime? startTime;
  late MakingData P;
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
  List<MakingData> plist = [];
  // LateXInputScreenのキーを作成
  final GlobalKey<LatexInputScreenState> _latexInputKey =
      GlobalKey<LatexInputScreenState>();
  bool _initialized = false;
  late int qCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      // 1. Provider から「今選ばれている設定」を直接取得
      final activeConfig = ref.read(currentDetailConfigProvider);

      // 2. 問題数(qcount)の取得
      qCount = activeConfig.qcount;

      // 3. marks の初期化
      if (!activeConfig.modeData.isbattle) {
        marks = List.filled(qCount, "");
      } else {
        marks = [];
      }

      // 4. タイマー開始判定
      if (activeConfig.modeData.isbattle) {
        startTimer();
      }

      // 5. 最初の問題を表示
      updateQuestion().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
          });
        }
      });
    }
  }

  // 次の問題に移行する際にLatexInputScreenもリセット
  Future<void> updateQuestion() async {
    // 素材(PartData)を1つ選ぶ
    ChooseQuizData chooseQuizData = ChooseQuizData(
      correctCount: correctCount,
      quizinfo: widget.quizinfo,
      filteredMapByScore: widget.filteredMap,
    );
    PartData ct = chooseQuizData.chooseRandombyScoreRange();

    setState(() {
      // ★ factoryを呼ぶだけ。これでPの中身は勝手にLatexMakingDataかOptionMakingDataになる
      P = MakingData.fromPart(ct);

      // 2. 共通の更新処理
      result = '';
      isAnswerChecked = false;
      startTime = DateTime.now();
    });

    // LaTeX特有の表示リセットだけ 'is' で判定して実行
    if (P is LatexMakingData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _latexInputKey.currentState?.resetLatexOutputs();
      });
    }
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
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isGameOver) return;
      setState(() {
        scoreIncrement1 = '';
        scoreIncrement2 = '';
        selectedAnswer = null;
        isAnswerChecked = false;
      });

      if (remainingTime > 0 && widget.quizinfo.modeData.isbattle == true) {
        updateQuestion();
      }
      if (widget.quizinfo.modeData.isbattle == false) {
        marks[qcount] = result;
        plist.add(P);
        if (qcount == qCount - 1) {
          if (!mounted) return;

          ref.read(appSoundProvider).requireValue.playSound('hoi.mp3');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => widget.quizinfo.modeData.isbattle
                  ? PipiScreen(totalScore: totalScore)
                  : PipiScreen(
                      totalScore: correctCount, originalData: [plist, marks]),
            ),
          );
          return;
        } else {
          qcount++;
          updateQuestion();
        }
      }
    });
    if (isGameOver) return;

    if (seigo == "peke") {
      setState(() {
        result = '×';
        isAnswerChecked = true;
        totalScore = max(0, totalScore - 10);
        scoreIncrement1 = '-10点';
      });
      ref.read(appSoundProvider).requireValue.playSound('peke.mp3');
    } else if (seigo == "maru") {
      // ★ ここから修正：モードによってスコアの計算パーツを分ける
      int lastScore = 0;
      int soundLevel = 1;

      if (P case LatexMakingData p) {
        final List<int> ctScoreList =
            p.holes.map((hole) => hole.score).toList();
        lastScore = ctScoreList.last * 10;
        soundLevel = ctScoreList.length;
      } else {
        // Optionモードのときは、holesがないのでトータルスコアを基礎点にする
        lastScore = P.totalScore * 10;
        soundLevel = 1;
      }

      // 共通のボーナス計算
      int sumscore = P.totalScore * 10;
      DateTime endTime = DateTime.now();
      Duration elapsed = endTime.difference(startTime!);
      int elapsedTenth = elapsed.inMilliseconds;
      double decrease = elapsedTenth * 0.002 / sumscore;
      double timebonus = max(0.0, 1 - decrease);

      int bonuspoint = (sumscore * timebonus).round();

      setState(() {
        result = "◯";
        isAnswerChecked = true;
        totalScore += bonuspoint + lastScore;
        scoreIncrement1 = '+$lastScore点';
        scoreIncrement2 = '+$bonuspoint点';
        correctCount += 1;
      });

      // ★ 音の出し分けも soundLevel で判定
      if (soundLevel > 1) {
        ref.read(appSoundProvider).requireValue.playSound('marumaru.mp3');
      } else {
        ref.read(appSoundProvider).requireValue.playSound('maru.mp3');
      }
    }
  }

  void startTimer() {
    setState(() {
      remainingTime = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 1 && !isGameOver) {
        ref.read(appSoundProvider).requireValue.playSound('ry.mp3');
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
        ref.read(appSoundProvider).requireValue.playSound('hoi.mp3');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PipiScreen(totalScore: totalScore),
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
    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Widget childWidget = buildChildWidget(context, P);

    return PopScope(
      canPop: false, // デフォルトの戻りはキャンセル
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        isGameOver
            ? null
            : showMenuDialog(
                context,
                () => setState(() {
                  isGameOver = true;
                }),
                widget.quizinfo.modeData.islimited,
              );
      },
      child: AppAdScaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        if (widget.quizinfo.modeData.isbattle == true)
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CustomPaint(
                                  size: const Size(100, 100),
                                  painter: TimeCirclePainter(
                                    remainingTime: remainingTime,
                                    isDark: isDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Expanded(flex: 2, child: quizInfo(context, P)),
                        Expanded(
                          flex: 1,
                          child: menuButton(
                            context,
                            () => setState(() {
                              isGameOver = true;
                            }),
                            false,
                            istap: !isGameOver,
                          ),
                        ),
                        if (widget.quizinfo.modeData.isbattle == true)
                          Expanded(
                            flex: 2,
                            child: pointwidget(
                              context,
                              totalScore,
                              remainingTime: remainingTime,
                            ),
                          ),
                        if (widget.quizinfo.modeData.isbattle == true)
                          Expanded(
                            flex: 1,
                            child: increasewidget(
                              scoreIncrement1,
                              scoreIncrement2,
                            ),
                          ),
                        if (widget.quizinfo.modeData.isbattle == false)
                          Expanded(
                            flex: 4,
                            child: marupekelist(context, marks),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: childWidget,
                    ),
                  ),
                  if (P case LatexMakingData p)
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: LatexInputScreen3(
                          key: _latexInputKey,
                          shubetu: p.firstButton, // P ではなく p を使う
                          marusikaku: p.initialLatexA, // ここで赤線が出ない！
                          alist: p.indexDataA.map((e) => e.tokenList).toList(),
                          blist: p.indexDataB.map((e) => e.tokenList).toList(),
                          button2: p.indexDataA.map((e) => e.button).toList(),
                          ctscore: p.indexDataA.map((e) => e.score).toList(),
                          categoly: p.subject,
                          pekepeke: (ddd) => judge(ddd),
                          partpoint: (score) => partpoints(score),
                        ),
                      ),
                    ),

                  // ★こっちも！「もし P が OptionMakingData だったら、それを p と名付けて使う」
                  if (P case OptionMakingData p)
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: QuizOptions(
                          quizData: p, // p なので optionList にアクセス可能
                          onCorrect: (ddd) => judge(ddd),
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
      ),
    );
  }
}

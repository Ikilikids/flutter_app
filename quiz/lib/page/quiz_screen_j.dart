import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

class Quizscreen extends HookConsumerWidget {
  const Quizscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    final notifier = ref.read(quizSessionNotifierProvider.notifier);
    final activeConfig = ref.read(currentDetailConfigProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 初期化
    useEffect(() {
      Future.microtask(() {
        notifier.init(activeConfig);
        _updateQuestion(ref, isInitial: true);
      });
      return null;
    }, []);

    // 正誤判定後の処理
    ref.listen(quizSessionNotifierProvider.select((s) => s.isAnswerChecked),
        (prev, checked) {
      if (checked) {
        Future.delayed(
            Duration(
                milliseconds: activeConfig.appData.appTitle == "とことん高校数学"
                    ? 400
                    : 150), () {
          final currentSession = ref.read(quizSessionNotifierProvider);
          if (!context.mounted) return;
          if (currentSession.isGameOver) return;
          if (activeConfig.appData.appTitle == "appTitle") {
            if (currentSession.correctCount >= activeConfig.qcount) {
              _finishGame(context, ref, activeConfig, currentSession);
            } else {
              _updateQuestion(ref);
            }
          } else if (activeConfig.modeData.isbattle) {
            _updateQuestion(ref);
          } else {
            if (currentSession.currentIndex >= activeConfig.qcount - 1) {
              _finishGame(context, ref, activeConfig, currentSession);
            } else {
              _updateQuestion(ref);
            }
          }
        });
      }
    });

    // ゲームオーバー判定
    ref.listen(quizSessionNotifierProvider.select((s) => s.isGameOver),
        (prev, isOver) {
      if (isOver && context.mounted) {
        final currentSession = ref.read(quizSessionNotifierProvider);
        _finishGame(context, ref, activeConfig, currentSession);
      }
    });

    if (session.currentQuestion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final P = session.currentQuestion!;
    final childWidget = buildChildWidget(context, P);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!session.isGameOver) {
          showMenuDialog(context,
              onTap: () =>
                  ref.read(quizSessionNotifierProvider.notifier).endGame(),
              isLimitedMode: activeConfig.modeData.islimited);
        }
      },
      child: AppAdScaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          if (activeConfig.appData.appTitle == "appTitle") ...[
                            // appTotleの場合
                            Expanded(
                              flex: 3,
                              child: timewidget(
                                activeConfig.detail.sort,
                                session.elapsedTime,
                                session.correctCount,
                                context,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: menuButton(context,
                                  onTap: () => ref
                                      .read(
                                          quizSessionNotifierProvider.notifier)
                                      .endGame(),
                                  isLimitedMode:
                                      activeConfig.modeData.islimited,
                                  istap: !session.isGameOver),
                            ),
                            Expanded(
                                flex: 3,
                                child: pointwidget(
                                    context, session.correctCount,
                                    remainingTime: session.remainingTime)),
                          ] else ...[
                            // それ以外の場合
                            if (activeConfig.modeData.isbattle) ...[
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: CustomPaint(
                                    size: const Size(100, 100),
                                    painter: TimeCirclePainter(
                                        remainingTime: session.remainingTime,
                                        isDark: isDark),
                                  ),
                                ),
                              )
                            ],
                            Expanded(flex: 2, child: quizInfo(context, P)),
                            Expanded(
                              flex: 1,
                              child: menuButton(context,
                                  onTap: () => ref
                                      .read(
                                          quizSessionNotifierProvider.notifier)
                                      .endGame(),
                                  isLimitedMode:
                                      activeConfig.modeData.islimited,
                                  istap: !session.isGameOver),
                            ),
                            if (activeConfig.modeData.isbattle) ...[
                              Expanded(
                                  flex: 2,
                                  child: pointwidget(
                                      context, session.totalScore,
                                      remainingTime: session.remainingTime)),
                              Expanded(
                                flex: 1,
                                child: increasewidget(
                                  session.scoreFeedback1,
                                  session.scoreFeedback2,
                                ),
                              ),
                            ] else
                              Expanded(
                                  flex: 4,
                                  child: marupekelist(context, session.marks)),
                          ],
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: childWidget)),
                  if (P is LatexMakingData) ...[
                    const Expanded(flex: 2, child: LatexDisplayView()),
                    const Expanded(flex: 5, child: LatexKeyboardView()),
                  ],
                  if (P is EngMakingData) ...[
                    const Expanded(flex: 3, child: EngDisplayView()),
                    const Expanded(flex: 4, child: EngKeyboardView()),
                  ],
                  if (P is OptionMakingData)
                    Expanded(
                        flex: 7,
                        child: QuizOptions(
                            quizData: P,
                            onCorrect: (res) =>
                                notifier.judge(res, activeConfig))),
                ],
              ),
              if (session.isAnswerChecked)
                Center(
                  child: Image.asset(
                    isDark
                        ? 'assets/images/${session.resultMark.name}_dark.png'
                        : 'assets/images/${session.resultMark.name}.png',
                    height: 300,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateQuestion(WidgetRef ref, {bool isInitial = false}) {
    final sessionNotifier = ref.read(quizSessionNotifierProvider.notifier);

    if (!isInitial) {
      sessionNotifier.nextQuestionIndex();
    }

    final ct = ChooseQuizData(ref: ref).chooseRandombyScoreRange();

    final question = MakingData.fromPart(ct);

    sessionNotifier.updateQuestion(question);
  }

  void _finishGame(BuildContext context, WidgetRef ref, DetailConfig config,
      QuizSessionState session) {
    ref.read(quizSessionNotifierProvider.notifier).endGame();

    Future.delayed(const Duration(milliseconds: 200), () {
      ref.read(appSoundProvider).playSound('hoi.mp3');
      final solved = [
        ...session.solvedQuestions,
        if (session.currentQuestion != null) session.currentQuestion!
      ];

      // 品詞・レベル別の加算スコアを集計
      Map<String, int>? categoryScores;
      if (config.appData.appTitle != "appTitle") {
        final Map<String, int> counts = {};
        for (int i = 0; i < solved.length; i++) {
          if (i < session.marks.length &&
              session.marks[i] == QuizResult.circle) {
            final p = solved[i];
            final domain = p.pt.domain;
            final subject = p.pt.subject;
            print(p);
            // 英単語アプリ特有のマッピングロジック
            String? category;
            print("Domain: $domain, Subject: $subject");
            if (domain == "動詞") {
              category = "動詞";
            } else if (domain == "形容詞" || domain == "副詞") {
              category = "形容詞・副詞";
            } else if (domain == "名詞" || domain.contains("詞")) {
              category = "名詞・その他";
            } else {
              category = generateRankLabel(subject);
            }

            counts[category] = (counts[category] ?? 0) + 1;
          }
        }
        if (counts.isNotEmpty) categoryScores = counts;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => config.appData.appTitle == "appTitle"
              ? PipiScreen(totalScore: session.elapsedTime)
              : config.modeData.isbattle
                  ? PipiScreen(
                      totalScore: session.totalScore,
                      originalData: [solved, session.marks],
                      categoryScores: categoryScores,
                    )
                  : PipiScreen(
                      totalScore: session.correctCount,
                      originalData: [solved, session.marks],
                      categoryScores: categoryScores,
                    ),
        ),
      );
    });
  }
}

String generateRankLabel(String sort) {
  if (sort == "1" || sort == "A") return "数Ⅰ・数A";
  if (sort == "2" || sort == "B") return "数Ⅱ・数B";
  if (sort == "3" || sort == "C") return "数Ⅲ・数C";
  return sort;
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

class Quizscreen extends HookConsumerWidget {
  const Quizscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final P =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));
    final isGameOver =
        ref.watch(quizSessionNotifierProvider.select((s) => s.isGameOver));
    final isAnswerChecked =
        ref.watch(quizSessionNotifierProvider.select((s) => s.isAnswerChecked));
    final resultMark =
        ref.watch(quizSessionNotifierProvider.select((s) => s.resultMark));
    final listenCount = useRef(0);

    ref.listen(quizSessionNotifierProvider, (prev, next) {
      listenCount.value++;
    });

    final notifier = ref.read(quizSessionNotifierProvider.notifier);
    final activeConfig = ref.read(currentDetailConfigProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 初期化
    useEffect(() {
      Future.microtask(() {
        notifier.init(activeConfig);
        notifier.updateQuestionFlow(isInitial: true); // これだけ
      });
      return null;
    }, []);

    ref.listen(quizSessionNotifierProvider.select((s) => s.isGameOver),
        (prev, isOver) {
      final session = ref.read(quizSessionNotifierProvider);
      if (isOver &&
          session.status == QuizSessionStatus.finished &&
          context.mounted) {
        _performTransition(context, ref);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!isGameOver) {
          MenuButton.openDialog(context);
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
                              child: TimeWidget(),
                            ),
                            Expanded(
                              flex: 2,
                              child: MenuButton(),
                            ),
                            Expanded(flex: 3, child: PointWidget()),
                          ] else ...[
                            // それ以外の場合
                            if (activeConfig.modeData.isbattle) ...[
                              Expanded(flex: 1, child: TimeCircle())
                            ],
                            Expanded(flex: 2, child: QuizInfoWidget()),
                            Expanded(
                              flex: 1,
                              child: MenuButton(),
                            ),
                            if (activeConfig.modeData.isbattle) ...[
                              Expanded(flex: 2, child: PointWidget()),
                              Expanded(
                                flex: 1,
                                child: IncreaseFeedbackWidget(),
                              ),
                            ] else
                              Expanded(flex: 4, child: MaruPekeListWidget()),
                          ],
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: QuestionDisplayArea())),
                  if (P is LatexMakingData) ...[
                    const Expanded(flex: 2, child: LatexDisplayView()),
                    const Expanded(flex: 5, child: LatexKeyboardView()),
                  ],
                  if (P is EngMakingData) ...[
                    const Expanded(flex: 3, child: EngDisplayView()),
                    const Expanded(flex: 4, child: EngKeyboardView()),
                  ],
                  if (P is OptionMakingData)
                    Expanded(flex: 7, child: QuizOptions()),
                ],
              ),
              if (isAnswerChecked)
                Center(
                  child: Image.asset(
                    isDark
                        ? 'assets/images/${resultMark.name}_dark.png'
                        : 'assets/images/${resultMark.name}.png',
                    height: 300,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _performTransition(BuildContext context, WidgetRef ref) {
    final config = ref.read(currentDetailConfigProvider);
    int delay =
        config.appData.appTitle == "appTitle" || !config.modeData.isbattle
            ? 300
            : 0;
    Future.delayed(Duration(milliseconds: delay), () {
      if (!context.mounted) return;
      ref.read(appSoundProvider).playSound('hoi.mp3');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PipiScreen();
          },
        ),
      );
    });
  }
}

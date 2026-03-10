import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

class EngDisplayView extends HookConsumerWidget {
  const EngDisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    final inputState = ref.watch(engInputNotifierProvider);
    final question = session.currentQuestion;

    if (question is! EngMakingData) return const SizedBox.shrink();

    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: getQuizColor2(question.subject, context, 0.6, 0.2, 0.95),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown, // 幅に収まらない時だけ縮小する
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                inputState.enteredText,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: textColor1(context),
                ),
              ),
              const SizedBox(height: 8),
              // 下線を表示（単語の長さ分）
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(question.word.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 20,
                    height: 2,
                    color: index < inputState.enteredText.length
                        ? Colors.transparent
                        : textColor1(context).withAlpha(128),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EngKeyboardView extends HookConsumerWidget {
  const EngKeyboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    final inputState = ref.watch(engInputNotifierProvider);
    final question = session.currentQuestion;

    if (question is! EngMakingData) return const SizedBox.shrink();

    final config = ref.read(currentDetailConfigProvider);
    final notifier = ref.read(engInputNotifierProvider.notifier);

    // 状態から最新のボタンリストを取得
    final buttons = inputState.availableButtons;
    final halfLength = (buttons.length / 2).ceil();

    Widget buildButton(String char, int index) {
      final isUsed = char.endsWith('*');
      final displayChar = isUsed ? char.substring(0, char.length - 1) : char;
      final isDisabled =
          session.isAnswerChecked || session.isGameOver || isUsed;

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed:
                isDisabled ? null : () => notifier.processLetter(index, config),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  getQuizColor2(question.subject, context, 0.6, 0.2, 0.95),
              foregroundColor: textColor1(context),
              disabledBackgroundColor:
                  getQuizColor2(question.subject, context, 0.6, 0.2, 0.95)
                      .withAlpha(50),
              disabledForegroundColor: textColor1(context).withAlpha(50),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              displayChar,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: List.generate(
            halfLength,
            (i) => buildButton(buttons[i], i),
          ),
        ),
        Row(
          children: List.generate(
            buttons.length - halfLength,
            (i) => buildButton(buttons[i + halfLength], i + halfLength),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton.icon(
                  onPressed: session.isAnswerChecked ||
                          session.isGameOver ||
                          inputState.enteredText.isNotEmpty
                      ? null
                      : () => notifier.giveHint(config),
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text("ヒント"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withAlpha(200),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton.icon(
                  onPressed: session.isAnswerChecked || session.isGameOver
                      ? null
                      : () => ref
                          .read(quizSessionNotifierProvider.notifier)
                          .judge("peke", config,
                              isHintUsed: inputState.isHintUsed),
                  icon: const Icon(Icons.skip_next),
                  label: const Text("パス"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withAlpha(200),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

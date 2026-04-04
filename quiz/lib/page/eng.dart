import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

import '../providers/eng_provider.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: getQuizColor2(question.subject, context, 0.6, 0.2, 0.95),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // 文字同士の間隔を最小限に（プロポーショナルな並びにする）
            children: List.generate(question.word.length, (index) {
              final hasInput = index < inputState.enteredText.length;
              final char = hasInput ? inputState.enteredText[index] : '';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IntrinsicWidthで「文字の幅」をそのまま反映させる
                    IntrinsicWidth(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // 1. 文字表示（幅は文字に依存。mでも切れない）
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              // 未入力時は適当な文字（'A'等）を透明で置いて
                              // 全て同じ幅の下線に見せる（バレ防止）
                              char.isEmpty ? 'A' : char,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: char.isEmpty
                                    ? Colors.transparent
                                    : textColor1(context),
                              ),
                            ),
                          ),
                          // 2. 下線（Stackの幅、つまり上の文字幅に自動で伸び縮みする）
                          Container(
                            height: 3,
                            // 未入力時は 'A' の幅、入力後はその文字の幅になる
                            decoration: BoxDecoration(
                              color: char.isEmpty
                                  ? textColor1(context).withAlpha(120)
                                  : Colors.transparent, // 入力後は消す
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
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

    // ヒントボタンの有効化判定
    final targetWord = question.word.toLowerCase();
    final currentLen = inputState.enteredText.length;
    final maxHintLen = config.modeData.isbattle
        ? 1
        : (targetWord.length - 2).clamp(1, targetWord.length);
    final isHintDisabled = session.isAnswerChecked ||
        session.isGameOver ||
        currentLen >= maxHintLen;

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
                  onPressed:
                      isHintDisabled ? null : () => notifier.giveHint(config),
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text("ヒント"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withAlpha(200),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.withAlpha(100),
                    disabledForegroundColor: Colors.white.withAlpha(100),
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
                      : () =>
                          ref.read(quizSessionNotifierProvider.notifier).judge(
                                QuizResult.cross,
                                config,
                              ),
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

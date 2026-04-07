import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

// These typedefs are local to this file for now.

class ScoreSection extends ConsumerWidget {
  final int step;

  const ScoreSection({required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizinfo = ref.watch(currentDetailConfigProvider);
    final elapsed = ref.watch(quizElapsedTimerProvider);
    final session = ref.watch(quizSessionNotifierProvider);

// 2. switch 式で、どの値を「スコア」として採用するか決める
    final num score = switch (quizinfo.timeMode) {
      TimeMode.timeAttack => elapsed,
      TimeMode.countDown => session.totalScore,
      TimeMode.learning => session.correctCount,
    };
    final label = switch (quizinfo.timeMode) {
      TimeMode.learning => "正解数",
      TimeMode.countDown => 'timeLabel',
      TimeMode.timeAttack => 'timeLabel',
    };
    Color borderColor = getQuizColor2(
      quizinfo.detail.color,
      context,
      1,
      0.35,
      0.95,
    );
    String useLabel = l10n(context, label);
    String unit = l10n(context, quizinfo.modeData.unit);
    int fix = quizinfo.modeData.fix;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: FittedBox(
                  child: Text(
                    useLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor1(context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor2(context),
                  border: Border.all(color: borderColor, width: 3),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        step == 0 ? " " : score.toStringAsFixed(fix),
                        style: TextStyle(
                          fontSize: 1000,
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 400,
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
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
    );
  }
}

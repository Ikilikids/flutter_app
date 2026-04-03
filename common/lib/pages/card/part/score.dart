import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoreDisplay extends HookConsumerWidget {
  final QuizId quizId;

  const ScoreDisplay({
    required this.quizId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(quizDetailProvider(quizId));
    final detail = config.detail;
    final mode = config.modeData;
    final highScore = config.highScore;
    final unit = mode.unit;
    final fix = mode.fix;
    final iconColor = getQuizColor2(detail.color, context, 1, 0.35, 0.95);

    final displayValue =
        (highScore == 0.0 ? "--" : highScore.toStringAsFixed(fix));
    final icon = mode.isbattle ? Icons.emoji_events : Icons.workspace_premium;

    return Expanded(
      child: FittedBox(
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 100),
            const SizedBox(width: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(displayValue,
                    style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: textColor1(context))),
                const SizedBox(width: 8),
                Text(l10n(context, unit),
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: textColor1(context))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

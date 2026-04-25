import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

import '../providers/word_stats_provider.dart';

class EngWordStatsTile extends HookConsumerWidget {
  final EngMakingData? question;
  const EngWordStatsTile({super.key, this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestion = question ??
        ref.watch(quizSessionNotifierProvider.select((s) {
          final q = s.currentQuestion;
          return q is EngMakingData ? q : null;
        }));
    if (currentQuestion == null) return const SizedBox.shrink();

    final String word = currentQuestion.word.trim();

    final stats = ref.watch(wordStatsNotifierProvider.select(
      (s) => s.value?[word.toLowerCase()] ?? const WordStats(),
    ));

    final toggleMarker = useCallback((String type) async {
      final notifier = ref.read(wordStatsNotifierProvider.notifier);
      if (type == 'star') {
        await notifier.toggleStar(word);
      } else {
        await notifier.toggleHeart(word);
      }
    }, [word]);

    final themeColor =
        getQuizColor2(currentQuestion.subject, context, 1, 0.65, 1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor1(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColor.withAlpha(80), width: 1.5),
      ),
      child: Row(
        children: [
          // 1. 統計情報 (正解数・率)
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(children: [
                    const Text(
                      "直近5回",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    ...List.generate(
                      5,
                      (index) {
                        QuizResult quizResult = QuizResult.unknown;
                        Color color = Colors.grey.withAlpha(100);
                        if (index < stats.recentResults.length) {
                          quizResult = stats.recentResults[index];
                          if (quizResult == QuizResult.circle)
                            color = Colors.red;
                          if (quizResult == QuizResult.triangle)
                            color = Colors.green;
                          if (quizResult == QuizResult.cross)
                            color = Colors.blue;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            quizResultToEmoji(quizResult),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Text("○:${stats.correctCount}",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Text("△:${stats.hintCount}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Text("×:${stats.incorrectCount}",
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text("${stats.accuracyRate.toStringAsFixed(1)}%",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 2. タグボタン
          Row(
            children: [
              IconButton(
                icon: Icon(
                  stats.star ? Icons.star : Icons.star_border,
                  color: stats.star ? Colors.orange : Colors.grey,
                  size: 28,
                ),
                onPressed: () {
                  toggleMarker('star');
                  if (!stats.star)
                    ref.read(appSoundProvider).playSound("star.mp3");
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  stats.heart ? Icons.favorite : Icons.favorite_border,
                  color: stats.heart ? Colors.red : Colors.grey,
                  size: 28,
                ),
                onPressed: () {
                  toggleMarker('heart');
                  if (!stats.heart)
                    ref.read(appSoundProvider).playSound("heart.mp3");
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

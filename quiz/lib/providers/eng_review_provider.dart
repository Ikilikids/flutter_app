import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'word_stats_provider.dart';

enum ReviewMetric {
  accuracyRate("正解率", 0, 100, "%"),
  correctCount("正解数", 0, 20, "回"),
  incorrectCount("不正解数", 0, 20, "回"),
  recentCorrectCount("直近5回の正解数", 0, 5, "回"),
  recentIncorrectCount("直近5回の不正解数", 0, 5, "回"),
  totalPlayCount("プレイ回数", 0, 20, "回");

  final String label;
  final double min;
  final double max;
  final String unit;
  const ReviewMetric(this.label, this.min, this.max, this.unit);
}

class EngReviewFilter {
  final Set<String> parts;
  final Set<int> levels;
  final ReviewMetric metric;
  final RangeValues range;
  final bool star;
  final bool heart;

  const EngReviewFilter({
    required this.parts,
    required this.levels,
    required this.metric,
    required this.range,
    required this.star,
    required this.heart,
  });

  bool matches(EngPartData part, WordStats s) {
    // 1. 品詞チェック
    final domain = part.middle;
    bool partMatch = parts.contains(domain) ||
        (domain != "名詞" &&
            domain != "動詞" &&
            domain != "形容詞" &&
            domain != "副詞" &&
            parts.contains("その他"));
    if (!partMatch) return false;

    // 2. レベルチェック
    if (!levels.contains(part.totalScore)) return false;

    // 3. タグ判定
    bool tagMatch = false;
    if (star && s.star) tagMatch = true;
    if (heart && s.heart) tagMatch = true;
    if (!star && !heart) tagMatch = true;
    if (!tagMatch) return false;

    // 4. 指標判定
    double val = 0;
    switch (metric) {
      case ReviewMetric.accuracyRate:
        val = s.accuracyRate;
        break;
      case ReviewMetric.correctCount:
        val = s.correctCount.toDouble();
        break;
      case ReviewMetric.incorrectCount:
        val = s.incorrectCount.toDouble();
        break;
      case ReviewMetric.recentCorrectCount:
        val = s.recentCorrectCount.toDouble();
        break;
      case ReviewMetric.recentIncorrectCount:
        val = s.recentIncorrectCount.toDouble();
        break;
      case ReviewMetric.totalPlayCount:
        val = s.totalPlayCount.toDouble();
        break;
    }
    return val >= range.start && val <= range.end;
  }
}

/// 英単語アプリ専用の「復習モード」フィルタ条件を保持するスロット
final engReviewFilterProvider = StateProvider<EngReviewFilter?>((ref) => null);

/// フィルタリングされた単語リストを提供するプロバイダー
final filteredReviewQuestionsProvider = Provider<List<EngPartData>>((ref) {
  final integratedData = ref.watch(integratedEngQuizProvider).value;
  if (integratedData == null) return [];

  final statsMap = ref.watch(wordStatsNotifierProvider).value ?? {};
  final filter = ref.watch(engReviewFilterProvider);
  if (filter == null) return [];

  final List<EngPartData> results = [];
  integratedData.forEach((score, partList) {
    for (var part in partList) {
      final s = statsMap[part.word.toLowerCase()] ?? const WordStats();
      if (filter.matches(part, s)) {
        results.add(part);
      }
    }
  });
  return results;
});

/// フィルタリングされた単語数を提供するプロバイダー
final filteredReviewCountProvider = Provider<int>((ref) {
  return ref.watch(filteredReviewQuestionsProvider).length;
});

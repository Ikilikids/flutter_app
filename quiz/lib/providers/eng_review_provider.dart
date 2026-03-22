import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

/// 英単語アプリ専用の「復習モード」フィルタ条件を保持するスロット
final engReviewFilterProvider = StateProvider<EngReviewFilter?>((ref) => null);

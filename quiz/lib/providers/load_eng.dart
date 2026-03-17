import 'package:common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'word_stats_provider.dart';

class EngQuizLoader {
  static Future<Map<int, List<PartData>>> load(
      WidgetRef ref, DetailConfig quizinfo) async {
    // 1. 統合データ（CSV + 初期統計）を取得
    final integratedData = await ref.read(integratedEngQuizProvider.future);
    // 2. 最新の統計（星・成績）を取得
    final statsMap = ref.read(wordStatsNotifierProvider).value ?? {};

    final List<PartData> allCandidates = [];
    final sortParts = quizinfo.detail.sort.split(';');

    integratedData.forEach((score, partList) {
      for (var part in partList) {
        if (sortParts.length < 2) continue;

        // 品詞・レベルの基本チェック
        if (!sortParts[0].contains(part.subject)) continue;
        if (!sortParts[1].contains(part.totalScore.toString())) continue;

        // 復習モードの詳細条件（星・成績指標など）
        if (sortParts.length >= 6) {
          final s = statsMap[part.word.toLowerCase()] ?? const WordStats();
          if (!_checkReviewFilter(sortParts, s)) continue;
        }
        allCandidates.add(part);
      }
    });

    allCandidates.shuffle();
    print(
        "EngQuizLoader: total candidates after filtering = ${allCandidates.length}");
    return {1: allCandidates};
  }

  static bool _checkReviewFilter(List<String> sortParts, WordStats s) {
    final metricIdx = int.tryParse(sortParts[2]) ?? 0;
    final min = int.tryParse(sortParts[3]) ?? 0;
    final max = int.tryParse(sortParts[4]) ?? 100;
    final tagMode = sortParts[5];

    // タグ判定
    if (tagMode == "star" && !s.star) return false;
    if (tagMode == "heart" && !s.heart) return false;
    if (tagMode == "both" && !(s.star || s.heart)) return false;

    // 指標判定
    double val = 0;
    switch (metricIdx) {
      case 0:
        val = s.accuracyRate;
        break;
      case 1:
        val = s.correctCount.toDouble();
        break;
      case 2:
        val = s.incorrectCount.toDouble();
        break;
      case 3:
        val = s.recentCorrectCount.toDouble();
        break;
      case 4:
        val = s.recentIncorrectCount.toDouble();
        break;
      case 5:
        val = s.totalPlayCount.toDouble();
        break;
    }
    return val >= min && val <= max;
  }
}

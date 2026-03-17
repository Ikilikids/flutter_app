import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:quiz/quiz.dart";
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'word_stats_provider.dart';

part 'quiz_data_provider.g.dart';

/// 1. 固定データ: 英単語CSVのパース結果をキャッシュ
@Riverpod(keepAlive: true)
Future<List<List<dynamic>>> juniorEngRawCsv(Ref ref) async {
  final csvString = await rootBundle.loadString("assets/csv/eng_data.csv");
  return const CsvToListConverter().convert(csvString);
}

/// 3. 統合データ: 固定CSVデータ + 可変統計データをマージ (非同期)
@Riverpod(keepAlive: true)
Future<Map<int, List<EngPartData>>> integratedEngQuiz(Ref ref) async {
  // 英単語専用のプロバイダーを監視
  final rows = await ref.watch(juniorEngRawCsvProvider.future);
  // 可変データの初期値を監視 (初回のみ実行されるように)
  final statsMap = await ref.watch(wordStatsInitialProvider.future);

  final Map<int, List<EngPartData>> scoreMap = {};

  for (var row in rows) {
    if (row.length < 3) continue;

    final word = row[1].toString().trim();
    final meaning = row[2].toString().trim();
    final totalScore = ((row[0] ~/ 400) + 1).clamp(1, 7);

    final statsKey = word.toLowerCase();
    final stats = statsMap[statsKey] ?? const WordStats();

    final p = EngPartData(
      mode: "eng",
      making: [word, meaning],
      subject: getSpeechNumber(row[3].toString()),
      domain: row[3].toString(),
      field: row[0].toString(),
      totalScore: totalScore,
      correctCount: stats.correctCount,
      incorrectCount: stats.incorrectCount,
      hintCount: stats.hintCount,
      star: stats.star,
      heart: stats.heart,
      recentResults: stats.recentResults,
    );
    scoreMap.putIfAbsent(totalScore, () => []).add(p);
  }

  return scoreMap;
}

/// ② 今プレイするゲームのために「フィルタリングされた」マップを保持する器
@Riverpod(keepAlive: true)
class ActiveGameMap extends _$ActiveGameMap {
  @override
  Map<int, List<PartData>> build() => {};

  void update(Map<int, List<PartData>> map) {
    state = map;
  }
}

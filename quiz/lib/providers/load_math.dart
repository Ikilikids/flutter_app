import 'package:common/common.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'quiz_models.dart';

class MathQuizLoader {
  static Future<Map<int, List<PartData>>> load(DetailConfig quizinfo) async {
    final csv = await rootBundle.loadString("assets/csv/quizdata.csv");
    final rows = const CsvToListConverter().convert(csv);
    final Map<int, List<PartData>> scoreIndexMap = {};
    _processMathRows(rows, scoreIndexMap);

    final Map<int, List<PartData>> filtered = {};
    scoreIndexMap.forEach((score, list) {
      final newList = list.where((p) {
        if (!quizinfo.modeData.isbattle)
          return p.field == quizinfo.detail.displayLabel;
        return quizinfo.detail.sort.contains(p.subject);
      }).toList();
      if (newList.isNotEmpty) filtered[score] = newList;
    });
    return filtered;
  }

  static void _processMathRows(
      List<List<dynamic>> rows, Map<int, List<PartData>> map) {
    for (var row in rows) {
      if (row.length < 17) continue;
      final mode = row[0].toString();
      final making = [row[1].toString(), row[2].toString(), row[3].toString()];
      if (mode == "latex") {
        _processLatex(row, mode, making, row[5].toString(), row[6].toString(),
            row[7].toString(), map);
      } else {
        final score =
            int.parse(row[13].toString().replaceAll(RegExp(r"[ab]"), ""));
        map.putIfAbsent(score, () => []).add(PartData.create(
            mode: mode,
            making: making,
            subject: row[5].toString(),
            domain: row[6].toString(),
            field: row[7].toString(),
            totalScore: score));
      }
    }
  }

  // --- 既存のLatexパース処理をここに保持 ---
  static void _processLatex(List<dynamic> row, String mode, List<String> making,
      String sub, String dom, String field, Map<int, List<PartData>> map) {
    final scoreStrings = [
      row[13].toString(),
      row[14].toString(),
      row[15].toString(),
      row[16].toString()
    ];
    List<int> validIndices = [];
    for (int k = 0; k < 4; k++)
      if (scoreStrings[k].isNotEmpty) validIndices.add(k);

    for (int i = 1; i < (1 << validIndices.length); i++) {
      List<int> subset = [];
      for (int j = 0; j < validIndices.length; j++)
        if ((i & (1 << j)) != 0) subset.add(validIndices[j]);

      // バリデーション等の既存処理 ...
      List<HoleData> holes = [];
      int total = 0;
      for (int idx in subset) {
        int s = int.parse(scoreStrings[idx].replaceAll(RegExp(r"[ab]"), ""));
        holes.add(
            HoleData(index: idx, button: row[9 + idx].toString(), score: s));
        total += s;
      }
      map.putIfAbsent(total, () => []).add(PartData.create(
          mode: mode,
          making: making,
          subject: sub,
          domain: dom,
          field: field,
          totalScore: total,
          holes: holes,
          firstButton: row[8].toString()));
    }
  }

  // Case 2: appTitle 特有の処理
  static void expandForAppTitle(
      WidgetRef ref, DetailConfig quizinfo, Map<int, List<PartData>> filtered) {
    final list = filtered[1];
    if (list == null || list.isEmpty) return;
    int qCount = quizinfo.detail.sort == "4867" ? 10 : 20;
    ref.read(userStatusNotifierProvider.notifier).updateQcount(
        quizinfo.detail.resisterOrigin, quizinfo.modeData.modeType, qCount);

    final count = qCount ~/ list.length;
    List<PartData> expanded = [];
    for (var item in list) for (int i = 0; i < count; i++) expanded.add(item);
    filtered[1] = expanded..shuffle();
  }
}

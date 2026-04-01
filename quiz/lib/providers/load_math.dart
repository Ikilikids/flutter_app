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
        _processLatex(
          row,
          mode,
          making,
          row[5].toString(),
          row[6].toString(),
          row[7].toString(),
          map,
        );
      } else {
        // latex以外はrow[13]の単一スコアのみ処理
        final scoreStr = row[13].toString().replaceAll(RegExp(r"[ab]"), "");
        if (scoreStr.isEmpty) continue;

        final score = int.parse(scoreStr);
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

  static void _processLatex(List<dynamic> row, String mode, List<String> making,
      String sub, String dom, String field, Map<int, List<PartData>> map) {
    final controlButtons = [
      row[9].toString(),
      row[10].toString(),
      row[11].toString(),
      row[12].toString()
    ];
    final scoreStrings = [
      row[13].toString(),
      row[14].toString(),
      row[15].toString(),
      row[16].toString()
    ];

    List<int> validIndices = [];
    List<int> aIndices = [];
    List<int> bIndices = [];

    // 有効なインデックスとa/bグループの分類
    for (int k = 0; k < scoreStrings.length; k++) {
      if (scoreStrings[k].isNotEmpty) {
        validIndices.add(k);
        if (scoreStrings[k].contains('a')) aIndices.add(k);
        if (scoreStrings[k].contains('b')) bIndices.add(k);
      }
    }

    int n = validIndices.length;
    // ビット全探索で全ての組み合わせを生成
    for (int i = 1; i < (1 << n); i++) {
      List<int> subsetIndices = [];
      for (int j = 0; j < n; j++) {
        if ((i & (1 << j)) != 0) subsetIndices.add(validIndices[j]);
      }

      // --- バリデーションロジック ---

      // グループ「a」: 含まれている場合は、aに属する全てが含まれていなければならない（必須セット）
      if (aIndices.isNotEmpty) {
        if (!aIndices.every((idx) => subsetIndices.contains(idx))) continue;
      }

      // グループ「b」: 一つでも含まれるなら、bに属する全てが含まれていなければならない（一括セット）
      if (bIndices.isNotEmpty) {
        bool hasAnyB = bIndices.any((idx) => subsetIndices.contains(idx));
        bool hasAllB = bIndices.every((idx) => subsetIndices.contains(idx));
        if (hasAnyB && !hasAllB) continue;
      }

      List<HoleData> holes = [];
      int currentTotal = 0;
      for (int idx in subsetIndices) {
        int s = int.parse(scoreStrings[idx].replaceAll(RegExp(r"[ab]"), ""));
        holes.add(HoleData(index: idx, button: controlButtons[idx], score: s));
        currentTotal += s;
      }

      final p = PartData.create(
        mode: mode,
        making: making,
        subject: sub,
        domain: dom,
        field: field,
        totalScore: currentTotal,
        holes: holes,
        firstButton: row[8].toString(),
      );
      map.putIfAbsent(currentTotal, () => []).add(p);
    }
  }

  // Case 2: appTitle 特有の処理
  static void expandForAppTitle(
      WidgetRef ref, DetailConfig quizinfo, Map<int, List<PartData>> filtered) {
    final list = filtered[1];
    if (list == null || list.isEmpty) return;
    int qCount = quizinfo.detail.sort == "4867" ? 10 : 20;
    ref
        .read(userStatusNotifierProvider.notifier)
        .updateQcount(quizinfo.detail.quizId, qCount);

    final count = qCount ~/ list.length;
    List<PartData> expanded = [];
    for (var item in list) for (int i = 0; i < count; i++) expanded.add(item);
    filtered[1] = expanded..shuffle();
  }
}

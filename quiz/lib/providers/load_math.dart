import 'package:common/common.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'quiz_models.dart';

Future<Map<int, List<PartData>>> load(DetailConfig quizinfo) async {
  final isCalEasy = quizinfo.appData.appTitle == "appTitle";
  print(
      "Loading quiz data for ${quizinfo.detail.displayLabel} (isCalEasy: $isCalEasy)");
  final csv = await rootBundle.loadString(isCalEasy
      ? "packages/common/assets/csv/cal_easy_data.csv"
      : "packages/common/assets/csv/math_data.csv");
  final rows = const CsvToListConverter().convert(csv);
  final Map<int, List<PartData>> scoreIndexMap = {};

  for (var row in rows) {
    if (row.length < 17) continue;

    // --- 【ここが肝】処理する前に「今のクイズに関係あるか」判定 ---
    final String rowField = row[7].toString();
    final String rowTop = row[5].toString();

    bool isTarget = false;
    if (!quizinfo.modeData.isbattle) {
      // 通常モード：表示ラベルが一致するか
      isTarget = (rowField == quizinfo.detail.displayLabel);
    } else {
      // バトルモード：特定のソート条件に含まれるか
      isTarget = quizinfo.detail.sort.contains(rowTop);
    }

    if (!isTarget) continue; // 関係ない行はここでポイッ（解析しない）

    // --- 通ったものだけ解析（ビット全探索など）を実行 ---
    final mode = row[0].toString();
    if (mode == "latex" || mode == "alice") {
      _processLatex(row, scoreIndexMap);
    } else {
      final score = int.parse(row[13].toString());
      scoreIndexMap.putIfAbsent(score, () => []).add(
            PartData.create(
                mode: QuizMode.option,
                making: [
                  row[1].toString(),
                  row[2].toString(),
                  row[3].toString()
                ],
                subject: row[5].toString(),
                domain: row[6].toString(),
                field: row[7].toString(),
                totalScore: score),
          );
    }
  }

  // ここで返る scoreIndexMap は、すでにフィルター済みの綺麗な状態
  return scoreIndexMap;
}

void _processLatex(List<dynamic> row, Map<int, List<PartData>> map) {
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
      mode: row[0].toString() == "alice" ? QuizMode.alice : QuizMode.latex,
      making: [row[1].toString(), row[2].toString(), row[3].toString()],
      subject: row[5].toString(),
      domain: row[6].toString(),
      field: row[7].toString(),
      totalScore: currentTotal,
      holes: holes,
      firstButton: row[8].toString(),
    );
    map.putIfAbsent(currentTotal, () => []).add(p);
  }
}

// Case 2: appTitle 特有の処理
void expandForAppTitle(
    WidgetRef ref, DetailConfig quizinfo, Map<int, List<PartData>> filtered) {
  final list = filtered[1];
  if (list == null || list.isEmpty) return;
  int qCount = quizinfo.detail.sort == "4867" ? 10 : 20;
  ref
      .read(quizCountNotifierProvider.notifier)
      .selectQuizCount(quizinfo.detail.quizId, qCount);

  final count = qCount ~/ list.length;
  List<PartData> expanded = [];
  for (var item in list) for (int i = 0; i < count; i++) expanded.add(item);
  filtered[1] = expanded..shuffle();
}

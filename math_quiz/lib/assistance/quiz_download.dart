import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizProvider extends ChangeNotifier {
  Map<int, List<PartData>> scoreIndexMap = {};

  Future<void> initAll() async {
    final csvString = await rootBundle.loadString("assets/csv/quizdata.csv");
    final rows = const CsvToListConverter().convert(csvString);
    scoreIndexMap.clear();

    for (var row in rows) {
      if (row.length < 17) continue;
      _processRow(row);
    }
    notifyListeners();
  }

  void _processRow(List<dynamic> row) {
    final mode = row[0].toString();
    final making = [row[1].toString(), row[2].toString(), row[3].toString()];
    final subject = row[5].toString();
    final domain = row[6].toString();
    final field = row[7].toString();

    if (mode == "latex") {
      // ===== LaTeXの重いロジック（bit演算）はここに隔離 =====
      _processLatex(row, mode, making, subject, domain, field);
    } else {
      // ===== Optionモード：13列目(row[13])をスコアにして1つ作る =====
      final totalScore =
          int.parse(row[13].toString().replaceAll(RegExp(r"[ab]"), ""));
      final p = PartData.create(
        mode: mode,
        making: making,
        subject: subject,
        domain: domain,
        field: field,
        totalScore: totalScore,
      );
      scoreIndexMap.putIfAbsent(totalScore, () => []).add(p);
    }
  }

  void _processLatex(List<dynamic> row, String mode, List<String> making,
      String sub, String dom, String field) {
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

    for (int k = 0; k < scoreStrings.length; k++) {
      if (scoreStrings[k].isNotEmpty) {
        validIndices.add(k);
        if (scoreStrings[k].contains('a')) aIndices.add(k);
        if (scoreStrings[k].contains('b')) bIndices.add(k);
      }
    }

    int n = validIndices.length;
    for (int i = 1; i < (1 << n); i++) {
      List<int> subsetIndices = [];
      for (int j = 0; j < n; j++) {
        if ((i & (1 << j)) != 0) subsetIndices.add(validIndices[j]);
      }

      // 1. ★ グループ「a」の掟：【絶対に全員穴にすること】
      if (aIndices.isNotEmpty) {
        // aのインデックスが一つでも欠けていたら、そのパターンはボツ
        bool hasAllA = aIndices.every((idx) => subsetIndices.contains(idx));
        if (!hasAllA) continue;
      }

      // 2. ★ グループ「b」の掟：【全員一緒か、さもなくば全員ゼロか】
      if (bIndices.isNotEmpty) {
        bool hasAnyB = bIndices.any((idx) => subsetIndices.contains(idx));
        bool hasAllB = bIndices.every((idx) => subsetIndices.contains(idx));
        // 「誰か一人でもいるのに、全員揃っていない」場合はボツ
        if (hasAnyB && !hasAllB) continue;
      }

      // 3. 全ての掟をパスしたエリートのみが PartData になれる
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
      scoreIndexMap.putIfAbsent(currentTotal, () => []).add(p);
    }
  }
}

abstract class PartData {
  final String mode;
  final List<String> making;
  final String subject;
  final String domain;
  final String field;
  final int totalScore;

  const PartData({
    required this.mode,
    required this.making,
    required this.subject,
    required this.domain,
    required this.field,
    required this.totalScore,
  });

  // ★ factory 窓口：Providerからの指示を適切なクラスに振り分けるだけ
  factory PartData.create({
    required String mode,
    required List<String> making,
    required String subject,
    required String domain,
    required String field,
    required int totalScore,
    List<HoleData>? holes,
    String? firstButton,
  }) {
    if (mode == "latex") {
      return LatexPartData(
        mode: mode,
        making: making,
        subject: subject,
        domain: domain,
        field: field,
        totalScore: totalScore,
        holes: holes!,
        firstButton: firstButton!,
      );
    } else {
      return OptionPartData(
        mode: mode,
        making: making,
        subject: subject,
        domain: domain,
        field: field,
        totalScore: totalScore,
      );
    }
  }
}

class LatexPartData extends PartData {
  final List<HoleData> holes;
  final String firstButton;

  LatexPartData({
    required super.mode,
    required super.making,
    required super.subject,
    required super.domain,
    required super.field,
    required super.totalScore,
    required this.holes,
    required this.firstButton,
  });
}

class OptionPartData extends PartData {
  OptionPartData({
    required super.mode,
    required super.making,
    required super.subject,
    required super.domain,
    required super.field,
    required super.totalScore,
  });
}

class HoleData {
  final int index; // 何番目の [ ... ]
  final String button; // 対応ボタン
  final int score; // スコア

  const HoleData({
    required this.index,
    required this.button,
    required this.score,
  });
}

import 'package:common/common.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:quiz/quiz.dart";

class LoadQuiz {
  final DetailConfig quizinfo;
  Map<int, List<PartData>> allQuizData = {};
  Map<int, List<PartData>> filterdQuizData = {};

  LoadQuiz({required this.quizinfo});

  Future<void> init(WidgetRef ref) async {
    await loadAllQuizData();
    loadFilterdQuizData();
    ref.read(activeGameMapProvider.notifier).update(filterdQuizData);
  }

  Future<void> loadAllQuizData() async {
    // 1. 数学クイズの読み込み（既存）
    if (quizinfo.appData.appTitle == "とことん高校数学") {
      final csvString = await rootBundle.loadString("assets/csv/quizdata.csv");
      final rows = const CsvToListConverter().convert(csvString);
      _processMathRows(rows);
    }

    // 2. 英単語クイズの読み込み（新規）
    else if (quizinfo.appData.appTitle.contains("英単語")) {
      final engCsvString =
          await rootBundle.loadString("assets/csv/eng_data.csv");
      final engRows = const CsvToListConverter().convert(engCsvString);
      _processEngRows(engRows);
    }

    allQuizData = scoreIndexMap;
  }

  final Map<int, List<PartData>> scoreIndexMap = {};

  void _processMathRows(List<List<dynamic>> rows) {
    for (var row in rows) {
      if (row.length < 17) continue;

      final mode = row[0].toString();
      final making = [row[1].toString(), row[2].toString(), row[3].toString()];
      final subject = row[5].toString();
      final domain = row[6].toString();
      final field = row[7].toString();

      if (mode == "latex") {
        _processLatex(row, mode, making, subject, domain, field, scoreIndexMap);
      } else {
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
  }

  void _processEngRows(List<List<dynamic>> rows) {
    for (var row in rows) {
      if (row.length < 3) continue;

      final word = row[1].toString();
      final meaning = row[2].toString();
      final totalScore = ((row[0] ~/ 400) + 1).clamp(1, 8);

      final p = PartData.create(
        mode: "eng",
        making: [word, meaning],
        subject: getSpeechNumber(row[3].toString()),
        domain: row[3].toString(),
        field: row[0].toString(),
        totalScore: totalScore,
      );
      scoreIndexMap.putIfAbsent(totalScore, () => []).add(p);
    }
  }

  void loadFilterdQuizData() {
    allQuizData.forEach((score, partList) {
      final newList = partList.where((part) {
        if (part.mode == "eng") {
          final parts = quizinfo.detail.sort.split(';');

          final subjectPart = parts.isNotEmpty ? parts[0] : '';
          final scorePart = parts.length > 1 ? parts[1] : '';

          final isSubjectMatch = subjectPart.contains(part.subject);
          final isScoreMatch = scorePart.contains(part.totalScore.toString());

          return isSubjectMatch && isScoreMatch;
        } else if (!quizinfo.modeData.isbattle) {
          return part.field == quizinfo.detail.displayLabel;
        } else {
          return quizinfo.detail.sort.contains(part.subject);
        }
      }).toList();

      if (newList.isNotEmpty) filterdQuizData[score] = newList;
    });
  }

  void _processLatex(List<dynamic> row, String mode, List<String> making,
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

      // グループ「a」のバリデーション
      if (aIndices.isNotEmpty) {
        if (!aIndices.every((idx) => subsetIndices.contains(idx))) continue;
      }
      // グループ「b」のバリデーション
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
}

// --- データモデル定義 ---

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
    } else if (mode == "eng") {
      return EngPartData(
        mode: mode,
        making: making,
        subject: subject,
        domain: domain,
        field: field,
        totalScore: totalScore,
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

class EngPartData extends PartData {
  EngPartData({
    required super.mode,
    required super.making,
    required super.subject,
    required super.domain,
    required super.field,
    required super.totalScore,
  });

  String get word => making[0];
  String get meaning => making[1];
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
  final int index;
  final String button;
  final int score;

  const HoleData({
    required this.index,
    required this.button,
    required this.score,
  });
}

String getSpeechNumber(String speech) {
  switch (speech) {
    case "動詞":
      return "3";
    case "形容詞":
      return "1";
    case "副詞":
      return "5";
    case "名詞":
      return "2";
    default:
      return "4";
  }
}

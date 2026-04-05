import 'dart:math';

import '../quiz.dart';

abstract class PartData {
  final QuizMode mode;
  final List<String> making;
  final String top;
  final String middle;
  final String field;
  final int totalScore;

  PartData({
    required this.mode,
    required this.making,
    required this.top,
    required this.middle,
    required this.field,
    required this.totalScore,
  });

  factory PartData.create({
    required QuizMode mode,
    required List<String> making,
    required String subject,
    required String domain,
    required String field,
    required int totalScore,
    List<HoleData>? holes,
    String? firstButton,
    int correctCount = 0,
    int incorrectCount = 0,
    int hintCount = 0,
    bool star = false,
    bool heart = false,
    List<QuizResult> recentResults = const [],
  }) {
    if (mode == QuizMode.latex || mode == QuizMode.alice) {
      return LatexPartData(
        mode: mode,
        making: making,
        top: subject,
        middle: domain,
        field: field,
        totalScore: totalScore,
        holes: holes!,
        firstButton: firstButton!,
      );
    } else if (mode == QuizMode.eng) {
      return EngPartData(
        mode: mode,
        making: making,
        top: subject,
        middle: domain,
        field: field,
        totalScore: totalScore,
        correctCount: correctCount,
        incorrectCount: incorrectCount,
        hintCount: hintCount,
        star: star,
        heart: heart,
        recentResults: recentResults,
      );
    } else {
      return OptionPartData(
        mode: mode,
        making: making,
        top: subject,
        middle: domain,
        field: field,
        totalScore: totalScore,
      );
    }
  }
}

class EngPartData extends PartData {
  int correctCount;
  int incorrectCount;
  int hintCount;
  bool star;
  bool heart;
  List<QuizResult> recentResults;

  EngPartData({
    required super.mode,
    required super.making,
    required super.top,
    required super.middle,
    required super.field,
    required super.totalScore,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.hintCount = 0,
    this.star = false,
    this.heart = false,
    this.recentResults = const [],
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
    required super.top,
    required super.middle,
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
    required super.top,
    required super.middle,
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

enum QuizMode {
  latex,
  option,
  eng,
  alice;

  bool get isMath => this == QuizMode.latex || this == QuizMode.option;

  /// 各モードの特性に応じた問題選出
  PartData pick({
    required Map<int, List<PartData>> filteredMapByScore,
    required int currentIndex,
    required int correctCount,
    required String sortKey,
    required bool isBattleMode,
  }) {
    return switch (this) {
      // Alice または 英語 (特定のリストから順次またはランダム)
      QuizMode.alice || QuizMode.eng => _pickSequentialOrRandom(
          list: filteredMapByScore[1]!,
          currentIndex: currentIndex,
        ),

      // 数学系 (Latex / Option)
      QuizMode.latex || QuizMode.option => _pickMathStrategy(
          filteredMapByScore: filteredMapByScore,
          correctCount: correctCount,
          sortKey: sortKey,
          isBattleMode: isBattleMode,
        ),
    };
  }

  // --- 内部ヘルパー ---

  PartData _pickSequentialOrRandom({
    required List<PartData> list,
    required int currentIndex,
  }) {
    Random random = Random();
    if (currentIndex < list.length) {
      return list[currentIndex];
    }
    return list[random.nextInt(list.length)];
  }

  PartData _pickMathStrategy({
    required Map<int, List<PartData>> filteredMapByScore,
    required int correctCount,
    required String sortKey,
    required bool isBattleMode,
  }) {
    Random random = Random();
    final List<PartData> candidates = [];

    if (!isBattleMode) {
      candidates.addAll(filteredMapByScore.values.expand((list) => list));
    } else {
      final scoreRange = getScoreRange(correctCount, sortKey);
      filteredMapByScore.forEach((score, list) {
        if (score >= scoreRange[0] && score <= scoreRange[1]) {
          candidates.addAll(list);
        }
      });
    }

    // 分野(field)ごとにグループ化して均等抽選
    final Map<String, List<PartData>> fieldMap = {};
    for (final part in candidates) {
      fieldMap.putIfAbsent(part.field, () => []).add(part);
    }

    final fields = fieldMap.keys.toList();
    final chosenField = fields[random.nextInt(fields.length)];
    final partsInField = fieldMap[chosenField]!;

    return partsInField[random.nextInt(partsInField.length)];
  }
}

import 'package:quiz/quiz.dart';

abstract class PartData {
  final String mode;
  final List<String> making;
  final String subject;
  final String domain;
  final String field;
  final int totalScore;

  PartData({
    required this.mode,
    required this.making,
    required this.subject,
    required this.domain,
    required this.field,
    required this.totalScore,
  });

  factory PartData.create({
    required String mode,
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
    List<String> recentResults = const [],
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
        subject: subject,
        domain: domain,
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
  List<String> recentResults;

  EngPartData({
    required super.mode,
    required super.making,
    required super.subject,
    required super.domain,
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

  double get accuracyRate {
    final total = correctCount + hintCount + incorrectCount;
    if (total == 0) return 0.0;
    return ((correctCount + hintCount * 0.5) / total) * 100;
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
    case "動詞": return "3";
    case "形容詞": return "1";
    case "副詞": return "5";
    case "名詞": return "2";
    default: return "4";
  }
}

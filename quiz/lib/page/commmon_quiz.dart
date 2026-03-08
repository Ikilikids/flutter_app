import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import "package:quiz/quiz.dart";

class ChooseQuizData {
  int correctCount;
  final DetailConfig quizinfo;
  final Map<int, List<PartData>> filteredMapByScore;

  ChooseQuizData({
    required this.correctCount,
    required this.quizinfo,
    required this.filteredMapByScore,
  });

  // スコア範囲から素早く選ぶ
  PartData chooseRandombyScoreRange() {
    final random = Random();

    // 1️⃣ スコア範囲で抽出
    final candidates = <PartData>[];

    // 全データが英単語モードかどうかをチェック（最初の要素で判定）
    bool isEngMode = false;
    if (filteredMapByScore.isNotEmpty) {
      final firstList = filteredMapByScore.values.first;
      if (firstList.isNotEmpty && firstList.first.mode == "eng") {
        isEngMode = true;
      }
    }

    // 🔥 バトルじゃないとき、または英単語モードのときは全件対象
    if (!quizinfo.modeData.isbattle || isEngMode) {
      filteredMapByScore.forEach((_, partList) {
        candidates.addAll(partList);
      });
    }
    // ⚔ バトルのときだけスコア範囲で絞る
    else {
      final scoreRange = getScoreRange(correctCount, quizinfo.detail.sort);
      final minScore = scoreRange[0];
      final maxScore = scoreRange[1];

      filteredMapByScore.forEach((score, partList) {
        if (score >= minScore && score <= maxScore) {
          candidates.addAll(partList);
        }
      });
    }

    if (candidates.isEmpty) {
      throw Exception("No quiz candidates found in score range");
    }

    if (isEngMode) {
      print(candidates.length);
      return candidates[random.nextInt(candidates.length)];
    }
    // 2️⃣ fieldごとにまとめる
    final fieldMap = <String, List<PartData>>{};
    for (var part in candidates) {
      fieldMap.putIfAbsent(part.field, () => []).add(part);
    }

    // 3️⃣ field均等抽選
    final fields = fieldMap.keys.toList();
    final chosenField = fields[random.nextInt(fields.length)];

    final partsInField = fieldMap[chosenField]!;

    // 4️⃣ 最終ランダム
    return partsInField[random.nextInt(partsInField.length)];
  }
}

String makeHoleString(
  String input,
  List<HoleData> holes,
) {
  final regExp = RegExp(r'\[[^\]]*\]');
  int currentIndex = 0;

  // index → HoleData のMapを作る（高速化）
  final holeMap = {
    for (var h in holes) h.index: h,
  };

  return input.replaceAllMapped(regExp, (match) {
    final original = match.group(0)!;

    final hole = holeMap[currentIndex];

    currentIndex++;

    if (hole != null) {
      // 穴にする場合
      if (original == r"[\cos]" ||
          original == r"[\sin]" ||
          original == r"[\tan]" ||
          original == r"[\log]") {
        return '□';
      } else if ((original == "[-]" || original == "[+]") &&
          hole.button == "[+-]") {
        return '☆';
      } else {
        return '◯';
      }
    } else {
      // 穴にしない場合は [] を外す
      return original.replaceAll('[', '').replaceAll(']', '');
    }
  });
}

List<String> makinglist(String input) {
  input = input.replaceAll("[", "");
  input = input.replaceAll("]", "");
  input = input.replaceAll("\\frac", "f");
  input = input.replaceAll("\\sqrt", "r");
  input = input.replaceAll("\\pi", "p");
  input = input.replaceAll("\\infty", "i");
  input = input.replaceAll("\\pm", "q");
  input = input.replaceAll("\\sin", "s");
  input = input.replaceAll("\\cos", "c");
  input = input.replaceAll("\\tan", "t");
  input = input.replaceAll("\\log", "l");
  List<String> result = [];
  int i = 0;

  // { ... } 内の文字列を取り出す関数
  String extractBraceContent() {
    if (input[i] != '{') return '';
    int start = ++i;
    int braceCount = 1;
    while (i < input.length && braceCount > 0) {
      if (input[i] == '{') {
        braceCount++;
      } else if (input[i] == '}') {
        braceCount--;
      }
      if (braceCount > 0) i++;
    }
    // iは閉じ括弧の位置
    String content = input.substring(start, i);
    i++; // 閉じ括弧の次の位置へ
    return content;
  }

  while (i < input.length) {
    if (input.startsWith('f', i)) {
      i += 1; // "\frac" の長さ分スキップ
      // 分子と分母を取り出す
      String numerator = extractBraceContent();
      String denominator = extractBraceContent();

      // 分母、f、分子 の順で入れる
      result.addAll(denominator.split('')); // 文字列を1文字ずつに分解して追加
      result.add('f');
      result.addAll(numerator.split(''));
    } else {
      // \frac以外は1文字ずつ追加。ただし空白は無視したいならスキップ
      if (input[i] != ' ') {
        result.add(input[i]);
      }
      i++;
    }
  }
  return result.where((ch) => ch != '{' && ch != '}').toList();
}

List<IndexData> buildIndexData(
  String input,
  List<HoleData> holes,
) {
  final regExp = RegExp(r'\[[^\]]*\]');
  int currentIndex = 0;

  final holeMap = {
    for (var h in holes) h.index: h,
  };

  List<IndexData> result = [];

  for (final match in regExp.allMatches(input)) {
    final originalWithBracket = match.group(0)!;
    final hole = holeMap[currentIndex];

    if (hole != null) {
      // []を外す
      final origin =
          originalWithBracket.substring(1, originalWithBracket.length - 1);

      result.add(
        IndexData(
          index: hole.index,
          button: hole.button,
          score: hole.score,
          origin: origin,
          tokenList: makinglist(origin),
        ),
      );
    }

    currentIndex++;
  }

  return result;
}

class QuizStateProvider extends ChangeNotifier {
  List<String> quizinfo = [];

  void setValues({required List<String> quizinfo}) {
    this.quizinfo = quizinfo;
    notifyListeners();
  }
}

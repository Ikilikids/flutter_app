import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:math_quiz/math_quiz.dart';

class ChooseQuizData {
  final Map<String, List<Map<String, String>>> scoreIndexMap;
  int correctCount;
  final QuizData quizinfo;

  ChooseQuizData({
    required this.scoreIndexMap,
    required this.correctCount,
    required this.quizinfo,
  });

  // スコア範囲から素早く選ぶ
  Map<String, String> chooseRandombyScoreRange(BuildContext context) {
    final chosedData = quizinfo.chosedData;
    List<int> scoreRange = getScoreRange(correctCount, quizinfo.sort);
    int minScore = scoreRange[0];
    int maxScore = scoreRange[1];
    // スコア範囲を使わず、全データを候補にする
    List<Map<String, String>> candidates = [];
    if (quizinfo.isbattle == false) {
      for (var list in scoreIndexMap.values) {
        candidates.addAll(list);
      }
    } else {
      for (int score = minScore; score <= maxScore; score++)
      //for (int score = 1; score <= 3; score++)
      {
        var key = score.toString();
        if (scoreIndexMap.containsKey(key)) {
          candidates.addAll(scoreIndexMap[key]!);
        }
      }
    }

    if (candidates.isEmpty) {
      throw Exception("候補データが存在しません");
    }

    final originalCandidates = [...candidates];
    List<Map<String, String>> filtered = [];

    const maxTry = 100;
    for (int i = 0; i < maxTry && filtered.isEmpty; i++) {
      final chosed = chosedData![Random().nextInt(chosedData.length)];
      /*filtered = originalCandidates
          .where((e) => e['fi3']!.contains("対数の不等式"))
          .toList();*/
      filtered = originalCandidates
          .where((e) =>
              e['fi3'] == chosed["sub"] &&
              e['fi2'] == chosed["main"] &&
              e['fi1'] == chosed["123abc"])
          .toList();
    }

    return filtered[Random().nextInt(filtered.length)];
  }
}

class MakingDeta {
  Map<String, dynamic> calculatedresult;
  final VoidCallback? onError;
  MakingDeta({
    required this.calculatedresult,
    this.onError,
  });
  Map<String, dynamic> deta() {
    Map<String, dynamic> result = {};
    int y = calculatedresult["all1"].split('[').length - 1;
    List<int> indexs = calculatedresult["index"];
    List<int> unindexs = [];
    for (int i = 0; i < y; i++) {
      if (!indexs.contains(i)) {
        unindexs.add(i);
      }
    }
    List<String> button2 = [];
    List<String> button = [
      calculatedresult["button1"],
      calculatedresult["button2"],
      calculatedresult["button3"],
      calculatedresult["button4"],
    ];

    for (int i = 0; i < indexs.length; i++) {
      button2.add(button[indexs[i]]);
    }
    result["button"] = button2;
    List<String> origin1 = extractRandomAndModify(
      calculatedresult["all1"],
      indexs,
      unindexs,
      button,
      onProblemDetected: onError,
    );
    result["latex"] = origin1[0];

    List<String> alist1 = makinglist(origin1[1]);
    List<String> alist2 = makinglist(origin1[2]);
    List<String> alist3 = makinglist(origin1[3]);
    List<String> alist4 = makinglist(origin1[4]);
    result["alist"] = [alist1, alist2, alist3, alist4];
// 🔽 all2が存在する場合のみblistをつくる
    if (calculatedresult["all2"] != null) {
      List<String> origin2 = extractRandomAndModify(
        calculatedresult["all2"],
        indexs,
        unindexs,
        button,
        onProblemDetected: onError,
      );

      List<String> blist1 = makinglist(origin2[1]);
      List<String> blist2 = makinglist(origin2[2]);
      List<String> blist3 = makinglist(origin2[3]);
      List<String> blist4 = makinglist(origin2[4]);
      bool allMatch = true;
      if (origin1.length > 5 && origin2.length > 5) {
        for (int i = 5; i < origin1.length && i < origin2.length; i++) {
          if (origin1[i] != origin2[i]) {
            allMatch = false;
            break;
          }
        }
      }
      if (allMatch) {
        result["blist"] = [blist1, blist2, blist3, blist4];
      }
    }

    return result;
  }

  List<String> extractRandomAndModify(
    String input,
    List<int> indexs,
    List<int> unindexs,
    List<String> button, {
    VoidCallback? onProblemDetected,
  }) {
    // 正規表現で括弧内の部分を抽出
    input = input.replaceAll("][", "]-space-[");
    RegExp regExp = RegExp(r'\[[^\]]*\]');
    Iterable<Match> matches = regExp.allMatches(input);

// マッチした部分をextractedリストに格納
    List<String> extracted = matches.map((match) => match.group(0)!).toList();

// []で囲まれていない部分（unextracted）を抽出
    List<String> unextracted = [];
    int lastIndex = 0;

// 最初に[]で囲まれていない部分があれば'n'を追加
    if (matches.isEmpty || matches.first.start == 0) {
      unextracted.add('-space-'); // 最初に囲まれていない部分があれば'n'を追加
    }

    for (var match in matches) {
      // []で囲まれていない部分をunextractedに追加
      if (match.start > lastIndex) {
        unextracted.add(input.substring(lastIndex, match.start));
      }
      lastIndex = match.end;
    }

// 残りの文字列（最後の[]以降）をunextractedに追加
    if (lastIndex < input.length) {
      unextracted.add(input.substring(lastIndex));
    } else {
      // 最後に[]以降に文字がない場合でも'n'を追加
      unextracted.add('-space-');
    }

    // extractedから新しいリストnewextractedを作成、選ばれた部分のみを◯に変換
    List<String> exextracted = [];
    List<String> newextracted = List.from(extracted);

// ランダムに選ばれたインデックスに対して、newextracted を変更する
    for (int i = 0; i < indexs.length; i++) {
      if (newextracted[indexs[i]] == r"[\cos]" ||
          newextracted[indexs[i]] == r"[\sin]" ||
          newextracted[indexs[i]] == r"[\tan]" ||
          newextracted[indexs[i]] == r"[\log]") {
        newextracted[indexs[i]] = '□';
      } else if ((newextracted[indexs[i]] == "[-]" ||
              newextracted[indexs[i]] == "[+]") &&
          button[indexs[i]] == "[+-]") {
        newextracted[indexs[i]] = '☆';
      } else {
        newextracted[indexs[i]] = '◯';
      } // ◯に変更

      exextracted.add(extracted[indexs[i]]); // exextracted に元の値を追加（◯を置き換える前のもの）
    }

    // unextractedとnewextractedを組み合わせて最終的な文字列を作成
    String finalString = '';
    int extractedIndex = 0;
    for (int i = 0; i < unextracted.length; i++) {
      finalString += unextracted[i];
      if (extractedIndex < newextracted.length) {
        finalString += newextracted[extractedIndex];
        extractedIndex++;
      }
    }
    finalString = finalString.replaceAll("-space-", "");
    finalString = finalString.replaceAll("[", "");
    finalString = finalString.replaceAll("]", "");
    int p = 4 - indexs.length;

    // 結果のリストを返す
    List<String> result = [];
    result.add(finalString);
    result.addAll(exextracted);
    for (int i = 0; i < p; i++) {
      result.add("[n]");
    }
    for (int i = 0; i < unindexs.length; i++) {
      result.add(extracted[unindexs[i]]);
    }

    return result;
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
}

class QuizStateProvider extends ChangeNotifier {
  List<String> quizinfo = [];

  void setValues({
    required List<String> quizinfo,
  }) {
    this.quizinfo = quizinfo;
    notifyListeners();
  }
}

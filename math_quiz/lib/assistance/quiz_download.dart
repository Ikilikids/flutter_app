import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizProvider extends ChangeNotifier {
  List<Map<String, String>> quizData = [];
  Map<String, List<Map<String, String>>> scoreIndexMap = {};

  QuizProvider();

  Future<void> initAll() async {
    await loadQuiz();
    await setQuizData();
    await buildScoreIndex();
    notifyListeners();
  }

  Future<void> loadQuiz() async {
    final csvString = await rootBundle.loadString("assets/csv/quizdata.csv");
    final rows = const CsvToListConverter().convert(csvString);

    quizData.clear();
    for (var row in rows) {
      if (row.length < 17) continue;
      quizData.add({
        "lc": row[0].toString(),
        "st1": row[1].toString(),
        "st2": row[2].toString(),
        "st3": row[3].toString(),
        "dt": row[4].toString(),
        "fi1": row[5].toString(),
        "fi2": row[6].toString(),
        "fi3": row[7].toString(),
        "fb": row[8].toString(),
        "b1": row[9].toString(),
        "b2": row[10].toString(),
        "b3": row[11].toString(),
        "b4": row[12].toString(),
        "scoreA": row[13].toString(),
        "scoreB": row[14].toString(),
        "scoreC": row[15].toString(),
        "scoreD": row[16].toString(),
      });
    }
  }

  Future<void> setQuizData() async {
    const keys = ["A", "B", "C", "D"];
    for (var map in quizData) {
      List<String?> scores = [
        map["scoreA"],
        map["scoreB"],
        map["scoreC"],
        map["scoreD"]
      ];
      List<int> validIndices = [
        for (int i = 0; i < 4; i++)
          if (scores[i]?.isNotEmpty ?? false) i
      ];
      Set<int> aIndices = {
        for (int i in validIndices)
          if (scores[i]!.contains("a")) i
      };
      Set<int> bIndices = {
        for (int i in validIndices)
          if (scores[i]!.contains("b")) i
      };

      int parseScore(int i) =>
          int.parse(scores[i]!.replaceAll(RegExp(r"[ab]"), ""));

      int n = validIndices.length;
      for (int mask = 1; mask < (1 << n); mask++) {
        Set<int> subset = {
          for (int j = 0; j < n; j++)
            if ((mask & (1 << j)) != 0) validIndices[j]
        };
        if (!subset.containsAll(aIndices)) continue;
        if (bIndices.isNotEmpty) {
          bool containsB = subset.any((i) => bIndices.contains(i));
          if (containsB && !bIndices.every((i) => subset.contains(i))) continue;
        }
        int total = subset.fold(0, (summ, i) => summ + parseScore(i));
        String keyStr = subset.map((i) => keys[i]).toList().join();
        map["score$keyStr"] = total.toString();
      }
    }
  }

  Future<void> buildScoreIndex() async {
    scoreIndexMap.clear();
    for (var q in quizData) {
      for (var entry in q.entries) {
        if (entry.key.startsWith("score")) {
          int? score = int.tryParse(entry.value);
          if (score != null) {
            scoreIndexMap.putIfAbsent(score.toString(), () => []).add({
              ...q,
              "usedScore": entry.key,
              "usedScoreValue": entry.value,
            });
          }
        }
      }
    }
  }
}

class ChoseProvider extends ChangeNotifier {
  List<Map<String, String>> quizData = [];

  Future<void> initAll() async {
    await loadQuiz();
    notifyListeners();
  }

  Future<void> loadQuiz() async {
    final csvString = await rootBundle.loadString("assets/csv/choosesort.csv");
    final rows = const CsvToListConverter().convert(csvString);

    quizData.clear();
    for (var row in rows) {
      if (row.length < 3) continue;
      quizData.add({
        "123abc": row[0].toString(),
        "main": row[1].toString(),
        "sub": row[2].toString(),
      });
    }
  }
}

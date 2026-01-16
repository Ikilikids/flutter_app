import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/assistance/makingdata.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/common_widget.dart';

class ExampleScreen extends StatefulWidget {
  final String st1;
  final String st2;
  final String st3;

  const ExampleScreen({
    super.key,
    required this.st1,
    required this.st2,
    required this.st3,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  bool _isLoaded = false;

  List<Map<String, String>> quizData = [];
  List<Map<String, String>> quizData2 = [];
  List<Map<String, String>> chosedData = [];
  Map<String, List<Map<String, String>>> scoreIndexMap = {};
  Map<String, dynamic> numberData = {};
  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    await loadCsvFile("assets/csv/quizdata.csv");
    await setQuizData(quizData);

    if (mounted) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  Future<void> loadCsvFile(String fileName) async {
    final csvString = await rootBundle.loadString(fileName);
    final csvString2 = await rootBundle.loadString("assets/csv/choosesort.csv");
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);
    quizData = [];
    List<List<dynamic>> choseds =
        const CsvToListConverter().convert(csvString2);

    if (rows.isNotEmpty) {
      for (var row in rows) {
        if (row.length < 13) continue; // 行の要素数チェック（scoreは21番目）

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
    if (choseds.isNotEmpty) {
      for (var chosed in choseds) {
        {
          if ((widget.st1.contains(chosed[0].toString()) ||
                  chosed[0].toString().contains(widget.st1)) &&
              chosed[1].toString().contains(widget.st2) &&
              chosed[2].toString() == (widget.st3)) {
            chosedData.add(
              {
                "123abc": chosed[0].toString(),
                "main": chosed[1].toString(),
                "sub": chosed[2].toString(),
              },
            );
          }
        }
      }
    }
  }

  Future<void> setQuizData(List<Map<String, String>> data) async {
    const keys = ["A", "B", "C", "D"];

    for (var map in data) {
      // 元スコア取得
      List<String?> scores = [
        map["scoreA"],
        map["scoreB"],
        map["scoreC"],
        map["scoreD"]
      ];

      // 空でないスコアのインデックスだけ
      List<int> validIndices = [
        for (int i = 0; i < 4; i++)
          if (scores[i]?.isNotEmpty ?? false) i
      ];

      // a/b フラグ
      Set<int> aIndices = {
        for (int i in validIndices)
          if (scores[i]!.contains("a")) i
      };
      Set<int> bIndices = {
        for (int i in validIndices)
          if (scores[i]!.contains("b")) i
      };

      // 安全にスコアを整数化
      int parseScore(int i) =>
          int.parse(scores[i]!.replaceAll(RegExp(r"[ab]"), ""));

      // 全組み合わせ（subset）の生成
      int n = validIndices.length;
      for (int mask = 1; mask < (1 << n); mask++) {
        Set<int> subset = {
          for (int j = 0; j < n; j++)
            if ((mask & (1 << j)) != 0) validIndices[j]
        };

        // aIndices 条件
        if (!subset.containsAll(aIndices)) continue;

        // bIndices 条件
        if (bIndices.isNotEmpty) {
          bool containsB = subset.any((i) => bIndices.contains(i));
          if (containsB && !bIndices.every((i) => subset.contains(i))) continue;
        }

        // スコア計算
        int total = subset.fold(0, (sum, i) => sum + parseScore(i));

        // キー文字列生成
        String keyStr = subset.map((i) => keys[i]).toList().join();
        map["score$keyStr"] = total.toString();
      }
    }

    quizData2 = data;
    _buildScoreIndex();
  }

  // スコア別に分類
  void _buildScoreIndex() {
    scoreIndexMap.clear();

    for (var q in quizData2) {
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !_isLoaded
          ? const CircularProgressIndicator()
          : NtQuizscreen(
              quizData: scoreIndexMap,
              numberData: numberData,
              chosedData: chosedData,
              st1: widget.st1,
              st2: widget.st2,
              st3: widget.st3),
    );
  }
}

class NtQuizscreen extends StatefulWidget {
  final Map<String, List<Map<String, String>>> quizData; // quizDataを受け取る
  final Map<String, dynamic> numberData;
  final List<Map<String, String>> chosedData;
  final String st1;
  final String st2;
  final String st3;

  const NtQuizscreen({
    super.key,
    required this.quizData,
    required this.numberData,
    required this.chosedData,
    required this.st1,
    required this.st2,
    required this.st3,
  }); // コンストラクタで受け取る

  @override
  QuizScreenState createState() => QuizScreenState();
}

class ChooseQuizData {
  final Map<String, List<Map<String, String>>> scoreIndexMap;
  int correctCount;
  final List<Map<String, String>> chosedData;

  ChooseQuizData(
      {required this.scoreIndexMap,
      required this.correctCount,
      required this.chosedData});

  // スコア範囲から素早く選ぶ
  Map<String, String> chooseRandombyScoreRange() {
    // スコア範囲を使わず、全データを候補にする
    List<Map<String, String>> candidates = [];
    for (var list in scoreIndexMap.values) {
      candidates.addAll(list);
    }

    if (candidates.isEmpty) {
      throw Exception("候補データが存在しません");
    }

    final originalCandidates = [...candidates];
    List<Map<String, String>> filtered = [];

    const maxTry = 100;
    for (int i = 0; i < maxTry && filtered.isEmpty; i++) {
      final chosed = chosedData[Random().nextInt(chosedData.length)];
      filtered = originalCandidates
          .where((e) =>
              e['fi3'] == chosed["sub"] &&
              e['fi2'] == chosed["main"] &&
              e['fi1'] == chosed["123abc"])
          .toList();
    }

    if (filtered.isEmpty) {
      // フィルタ条件で見つからない場合は全候補から選択
      filtered = originalCandidates;
    }

    return filtered[Random().nextInt(filtered.length)];
  }
}

class MakingDeta {
  Map<String, dynamic> calculatedresult;
  MakingDeta({
    required this.calculatedresult,
  });
  Map<String, dynamic> deta() {
    return calculatedresult;
  }
}

class QuizScreenState extends State<NtQuizscreen> {
  Map<String, dynamic> P = {};
  int correctCount = 0; // 正解数

  late SoundManager soundManager;
  // LateXInputScreenのキーを作成

  @override
  void initState() {
    super.initState();
    updateQuestion();
  }

  // 次の問題に移行する際にLatexInputScreenもリセット
  void updateQuestion() async {
    ChooseQuizData chooseQuizData = ChooseQuizData(
        scoreIndexMap: widget.quizData,
        correctCount: correctCount,
        chosedData: widget.chosedData);
    Map<String, String> ct = chooseQuizData.chooseRandombyScoreRange();
    Map<String, dynamic> numberData = widget.numberData;
    OriginCentral originCentral = OriginCentral(ct: ct, numberData: numberData);
    Map<String, dynamic> variable = originCentral.makingvariable();
    MakingDeta makingDeta = MakingDeta(
      calculatedresult: variable,
    );
    Map<String, dynamic> endResult = makingDeta.deta();

    variable.addAll(endResult);
    P = variable;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = buildChildWidget(context, P);

    // Scaffold を削除
    return widget.quizData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : childWidget;
  }
}

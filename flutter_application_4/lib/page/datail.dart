import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/firebase_score.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/assistance/latex_to_latex2.dart';
import 'package:flutter_application_4/page/commmon_quiz.dart';
import 'package:flutter_application_4/page/common_widget.dart';
import 'package:flutter_application_4/page/example.dart';
import 'package:flutter_application_4/page/firstpage.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'choose123abc.dart';
import 'countdown_screen.dart';

class DetailCard extends StatefulWidget {
  final String title;
  const DetailCard({super.key, required this.title});

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  Map<String, int> _highScores = {};
  bool _loading = true;
  String title = "";
  bool j = true;
  @override
  void initState() {
    super.initState();
    title = widget.title;
    j = title == "jissen";
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    Map<String, int> scores = {};

    // subjects から全問題名を収集
    List<String> allProblems = [];
    for (var subject in subjects) {
      allProblems.add(subject[2]);
    }

    // 全問題のスコアを Future リストで作成
    final futures = allProblems.map(
      (problem) async {
        final score = j
            ? await HighScoreManager.getHighScore(problem, true)
            : await HighScoreManager.getHighScore(problem, false);
        return MapEntry(problem, score);
      },
    ).toList();

    // 並列実行して結果取得
    final results = await Future.wait(futures);

    // Map に変換
    for (var entry in results) {
      scores[entry.key] = entry.value;
    }

    if (mounted) {
      setState(
        () {
          _highScores = scores;
          _loading = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    QuizStateProvider quizState =
        Provider.of<QuizStateProvider>(context, listen: false);
    final List<List<String>> subjectSchedule = j
        ? subjects
            .where((s) => s[0].length > 1 && s[2] != "全合計")
            .map((s) => [s[0], s[1], s[2], s[3]])
            .toList()
        : subjects
            .where((s) => s[0] == title)
            .map((s) => [s[0], s[1], s[2], s[3]])
            .toList();

    final double cardHeight = MediaQuery.of(context).size.height / 5;

    return PopScope(
        canPop: false, // 条件に応じて true/false
        child: AdScaffold(
          appBar: AppBar(
            title: j
                ? Row(children: [
                    Icon(
                      Icons.local_fire_department,
                    ),
                    SizedBox(width: 4),
                    Text("実践モード")
                  ])
                : Row(children: [
                    Icon(
                      Icons.school,
                    ),
                    SizedBox(width: 4),
                    Text("練習モード (数${getSubjectFromSymbol(title)}) ")
                  ]),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => j ? FirstPage() : Choose123abc()),
                );
              },
            ),
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: subjectSchedule.length,
                  itemBuilder: (context, index) {
                    final item = subjectSchedule[index];
                    final abc = item[0];
                    final category = item[1];
                    final subTitle = item[2];
                    final detail = item[3];
                    final score = _highScores[subTitle] ?? 0;

                    List<String> parts = j ? abc.split("") : title.split("");
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: cardHeight,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: bgColor1(context),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: buildCircleDecoration(
                                              parts, title, context),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Icon(
                                                getIconForCategory(category),
                                                size: 100,
                                                color: bgColor1(context),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start, // 左寄せ
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: FittedBox(
                                                child: Text(
                                                  subTitle,
                                                  style: TextStyle(
                                                      fontSize: 100,
                                                      color:
                                                          textColor1(context)),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: FittedBox(
                                                child: Text(
                                                  category,
                                                  style: TextStyle(
                                                      fontSize: 100,
                                                      color:
                                                          textColor2(context)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 1, child: SizedBox()),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start, // 左寄せ
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: FittedBox(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle_outlined,
                                                      size: 100, // 好きな大きさ
                                                      color: getQuizColor2(
                                                          title,
                                                          context,
                                                          1,
                                                          0.35,
                                                          0.95), // 必要なら色
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Math.tex(
                                                      detail,
                                                      textStyle: TextStyle(
                                                          fontSize: 100,
                                                          color: textColor1(
                                                              context)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                      vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: FittedBox(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsGeometry.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  j
                                                      ? Icons.emoji_events
                                                      : Icons.check_circle,
                                                  color: getQuizColor2(abc,
                                                      context, 1, 0.35, 0.95),
                                                  size: 100,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "$score",
                                                  style: TextStyle(
                                                      fontSize: 100,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          textColor1(context)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsGeometry.symmetric(
                                            horizontal: 6,
                                          ),
                                          child: j
                                              ? FittedBox(
                                                  child: Padding(
                                                    padding: EdgeInsetsGeometry
                                                        .symmetric(
                                                      vertical: 12,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "🎖",
                                                          style: TextStyle(
                                                            fontSize: 100,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        getRankIconAndImage(
                                                            getRank(score, abc),
                                                            100),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title:
                                                              const Text("例題"),
                                                          content: SizedBox(
                                                            width: min(
                                                                    screenWidth,
                                                                    screenHeight) *
                                                                0.6,
                                                            height: min(
                                                                    screenWidth,
                                                                    screenHeight) *
                                                                0.6,
                                                            child:
                                                                ExampleScreen(
                                                              st1: abc,
                                                              st2: category,
                                                              st3: subTitle,
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "閉じる"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    minimumSize: const Size(
                                                      double.infinity,
                                                      double.infinity,
                                                    ), // 幅・高さ
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    foregroundColor:
                                                        getQuizColor2(
                                                            title,
                                                            context,
                                                            1,
                                                            0.55,
                                                            0.95), // 文字色
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        3,
                                                      ), // 角丸ボタン
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsetsGeometry
                                                        .symmetric(
                                                      vertical: 12,
                                                    ),
                                                    child: FittedBox(
                                                      child: Text(
                                                        "例題",
                                                        style: TextStyle(
                                                            fontSize: 100),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsGeometry.symmetric(
                                            horizontal: 6,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // クリックしたカードの値だけセット
                                              quizState.setValues(
                                                quizinfo: [
                                                  abc,
                                                  category,
                                                  subTitle,
                                                  j ? "time" : "notime"
                                                ],
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CountdownScreen(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 1,
                                              minimumSize: const Size(
                                                double.infinity,
                                                double.infinity,
                                              ), // 幅・高さ
                                              backgroundColor: getQuizColor2(
                                                  abc, context, 1, 0.55, 0.95),
                                              foregroundColor:
                                                  bgColor1(context), // 文字色
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  3,
                                                ), // 角丸ボタン
                                              ),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                "スタート",
                                                style: TextStyle(
                                                  fontSize: 100,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}

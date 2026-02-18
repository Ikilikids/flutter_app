import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math_quiz/math_quiz.dart';

/// Pを受け取ってウィジェットを返す関数
Widget buildChildWidget(BuildContext context, Map<String, dynamic> P) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  // 図のとき
  if (["sekimen", "pointlined", "cyebamene", "triangle"].contains(P["st1"])) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        switch (P["st1"]) {
          case "sekimen":
            final origin = OriginSekibunMenseki(deta: P);
            return KaigaSekibunMenseki(
                origin: origin, width: width, height: height);
          case "pointlined":
            final origin = OriginPointlined(deta: P);
            return KaigaPointlined(
                origin: origin, width: width, height: height);
          case "cyebamene":
            return CevaDemo(deta: P, width: width, height: height);
          case "triangle":
            return Triangle(deta: P, width: width, height: height);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  } else {
    // else の時は今まで通り
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark
              ? getQuizColor2(P["fi1"], context, 0.6, 0.4, 0.65)
              : getQuizColor2(P["fi1"], context, 0.6, 0.4, 0.95),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var key in [
                "question1",
                "question2",
                "question3",
                "question4"
              ])
                if ((P[key] ?? "").isNotEmpty) ...[
                  if (key != "question1") const SizedBox(height: 5),
                  Math.tex(
                    P[key]!,
                    textStyle:
                        TextStyle(fontSize: 30, color: textColor1(context)),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 丸ボタン＋テキスト共通部品

Widget quizInfo(BuildContext context, Map<String, dynamic> P) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  int sumscore = int.parse(P["usedScoreValue"]);
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              alignment: const Alignment(0, 0),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isDark
                    ? getQuizColor2(P["fi1"], context, 0.6, 0.4, 0.65)
                    : getQuizColor2(P["fi1"], context, 0.6, 0.4, 0.95),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '${P["fi2"]}',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: textColor1(context)),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              alignment: const Alignment(0, 0),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(99, 111, 111, 111),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '${P["fi3"]}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor1(context),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              alignment: const Alignment(0, 0),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: bgColor1(context).withAlpha(128), // 0〜255 の範囲、128は約50%
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '★' * sumscore,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor1(context),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget increasewidget(String scoreIncrement1, String scoreIncrement2) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              scoreIncrement2,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 128, 255),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              scoreIncrement1,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 0, 0),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget marupekelist(BuildContext context, List<String> marks) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  Widget buildRow(List<String> rowMarks, int offset) {
    return Expanded(
      child: Row(
        children: List.generate(rowMarks.length, (index) {
          final mark = rowMarks[index];

          return Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: mark == "◯"
                        ? Image.asset(
                            isDark
                                ? 'assets/images/circle_dark.png'
                                : 'assets/images/circle.png',
                            fit: BoxFit.contain,
                          )
                        : mark == "×"
                            ? Image.asset(
                                isDark
                                    ? 'assets/images/cross_dark.png'
                                    : 'assets/images/cross.png',
                                fit: BoxFit.contain,
                              )
                            : null,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  if (marks.length <= 5) {
    // 5問以下 → 1行
    return Row(
      children: List.generate(marks.length, (index) {
        return Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("${index + 1}問目"),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: marks[index] == "◯"
                      ? Image.asset(
                          isDark
                              ? 'assets/images/circle_dark.png'
                              : 'assets/images/circle.png',
                        )
                      : marks[index] == "×"
                          ? Image.asset(
                              isDark
                                  ? 'assets/images/cross_dark.png'
                                  : 'assets/images/cross.png',
                            )
                          : null,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // 6問以上 → 2段
  final upper = marks.take(5).toList();
  final lower = marks.skip(5).toList();

  return Column(
    children: [
      buildRow(upper, 0),
      buildRow(lower, 5),
    ],
  );
}

import 'package:common/widgets/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Pを受け取ってウィジェットを返す関数
Widget buildChildWidget(BuildContext context, Map<String, dynamic> P) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  // 図のとき

  // else の時は今まで通り
  return Center(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? getQuizColor2(P["fi1"], context, 0.8, 0.4, 0.65)
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
                      TextStyle(fontSize: 40, color: textColor1(context)),
                ),
              ],
          ],
        ),
      ),
    ),
  );
}

Widget quizInfo(BuildContext context, Map<String, dynamic> P) {
  int sumscore = int.parse(P["usedScoreValue"]);
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              alignment: Alignment(0, 0),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: getQuizColor2(P["fi1"], context, 0.6, 0.4, 0.95),
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
              alignment: Alignment(0, 0),
              padding: EdgeInsets.all(2),
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
              alignment: Alignment(0, 0),
              padding: EdgeInsets.all(2),
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

Widget pointwidget(int correctCount, BuildContext context) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromARGB(255, 215, 121, 54)
                        : Colors.orangeAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                  ),
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '正解数',
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: textColor1(context),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container())
            ])),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark
                    ? const Color.fromARGB(255, 215, 121, 54)
                    : Colors.orangeAccent,
                width: 2,
              ),
              color: bgColor1(context),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6)),
            ),
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: Text(
                '$correctCount',
                style: TextStyle(
                  fontSize: 100,
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

Widget timewidget(
    String sort, double remainingTime, num totalScore, BuildContext context) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  int changeCount = sort == "56" ? 8 : 16;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromARGB(255, 215, 121, 54)
                        : Colors.orangeAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                  ),
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'タイム',
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: textColor1(context),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container())
            ])),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark
                    ? const Color.fromARGB(255, 215, 121, 54)
                    : Colors.orangeAccent,
                width: 2,
              ),
              color: bgColor1(context),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6)),
            ),
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: Text(
                totalScore < changeCount
                    ? remainingTime.toStringAsFixed(2)
                    : "??",
                style: TextStyle(
                  fontSize: 100,
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
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              scoreIncrement2,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 128, 255),
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
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 0, 0),
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
  return Row(
    children: List.generate(marks.length, (index) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${index + 1}問目",
                  style: TextStyle(fontSize: 12),
                ),
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
                        fit: BoxFit.contain,
                      )
                    : marks[index] == "×"
                        ? Image.asset(
                            isDark
                                ? 'assets/images/cross_dark.png'
                                : 'assets/images/cross.png',
                            fit: BoxFit.contain,
                          )
                        : null, // 空の場合は何も表示しない
              ),
            ),
          ],
        ),
      );
    }),
  );
}

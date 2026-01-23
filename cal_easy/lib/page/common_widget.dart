import 'package:common/common.dart';
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

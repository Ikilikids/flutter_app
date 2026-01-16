import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/figure/point_line_d.dart';
import 'package:flutter_application_4/figure/sekibun_menseiki.dart';
import 'package:flutter_application_4/figure/triangle.dart';
import 'package:flutter_application_4/figure/tyebamene.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/countdown_screen.dart';
import 'package:flutter_application_4/page/datail.dart';
import 'package:flutter_math_fork/flutter_math.dart';

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

Future<void> showMenuDialog(
  BuildContext context,
  List<dynamic> quizinfo,
  VoidCallback onSetGameOver,
) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("メニュー"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MenuButton(
              icon: Icons.close,
              label: "キャンセル",
              onPressed: () => Navigator.of(context).pop(false),
            ),
            _MenuButton(
              icon: Icons.refresh,
              label: "やり直し",
              onPressed: () {
                onSetGameOver(); // ← 呼び出し元のisGameOverを変更できる
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdInterstitialNavigator(
                      nextScreen: CountdownScreen(),
                    ),
                  ),
                );
              },
            ),
            _MenuButton(
              icon: Icons.home,
              label: "ホームへ",
              onPressed: () {
                onSetGameOver();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdInterstitialNavigator(
                      nextScreen: quizinfo[3] == "time"
                          ? DetailCard(title: "jissen")
                          : DetailCard(title: quizinfo[0]),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}

/// 丸ボタン＋テキスト共通部品
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

Widget menuButton(
  BuildContext context,
  List<dynamic> quizinfo,
  VoidCallback onSetGameOver,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 5, right: 5),
    child: FittedBox(
      fit: BoxFit.contain,
      child: ElevatedButton(
        onPressed: () async {
          await showMenuDialog(context, quizinfo, onSetGameOver);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor1(context), // 0〜255 の範囲、128は約50%,
          elevation: 0, // 影をなくす
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 角丸
          ),
          fixedSize: const Size(60, 60), // ← 正方形に固定
          padding: EdgeInsets.all(8),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Icon(Icons.menu, size: 40, color: textColor2(context)),
        ),
      ),
    ),
  );
}

Widget quizInfo(BuildContext context, Map<String, dynamic> P) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
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

Widget pointwidget(int remainingTime, int totalScore, BuildContext context) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.only(left: 10),
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
                      'Point',
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
                remainingTime > 30 ? '$totalScore' : "??",
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

List<Color> getSweepColors(BuildContext context) {
  final List<String> labels = [
    "1",
    "1",
    "A",
    "A",
    "2",
    "2",
    "B",
    "B",
    "3",
    "3",
    "C",
    "C"
  ];
  return labels
      .map((label) => getQuizColor2(label, context, 1, 0.35, 0.95))
      .toList();
}

List<double> sweepStops = [
  0.0,
  0.166,
  0.166,
  0.333,
  0.333,
  0.5,
  0.5,
  0.666,
  0.666,
  0.833,
  0.833,
  1.0
];
BoxDecoration buildCircleDecoration(
    List<String> parts, String title, BuildContext context) {
  if (parts.length == 6) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: SweepGradient(
        startAngle: 0,
        endAngle: 6.28,
        colors: getSweepColors(context),
        stops: sweepStops,
      ),
    );
  } else if (parts.length == 2) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors:
            parts.map((p) => getQuizColor2(p, context, 1, 0.35, 0.95)).toList(),
        stops: [0.5, 0.5],
      ),
    );
  } else {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: getQuizColor2(title, context, 1, 0.35, 0.95),
    );
  }
}

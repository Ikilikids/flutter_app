import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

import '../math_quiz.dart';

// These typedefs are local to this file for now.

class NtEndScreen extends StatefulWidget {
  final int correctCount;
  final List<Map<String, dynamic>> P;
  final QuizData quizinfo;
  const NtEndScreen(
      {super.key,
      required this.correctCount,
      required this.P,
      required this.quizinfo});

  @override
  // ignore: library_private_types_in_public_api
  _NtEndScreenState createState() => _NtEndScreenState();
}

class _NtEndScreenState extends State<NtEndScreen> {
  int step = 0; // 0:正解数 1:最高記録 2:ランキング
  late SoundManager soundManager; // main.dart にある SoundManager を使用
  late QuizData _quizinfo;

  @override
  void initState() {
    super.initState();
    soundManager = Provider.of<SoundManager>(context, listen: false);
    _quizinfo = widget.quizinfo;
    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 800));
    soundManager.playSound('pipi.mp3'); // main.dart の soundManager を使用
    if (!mounted) return;
    setState(() => step = 1);
  }

  @override
  Widget build(BuildContext context) {
    Color quizColor = getQuizColor2(_quizinfo.color, context, 1, 0.35, 0.95);
    String unit = _quizinfo.unit;
    int fix = _quizinfo.fix;
    return PopScope(
      canPop: false,
      child: AppAdScaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _QuizNameSection(
                    quizName: _quizinfo.label,
                    backgroundColor: quizColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 3,
                  child: _ScoreSection(
                    score: step >= 1 ? widget.correctCount : null,
                    borderColor: quizColor,
                    fix: fix,
                    unit: unit,
                  ),
                ),
                SizedBox(
                  height: 420,
                  child: _RankSection(
                    P: widget.P,
                    quizinfo: _quizinfo,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ActionSection(
                    backgroundColor: quizColor,
                    isLimitedMode: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizNameSection extends StatelessWidget {
  final String quizName;
  final Color backgroundColor;

  const _QuizNameSection({
    required this.quizName,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 4),
                    color: Color.fromARGB(22, 0, 0, 0),
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '★$quizName★',
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

class _ScoreSection extends StatelessWidget {
  final num? score;
  final Color borderColor;
  final int fix;
  final String unit;

  const _ScoreSection({
    required this.score,
    required this.borderColor,
    required this.fix,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: FittedBox(
                  child: Text(
                    '正解数',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor1(context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor2(context),
                  border: Border.all(color: borderColor, width: 3),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        score == null ? " " : score!.toStringAsFixed(fix),
                        style: TextStyle(
                          fontSize: 1000,
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 400,
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankSection extends StatelessWidget {
  final List<Map<String, dynamic>> P;
  final QuizData quizinfo;

  const _RankSection({
    required this.P,
    required this.quizinfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(2),
        height: 410,
        width: double.infinity,
        child: DefaultTabController(
          length: min(P.length, 10), // P の長さに応じてタブ数調整
          child: Column(
            children: [
              TabBar(
                isScrollable: P.length > 5,
                labelPadding: EdgeInsets.zero,
                tabs: List.generate(
                  min(P.length, 10),
                  (index) {
                    String isCorrect = P[index]["marks"] ?? "×";
                    return SizedBox(
                        width: P.length > 5 ? 80 : null, // ★ ここで制御
                        height: 40,
                        child: Tab(
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('問題${index + 1}'),
                              isCorrect == "◯"
                                  ? Image.asset(
                                      'assets/images/circle.png',
                                      height: 20,
                                    )
                                  : isCorrect == "×"
                                      ? Image.asset(
                                          'assets/images/cross.png',
                                          height: 20,
                                        )
                                      : Container(),
                            ],
                          ),
                        ));
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: List.generate(
                    min(P.length, 10),
                    (index) => Column(
                      children: [
                        SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: buildChildWidget(context, P[index])),
                        Container(
                          height: 120,
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: getQuizColor2(
                                quizinfo.color, context, 0.4, 0.2, 0.95),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown, // 親に収める
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                parts(P[index]["all1"], P[index]["unindex"])
                                    .length,
                                (index2) => Column(
                                  children: [
                                    if (parts(P[index]["all1"],
                                            P[index]["unindex"])[index2]
                                        .trim()
                                        .isNotEmpty)
                                      Math.tex(
                                        parts(P[index]["all1"],
                                            P[index]["unindex"])[index2],
                                        textStyle: TextStyle(
                                            fontSize: min(30, 30),
                                            color: textColor1(context)),
                                      ),
                                    if (index2 <
                                        parts(P[index]["all1"],
                                                    P[index]["unindex"])
                                                .length -
                                            1)
                                      SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  final Color backgroundColor;
  final bool isLimitedMode;

  const _ActionSection({
    required this.backgroundColor,
    required this.isLimitedMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionItem(
            backgroundColor: backgroundColor,
            icon: Icons.refresh,
            label: 'もう一度',
            onTap: isLimitedMode
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdInterstitialNavigator(
                          nextScreen: CommonCountdownScreen(),
                        ),
                      ),
                    );
                  },
          ),
          _ActionItem(
            backgroundColor: backgroundColor,
            icon: Icons.home,
            label: 'メニュー',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AdInterstitialNavigator(
                    nextScreen: CommonDetailCard(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 1,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  disabledBackgroundColor: Theme.of(context).disabledColor,
                  disabledForegroundColor: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withAlpha(128),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(icon, color: textColor1(context), size: 100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 100,
                      color: textColor1(context)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> parts(String P, List<int> unindex) {
  P = removeBracketsFromElements(P, unindex);
  P = P
      .replaceAll('[+]', '\\textcolor{orange}{+}')
      .replaceAll('[-]', '\\textcolor{orange}{-}')
      .replaceAll('[\\cos]', '\\textcolor{blue}{\\cos}')
      .replaceAll('[\\sin]', '\\textcolor{blue}{\\sin}');
  P = P.replaceAll('[', '\\textcolor{red}{').replaceAll(']', '}');
  return P.split(';');
}

String removeBracketsFromElements(String input, List<int> unindex) {
  // [ ] で囲まれた部分を抽出
  RegExp elementRegex = RegExp(r'\[[^\[\]]*\]');
  Iterable<RegExpMatch> matches = elementRegex.allMatches(input);

  StringBuffer sb = StringBuffer();
  int lastEnd = 0;
  int index = 0;

  for (final match in matches) {
    // [ ] で囲まれていない前の文字列をそのまま追加
    sb.write(input.substring(lastEnd, match.start));

    String element = match.group(0)!; // 例: "[2]"
    if (unindex.contains(index)) {
      // 括弧を削除
      sb.write(element.substring(1, element.length - 1));
    } else {
      sb.write(element); // そのまま
    }

    lastEnd = match.end;
    index++;
  }

  // 最後に残りの文字列を追加
  if (lastEnd < input.length) {
    sb.write(input.substring(lastEnd));
  }

  return sb.toString();
}

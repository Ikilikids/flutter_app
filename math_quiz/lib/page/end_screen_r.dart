import 'dart:math';

import 'package:common/common.dart';
import 'package:common/providers/app_sound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../math_quiz.dart';

// These typedefs are local to this file for now.

class NtEndScreen extends ConsumerStatefulWidget {
  final int correctCount;
  final List<MakingData> P;
  final List<String> marks;
  final DetailConfig quizinfo;
  const NtEndScreen({
    super.key,
    required this.correctCount,
    required this.P,
    required this.marks,
    required this.quizinfo,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NtEndScreenState createState() => _NtEndScreenState();
}

class _NtEndScreenState extends ConsumerState<NtEndScreen> {
  int step = 0; // 0:正解数 1:最高記録 2:ランキン
  late DetailConfig _quizinfo;

  @override
  void initState() {
    super.initState();
    _quizinfo = widget.quizinfo;
    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 800));
    ref.read(appSoundProvider).requireValue.playSound('pipi.mp3');
    if (!mounted) return;
    setState(() => step = 1);
  }

  @override
  Widget build(BuildContext context) {
    Color quizColor = getQuizColor2(
      _quizinfo.detail.color,
      context,
      1,
      0.35,
      0.95,
    );
    String unit = _quizinfo.modeData.unit;
    int fix = _quizinfo.modeData.fix;
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
                    quizName: _quizinfo.detail.displayLabel,
                    backgroundColor: quizColor,
                  ),
                ),
                const SizedBox(height: 20),
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
                      P: widget.P, quizinfo: _quizinfo, marks: widget.marks),
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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
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
  final List<MakingData> P;
  final List<String> marks;
  final DetailConfig quizinfo;

  const _RankSection(
      {required this.P, required this.quizinfo, required this.marks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: const EdgeInsets.all(2),
        height: 410,
        width: double.infinity,
        child: DefaultTabController(
          length: min(P.length, 10), // P の長さに応じてタブ数調整
          child: Column(
            children: [
              TabBar(
                isScrollable: P.length > 5,
                labelPadding: EdgeInsets.zero,
                tabs: List.generate(min(P.length, 10), (index) {
                  String isCorrect = marks[index];
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
                    ),
                  );
                }),
              ),
              Expanded(
                child: TabBarView(
                  children: List.generate(
                    min(P.length, 10),
                    (index) {
                      // 各タブの index に応じて lines を作る
                      final lines = restoreSymbols(P[index]);

                      return Column(
                        children: [
                          SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: buildChildWidget(context, P[index]),
                          ),
                          Container(
                            height: 120,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: getQuizColor2(
                                quizinfo.detail.color,
                                context,
                                0.4,
                                0.2,
                                0.95,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: lines.map((line) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Math.tex(
                                      line,
                                      textStyle: TextStyle(
                                        fontSize: 30,
                                        color: textColor1(context),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
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
                    InterstitialAdHelper.navigate(
                      context,
                      CommonCountdownScreen(),
                    );
                  },
          ),
          _ActionItem(
            backgroundColor: backgroundColor,
            icon: Icons.home,
            label: 'メニュー',
            onTap: () {
              InterstitialAdHelper.navigate(context, null);
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
                  disabledForegroundColor: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withAlpha(128),
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
}

List<String> restoreSymbols(MakingData P) {
  const colorMap = {
    '◯': 'red',
    '□': 'blue',
    '☆': 'orange',
  };
  if (P is LatexMakingData) {
    String base = P.initialLatexA;
    List<IndexData> sorted = [...P.indexDataA]
      ..sort((a, b) => a.index.compareTo(b.index));

    StringBuffer sb = StringBuffer();
    int basePos = 0;

    for (final data in sorted) {
      // 元の文字列の左から順にコピー（置換対象以外はそのまま）
      while (basePos < base.length && !colorMap.containsKey(base[basePos])) {
        sb.write(base[basePos]);
        basePos++;
      }

      // 置換対象の位置
      if (basePos < base.length) {
        String originalSymbol = base[basePos]; // 元の文字
        String replacement = data.origin; // 置換文字

        // 色は元の文字に基づく
        String? color = colorMap[originalSymbol];

        if (color != null) {
          sb.write("\\textcolor{$color}{$replacement}");
        } else {
          sb.write(replacement);
        }

        basePos++;
      }
    }

    // 残りの文字を追加
    while (basePos < base.length) {
      sb.write(base[basePos]);
      basePos++;
    }

    // セミコロンで分割して複数行対応
    return sb.toString().split(';');
  } else {
    return [];
  }
}

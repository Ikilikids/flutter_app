import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:quiz/quiz.dart";

import '../providers/eng_review_provider.dart';

// These typedefs are local to this file for now.

class NtEndScreen extends ConsumerStatefulWidget {
  const NtEndScreen({
    super.key,
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
    _quizinfo = ref.read(currentDetailConfigProvider);
    LoadQuiz(quizinfo: _quizinfo).init(ref).then((_) => _startSequence());
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 800));
    ref.read(appSoundProvider).playSound('pipi.mp3');
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
                  child: _QuizNameSection(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: _ScoreSection(step: step),
                ),
                SizedBox(
                  height: 420,
                  child: _RankSection(),
                ),
                Expanded(
                  flex: 2,
                  child: _ActionSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizNameSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizinfo = ref.watch(currentDetailConfigProvider);
    final quizName = quizinfo.detail.displayLabel;
    Color backgroundColor = getQuizColor2(
      quizinfo.detail.color,
      context,
      1,
      0.35,
      0.95,
    );
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

class _ScoreSection extends ConsumerWidget {
  final int step;

  const _ScoreSection({required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizinfo = ref.watch(currentDetailConfigProvider);
    final elapsed = ref.watch(quizElapsedTimerProvider);
    final session = ref.watch(quizSessionNotifierProvider);

// 2. switch 式で、どの値を「スコア」として採用するか決める
    final num score = switch (quizinfo.timeMode) {
      TimeMode.timeAttack => elapsed,
      TimeMode.countDown => session.totalScore,
      TimeMode.learning => session.correctCount, // その他のモード用（必要なら）
    };
    Color borderColor = getQuizColor2(
      quizinfo.detail.color,
      context,
      1,
      0.35,
      0.95,
    );
    String unit = quizinfo.modeData.unit;
    int fix = quizinfo.modeData.fix;

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
                        step == 0 ? " " : score.toStringAsFixed(fix),
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

class _RankSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    final P = session.historyQuestions;
    final marks = session.historyMarks;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
                  QuizResult isCorrect = marks[index];
                  return SizedBox(
                    width: P.length > 5 ? 80 : null, // ★ ここで制御
                    height: 40,
                    child: Tab(
                      height: 40,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('問題${index + 1}'),
                          Image.asset(
                              isDark
                                  ? 'assets/images/${isCorrect.name}_dark.png'
                                  : 'assets/images/${isCorrect.name}.png',
                              height: 20),
                          Container(),
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
                            child: QuestionDisplayArea(index: index),
                          ),
                          Container(
                            height: 120,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: getQuizColor2(
                                P[index].subject,
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
                                    child: P[index] is EngMakingData
                                        ? Text(
                                            line,
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: textColor1(context),
                                            ),
                                          )
                                        : Math.tex(
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

class _ActionSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMap = ref.watch(activeGameMapProvider);
    final quizinfo = ref.watch(currentDetailConfigProvider);
    Color backgroundColor = getQuizColor2(
      quizinfo.detail.color,
      context,
      1,
      0.35,
      0.95,
    );
    final isLimitedMode = quizinfo.modeData.islimited;
    final availableCount = activeMap[1]?.length ?? 0;
    final isReviewMode = quizinfo.detail.resisterOrigin == "復習モード";

    // 復習モードの場合、必要な問題数(qcount)が足りているかチェック
    final hasEnoughQuestions =
        !isReviewMode || availableCount >= quizinfo.qcount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionItem(
            backgroundColor: backgroundColor,
            icon: Icons.refresh,
            label: 'もう一度',
            availableCount: availableCount,
            showCount: isReviewMode,
            onTap: (isLimitedMode || !hasEnoughQuestions)
                ? null
                : () {
                    InterstitialAdHelper.navigate(
                      context,
                      const CommonCountdownScreen(),
                    );
                  },
          ),
          _ActionItem(
            backgroundColor: backgroundColor,
            icon: Icons.home,
            label: 'メニュー',
            onTap: () {
              ref.read(engReviewFilterProvider.notifier).state = null;
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
  final int? availableCount;
  final bool showCount;

  const _ActionItem({
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.onTap,
    this.availableCount,
    this.showCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (showCount && availableCount != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '現在: $availableCount問',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: (onTap == null)
                      ? Colors.red
                      : textColor1(context).withAlpha(180),
                ),
              ),
            ),
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
  } else if (P is EngMakingData) {
    return [P.word];
  } else {
    return [];
  }
}

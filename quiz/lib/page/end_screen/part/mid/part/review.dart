import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/page/eng_word_stats_tile.dart';
import "package:quiz/quiz.dart";

// These typedefs are local to this file for now.

class ReviewSection extends ConsumerWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    final questions = session.historyQuestions;

    if (questions.isEmpty) return const SizedBox.shrink();

    return DefaultTabController(
      length: questions.length,
      child: Column(
        children: [
          // 🔽 タブ部分（切り出し）
          _ReviewTabBar(questions: questions, marks: session.historyMarks),

          // 🔽 コンテンツ部分（切り出し）
          Expanded(
            child: _ReviewTabBarView(questions: questions),
          ),
        ],
      ),
    );
  }
}

class _ReviewTabBar extends StatelessWidget {
  final List<dynamic> questions;
  final List<QuizResult> marks;

  const _ReviewTabBar({required this.questions, required this.marks});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TabBar(
      isScrollable: questions.length > 5,
      labelPadding: EdgeInsets.zero,
      tabs: List.generate(questions.length, (index) {
        final isCorrect = marks[index];
        return SizedBox(
          width: questions.length > 5 ? 80 : null,
          height: 40,
          child: Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('問題${index + 1}'),
                const SizedBox(width: 4),
                Image.asset(
                  isDark
                      ? 'assets/images/${isCorrect.name}_dark.png'
                      : 'assets/images/${isCorrect.name}.png',
                  height: 20,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ReviewTabBarView extends StatelessWidget {
  final List<dynamic> questions;

  const _ReviewTabBarView({required this.questions});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: List.generate(questions.length, (index) {
        final question = questions[index];

        return Column(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                child: QuestionDisplayArea(index: index),
              ),
            ),
            if (question is EngMakingData)
              Padding(
                padding: EdgeInsetsGeometry.only(bottom: 10),
                child: EngWordStatsTile(question: question),
              ),
            Expanded(
              flex: 1,
              child: _AnswerDisplayArea(question: question, index: index),
            ),
          ],
        );
      }),
    );
  }
}

class _AnswerDisplayArea extends StatelessWidget {
  final dynamic question;
  final int index;

  const _AnswerDisplayArea({required this.question, required this.index});

  @override
  Widget build(BuildContext context) {
    final lines = restoreSymbols(question);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: getQuizColor2(
          question.subject,
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
          children: lines.map((line) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: question is EngMakingData
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
  } else if (P is OptionMakingData) {
    return P.optionList[0].split(';');
  } else {
    return [];
  }
}

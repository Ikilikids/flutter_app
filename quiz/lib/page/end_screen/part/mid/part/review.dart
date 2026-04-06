import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

// These typedefs are local to this file for now.

class ReviewSection extends ConsumerWidget {
  const ReviewSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    final P = session.historyQuestions;
    final marks = session.historyMarks;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        child: DefaultTabController(
          length: min(P.length, 10), // P の長さに応じてタブ数調整
          child: Column(
            children: [
              TabBar(
                isScrollable: P.length > 5,
                labelPadding: EdgeInsets.zero,
                tabs: List.generate(P.length, (index) {
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
                    P.length,
                    (index) {
                      // 各タブの index に応じて lines を作る
                      final lines = restoreSymbols(P[index]);
                      return Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: double.infinity,
                              child: QuestionDisplayArea(index: index),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
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
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
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

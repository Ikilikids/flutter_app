import 'dart:math';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

class QuizOptions extends HookConsumerWidget {
  const QuizOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooksによる状態管理
    final quizData =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion!))
            as OptionMakingData;
    final notifier = ref.read(quizSessionNotifierProvider.notifier);
    final answered = useState(false);
    final pressedIndex = useState<int?>(null);
    final optionsState = useState<List<String>>([]);

    // quizDataが変わるたびにオプションを生成（シャッフル）
    useEffect(() {
      final list = List<String>.from(quizData.optionList);
      list.shuffle(Random());
      optionsState.value = list;

      // 新しい問題になったらフラグをリセット
      answered.value = false;
      pressedIndex.value = null;
      return null;
    }, [quizData]);

    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow.shade700,
    ];

    // 正解の文字列（quizData.optionList[0]が元の正解と想定）
    final correctAnswer = quizData.optionList[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(optionsState.value.length, (index) {
        final option = optionsState.value[index];
        final color = colors[index % colors.length];
        final isPressed = pressedIndex.value == index;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            child: GestureDetector(
              onTap: answered.value
                  ? null
                  : () {
                      answered.value = true;
                      pressedIndex.value = index;

                      // 100ms後に押下表示を戻す
                      Future.delayed(const Duration(milliseconds: 100), () {
                        pressedIndex.value = null;
                      });

                      // 正誤判定
                      if (option == correctAnswer) {
                        notifier.judge(QuizResult.circle);
                      } else {
                        notifier.judge(QuizResult.cross);
                      }
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isPressed
                      ? bgColor1(context).withAlpha(0)
                      : bgColor1(context),
                  border: Border.all(color: color, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, isPressed ? 1 : 2),
                      blurRadius: isPressed ? 0.5 : 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 30.0,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Math.tex(
                      option,
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

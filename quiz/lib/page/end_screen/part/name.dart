import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// These typedefs are local to this file for now.

class QuizNameSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizinfo = ref.watch(currentDetailConfigProvider);
    final quizName = l10n(context, quizinfo.detail.displayLabel);
    Color backgroundColor = getQuizColor2(
      quizinfo.detail.color,
      context,
      1,
      0.35,
      0.95,
    );
    final sideIcon = Icon(
      quizinfo.detail.detailIcon,
      size: 100,
    );
    return Center(
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor1(context),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: backgroundColor,
                  width: 2,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 必要な分だけ幅を取る
                  children: [
                    sideIcon,
                    const SizedBox(width: 20),
                    Text(
                      l10n(context, quizName),
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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

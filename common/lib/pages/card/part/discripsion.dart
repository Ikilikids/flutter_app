import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardTitle extends HookConsumerWidget {
  final QuizId quizId;

  const CardTitle({
    required this.quizId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(quizDetailProvider(quizId));
    final detail = config.detail;
    final appTitle = config.appData.appTitle;
    final accentColor = getQuizColor2(detail.color, context, 1, 0.55, 0.95);

    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n(context, detail.displayLabel),
                  style: TextStyle(fontSize: 100, color: textColor1(context)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text("-${l10n(context, detail.method)}-",
                    style:
                        TextStyle(fontSize: 100, color: textColor2(context))),
              ),
            ),
            Expanded(
              flex: 4,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, size: 80, color: accentColor),
                    const SizedBox(width: 8),
                    if (appTitle == "とことん高校数学")
                      Math.tex(l10n(context, detail.description),
                          textStyle: TextStyle(
                              fontSize: 100, color: textColor2(context)))
                    else
                      Text(l10n(context, detail.description),
                          style: TextStyle(
                              fontSize: 100, color: textColor2(context))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

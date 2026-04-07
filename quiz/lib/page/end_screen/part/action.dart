import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

import '../../../providers/eng_review_provider.dart';

// These typedefs are local to this file for now.

class ActionSection extends ConsumerWidget {
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
            label: l10n(context, 'retryButton'),
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
            label: l10n(context, 'menuButton'),
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
                  shape: CircleBorder(
                    side: onTap == null
                        ? BorderSide.none
                        : BorderSide(
                            color: backgroundColor,
                            width: 2, // ← 太さ
                          ),
                  ),
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

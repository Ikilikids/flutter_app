import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

// These typedefs are local to this file for now.

class MidSection extends HookConsumerWidget {
  const MidSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);

    return Column(
      children: [
        // 🔽 タブ
        Row(
          children: [
            TabButton(
              label: '復習',
              isSelected: tabIndex.value == 0,
              onTap: () => tabIndex.value = 0,
            ),
            TabButton(
              label: 'ランキング',
              isSelected: tabIndex.value == 1,
              onTap: () => tabIndex.value = 1,
            ),
          ],
        ),
        // 🔽 中身切り替え
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: tabIndex.value == 0
                ? const ReviewSection(key: ValueKey('review'))
                : RankSection(),
          ),
        ),
      ],
    );
  }
}

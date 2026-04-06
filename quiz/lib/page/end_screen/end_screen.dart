import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

// These typedefs are local to this file for now.

class EndScreen extends HookConsumerWidget {
  const EndScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.read(currentDetailConfigProvider);
    final timeMode = detail.timeMode;
    final step = useState(0);
    useEffect(() {
      Future<void> init() async {
        await Future.delayed(const Duration(milliseconds: 800));
        ref.read(appSoundProvider).playSound('pipi.mp3');
        step.value = 1;
      }

      init();
      return null; // dispose不要
    }, []);

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
                  child: QuizNameSection(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: ScoreSection(step: step.value),
                ),
                SizedBox(
                  height: 420,
                  child: switch (timeMode) {
                    TimeMode.countDown => const MidSection(),
                    TimeMode.learning => const MidSection(),
                    TimeMode.timeAttack => const RankSection(),
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: ActionSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/providers/quiz_remaining_timer_provider.dart
import 'dart:async';

import 'package:common/common.dart';
import 'package:quiz/quiz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_remaining_provider.g.dart';

@riverpod
class QuizRemainingTimer extends _$QuizRemainingTimer {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  void start() {
    _timer?.cancel();
    state = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state <= 1) {
        state = 0;
        timer.cancel();
        ref.read(quizSessionNotifierProvider.notifier).endGame();
      } else {
        state -= 1;
        ref.read(appSoundProvider).playSound("ry.mp3");
      }
    });
  }

  void stop() => _timer?.cancel();
}

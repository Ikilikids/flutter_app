// lib/providers/quiz_elapsed_timer_provider.dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_elapsed_provider.g.dart';

@Riverpod(keepAlive: true)
class QuizElapsedTimer extends _$QuizElapsedTimer {
  Timer? _timer;

  @override
  double build() {
    ref.onDispose(() => _timer?.cancel());
    return 0.0;
  }

  void start() {
    _timer?.cancel();
    final startAt = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      state = DateTime.now().difference(startAt).inMilliseconds / 1000.0;
    });
  }

  void stop() => _timer?.cancel();

  void setElapsed(double elapsed) {
    _timer?.cancel();
    state = elapsed;
  }
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/app_sound.dart';
import '../providers/ui_provider.dart';

class CommonCountdownScreen extends ConsumerStatefulWidget {
  const CommonCountdownScreen({super.key});

  @override
  ConsumerState<CommonCountdownScreen> createState() =>
      _CommonCountdownScreenState();
}

class _CommonCountdownScreenState extends ConsumerState<CommonCountdownScreen> {
  int _countdown = 3;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _startCountdown();
    }
  }

  bool _isLoadGameCalled = false;

  void _startCountdown() {
    if (!mounted) return;

    final gameBuilder = allData.mainGame;
    final quizData = ref.read(currentDetailConfigProvider);
    print(quizData.modeData.islimited);
    final loadBuilder = allData.loadGame;

    // ★ 1回だけ実行
    if (!_isLoadGameCalled) {
      loadBuilder?.call(context, quizData);
      _isLoadGameCalled = true;
    }

    if (_countdown > 1) {
      ref.read(appSoundProvider).requireValue.playSound('countdown1.mp3');
      setState(() => _countdown--);
      Future.delayed(const Duration(seconds: 1), _startCountdown);
    } else {
      ref.read(appSoundProvider).requireValue.playSound('countdown2.mp3');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => gameBuilder(context, quizData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizinfo = ref.watch(currentDetailConfigProvider);
    Color color = getQuizColor2(quizinfo.detail.color, context, 1, 0.35, 0.95);

    return PopScope(
      canPop: false,
      child: AppAdScaffold(
        advisible: false,
        body: Center(
          child: Text(
            '$_countdown',
            style: TextStyle(
              fontSize: 200,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

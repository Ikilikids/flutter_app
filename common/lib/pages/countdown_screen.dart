import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonCountdownScreen extends StatefulWidget {
  const CommonCountdownScreen({super.key});

  @override
  State<CommonCountdownScreen> createState() => _CommonCountdownScreenState();
}

class _CommonCountdownScreenState extends State<CommonCountdownScreen> {
  int _countdown = 3;
  late SoundManager soundManager;
  bool _initialized = false;
  late AppConfig _appConfig;
  late QuizStateProvider quizinfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      soundManager = context.read<SoundManager>();

      _appConfig = Provider.of<AppConfig>(context);
      quizinfo = Provider.of<QuizStateProvider>(context);
      _initialized = true;
      _startCountdown();
    }
  }

  bool _isLoadGameCalled = false;

  void _startCountdown() {
    if (!mounted) return;

    final gameBuilder = _appConfig.mainGame;
    final quizData = context.read<QuizStateProvider>().quizinfo;
    final loadBuilder = _appConfig.loadGame;

    // ★ 1回だけ実行
    if (!_isLoadGameCalled) {
      loadBuilder?.call(context, quizData);
      _isLoadGameCalled = true;
    }

    if (_countdown > 1) {
      soundManager.playSound('countdown1.mp3');
      setState(() => _countdown--);
      Future.delayed(const Duration(seconds: 1), _startCountdown);
    } else {
      soundManager.playSound('countdown2.mp3');

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
    Color color = getQuizColor2(quizinfo.color, context, 1, 0.35, 0.95);

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

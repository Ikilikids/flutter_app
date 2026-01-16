import 'package:common/assistance/quiz_state_provider.dart';
import 'package:common/assistance/sound_manager.dart';
import 'package:common/config/app_config.dart';
import 'package:common/widgets/app_ad_scaffold.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      soundManager = context.read<SoundManager>();

      _appConfig = Provider.of<AppConfig>(context);
      _initialized = true;
      _startCountdown();
    }
  }

  void _startCountdown() {
    if (!mounted) return;

    if (_countdown > 1) {
      soundManager.playSound('countdown1.mp3');
      setState(() => _countdown--);
      Future.delayed(const Duration(seconds: 1), _startCountdown);
    } else {
      soundManager.playSound('countdown2.mp3');
      final gameBuilder = _appConfig.mainGame;
      final quizState = context.read<QuizStateProvider>();

      // ここで次の画面を決める
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => gameBuilder(context, quizState.quizinfo)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = context.watch<QuizStateProvider>();
    Color color = quizState.quizinfo[3];

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

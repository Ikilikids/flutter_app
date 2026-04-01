import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // flutter_hooks をインポート
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonCountdownScreen extends HookConsumerWidget {
  const CommonCountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useState でカウントダウンの状態を管理
    final countdown = useState(2);

    // クイズデータの取得 (同期)
    final quizData = ref.watch(currentDetailConfigProvider);
    final color = getQuizColor2(quizData.detail.color, context, 1, 0.35, 0.95);

    // useEffect を使って初期化処理を行う（マウント時に1回だけ実行）
    useEffect(() {
      final gameBuilder = allData.mainGame;
      final loadBuilder = allData.loadGame;
      final sound = ref.read(appSoundProvider);

      // ゲームのロード処理
      if (loadBuilder != null) {
        loadBuilder(context, ref, quizData);
      }

      // カウントダウンタイマーのロジック
      Future<void> startTimer() async {
        for (int i = 2; i >= 0; i--) {
          if (!context.mounted) return;

          countdown.value = i;

          if (i == 2 || i == 1) {
            sound.playSound('countdown1.mp3');
            await Future.delayed(const Duration(seconds: 1));
          } else {
            sound.playSound('countdown2.mp3');
            // 最後のカウントが終わったら画面遷移
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => gameBuilder(context, quizData),
                ),
              );
            }
          }
        }
      }

      startTimer();
      return null;
    }, const []);

    return PopScope(
      canPop: true,
      child: AppAdScaffold(
        advisible: false,
        body: Center(
          child: Text(
            '${countdown.value}',
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

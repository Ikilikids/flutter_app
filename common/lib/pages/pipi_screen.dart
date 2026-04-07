import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/quiz.dart';

class PipiScreen extends HookConsumerWidget {
  const PipiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 内部的な状態管理（画面遷移に使うデータ）

    useEffect(() {
      // データのロードと画面遷移のロジック
      Future<void> loadAndNavigate() async {
        final quizinfo = ref.read(currentDetailConfigProvider);

        final startTime = DateTime.now();

        try {
          final myscore = await ScoreManager.updateAllScores(ref: ref);

          final myRank = await ScoreManager.getMyRank(
            quizId: quizinfo.detail.quizId,
            myScoreMap: myscore,
            isBattle: quizinfo.modeData.isbattle,
            isSmallerBetter: quizinfo.modeData.isSmallerBetter,
          );
          ref.read(myRankMapProvider.notifier).setMap(myRank);
          ref.read(myScoreMapProvider.notifier).setMap(myscore);
        } catch (e) {
          debugPrint('Error loading data: $e');
        }

        // 3. 演出のための最低待ち時間（2秒）を確保
        final elapsed = DateTime.now().difference(startTime);
        const minDuration = Duration(seconds: 2);
        if (elapsed < minDuration) {
          await Future.delayed(minDuration - elapsed);
        }

        if (!context.mounted) return;

        // 4. 画面遷移
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EndScreen(),
          ),
        );
      }

      loadAndNavigate();
      return null;
    }, const []);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n(context, 'finishingText'),
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

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
    final highScore = useRef(0.0);

    useEffect(() {
      // データのロードと画面遷移のロジック
      Future<void> loadAndNavigate() async {
        final quizinfo = ref.read(currentDetailConfigProvider);
        final session = ref.read(quizSessionNotifierProvider);
        final elapsedTime = ref.read(quizElapsedTimerProvider);
        final categoryScores = session.categortScore;

        final num score = switch (quizinfo.timeMode) {
          TimeMode.timeAttack => elapsedTime,
          TimeMode.countDown => session.totalScore,
          TimeMode.learning => session.correctCount,
        };
        final startTime = DateTime.now();
        final userName = ref.read(appUserNameProvider).requireValue;

        try {
          List<double> myscore = await ScoreManager.updateAllScores(
            score: score.toDouble(),
            resisterOrigin: quizinfo.detail.resisterOrigin,
            modeType: quizinfo.modeData.modeType,
            isBattle: quizinfo.modeData.isbattle,
            isSmallerBetter: quizinfo.modeData.isSmallerBetter,
            isLimitedMode: quizinfo.modeData.islimited,
            fix: 100,
            userName: userName,
            categoryScores: categoryScores, // 渡されたものをそのまま使う
          );

          highScore.value = await ScoreManager.getScore(
            resisterOriginOrSub: quizinfo.detail.resisterOrigin,
            modeType: quizinfo.modeData.modeType,
          );

          // ローカルのスコア更新
          ref.read(userStatusNotifierProvider.notifier).updateScoreLocally(
                QuizId(
                  resisterOrigin: quizinfo.detail.resisterOrigin,
                  modeType: quizinfo.modeData.modeType,
                ),
                highScore.value,
              );

          List<int> myRank = await ScoreManager.getMyRank(
            resisterOrigin: quizinfo.detail.resisterOrigin,
            modeType: quizinfo.modeData.modeType,
            myScore: score.toDouble(),
            isSmallerBetter: quizinfo.modeData.isSmallerBetter,
            targetPeriods: buildPeriod(),
          );
          ref.read(myRankListProvider.notifier).setList(myRank);
          ref.read(myScoreListProvider.notifier).setList(myscore);
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

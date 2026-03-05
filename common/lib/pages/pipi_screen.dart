import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PipiScreen extends HookConsumerWidget {
  final num totalScore;
  final dynamic originalData;

  const PipiScreen({
    super.key,
    required this.totalScore,
    this.originalData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 内部的な状態管理（画面遷移に使うデータ）
    final highScore = useRef(0.0);
    final myRank = useRef([0, 0, 0]);

    useEffect(() {
      // データのロードと画面遷移のロジック
      Future<void> loadAndNavigate() async {
        final quizinfo = ref.read(currentDetailConfigProvider);
        final endBuilder = allData.endBuilder;
        final startTime = DateTime.now();

        final uid = await ref.read(appUidProvider.future);
        final userName =
            await ref.read(appUidProvider.notifier).loadUsername(uid);

        try {
          await ScoreManager.updateAllScores(
            score: totalScore.toDouble(),
            resisterOrigin: quizinfo.detail.resisterOrigin,
            resisterSub: quizinfo.detail.resisterSub,
            modeType: quizinfo.modeData.modeType,
            isBattle: quizinfo.modeData.isbattle,
            isSmallerBetter: quizinfo.modeData.isSmallerBetter,
            isLimitedMode: quizinfo.modeData.islimited,
            fix: 100,
            userName: userName,
          );

          highScore.value = await ScoreManager.getScore(
            resisterOriginOrSub: quizinfo.detail.resisterOrigin,
            modeType: quizinfo.modeData.modeType,
          );

          // ローカルのスコア更新
          ref.read(userStatusNotifierProvider.notifier).updateScoreLocally(
                quizinfo.detail.resisterOrigin,
                quizinfo.modeData.modeType,
                highScore.value,
              );

          myRank.value = await ScoreManager.getMyRank(
            resisterOrigin: quizinfo.detail.resisterSub,
            modeType: quizinfo.modeData.modeType,
            myScore: totalScore.toDouble(),
            isSmallerBetter: quizinfo.modeData.isSmallerBetter,
          );
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
          quizinfo.modeData.isbattle
              ? MaterialPageRoute(
                  builder: (_) => CommonEndScreen(
                    totalScore: totalScore,
                    highScore: highScore.value,
                    rankAll: myRank.value[0],
                    rankMonthly: myRank.value[1],
                    rankWeekly: myRank.value[2],
                  ),
                )
              : MaterialPageRoute(
                  builder: (context) => endBuilder!(
                    context,
                    totalScore,
                    originalData,
                    quizinfo,
                  ),
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

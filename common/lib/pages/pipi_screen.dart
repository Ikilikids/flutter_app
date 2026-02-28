import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ui_provider.dart';

class PipiScreen extends ConsumerStatefulWidget {
  final num totalScore;
  final dynamic originalData;

  const PipiScreen({super.key, required this.totalScore, this.originalData});

  @override
  ConsumerState<PipiScreen> createState() => _PipiScreenState();
}

class _PipiScreenState extends ConsumerState<PipiScreen> {
  double _highScore = 0.0;
  List<int> myRank = [0, 0, 0];
  late final String userName;

  @override
  void initState() {
    super.initState();
    _loadDataWithDelay();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n(context, 'finishingText'),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ));
  }

  Future<void> _loadDataWithDelay() async {
    final _quizinfo = ref.read(currentDetailConfigProvider);
    final minDuration = const Duration(seconds: 2);
    final maxDuration = const Duration(seconds: 5);
    final EndBuilder = allData.endBuilder;
    final startTime = DateTime.now();
    final uid = await ref.read(appUidProvider.future);
    userName = await ref.read(appUidProvider.notifier).loadUsername(uid);
    print('UID: $uid');
    print('ユーザー名: $userName');

    try {
      await _loadData();
    } catch (_) {}

    final elapsed = DateTime.now().difference(startTime);
    final remaining = minDuration - elapsed;
    if (remaining > Duration.zero) await Future.delayed(remaining);

    final totalElapsed = DateTime.now().difference(startTime);
    if (totalElapsed > maxDuration) if (!mounted) return;

    Navigator.pushReplacement(
      context,
      _quizinfo.modeData.isbattle
          ? MaterialPageRoute(
              builder: (_) => CommonEndScreen(
                totalScore: widget.totalScore,
                highScore: _highScore,
                rankAll: myRank[0],
                rankMonthly: myRank[1],
                rankWeekly: myRank[2],
              ),
            )
          : MaterialPageRoute(
              builder: (context) => EndBuilder!(
                context,
                widget.totalScore,
                widget.originalData,
                _quizinfo,
              ),
            ),
    );
  }

  Future<void> _loadData() async {
    final _quizinfo = ref.read(currentDetailConfigProvider);

    // 1. Firebase更新を実行（戻り値として、更新された場合のみ新しいスコアが返る）
    final double? updatedScore = await ScoreManager.updateAllScores(
      score: widget.totalScore.toDouble(),
      resisterOrigin: _quizinfo.detail.resisterOrigin,
      resisterSub: _quizinfo.detail.resisterSub,
      modeType: _quizinfo.modeData.modeType,
      isBattle: _quizinfo.modeData.isbattle,
      isSmallerBetter: _quizinfo.modeData.isSmallerBetter,
      isLimitedMode: _quizinfo.modeData.islimited,
      fix: 100,
      userName: userName,
    );

    _highScore = await ScoreManager.getScore(
      resisterOriginOrSub: _quizinfo.detail.resisterOrigin,
      modeType: _quizinfo.modeData.modeType,
    );
    ref.read(userStatusNotifierProvider.notifier).updateScoreLocally(
        _quizinfo.detail.resisterOrigin,
        _quizinfo.modeData.modeType,
        _highScore);

    print("記録: $_highScore");

    // 3. ランキングを取得（これは更新に関係なく常に最新を取る）
    myRank = await ScoreManager.getMyRank(
      resisterOrigin: _quizinfo.detail.resisterSub,
      modeType: _quizinfo.modeData.modeType,
      myScore: widget.totalScore.toDouble(),
      isSmallerBetter: _quizinfo.modeData.isSmallerBetter,
    );

    if (!mounted) return;
    setState(() {});
  }
}

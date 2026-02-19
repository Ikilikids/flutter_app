import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PipiScreen extends ConsumerStatefulWidget {
  final num totalScore;
  final dynamic originalData;

  const PipiScreen({super.key, required this.totalScore, this.originalData});

  @override
  ConsumerState<PipiScreen> createState() => _PipiScreenState();
}

class _PipiScreenState extends ConsumerState<PipiScreen> {
  double _highScore = 0.0;
  int _rankAll = 0;
  int _rankMonthly = 0;
  int _rankWeekly = 0;
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
    final _quizinfo = ref.read(appDetailConfigProvider);
    final minDuration = const Duration(seconds: 2);
    final maxDuration = const Duration(seconds: 5);
    final EndBuilder = allData.endBuilder;
    final startTime = DateTime.now();
    final uid = await ref.read(appUidProvider.future);
    userName = await ref.read(appUidProvider.notifier).loadUsername(uid);

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
                rankAll: _rankAll,
                rankMonthly: _rankMonthly,
                rankWeekly: _rankWeekly,
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
    final _quizinfo = ref.read(appDetailConfigProvider);
    // Translate keys to Japanese for DB storage
    final quizId =
        JapaneseTranslator.translateKeyToJapanese(_quizinfo.detail.label);
    final rankingId =
        allData.appTitle == "とことん高校数学" && !_quizinfo.modeData.isbattle
            ? convertLabel(_quizinfo.detail.sort)
            : quizId; // Use the already translated quizId

    // 🔹 ハイスコア & ランキング更新（v2共通マネージャ）
    await CommonHighScoreManager.setHighScoreSafe(
      quizId,
      rankingId,
      widget.totalScore,
      userName,
      _quizinfo.modeData.ranking,
      isLimitedMode: _quizinfo.modeData.islimited,
      roundingFactor: 100,
      isbattle: _quizinfo.modeData.isbattle,
      isDescending: _quizinfo.modeData.isDescending,
    );
    if (!_quizinfo.modeData.isbattle) {
      await CommonHighScoreManager.setHighScoreSafe(
        JapaneseTranslator.translateKeyToJapanese('allScores'),
        JapaneseTranslator.translateKeyToJapanese('allScores'),
        widget.totalScore,
        userName,
        _quizinfo.modeData.ranking,
        isLimitedMode: _quizinfo.modeData.islimited,
        roundingFactor: 100,
        isbattle: _quizinfo.modeData.isbattle,
        isDescending: _quizinfo.modeData.isDescending,
      );
    }
    if (_quizinfo.modeData.isbattle) {
      // 🔹 ハイスコア取得
      _highScore = await CommonHighScoreManager.getHighScore(
        quizId,
        _quizinfo.modeData.ranking,
      );

      _rankAll = await CommonRankingManager.getMyRank(
        rankingId,
        "all",
        _highScore,
        _quizinfo.modeData.ranking,
        isDescending: _quizinfo.modeData.isDescending,
      );
      _rankMonthly = await CommonRankingManager.getMyRank(
        rankingId,
        "monthly",
        _highScore,
        _quizinfo.modeData.ranking,
        isDescending: _quizinfo.modeData.isDescending,
      );
      _rankWeekly = await CommonRankingManager.getMyRank(
        rankingId,
        "weekly",
        _highScore,
        _quizinfo.modeData.ranking,
        isDescending: _quizinfo.modeData.isDescending,
      );
    }

    if (!mounted) return;
    setState(() {});
  }
}

String convertLabel(String label) {
  String result = "??";
  if (label == "1" || label == "A") {
    result = "数Ⅰ・数A";
  } else if (label == "2" || label == "B") {
    result = "数Ⅱ・数B";
  } else if (label == "3" || label == "C") {
    result = "数Ⅲ・数C";
  }
  return result;
}

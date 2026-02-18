import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../providers/app_uid.dart';

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
  late final QuizData _quizinfo;
  late final AppConfig appConfig;
  late final String userName;
  late bool isLimitedMode;

  @override
  void initState() {
    super.initState();
    _quizinfo = context.read<QuizStateProvider>().quizinfo;
    appConfig = context.read<AppConfig>();
    isLimitedMode = _quizinfo.islimited;

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
    final minDuration = const Duration(seconds: 2);
    final maxDuration = const Duration(seconds: 5);
    final EndBuilder = appConfig.endBuilder;
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
      _quizinfo.isbattle
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
    // Translate keys to Japanese for DB storage
    final quizId = JapaneseTranslator.translateKeyToJapanese(_quizinfo.label);
    final rankingId = appConfig.title == "とことん高校数学" && !_quizinfo.isbattle
        ? convertLabel(_quizinfo.sort)
        : quizId; // Use the already translated quizId

    // 🔹 ハイスコア & ランキング更新（v2共通マネージャ）
    await CommonHighScoreManager.setHighScoreSafe(
      quizId,
      rankingId,
      widget.totalScore,
      userName,
      _quizinfo.ranking,
      isLimitedMode: isLimitedMode,
      roundingFactor: 100,
      isbattle: _quizinfo.isbattle,
      isDescending: _quizinfo.isDescending,
    );
    if (!_quizinfo.isbattle) {
      await CommonHighScoreManager.setHighScoreSafe(
        JapaneseTranslator.translateKeyToJapanese('allScores'),
        JapaneseTranslator.translateKeyToJapanese('allScores'),
        widget.totalScore,
        userName,
        _quizinfo.ranking,
        isLimitedMode: isLimitedMode,
        roundingFactor: 100,
        isbattle: _quizinfo.isbattle,
        isDescending: _quizinfo.isDescending,
      );
    }
    if (_quizinfo.isbattle) {
      // 🔹 ハイスコア取得
      _highScore = await CommonHighScoreManager.getHighScore(
        quizId,
        _quizinfo.ranking,
      );

      _rankAll = await CommonRankingManager.getMyRank(
        rankingId,
        "all",
        _highScore,
        _quizinfo.ranking,
        isDescending: _quizinfo.isDescending,
      );
      _rankMonthly = await CommonRankingManager.getMyRank(
        rankingId,
        "monthly",
        _highScore,
        _quizinfo.ranking,
        isDescending: _quizinfo.isDescending,
      );
      _rankWeekly = await CommonRankingManager.getMyRank(
        rankingId,
        "weekly",
        _highScore,
        _quizinfo.ranking,
        isDescending: _quizinfo.isDescending,
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

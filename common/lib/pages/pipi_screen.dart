import 'package:common/assistance/firebase_score.dart';
import 'package:common/assistance/quiz_state_provider.dart';
import 'package:common/assistance/user_provider.dart';
import 'package:common/pages/end_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PipiScreen extends StatefulWidget {
  final num totalScore;

  const PipiScreen({super.key, required this.totalScore});

  @override
  State<PipiScreen> createState() => _PipiScreenState();
}

class _PipiScreenState extends State<PipiScreen> {
  double _highScore = 0.0;
  int _rankAll = 0;
  int _rankMonthly = 0;
  int _rankWeekly = 0;
  late final List<dynamic> _quizinfo;
  late bool isLimitedMode;

  @override
  void initState() {
    super.initState();
    _quizinfo = Provider.of<QuizStateProvider>(context, listen: false).quizinfo;
    isLimitedMode = _quizinfo[4];
    _loadDataWithDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "終了",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _loadDataWithDelay() async {
    final minDuration = const Duration(seconds: 2);
    final maxDuration = const Duration(seconds: 5);
    bool networkAvailable = true;
    final startTime = DateTime.now();

    try {
      await _loadData();
    } catch (_) {
      networkAvailable = false;
    }

    final elapsed = DateTime.now().difference(startTime);
    final remaining = minDuration - elapsed;
    if (remaining > Duration.zero) await Future.delayed(remaining);

    final totalElapsed = DateTime.now().difference(startTime);
    if (totalElapsed > maxDuration) networkAvailable = false;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CommonEndScreen(
          totalScore: widget.totalScore,
          highScore: networkAvailable ? _highScore : 0,
          rankAll: networkAvailable ? _rankAll : 0,
          rankMonthly: networkAvailable ? _rankMonthly : 0,
          rankWeekly: networkAvailable ? _rankWeekly : 0,
          quizinfo: _quizinfo,
          isLimitedMode: isLimitedMode,
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    final quizId = _quizinfo.length > 2 ? _quizinfo[2] : "";
    final userProvider = context.read<UserProvider>();
    final userName = userProvider.userName;

    // 🔹 ハイスコア & ランキング更新（v2共通マネージャ）
    await CommonHighScoreManager.setHighScoreSafe(
      quizId,
      widget.totalScore,
      userName,
      isLimitedMode: isLimitedMode,
      roundingFactor: 100,
    );

    // 🔹 ハイスコア取得
    _highScore = await CommonHighScoreManager.getHighScore(
      quizId,
      isLimitedMode: isLimitedMode,
    );

    // 🔹 順位取得
    _rankAll = await CommonRankingManager.getMyRank(
      quizId,
      "all",
      _highScore,
      isLimitedMode: isLimitedMode,
    );
    _rankMonthly = await CommonRankingManager.getMyRank(
      quizId,
      "monthly",
      _highScore,
      isLimitedMode: isLimitedMode,
    );
    _rankWeekly = await CommonRankingManager.getMyRank(
      quizId,
      "weekly",
      _highScore,
      isLimitedMode: isLimitedMode,
    );

    if (!mounted) return;
    setState(() {});
  }
}

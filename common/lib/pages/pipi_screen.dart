import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/assistance/firebase_score.dart';
import 'package:common/assistance/quiz_state_provider.dart';
import 'package:common/assistance/user_provider.dart';
import 'package:common/pages/end_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PipiScreen extends StatefulWidget {
  final double totalScore;

  const PipiScreen({
    super.key,
    required this.totalScore,
  });

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

  Future<void> _loadDataWithDelay() async {
    final minDuration = const Duration(seconds: 2);
    final maxDuration = const Duration(seconds: 5);

    bool networkAvailable = true;

    final startTime = DateTime.now();

    try {
      // データ取得
      await _loadData();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        networkAvailable = false;
      } else {
        throw e;
      }
    } catch (_) {
      networkAvailable = false;
    }

    // データ取得完了後、最低表示時間2秒を待つ
    final elapsed = DateTime.now().difference(startTime);
    final remaining = minDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    // 最大5秒を超えていれば強制遷移
    final totalElapsed = DateTime.now().difference(startTime);
    if (totalElapsed > maxDuration) {
      networkAvailable = false;
    }

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

// 通常のロード関数（データ取得だけ）
  Future<void> _loadData() async {
    final quizName = _quizinfo.length > 2 ? _quizinfo[2] : "";
    final userName = context.read<UserProvider>().userName;

    await CommonHighScoreManager.setHighScoreSafe(
        quizName, widget.totalScore, userName,
        isLimitedMode: isLimitedMode, roundingFactor: 100);

    final highScore = await CommonHighScoreManager.getHighScore(
      quizName,
      isLimitedMode: isLimitedMode,
    );

    final ranks = await Future.wait([
      CommonRankingManager.getMyRank(
        quizName,
        '全期間',
        highScore,
        isLimitedMode: isLimitedMode,
      ),
      CommonRankingManager.getMyRank(
        quizName,
        '月間',
        highScore,
        isLimitedMode: isLimitedMode,
      ),
      CommonRankingManager.getMyRank(
        quizName,
        '週間',
        highScore,
        isLimitedMode: isLimitedMode,
      ),
    ]);

    if (!mounted) return;

    setState(() {
      _highScore = highScore;
      _rankAll = ranks[0];
      _rankMonthly = ranks[1];
      _rankWeekly = ranks[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    // ロード中は「終了」文字を表示
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
}

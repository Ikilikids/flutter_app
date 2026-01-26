import 'package:common/common.dart';
import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDetailCard extends StatefulWidget {
  const CommonDetailCard({
    super.key,
  });

  @override
  State<CommonDetailCard> createState() => _CommonDetailCardState();
}

class _CommonDetailCardState extends State<CommonDetailCard> {
  late MidStateProvider _midConfig;
  late AppConfig appConfig;
  late bool isLimitedMode;
  late String rankingtype;
  bool _isDependenciesInitialized = false;

  Map<String, double> _highScores = {};
  bool _loading = true;

  Map<String, int> _playCounts = {};
  Map<String, bool> _rewardGranted = {};
  double _opacity = 0.0;
  bool _isNavigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDependenciesInitialized) {
      _midConfig = Provider.of<MidStateProvider>(context);
      appConfig = Provider.of<AppConfig>(context);
      // データ内の islimited を参照して処理
      isLimitedMode = _midConfig.isLimited;
      rankingtype = _midConfig.ranking;
      // 渡されたデータだけラベルを取得
      final labels = _midConfig.detail.map((e) => e.label).toList();

      if (isLimitedMode) {
        _loadPlayCounts(labels);
        RewardedAdManager.loadAd();
      }

      _loadHighScores(labels);
      _isDependenciesInitialized = true;
    }
  }

  Future<void> _loadPlayCounts(List<String> labels) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).toIso8601String();

    Map<String, int> newPlayCounts = {};
    Map<String, bool> newRewardGranted = {};

    for (final title in labels) {
      final lastPlayDateString = prefs.getString('lastPlayDate_$title');

      int count = 0;

      if (lastPlayDateString == today) {
        count = prefs.getInt('playCount_$title') ?? 0;
      } else {
        await prefs.setInt('playCount_$title', 0);
        await prefs.setString('lastPlayDate_$title', today);
      }

      newPlayCounts[title] = count;

      final rewardGrantedDateString = prefs.getString('rewardGranted_$title');

      if (rewardGrantedDateString == today) {
        newRewardGranted[title] = true;
      } else {
        await prefs.remove('rewardGranted_$title');
        newRewardGranted[title] = false;
      }
    }

    if (!mounted) return;
    setState(() {
      _playCounts = newPlayCounts;
      _rewardGranted = newRewardGranted;
    });
  }

  Future<void> _incrementPlayCount(String quizTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = _playCounts[quizTitle] ?? 0;
    final newCount = currentCount + 1;

    await prefs.setInt('playCount_$quizTitle', newCount);

    if (mounted) {
      setState(() {
        _playCounts[quizTitle] = newCount;
      });
    }
  }

  Future<void> _loadHighScores(List<String> labels) async {
    Map<String, double> scores = {};

    final futures = labels.map((label) async {
      final quizId = JapaneseTranslator.translateKeyToJapanese(label);
      final score = await CommonHighScoreManager.getHighScore(
        quizId,
        rankingtype,
      );
      return MapEntry(label, score);
    }).toList();

    final results = await Future.wait(futures);

    for (var entry in results) {
      scores[entry.key] = entry.value;
    }

    if (!mounted) return;
    setState(() {
      _highScores = scores;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDependenciesInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return PopScope(
        canPop: false, // 通常の戻るを無効化
        onPopInvokedWithResult: (didPop, result) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const CommonModeSelectionPage()),
            (route) => false,
          );
        },
        child: Stack(
          children: [
            AppAdScaffold(
              appBar: AppBar(
                title: Text(
                  l10n(
                      context,
                      _midConfig.title ??
                          (isLimitedMode
                              ? "dailyLimitedModeTitle"
                              : "unlimitedModeTitle")),
                ),
              ),
              body: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: _midConfig.detail.map((detail) {
                        final label = detail.label;
                        final score = _highScores[label] ?? 0.0;
                        final playCount = _midConfig.isLimited
                            ? (_playCounts[label] ?? 0)
                            : 0;
                        final rewardGranted = _rewardGranted[label] ?? false;

                        return SizedBox(
                          height: 200,
                          child: _CommonSubjectCard(
                              detail: detail,
                              score: score,
                              playCount: playCount,
                              rewardGranted: rewardGranted,
                              isLimitedMode: _midConfig.isLimited,
                              isbattle: _midConfig.isBattle,
                              isNavigating: _isNavigating,
                              onPlay: (qcount) => _handlePlay(detail, qcount),
                              onWatchAd: () => _handleWatchAd(detail.label),
                              fix: _midConfig.fix,
                              unit: _midConfig.unit,
                              title: appConfig.title),
                        );
                      }).toList(),
                    ),
            ),
            IgnorePointer(
              ignoring: _opacity == 0.0,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 300),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        ));
  }

  void _handlePlay(GameDetail detail, int? qcount) async {
    final label = detail.label;

    if (isLimitedMode) {
      await _incrementPlayCount(label);
      if (_rewardGranted[label] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('rewardGranted_$label');
        setState(() {
          _rewardGranted[label] = false;
        });
      }
    }

    setState(() {
      _opacity = 1.0;
      _isNavigating = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Provider.of<QuizStateProvider>(context, listen: false).setValues(
      quizinfo: QuizData(
        unit: _midConfig.unit,
        fix: _midConfig.fix,
        islimited: isLimitedMode,
        isbattle: _midConfig.isBattle,
        sort: detail.sort,
        label: detail.label,
        method: detail.method,
        description: detail.description,
        color: detail.color,
        circleColor: detail.circleColor,
        isDescending: _midConfig.isDescending,
        ranking: rankingtype,
        questionCount: qcount, // ← null なら何も起きない
      ),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CommonCountdownScreen()),
    );

    if (!mounted) return;
    setState(() {
      _isNavigating = false;
      _opacity = 0.0;
    });
  }

  void _handleWatchAd(String subTitle) {
    if (RewardedAdManager.isAdReady) {
      RewardedAdManager.showAd(
        onReward: () async {
          final prefs = await SharedPreferences.getInstance();
          final now = DateTime.now();
          final today =
              DateTime(now.year, now.month, now.day).toIso8601String();
          await prefs.setString('rewardGranted_$subTitle', today);
          setState(() {
            _rewardGranted[subTitle] = true;
          });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n(context, 'adLoadingSnackbar'))),
      );
      RewardedAdManager.loadAd();
    }
  }
}

class _CommonSubjectCard extends StatelessWidget {
  final GameDetail detail;
  final num score;
  final int playCount;
  final bool rewardGranted;
  final bool isLimitedMode;
  final bool isbattle;
  final bool isNavigating;
  final void Function(int? qcount) onPlay;
  final VoidCallback onWatchAd;
  final int fix;
  final String unit;
  final String title;

  const _CommonSubjectCard({
    required this.detail,
    required this.score,
    required this.playCount,
    required this.rewardGranted,
    required this.isLimitedMode,
    required this.isbattle,
    required this.isNavigating,
    required this.onPlay,
    required this.onWatchAd,
    required this.fix,
    required this.unit,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor1(context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  _buildCircleIcon(context),
                  _buildCardTitle(context, title),
                ],
              ),
            ),
            if (isbattle)
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _buildScoreDisplay(context),
                    _buildPlayButton(context),
                  ],
                ),
              ),
            if (!isbattle)
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _buildScoreDisplay(context),
                    _buildPlayButton(context, qcount: 5),
                    _buildPlayButton(context, qcount: 10),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(
    BuildContext context,
  ) {
    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return buildCircleWidget(detail.circleColor.split(''), context,
              constraints.maxHeight, detail.method, isLimitedMode);
        },
      ),
    );
  }

  Widget _buildCardTitle(BuildContext context, String title) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n(context, detail.label),
                  style: TextStyle(fontSize: 100, color: textColor1(context)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  "-${l10n(context, detail.method)}-",
                  style: TextStyle(fontSize: 100, color: textColor2(context)),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle_outlined,
                      size: 80,
                      color:
                          getQuizColor2(detail.color, context, 1, 0.55, 0.95),
                    ),
                    const SizedBox(width: 8),
                    if (title == "とことん高校数学")
                      Math.tex(
                        l10n(context, detail.description),
                        textStyle: TextStyle(
                            fontSize: 100, color: textColor2(context)),
                      ),
                    if (title != "とことん高校数学")
                      Text(
                        l10n(context, detail.description),
                        style: TextStyle(
                            fontSize: 100, color: textColor2(context)),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(BuildContext context) {
    return Expanded(
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              color: getQuizColor2(detail.color, context, 1, 0.35, 0.95),
              size: 100,
            ),
            const SizedBox(width: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  score == 0.0 ? "--" : score.toStringAsFixed(fix),
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: textColor1(context),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n(context, unit),
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: textColor1(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, {int? qcount}) {
    String buttonText;
    VoidCallback? onPressed;

    if (!isLimitedMode) {
      buttonText = qcount != null
          ? AppLocalizations.of(context)!.playButtonWithCount(qcount)
          : l10n(context, 'playButton');
      onPressed = isNavigating ? null : () => onPlay(qcount);
    } else {
      if (rewardGranted && playCount == 1) {
        buttonText = l10n(context, 'playButtonSecondTime');
        onPressed = isNavigating ? null : () => onPlay(qcount);
      } else {
        switch (playCount) {
          case 0:
            buttonText = l10n(context, 'playButton');
            onPressed = isNavigating ? null : () => onPlay(qcount);
            break;
          case 1:
            buttonText = l10n(context, 'watchAdToPlayButton');
            onPressed = isNavigating
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title:
                              Text(l10n(context, 'challengeAgainDialogTitle')),
                          content: Text(
                              l10n(context, 'challengeAgainDialogContent')),
                          actions: [
                            TextButton(
                              child: Text(l10n(context, 'cancelButton')),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: Text(l10n(context, 'watchAdButton')),
                              onPressed: () {
                                Navigator.of(context).pop();
                                onWatchAd();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  };
            break;
          default:
            buttonText = l10n(context, 'playedTodayButton');
            onPressed = null;
            break;
        }
      }
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, double.infinity),
            backgroundColor: qcount == 10
                ? bgColor1(context)
                : getQuizColor2(detail.color, context, 1, 0.55, 0.95),
            foregroundColor: qcount == 10
                ? getQuizColor2(detail.color, context, 1, 0.55, 0.95)
                : bgColor1(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: qcount == 10
                ? BorderSide(
                    color: getQuizColor2(detail.color, context, 1, 0.55, 0.95),
                    width: 2, // 枠線の太さ
                  )
                : null,
          ),
          child: FittedBox(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

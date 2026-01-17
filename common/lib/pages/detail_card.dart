import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDetailCard extends StatefulWidget {
  final bool isLimitedMode;

  const CommonDetailCard({
    super.key,
    required this.isLimitedMode,
  });

  @override
  State<CommonDetailCard> createState() => _CommonDetailCardState();
}

class _CommonDetailCardState extends State<CommonDetailCard> {
  late AppConfig _appConfig;
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
      _appConfig = Provider.of<AppConfig>(context);

      if (widget.isLimitedMode) {
        _loadPlayCounts(_appConfig.sortData);
        RewardedAdManager.loadAd();
      }
      _loadHighScores(_appConfig.sortData);
      _isDependenciesInitialized = true;
    }
  }

  Future<void> _loadPlayCounts(List<Map<String, String>> sortData) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).toIso8601String();

    Map<String, int> newPlayCounts = {};
    Map<String, bool> newRewardGranted = {};

    for (var subject in sortData) {
      final title = subject['label']!;
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
    if (mounted) {
      setState(() {
        _playCounts = newPlayCounts;
        _rewardGranted = newRewardGranted;
      });
    }
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

  Future<void> _loadHighScores(List<Map<String, String>> sortData) async {
    Map<String, double> scores = {};

    final futures = sortData.map((subject) async {
      final subTitle = subject['label']!;
      final score = await CommonHighScoreManager.getHighScore(
        subTitle,
        isLimitedMode: widget.isLimitedMode,
      );
      return MapEntry(subTitle, score);
    }).toList();

    final results = await Future.wait(futures);

    for (var entry in results) {
      scores[entry.key] = entry.value;
    }

    if (mounted) {
      setState(() {
        _highScores = scores;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizStateProvider>(context, listen: false);

    final title = _appConfig.title;
    final fix = _appConfig.fix;
    final unit = _appConfig.unit;

    if (!_isDependenciesInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final subjectSchedule = _appConfig.sortData.map((s) {
      final newSubject = Map<String, String>.from(s);
      newSubject['color'] = widget.isLimitedMode
          ? newSubject['limitColor']!
          : newSubject['normalColor']!;
      return newSubject;
    }).toList();

    return Stack(children: [
      AppAdScaffold(
        appBar: AppBar(
          title: Text(widget.isLimitedMode ? "1日限定モード" : "無制限モード"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _isNavigating
                ? null
                : () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommonModeSelectionPage()),
                    );
                  },
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  ...subjectSchedule.map((item) {
                    final subTitle = item['label']!;
                    final score = _highScores[subTitle] ?? 0.0;
                    final playCount =
                        widget.isLimitedMode ? (_playCounts[subTitle] ?? 0) : 0;
                    final rewardGranted = _rewardGranted[subTitle] ?? false;
                    final cardDescription = item['method']!;
                    return _CommonSubjectCard(
                        item: item,
                        score: score,
                        playCount: playCount,
                        rewardGranted: rewardGranted,
                        isLimitedMode: widget.isLimitedMode,
                        isNavigating: _isNavigating,
                        onPlay: () => _handlePlay(quizState, item),
                        onWatchAd: () => _handleWatchAd(subTitle),
                        cardDescription: cardDescription,
                        title: title,
                        fix: fix,
                        unit: unit);
                  }),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
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
    ]);
  }

  void _handlePlay(
      QuizStateProvider quizState, Map<String, String> item) async {
    final subTitle = item['label']!;
    if (widget.isLimitedMode) {
      await _incrementPlayCount(subTitle);
      if (_rewardGranted[subTitle] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('rewardGranted_$subTitle');
        setState(() {
          _rewardGranted[subTitle] = false;
        });
      }
    }

    setState(() {
      _opacity = 1.0;
      _isNavigating = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    quizState.setValues(
      quizinfo: [
        item['sort']!,
        item['description']!,
        item['label']!,
        item['color']!,
        widget.isLimitedMode,
      ],
    );
    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommonCountdownScreen()),
      );
      if (mounted) {
        setState(() {
          _isNavigating = false;
          _opacity = 0.0;
        });
      }
    }
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
        const SnackBar(content: Text('広告を準備中です。少し待ってからもう一度お試しください。')),
      );
      RewardedAdManager.loadAd();
    }
  }
}

class _CommonSubjectCard extends StatelessWidget {
  final Map<String, String> item;
  final num score;
  final int playCount;
  final bool rewardGranted;
  final bool isLimitedMode;
  final bool isNavigating;
  final VoidCallback onPlay;
  final VoidCallback onWatchAd;
  final String cardDescription;
  final String title;
  final int fix;
  final String unit;

  const _CommonSubjectCard({
    required this.item,
    required this.score,
    required this.playCount,
    required this.rewardGranted,
    required this.isLimitedMode,
    required this.isNavigating,
    required this.onPlay,
    required this.onWatchAd,
    required this.cardDescription,
    required this.title,
    required this.fix,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final category = item['description']!;
    final subTitle = item['label']!;
    final color = item['color']!;

    final circleColor = (title == "とことん四則演算")
        ? item['sort']!
        : (isLimitedMode ? item['limitColor']! : item['normalColor']!);
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Container(
          padding: const EdgeInsets.all(6),
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
                    _buildCircleIcon(
                      circleColor.split(
                          ''), // "12" -> ["1", "2"], "1234" -> ["1","2","3","4"]
                      context,
                      isLimitedMode,
                    ),
                    _buildCardTitle(subTitle, category, color, context),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _buildScoreDisplay(color, context, fix, unit),
                    _buildPlayButton(context, color),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIcon(
      List<String> parts, BuildContext context, bool isLimitedMode) {
    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return buildCircleWidget(parts, context, constraints.maxHeight,
              bgColor1(context), isLimitedMode);
        },
      ),
    );
  }

  Widget _buildCardTitle(
      String subTitle, String category, String color, BuildContext context) {
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
                  subTitle,
                  style: TextStyle(fontSize: 100, color: textColor1(context)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  "-${cardDescription}-",
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
                      color: getQuizColor2(color, context, 1, 0.55, 0.95),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style:
                          TextStyle(fontSize: 100, color: textColor2(context)),
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

  Widget _buildScoreDisplay(
      String color, BuildContext context, int fix, String unit) {
    return Expanded(
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              color: getQuizColor2(color, context, 1, 0.35, 0.95),
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
                  unit,
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

  Widget _buildPlayButton(BuildContext context, String color) {
    String buttonText;
    VoidCallback? onPressed;

    if (!isLimitedMode) {
      buttonText = "プレイ！";
      onPressed = isNavigating ? null : onPlay;
    } else {
      if (rewardGranted && playCount == 1) {
        buttonText = "プレイ！(2回目)";
        onPressed = isNavigating ? null : onPlay;
      } else {
        switch (playCount) {
          case 0:
            buttonText = "プレイ！";
            onPressed = isNavigating ? null : onPlay;
            break;
          case 1:
            buttonText = "広告を見てプレイ";
            onPressed = isNavigating
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("🎁 もう一度チャレンジ！"),
                          content: const Text("広告を1本見ると\n今日の挑戦をもう一度できます！"),
                          actions: [
                            TextButton(
                              child: const Text("やめる"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: const Text("広告を見て続ける ▶"),
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
            buttonText = "本日プレイ済み";
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
            backgroundColor: getQuizColor2(color, context, 1, 0.55, 0.95),
            foregroundColor: bgColor1(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
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

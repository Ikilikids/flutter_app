import 'package:common/common.dart';
import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDetailCard extends ConsumerStatefulWidget {
  const CommonDetailCard({
    super.key,
  });

  @override
  ConsumerState<CommonDetailCard> createState() => _CommonDetailCardState();
}

class _CommonDetailCardState extends ConsumerState<CommonDetailCard> {
  Map<String, double> _highScores = {};
  bool _loading = true;

  Map<String, int> _playCounts = {};
  Map<String, bool> _rewardGranted = {};
  double _opacity = 0.0;
  bool _isNavigating = false;

  // This flag ensures the one-time setup logic runs only once.
  bool _initialized = false;

  // This state is used to signal the ref.listen to navigate.
  DetailData? _RequestDetail;
  ModeData? _RequestModeData;

  @override
  void initState() {
    super.initState();
    // The initialization logic is moved here from the build method.
    // It's safer to call this from initState.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeScreen());
  }

  void _initializeScreen() {
    if (_initialized) return;
    final mid = ref.read(appMidConfigProvider).mid;
    final labels = mid.detail.map((e) => e.label).toList();
    final isLimited = mid.islimited;

    if (isLimited) {
      _loadPlayCounts(labels);
      RewardedAdManager.loadAd();
    }
    _loadHighScores(labels, mid.ranking);
    _initialized = true;
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

  Future<void> _loadHighScores(List<String> labels, String rankingtype) async {
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
    // THIS IS THE FIX: Listen to the provider. When it changes, and if the
    // change was triggered by our navigation request, then navigate.
    ref.listen<DetailConfig>(appDetailConfigProvider, (previous, next) {
      // Check if there is a pending navigation request and if the new state
      // matches the requested data.

      if (_RequestDetail != null &&
          _RequestModeData != null &&
          next.detail == _RequestDetail &&
          next.modeData == _RequestModeData) {
        // Clear the request
        _RequestDetail = null;
        _RequestModeData = null;

        // Navigate to the next screen. This is now guaranteed to happen
        // *after* the state has been updated.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CommonCountdownScreen()),
        ).then((_) {
          // When we return from countdown, reset the navigating state.
          if (mounted) {
            setState(() {
              _isNavigating = false;
              _opacity = 0.0;
            });
          }
        });
      }
    });

    final midConfig = ref.watch(appMidConfigProvider);

    return PopScope(
        canPop: false, // 通常の戻るを無効化
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => CommonModeSelectionPage()),
              (route) => false,
            );
          }
        },
        child: Stack(
          children: [
            AppAdScaffold(
              appBar: AppBar(
                title: Text(
                  l10n(
                      context,
                      midConfig.mid.modeTitle ??
                          (midConfig.mid.islimited
                              ? "dailyLimitedModeTitle"
                              : "unlimitedModeTitle")),
                ),
              ),
              body: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: midConfig.mid.detail.map((detail) {
                        final label = detail.label;
                        final score = _highScores[label] ?? 0.0;
                        final playCount = midConfig.mid.islimited
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
                              isLimitedMode: midConfig.mid.islimited,
                              isbattle: midConfig.mid.isbattle,
                              isNavigating: _isNavigating,
                              onPlay: (qcount) => _handlePlay(
                                    detail,
                                    midConfig.mid.modeData,
                                    qcount,
                                    midConfig.mid.islimited,
                                  ),
                              onWatchAd: () => _handleWatchAd(detail.label),
                              fix: midConfig.mid.fix,
                              unit: midConfig.mid.unit,
                              title: allData.appTitle),
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

  // THIS IS THE FIX: _handlePlay NO LONGER NAVIGATES.
  // It only signals its intent to navigate by updating the providers.
  void _handlePlay(
      DetailData detail, ModeData modeData, int? qcount, bool islimited) async {
    // 1. Handle local UI changes and business logic
    final label = detail.label;
    if (islimited) {
      await _incrementPlayCount(label);
      if (_rewardGranted[label] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('rewardGranted_$label');
        if (mounted) {
          setState(() {
            _rewardGranted[label] = false;
          });
        }
      }
    }

    setState(() {
      _opacity = 1.0;
      _isNavigating = true;
    });

    // 2. Set the navigation request flag for the listener
    _RequestDetail = detail;
    _RequestModeData = modeData;

    // 3. Update the global provider. The listener will see this change and navigate.
    ref.read(appDetailConfigProvider.notifier).selectDetail(detail, modeData);
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
          if (mounted) {
            setState(() {
              _rewardGranted[subTitle] = true;
            });
          }
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
  final DetailData detail;
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

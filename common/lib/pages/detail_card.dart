import 'package:common/common.dart';
import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonDetailCard extends ConsumerStatefulWidget {
  const CommonDetailCard({super.key});

  @override
  ConsumerState<CommonDetailCard> createState() => _CommonDetailCardState();
}

class _CommonDetailCardState extends ConsumerState<CommonDetailCard> {
  // ★ _highScores は不要になったので削除！
  bool _loading = true;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    // 読み込み（ボタンテキストもハイスコアも全部 Provider で完結）
    await ref.read(appMidConfigProvider.notifier).loadMid();

    final mid = ref.read(appMidConfigProvider).mid;
    if (mid.islimited) RewardedAdManager.loadAd();

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final midConfig = ref.watch(appMidConfigProvider);

    ref.listen<DetailConfig>(appDetailConfigProvider, (prev, next) {
      if (_isNavigating) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CommonCountdownScreen())).then((_) {
          if (mounted) setState(() => _isNavigating = false);
        });
      }
    });

    return AppAdScaffold(
      appBar: AppBar(title: Text(l10n(context, midConfig.mid.modeTitle))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: midConfig.mid.detail.length,
              itemBuilder: (context, index) {
                final detail = midConfig.mid.detail[index];
                return SizedBox(
                  height: 200,
                  child: _CommonSubjectCard(
                    detail: detail,
                    score: detail.highScore.toDouble(),
                    isLimitedMode: midConfig.mid.islimited,
                    isbattle: midConfig.mid.isbattle,
                    isNavigating: _isNavigating,
                    onPlay: (qcount) =>
                        _handlePlay(detail, midConfig.mid.modeData, qcount),
                    onWatchAd: () => _handleWatchAd(detail.resisterUser),
                    fix: midConfig.mid.fix,
                    unit: midConfig.mid.unit,
                    title: allData.appTitle,
                  ),
                );
              },
            ),
    );
  }

  void _handlePlay(DetailData detail, ModeData modeData, int? qCount) async {
    if (modeData.islimited) {
      // プレイ開始時にカウントを増やす
      await ref
          .read(appMidConfigProvider.notifier)
          .recordPlay(detail.resisterUser);
    }
    setState(() => _isNavigating = true);
    ref
        .read(appDetailConfigProvider.notifier)
        .selectDetail(detail, modeData, qCount);
  }

  void _handleWatchAd(String userLabel) {
    if (RewardedAdManager.isAdReady) {
      RewardedAdManager.showAd(onReward: () async {
        // ここで報酬付与。Provider内の日付判定と一致させる
        await ref.read(appMidConfigProvider.notifier).grantReward(userLabel);
      });
    } else {
      RewardedAdManager.loadAd();
    }
  }
}

class _CommonSubjectCard extends StatelessWidget {
  final DetailData detail;
  final double score;
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
          border: Border.all(
              color: getQuizColor2(detail.color, context, 0.7, 0.55, 0.95),
              width: 2),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  _buildScoreDisplay(context),
                  if (isbattle) _buildPlayButton(context),
                  if (!isbattle) ...[
                    _buildPlayButton(context, qcount: 5),
                    _buildPlayButton(context, qcount: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(BuildContext context) {
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

  Widget _buildCardTitle(BuildContext context, String appTitle) {
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
                  l10n(context, detail.displayLabel),
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
                  children: [
                    Icon(Icons.circle_outlined,
                        size: 80,
                        color: getQuizColor2(
                            detail.color, context, 1, 0.55, 0.95)),
                    const SizedBox(width: 8),
                    if (appTitle == "とことん高校数学")
                      Math.tex(l10n(context, detail.description),
                          textStyle: TextStyle(
                              fontSize: 100, color: textColor2(context)))
                    else
                      Text(l10n(context, detail.description),
                          style: TextStyle(
                              fontSize: 100, color: textColor2(context))),
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
          children: [
            Icon(Icons.emoji_events,
                color: getQuizColor2(detail.color, context, 1, 0.35, 0.95),
                size: 100),
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
                      color: textColor1(context)),
                ),
                const SizedBox(width: 8),
                Text(l10n(context, unit),
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: textColor1(context))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, {int? qcount}) {
    final btnKey = detail.buttonText; // Providerが決めたキーを取得

    // 表示テキスト
    String buttonText = (qcount != null && btnKey == 'playButton')
        ? AppLocalizations.of(context)!.playButtonWithCount(qcount)
        : l10n(context, btnKey);

    // ボタンの挙動
    VoidCallback? onPressed;
    if (!isNavigating) {
      if (btnKey == 'watchAdToPlayButton') {
        onPressed = () => _showAdDialog(context);
      } else if (btnKey != 'playedTodayButton') {
        onPressed = () => onPlay(qcount);
      }
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, double.infinity),
            backgroundColor: (btnKey == 'playedTodayButton')
                ? Colors.grey
                : (qcount == 10
                    ? bgColor1(context)
                    : getQuizColor2(detail.color, context, 1, 0.55, 0.95)),
            foregroundColor: (qcount == 10 && btnKey != 'playedTodayButton')
                ? getQuizColor2(detail.color, context, 1, 0.55, 0.95)
                : (btnKey == 'playedTodayButton'
                    ? Colors.white
                    : bgColor1(context)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: (qcount == 10 && btnKey != 'playedTodayButton')
                ? BorderSide(
                    color: getQuizColor2(detail.color, context, 1, 0.55, 0.95),
                    width: 2)
                : null,
          ),
          child: FittedBox(
            child: Text(buttonText,
                style: const TextStyle(
                    fontSize: 100, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void _showAdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n(context, 'challengeAgainDialogTitle')),
        content: Text(l10n(context, 'challengeAgainDialogContent')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n(context, 'cancelButton'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onWatchAd();
            },
            child: Text(l10n(context, 'watchAdButton')),
          ),
        ],
      ),
    );
  }
}

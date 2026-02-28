import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 新しいプロバイダーをインポート
import '../freezed/app_data.dart';
import '../freezed/ui_config.dart';
import '../providers/ui_provider.dart';

class CommonDetailCard extends ConsumerWidget {
  const CommonDetailCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のモードの合体済みパックを監視
    final midConfig = ref.watch(currentMidConfigProvider);
    if (midConfig.details.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.loadingProblem),
            ],
          ),
        ),
      );
    }
    return AppAdScaffold(
      appBar: AppBar(
          title: Text(l10n(context, midConfig.modeData.modeTitle ?? ''))),
      body: ListView.builder(
        itemCount: midConfig.details.length,
        itemBuilder: (context, index) {
          final detailConfig = midConfig.details[index];

          return SizedBox(
            height: 200,
            child: _CommonSubjectCard(
              detailConfig: detailConfig,
              // カード内部から Notifier を叩くためのコールバック
              onPlay: (qcount) =>
                  _handlePlay(context, ref, detailConfig, qcount),
              onWatchAd: () =>
                  _handleWatchAd(ref, detailConfig.detail.resisterOrigin),
            ),
          );
        },
      ),
    );
  }

  /// プレイ開始処理
  void _handlePlay(BuildContext context, WidgetRef ref, DetailConfig config,
      int? qcount) async {
    final notifier = ref.read(userStatusNotifierProvider.notifier);

    // このカードが持っている固有のIDとモードを抽出
    final String resisterOrigin = config.detail.resisterOrigin;
    final String modeType = config.modeData.modeType;

    // 1. 選択状態を更新（これは画面表示用）
    notifier.selectDetail(resisterOrigin);

    // 2. 問題数を更新（IDとモードを指名して叩く）
    if (qcount != null) {
      notifier.updateQcount(resisterOrigin, modeType, qcount);
    }

    // 3. 限定モードならプレイ記録をつける（IDを指名して叩く）
    if (config.modeData.islimited) {
      await notifier.recordPlay(resisterOrigin);
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CommonCountdownScreen()),
      );
    }
  }

  /// 広告視聴処理
  void _handleWatchAd(WidgetRef ref, String resisterOrigin) {
    if (RewardedAdManager.isAdReady) {
      RewardedAdManager.showAd(onReward: () async {
        // ★ ここ！「今押されたカードのID」を直接渡す
        await ref
            .read(userStatusNotifierProvider.notifier)
            .grantReward(resisterOrigin);
      });
    } else {
      RewardedAdManager.loadAd();
    }
  }
}

class _CommonSubjectCard extends StatelessWidget {
  final DetailConfig detailConfig;
  final void Function(int? qcount) onPlay;
  final VoidCallback onWatchAd;

  const _CommonSubjectCard({
    required this.detailConfig,
    required this.onPlay,
    required this.onWatchAd,
  });

  @override
  Widget build(BuildContext context) {
    final detail = detailConfig.detail;
    final mode = detailConfig.modeData;

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
                  _buildCircleIcon(context, detail, mode.islimited),
                  _buildCardTitle(
                      context, detail, detailConfig.appData.appTitle),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  _buildScoreDisplay(context, detail, mode.unit, mode.fix),
                  if (mode.isbattle) _buildPlayButton(context, detail),
                  if (!mode.isbattle) ...[
                    _buildPlayButton(context, detail, qcount: 5),
                    _buildPlayButton(context, detail, qcount: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(
      BuildContext context, DetailData detail, bool isLimited) {
    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return buildCircleWidget(detail.circleColor.split(''), context,
              constraints.maxHeight, detail.method, isLimited);
        },
      ),
    );
  }

  Widget _buildCardTitle(
      BuildContext context, DetailData detail, String appTitle) {
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
                child: Text("-${l10n(context, detail.method)}-",
                    style:
                        TextStyle(fontSize: 100, color: textColor2(context))),
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

  Widget _buildScoreDisplay(
      BuildContext context, DetailData detail, String unit, int fix) {
    final score = detailConfig.highScore;
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

  Widget _buildPlayButton(BuildContext context, DetailData detail,
      {int? qcount}) {
    final btnKey = detailConfig.buttonText;

    String buttonText = (qcount != null && btnKey == 'playButton')
        ? AppLocalizations.of(context)!.playButtonWithCount(qcount)
        : l10n(context, btnKey);

    VoidCallback? onPressed;
    if (btnKey == 'watchAdToPlayButton') {
      onPressed = () => _showAdDialog(context);
    } else if (btnKey != 'playedTodayButton') {
      onPressed = () => onPlay(qcount);
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

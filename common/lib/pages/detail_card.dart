import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonDetailCard extends ConsumerStatefulWidget {
  final int modeIndex;
  const CommonDetailCard({super.key, required this.modeIndex});

  @override
  ConsumerState<CommonDetailCard> createState() => _CommonDetailCardState();
}

class _CommonDetailCardState extends ConsumerState<CommonDetailCard> {
  bool _isNavigating = false; // 連打防止用フラグ

  @override
  Widget build(BuildContext context) {
    // 現在のモードの合体済みパックを監視 (同期)
    final midConfig = ref.watch(currentMidConfigProvider);

    // インデックスの安全チェック
    if (widget.modeIndex >= allData.mid.length) {
      return const Scaffold(
        body: Center(child: Text("モードが見つかりません")),
      );
    }

    // モード切り替え時の一致チェック
    final expectedModeType = allData.mid[widget.modeIndex].modeData.modeType;
    if (midConfig.modeData.modeType != expectedModeType) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

    return ListView.builder(
      itemCount: midConfig.details.length,
      itemBuilder: (context, index) {
        final detailConfig = midConfig.details[index];

        return SizedBox(
          height: 200,
          child: _CommonSubjectCard(
            detailConfig: detailConfig,
            onPlay: _isNavigating
                ? null
                : (qcount) => _handlePlay(context, ref, detailConfig, qcount),
            onWatchAd: _isNavigating
                ? null
                : () => _handleWatchAd(ref, detailConfig.detail.resisterOrigin),
          ),
        );
      },
    );
  }

  /// プレイ開始処理
  void _handlePlay(BuildContext context, WidgetRef ref, DetailConfig config,
      int? qcount) async {
    if (_isNavigating) return;

    setState(() => _isNavigating = true);

    try {
      final notifier = ref.read(userStatusNotifierProvider.notifier);
      final String resisterOrigin = config.detail.resisterOrigin;
      final String modeType = config.modeData.modeType;

      notifier.selectDetail(resisterOrigin);

      if (qcount != null) {
        notifier.updateQcount(resisterOrigin, modeType, qcount);
      }

      if (config.modeData.islimited) {
        await notifier.recordPlay(resisterOrigin);
      }

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CommonCountdownScreen()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isNavigating = false);
      }
    }
  }

  /// 広告視聴処理
  void _handleWatchAd(WidgetRef ref, String resisterOrigin) {
    if (RewardedAdManager.isAdReady) {
      RewardedAdManager.showAd(onReward: () async {
        await ref
            .read(userStatusNotifierProvider.notifier)
            .grantReward(resisterOrigin);
      });
    } else {
      RewardedAdManager.loadAd();
    }
  }
}

class _CommonSubjectCard extends HookConsumerWidget {
  final DetailConfig detailConfig;
  final void Function(int? qcount)? onPlay;
  final VoidCallback? onWatchAd;

  const _CommonSubjectCard({
    required this.detailConfig,
    required this.onPlay,
    required this.onWatchAd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = detailConfig.detail;
    final mode = detailConfig.modeData;

    final mainColor = getQuizColor2(detail.color, context, 0.7, 0.55, 0.95);
    final accentColor = getQuizColor2(detail.color, context, 1, 0.55, 0.95);
    final scoreIconColor = getQuizColor2(detail.color, context, 1, 0.35, 0.95);

    // モードが "z" の場合、登録単語数を取得（リアクティブ）
    final registeredCount = (mode.modeType == "z")
        ? detailConfig.appData.registeredCount?.call(ref, detail.sort)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor1(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mainColor, width: 2),
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
                  _CircleIcon(
                    mode: mode,
                    detail: detail,
                  ),
                  _CardTitle(
                    displayLabel: detail.displayLabel,
                    method: detail.method,
                    description: detail.description,
                    appTitle: detailConfig.appData.appTitle,
                    accentColor: accentColor,
                    quizColor: detail.color,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  _ScoreDisplay(
                    highScore: detailConfig.highScore,
                    unit: mode.unit,
                    fix: mode.fix,
                    iconColor: scoreIconColor,
                    modeType: mode.modeType,
                    config: detailConfig,
                    currentRegisteredCount: registeredCount,
                  ),
                  if (mode.isbattle)
                    _PlayButton(
                      buttonTextKey: detailConfig.buttonText,
                      accentColor: accentColor,
                      onPressed: onPlay != null
                          ? () => _handleOnPressed(
                              context, detailConfig.buttonText, null)
                          : null,
                    ),
                  if (!mode.isbattle) ...[
                    _PlayButton(
                      buttonTextKey: detailConfig.buttonText,
                      accentColor: accentColor,
                      qcount: 5,
                      onPressed: onPlay != null &&
                              (mode.modeType != "z" ||
                                  (registeredCount ?? 0) >= 5)
                          ? () => _handleOnPressed(
                              context, detailConfig.buttonText, 5)
                          : null,
                    ),
                    _PlayButton(
                      buttonTextKey: detailConfig.buttonText,
                      accentColor: accentColor,
                      qcount: 10,
                      onPressed: onPlay != null &&
                              (mode.modeType != "z" ||
                                  (registeredCount ?? 0) >= 10)
                          ? () => _handleOnPressed(
                              context, detailConfig.buttonText, 10)
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOnPressed(BuildContext context, String btnKey, int? qcount) {
    if (btnKey == 'watchAdToPlayButton') {
      _showAdDialog(context);
    } else if (btnKey != 'playedTodayButton') {
      onPlay!(qcount);
    }
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
              if (onWatchAd != null) onWatchAd!();
            },
            child: Text(l10n(context, 'watchAdButton')),
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final ModeData mode;
  final DetailData detail;

  const _CircleIcon({
    required this.mode,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxHeight,
            height: constraints.maxHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 背景円

                // 塗りつぶし部分
                CustomPaint(
                  size: Size(constraints.maxHeight, constraints.maxHeight),
                  painter: FilledCirclePartsPainter(
                      parts: detail.circleColor.split(""), context: context),
                ),
                // 中央アイコン
                SizedBox(
                  width: constraints.maxHeight * 0.4,
                  height: constraints.maxHeight * 0.4,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      getIconForCategory(detail.method) ?? (mode.modeIcon),
                      color: bgColor1(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String displayLabel;
  final String method;
  final String description;
  final String appTitle;
  final Color accentColor;
  final String quizColor;

  const _CardTitle({
    required this.displayLabel,
    required this.method,
    required this.description,
    required this.appTitle,
    required this.accentColor,
    required this.quizColor,
  });

  @override
  Widget build(BuildContext context) {
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
                  l10n(context, displayLabel),
                  style: TextStyle(fontSize: 100, color: textColor1(context)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text("-${l10n(context, method)}-",
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
                    Icon(Icons.circle_outlined, size: 80, color: accentColor),
                    const SizedBox(width: 8),
                    if (appTitle == "とことん高校数学")
                      Math.tex(l10n(context, description),
                          textStyle: TextStyle(
                              fontSize: 100, color: textColor2(context)))
                    else
                      Text(l10n(context, description),
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
}

class _ScoreDisplay extends HookConsumerWidget {
  final num highScore;
  final String unit;
  final int fix;
  final Color iconColor;
  final String modeType;
  final DetailConfig config;
  final int? currentRegisteredCount;

  const _ScoreDisplay({
    required this.highScore,
    required this.unit,
    required this.fix,
    required this.iconColor,
    required this.modeType,
    required this.config,
    this.currentRegisteredCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isbattle = config.modeData.isbattle;
    final isReviewMode = modeType == "z";
    final displayValue = isReviewMode
        ? (currentRegisteredCount?.toString() ?? "--")
        : (highScore == 0.0 ? "--" : highScore.toStringAsFixed(fix));
    final icon = isbattle
        ? Icons.emoji_events
        : isReviewMode
            ? Icons.collections_bookmark
            : Icons.workspace_premium;
    final displayUnit = l10n(context, unit);

    return Expanded(
      child: FittedBox(
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 100),
            const SizedBox(width: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  displayValue,
                  style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: textColor1(context)),
                ),
                const SizedBox(width: 8),
                Text(displayUnit,
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
}

class _PlayButton extends StatelessWidget {
  final String buttonTextKey;
  final Color accentColor;
  final int? qcount;
  final VoidCallback? onPressed;

  const _PlayButton({
    required this.buttonTextKey,
    required this.accentColor,
    this.qcount,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String buttonText = (qcount != null && buttonTextKey == 'playButton')
        ? AppLocalizations.of(context)!.playButtonWithCount(qcount!)
        : l10n(context, buttonTextKey);

    final isPlayedToday = buttonTextKey == 'playedTodayButton';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, double.infinity),
            backgroundColor: isPlayedToday
                ? Colors.grey
                : (qcount == 10 ? bgColor1(context) : accentColor),
            foregroundColor: (qcount == 10 && !isPlayedToday)
                ? accentColor
                : (isPlayedToday ? Colors.white : bgColor1(context)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: (qcount == 10 && !isPlayedToday)
                ? BorderSide(color: accentColor, width: 2)
                : null,
          ),
          child: FittedBox(
            child: Text(
              buttonText,
              style:
                  const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

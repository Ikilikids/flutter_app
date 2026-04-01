import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// These typedefs are local to this file for now.

class CommonEndScreen extends ConsumerStatefulWidget {
  final num totalScore;
  final num highScore;
  final int rankAll;
  final int rankMonthly;
  final int rankWeekly;

  const CommonEndScreen({
    super.key,
    required this.totalScore,
    required this.highScore,
    required this.rankAll,
    required this.rankMonthly,
    required this.rankWeekly,
  });

  @override
  ConsumerState<CommonEndScreen> createState() => _CommonEndScreenState();
}

class _CommonEndScreenState extends ConsumerState<CommonEndScreen> {
  int step = 0; // 0:正解数 1:最高記録 2:ランキング

  @override
  void initState() {
    super.initState();

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 700));
    ref.read(appSoundProvider).playSound('pi.mp3');
    if (!mounted) return;
    setState(() => step = 1);

    await Future.delayed(const Duration(milliseconds: 700));
    ref.read(appSoundProvider).playSound('pi.mp3');
    if (!mounted) return;
    setState(() => step = 2);

    await Future.delayed(const Duration(milliseconds: 700));
    ref.read(appSoundProvider).playSound('pipi.mp3');
    if (!mounted) return;
    setState(() => step = 3);
  }

  @override
  Widget build(BuildContext context) {
    final _quizinfo = ref.watch(currentDetailConfigProvider);
    Color quizColor =
        getQuizColor2(_quizinfo.detail.color, context, 1, 0.35, 0.95);
    String unit = _quizinfo.modeData.unit;
    int fix = _quizinfo.modeData.fix;
    print(widget.highScore);

    return PopScope(
      canPop: false,
      child: AppAdScaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _QuizNameSection(
                    quizName: _quizinfo.detail.displayLabel,
                    backgroundColor: quizColor,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _ScoreSection(
                    score: step >= 1 ? widget.totalScore : null,
                    borderColor: quizColor,
                    fix: fix,
                    unit: unit,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _HighScoreSection(
                      score: step >= 2 ? widget.highScore : null,
                      fix: fix,
                      unit: unit),
                ),
                Expanded(
                  flex: 2,
                  child: _RankSection(
                    rankAll: step >= 3 ? widget.rankAll : null,
                    rankMonthly: step >= 3 ? widget.rankMonthly : null,
                    rankWeekly: step >= 3 ? widget.rankWeekly : null,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ActionSection(
                    backgroundColor: quizColor,
                    isLimitedMode: _quizinfo.modeData.islimited,
                    stepEnd: step >= 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizNameSection extends StatelessWidget {
  final String quizName;
  final Color backgroundColor;

  const _QuizNameSection({
    required this.quizName,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 4),
                    color: Color.fromARGB(22, 0, 0, 0),
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '★${l10n(context, quizName)}★',
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

class _ScoreSection extends StatelessWidget {
  final num? score;
  final Color borderColor;
  final int fix;
  final String unit;

  const _ScoreSection({
    required this.score,
    required this.borderColor,
    required this.fix,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final localizedUnit = l10n(context, 'unitSecond');
    final title = unit == localizedUnit
        ? l10n(context, 'timeLabel')
        : l10n(context, 'scoreLabel');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: FittedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor1(context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor2(context),
                  border: Border.all(color: borderColor, width: 3),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        score == null ? " " : score!.toStringAsFixed(fix),
                        style: TextStyle(
                          fontSize: 1000,
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n(context, unit),
                        style: TextStyle(
                          fontSize: 400,
                          fontWeight: FontWeight.w600,
                          color: textColor1(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighScoreSection extends StatelessWidget {
  final num? score;
  final int fix;
  final String unit;
  const _HighScoreSection({
    required this.score,
    required this.fix,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final prefix = l10n(context, 'highScorePrefix');
    final localizedUnit = l10n(context, unit);
    String text;
    if (score == null) {
      text = "$prefix  $localizedUnit";
    } else if (score == 0.0) {
      text = "$prefix--$localizedUnit";
    } else {
      text = '$prefix${score!.toStringAsFixed(fix)}$localizedUnit';
    }

    return Row(
      children: [
        Expanded(
          child: FittedBox(
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor1(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

class _RankSection extends StatelessWidget {
  final int? rankAll;
  final int? rankMonthly;
  final int? rankWeekly;

  const _RankSection({
    this.rankAll,
    this.rankMonthly,
    this.rankWeekly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _RankCard(
              label: l10n(context, 'allPeriod'),
              value: rankAll == 0 ? "--" : rankAll?.toString() ?? ' ',
              color: Colors.orange,
              borderColor: Colors.orange,
            ),
          ),
          Expanded(
            child: _RankCard(
              label: l10n(context, 'monthlyPeriod'),
              value: rankMonthly == 0 ? "--" : rankMonthly?.toString() ?? ' ',
              color: Colors.blue,
              borderColor: Colors.blue,
            ),
          ),
          Expanded(
            child: _RankCard(
              label: l10n(context, 'weeklyPeriod'),
              value: rankWeekly == 0 ? "--" : rankWeekly?.toString() ?? ' ',
              color: Colors.green,
              borderColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  final Color backgroundColor;
  final bool isLimitedMode;
  final bool stepEnd;

  const _ActionSection({
    required this.backgroundColor,
    required this.isLimitedMode,
    required this.stepEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionItem(
            backgroundColor: backgroundColor,
            icon: Icons.refresh,
            label: l10n(context, 'retryButton'),
            onTap: isLimitedMode || !stepEnd
                ? null
                : () {
                    InterstitialAdHelper.navigate(
                        context, CommonCountdownScreen());
                  },
          ),
          _ActionItem(
            backgroundColor: backgroundColor,
            icon: Icons.home,
            label: l10n(context, 'menuButton'),
            onTap: !stepEnd
                ? null
                : () {
                    InterstitialAdHelper.navigate(context, null);
                  },
          ),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color borderColor;

  const _RankCard({
    required this.label,
    required this.value,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: bgColor1(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor2(context),
                border: Border.all(color: borderColor, width: 2),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 1000,
                        fontWeight: FontWeight.w600,
                        color: textColor1(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n(context, 'rankUnit'),
                      style: TextStyle(
                        fontSize: 400,
                        fontWeight: FontWeight.w600,
                        color: textColor1(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 1,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  disabledBackgroundColor: Theme.of(context).disabledColor,
                  disabledForegroundColor: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withAlpha(128),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(icon, color: textColor1(context), size: 100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 100,
                      color: textColor1(context)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

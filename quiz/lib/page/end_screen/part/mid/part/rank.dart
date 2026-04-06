import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankSection extends ConsumerWidget {
  const RankSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRankList = ref.watch(myRankListProvider);
    final myScoreList = ref.watch(myScoreListProvider);
    final rankAll = myRankList[0];
    final rankMonthly = myRankList[1];
    final rankWeekly = myRankList[2];
    final scoreAll = myScoreList[0];
    final scoreMonthly = myScoreList[1];
    final scoreWeekly = myScoreList[2];
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _RankCard(
                    label: l10n(context, 'allPeriod'),
                    value: scoreAll.toString(),
                    color: Colors.orange,
                    borderColor: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _RankCard(
                    label: l10n(context, 'monthlyPeriod'),
                    value: scoreMonthly.toString(),
                    color: Colors.blue,
                    borderColor: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _RankCard(
                    label: l10n(context, 'weeklyPeriod'),
                    value: scoreWeekly.toString(),
                    color: Colors.green,
                    borderColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _RankCard(
                    label: l10n(context, 'allPeriod'),
                    value: rankAll == 0 ? "--" : rankAll.toString(),
                    color: Colors.orange,
                    borderColor: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _RankCard(
                    label: l10n(context, 'monthlyPeriod'),
                    value: rankMonthly == 0 ? "--" : rankMonthly.toString(),
                    color: Colors.blue,
                    borderColor: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _RankCard(
                    label: l10n(context, 'weeklyPeriod'),
                    value: rankWeekly == 0 ? "--" : rankWeekly.toString(),
                    color: Colors.green,
                    borderColor: Colors.green,
                  ),
                ),
              ],
            ),
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

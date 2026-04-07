import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'rank.freezed.dart';

class RankSection extends ConsumerWidget {
  const RankSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mapとして監視
    final myRankMap = ref.watch(myRankMapProvider);
    final myScoreMap = ref.watch(myScoreMapProvider);

    final quizinfo = ref.watch(currentDetailConfigProvider);
    final fix = quizinfo.modeData.fix;

    // 1. ラベルと色を返すシンプルな関数を用意する
    String getLabel(PeriodType type) {
      return switch (type) {
        PeriodType.all => l10n(context, 'allPeriod'),
        PeriodType.month => l10n(context, 'monthlyPeriod'),
        PeriodType.week => l10n(context, 'weeklyPeriod'),
      };
    }

    Color getColor(PeriodType type) {
      return switch (type) {
        PeriodType.all => Colors.orange,
        PeriodType.month => Colors.blue,
        PeriodType.week => Colors.green,
      };
    }

    // 2. テンプレートに値を流し込む
    List<PeriodData> fillValues(Map<PeriodType, num> source,
        {required bool isRank}) {
      return PeriodType.values.map((type) {
        final rawValue = source[type] ?? 0;

        final String displayValue = isRank
            ? (rawValue == 0 ? "--" : rawValue.toString())
            : (rawValue.toDouble().toStringAsFixed(fix));

        final String unit = isRank
            ? l10n(context, 'rankUnit')
            : l10n(context, quizinfo.modeData.unit);

        return PeriodData(
          label: getLabel(type), // 分けた関数から取得
          color: getColor(type), // 分けた関数から取得
          value: displayValue,
          unit: unit,
        );
      }).toList();
    }

    final label = switch (quizinfo.timeMode) {
      TimeMode.learning => "合計正解数",
      TimeMode.countDown => "highScorePrefix",
      TimeMode.timeAttack => "highScorePrefix",
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(label: label),
          Expanded(
            child: _buildRow(fillValues(myScoreMap, isRank: false)),
          ),
          const SizedBox(height: 12),
          _SectionHeader(label: "rankingTitle"),
          Expanded(
            child: _buildRow(fillValues(myRankMap, isRank: true)),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<PeriodData> periods) {
    return Row(
      children:
          periods.map((p) => Expanded(child: _RankCard(periods: p))).toList(),
    );
  }
}

class _RankCard extends StatelessWidget {
  final PeriodData periods;

  const _RankCard({required this.periods});

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
                color: periods.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  periods.label,
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
                border: Border.all(color: periods.color, width: 2),
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
                      periods.value,
                      style: TextStyle(
                        fontSize: 1000,
                        fontWeight: FontWeight.w600,
                        color: textColor1(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      periods.unit,
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

@freezed
class PeriodData with _$PeriodData {
  const factory PeriodData({
    required String label,
    required Color color,
    @Default('') String value,
    @Default('') String unit,
  }) = _PeriodData;
}

class _SectionHeader extends ConsumerWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizinfo = ref.watch(currentDetailConfigProvider);

    final iconData = switch (quizinfo.timeMode) {
      TimeMode.learning => Icons.workspace_premium,
      TimeMode.countDown => Icons.local_fire_department,
      TimeMode.timeAttack => Icons.local_fire_department,
    };
    final sideIcon = Icon(
      label != "rankingTitle" ? iconData : Icons.emoji_events,
      size: 18,
      color: textColor1(context).withValues(alpha: 0.7),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 必要な分だけ幅を取る
        children: [
          sideIcon,
          const SizedBox(width: 6),
          Text(
            l10n(context, label),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor1(context).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 6),
          sideIcon,
        ],
      ),
    );
  }
}

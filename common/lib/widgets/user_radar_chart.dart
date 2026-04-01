import 'package:common/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RadarChartItem {
  final dynamic tab;
  final dynamic midData;
  RadarChartItem({required this.tab, required this.midData});
}

class UserRadarChart extends StatelessWidget {
  final MidData midData; // 単一モード用（互換性維持）
  final Map<String, Map<String, dynamic>> scoreMap;
  final Map<String, double> topScoreMap;
  final Color activeColor;

  const UserRadarChart({
    super.key,
    required this.midData,
    required this.scoreMap,
    required this.topScoreMap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    // 表示する項目のリストを作成
    final List<RadarChartItem> items = (midData.modeData.rankingList as List)
        .map((tab) => RadarChartItem(tab: tab, midData: midData))
        .toList();

    if (items.isEmpty || items.length < 3) {
      return const SizedBox.shrink();
    }

    final List<RadarEntry> entries = [];
    final List<String> axisTitles = [];

    for (var item in items) {
      final tab = item.tab;
      final mData = item.midData;
      final modeType = mData.modeData.modeType;
      final isSmallerBetter = mData.modeData.isSmallerBetter;

      final docId = "${tab.id}_$modeType";
      final data = scoreMap[docId];
      final score = (data?['score'] as num?)?.toDouble() ?? 0.0;
      final topScore =
          topScoreMap[docId] ?? (tab.id == "全合計" ? 3000.0 : 1000.0);

      double normalizedValue = 0.0;
      if (score > 0 && topScore > 0) {
        if (isSmallerBetter) {
          double val = 100 - ((score - topScore) / (topScore * 0.5) * 100);
          normalizedValue = val.clamp(0.0, 100.0);
        } else {
          normalizedValue = (score / topScore) * 100;
        }
      }

      entries.add(
          RadarEntry(value: normalizedValue > 100 ? 100 : normalizedValue));
// タイトルに1位の記録を追加
      final formattedTop = topScore.toStringAsFixed(mData.modeData.fix);
      final unit = l10n(context, mData.modeData.unit);
      axisTitles
          .add("${l10n(context, tab.display)}\n(Max: $formattedTop$unit)");
    }

    if (entries.length < 3) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: Colors.transparent,
              borderColor: Colors.transparent,
              entryRadius: 0,
              dataEntries: List.generate(
                  entries.length, (_) => const RadarEntry(value: 0)),
              borderWidth: 0,
            ),
            RadarDataSet(
              fillColor: Colors.transparent,
              borderColor: textColor1(context),
              entryRadius: 0,
              dataEntries: List.generate(
                  entries.length, (_) => const RadarEntry(value: 100)),
              borderWidth: 1.5,
            ),
            RadarDataSet(
              fillColor: activeColor.withAlpha(50),
              borderColor: activeColor,
              entryRadius: 2,
              dataEntries: entries,
              borderWidth: 1.5,
            ),
          ],
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.transparent),
          gridBorderData: BorderSide(color: Colors.grey.withAlpha(140)),
          tickCount: 10,
          ticksTextStyle:
              const TextStyle(color: Colors.transparent, fontSize: 0),
          tickBorderData: BorderSide(color: Colors.grey.withAlpha(50)),
          radarShape: RadarShape.polygon,
          getTitle: (index, angle) {
            return RadarChartTitle(
              text: axisTitles[index],
              angle: 0,
            );
          },
          titleTextStyle:
              const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

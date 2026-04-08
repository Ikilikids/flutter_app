import 'package:common/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserRadarChart extends StatelessWidget {
  final MidData midData;
  final Map<String, UserDialogData> dataMap; // ここを構造体のMapに変更
  final Color activeColor;

  const UserRadarChart({
    super.key,
    required this.midData,
    required this.dataMap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> rankingList = midData.modeData.rankingList ?? [];

    // レーダーチャートは最低3項目必要
    if (rankingList.length < 3) {
      return const SizedBox.shrink();
    }

    final List<RadarEntry> entries = [];
    final List<String> axisTitles = [];

    for (var tab in rankingList) {
      final modeType = midData.modeData.modeType;
      final isSmallerBetter = midData.modeData.isSmallerBetter;
      final docId = "${tab.id}_$modeType";

      // 直接構造体から取得
      final item = dataMap[docId] ?? UserDialogData.empty();
      final score = item.score;
      final topScore = item.topScore;

      double normalizedValue = 0.0;
      if (score > 0 && topScore > 0) {
        if (isSmallerBetter) {
          // 小さい方が良い場合（タイムなど）の正規化
          double val = 100 - ((score - topScore) / (topScore * 0.5) * 100);
          normalizedValue = val.clamp(0.0, 100.0);
        } else {
          // 大きい方が良い場合（点数など）の正規化
          normalizedValue = (score / topScore) * 100;
        }
      }

      entries.add(
          RadarEntry(value: normalizedValue > 100 ? 100 : normalizedValue));

      final formattedTop =
          topScore == 0 ? "--" : topScore.toStringAsFixed(midData.modeData.fix);
      final unit = l10n(context, midData.modeData.unit);
      axisTitles
          .add("${l10n(context, tab.display)}\n(Max: $formattedTop$unit)");
    }

    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: RadarChart(
        RadarChartData(
          dataSets: [
            // 背景（0%ライン）
            RadarDataSet(
              fillColor: Colors.transparent,
              borderColor: Colors.transparent,
              entryRadius: 0,
              dataEntries: List.generate(
                  entries.length, (_) => const RadarEntry(value: 0)),
              borderWidth: 0,
            ),
            // 外枠（100%ライン）
            RadarDataSet(
              fillColor: Colors.transparent,
              borderColor: textColor1(context),
              entryRadius: 0,
              dataEntries: List.generate(
                  entries.length, (_) => const RadarEntry(value: 100)),
              borderWidth: 1.5,
            ),
            // 実データ
            RadarDataSet(
              fillColor: activeColor.withAlpha(50),
              borderColor: activeColor,
              entryRadius: 2,
              dataEntries: entries,
              borderWidth: 1.5,
            ),
          ],
          // 以下、元のデザインを維持
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.transparent),
          gridBorderData: BorderSide(color: Colors.grey.withAlpha(140)),
          tickCount: 10,
          ticksTextStyle:
              const TextStyle(color: Colors.transparent, fontSize: 0),
          tickBorderData: BorderSide(color: Colors.grey.withAlpha(50)),
          radarShape: RadarShape.polygon,
          getTitle: (index, angle) =>
              RadarChartTitle(text: axisTitles[index], angle: 0),
          titleTextStyle:
              const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rakuraku_amedas/formula.dart';

class TempPieChart extends StatelessWidget {
  final Map<String, double> data; // 各項目の日数や値
  const TempPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 固定順序 (気温カテゴリ)
    final tempOrder = ["猛暑日", "真夏日", "夏日", "その他", "冬日", "真冬日"];
    final hasMoushoday = data.keys.contains("猛暑日");

    // 並び順決定
    final keys =
        hasMoushoday
              ? tempOrder.where((k) => data.containsKey(k)).toList()
              : data.keys.toList()
          ..sort(
            (a, b) => _extractFirstNumber(a).compareTo(_extractFirstNumber(b)),
          );
    // 差分計算
    final adjustedData = <String, double>{};
    if (hasMoushoday) {
      // 気温カテゴリの場合
      adjustedData["猛暑日"] = data["猛暑日"] ?? 0;
      adjustedData["真夏日"] = (data["真夏日"] ?? 0) - adjustedData["猛暑日"]!;
      adjustedData["夏日"] =
          (data["夏日"] ?? 0) - adjustedData["真夏日"]! - adjustedData["猛暑日"]!;
      adjustedData["真冬日"] = data["真冬日"] ?? 0;
      adjustedData["冬日"] = (data["冬日"] ?? 0) - adjustedData["真冬日"]!;
      adjustedData["その他"] = data["合計日数"]! - data["冬日"]! - data["夏日"]!;
    } else {
      // 非気温カテゴリの場合 (降水量など)
      final reversedKeys = keys.toList().reversed;
      double accumulated = 0;
      for (var key in reversedKeys) {
        if (key == "合計日数") continue; // ← 合計日数は処理しない
        final value = data[key] ?? 0;
        double diff = value - accumulated;
        if (diff < 0) diff = 0;
        adjustedData[key] = diff;
        accumulated += diff;
      }

      final sumKnown = adjustedData.entries
          .where((e) => (e.key != "その他"))
          .fold(0.0, (sum, e) => sum + e.value);
      adjustedData["その他"] = data["合計日数"]! - sumKnown;
    }

    // 合計値計算
    final total = adjustedData.values.fold(0.0, (sum, val) => sum + val);

    // PieChartセクション生成
    final sections = keys.map((key) {
      final value = adjustedData[key] ?? 0;
      final percent = total > 0 ? (value / total) * 100 : 0;

      return PieChartSectionData(
        value: value,
        color: getItemColor(key),
        title: percent > 5 ? "${percent.toStringAsFixed(1)}%" : "",
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 30,
          sectionsSpace: 1,
          startDegreeOffset: -90,
        ),
      ),
    );
  }

  // 文字列中の最初の数字を抽出 (数字がなければ最後にソート)
  int _extractFirstNumber(String text) {
    final match = RegExp(r'\d+').firstMatch(text);
    return match != null ? int.parse(match.group(0)!) : 9999;
  }
}

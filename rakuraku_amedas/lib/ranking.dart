import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rakuraku_amedas/amedasmap.dart';
import 'package:rakuraku_amedas/detailpage.dart';
import 'package:rakuraku_amedas/formula.dart';

import 'dropdownbutton.dart';

// 地方・都道府県マップ
const Map<String, List<String>> regionMap = {
  "東北地方": ["青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県"],
  "関東地方": ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県"],
  "中部地方": ["新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県"],
  "近畿地方": ["三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"],
  "中国地方": ["鳥取県", "島根県", "岡山県", "広島県", "山口県"],
  "四国地方": ["徳島県", "香川県", "愛媛県", "高知県"],
  "九州地方": ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県"],
};

// 島部除くプレフィックス
const List<String> excludedPrefixes = [
  "886",
  "887",
  "888",
  "889",
  "4417",
  "442",
  "443",
];

// 気温系指標
const tempMetrics = [
  "ht35",
  "ht30",
  "ht25",
  "lt0",
  "ht0",
  "lt25",
  "temp",
  "maxTemp",
  "minTemp",
];

// 指標ラベル
const Map<String, String> metricLabels = {
  "temp": "平均気温",
  "maxTemp": "平均最高気温",
  "minTemp": "平均最低気温",
  "rain": "降水量",
  "snow": "降雪量",
  "sun": "日照時間",
  "wind": "風速",
  "ht35": "猛暑日",
  "ht30": "真夏日",
  "ht25": "夏日",
  "lt0": "冬日",
  "ht0": "真冬日",
  "lt25": "熱帯夜",
  "p1": "降水量1mm以上",
  "p10": "降水量10mm以上",
  "p30": "降水量30mm以上",
  "p50": "降水量50mm以上",
  "p70": "降水量70mm以上",
  "p100": "降水量100mm以上",
  "ky3": "降雪量3cm以上",
  "ky5": "降雪量5cm以上",
  "ky10": "降雪量10cm以上",
  "ky20": "降雪量20cm以上",
  "ky50": "降雪量50cm以上",
  "sy5": "積雪量5cm以上",
  "sy10": "積雪量10cm以上",
  "sy20": "積雪量20cm以上",
  "sy50": "積雪量50cm以上",
  "sy100": "積雪量100cm以上",
  "w10": "風速10m/s以上",
  "w15": "風速15m/s以上",
  "w20": "風速20m/s以上",
  "w30": "風速30m/s以上",
};

class RankingPage extends StatefulWidget {
  final List<ObservationPoint> points;
  const RankingPage({super.key, required this.points});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  String selectedMetric = "temp";
  int selectedMonth = 12;
  String? selectedPrefecture = "全国";
  bool ascending = true; // trueなら昇順、falseなら降順
  String? getSafePrefectureValue(String? value, List<dynamic> items) {
    final strings = items.whereType<String>().toList();
    if (value != null && strings.contains(value)) return value;
    return null; // 存在しなければ全国にリセット
  }

  @override
  Widget build(BuildContext context) {
    // ソート済みランキング
    final sortedPoints =
        widget.points.where((p) {
          if (p.monthlyData[selectedMetric] == null) return false;
          return _isPointInRegion(p, selectedPrefecture, selectedMetric);
        }).toList()..sort((a, b) {
          final aData = a.monthlyData[selectedMetric]![selectedMonth];
          final bData = b.monthlyData[selectedMetric]![selectedMonth];
          final aRank = aData[1];
          final bRank = bData[1];

          int cmp;
          if (aRank != bRank) {
            cmp = aRank.compareTo(bRank);
          } else {
            cmp = bData[0].compareTo(aData[0]);
          }

          return ascending ? cmp : -cmp; // 昇順ならそのまま、降順なら反転
        });

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Row(
              children: [
                // 指標
                SizedBox(
                  width: 170.w, // 固定幅。文字がはみ出してもOK
                  child: DropdownButton<String>(
                    value: selectedMetric,
                    isExpanded: true, // 子の幅いっぱいに広がる
                    items: metricLabels.entries
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(
                              e.value,
                              style: TextStyle(fontSize: min(16.sp, 16)),
                            ), // はみ出しても表示
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;

                      setState(() {
                        selectedMetric = val;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 60.w, // 固定幅。文字がはみ出してもOK
                  child: DropdownButton<bool>(
                    value: ascending,
                    items: [
                      DropdownMenuItem(
                        value: true,
                        child: Text(
                          "昇順",
                          style: TextStyle(fontSize: min(16.sp, 16)),
                        ),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text(
                          "降順",
                          style: TextStyle(fontSize: min(16.sp, 16)),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => ascending = val);
                      }
                    },
                  ),
                ),

                // 月
                SizedBox(
                  width: 60.w, // 固定幅。文字がはみ出してもOK
                  child: DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(
                      13,
                      (i) => DropdownMenuItem(
                        value: i,
                        child: Text(
                          i == 12 ? "年間" : "${i + 1}月",
                          style: TextStyle(fontSize: min(16.sp, 16)),
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedMonth = val);
                    },
                  ),
                ),

                SizedBox(
                  width: 100.w,
                  child: DropdownButton<String?>(
                    isExpanded: true,
                    value: getSafePrefectureValue(
                      selectedPrefecture,
                      tempMetrics.contains(selectedMetric)
                          ? prefectureList
                          : prefectureList2
                                .where(
                                  (item) => item != "島を除く" && item != "島嶼部",
                                )
                                .toList(),
                    ),
                    items:
                        (tempMetrics.contains(selectedMetric)
                                ? prefectureList
                                : prefectureList2
                                      .where(
                                        (item) =>
                                            item != "島を除く" && item != "島嶼部",
                                      )
                                      .toList())
                            .map((item) {
                              if (item is String) return selectItem(item);
                              if (item is TitleItem) return titleItem(item);
                              throw Exception('未知の型: $item');
                            })
                            .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => selectedPrefecture = val);
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: sortedPoints.length,
              itemBuilder: (context, index) {
                final point = sortedPoints[index];
                final nationwideRank =
                    point.monthlyData[selectedMetric]![selectedMonth][1];
                final value =
                    point.monthlyData[selectedMetric]![selectedMonth][0];
                String displayValue = selectedMetric == "snow"
                    ? value.toStringAsFixed(1)
                    : (value / 10).toStringAsFixed(1);
                displayValue = "$displayValue${_getUnit(selectedMetric)}";

                int prefectureRank = 1;
                if (selectedPrefecture != null) {
                  final prefPoints = widget.points
                      .where(
                        (p) =>
                            p.monthlyData[selectedMetric]?[selectedMonth] !=
                                null &&
                            _isPointInRegion(
                              p,
                              selectedPrefecture,
                              selectedMetric,
                            ),
                      )
                      .toList();

                  prefectureRank = calculatePrefectureRank(
                    prefPoints,
                    point,
                    selectedMetric,
                    selectedMonth,
                  );
                }

                final rankText = selectedPrefecture == null
                    ? "$nationwideRank位"
                    : "$prefectureRank位\n($nationwideRank位)";

                return ListTile(
                  leading: Text(rankText, textAlign: TextAlign.center),
                  title: Row(
                    children: [
                      Icon(
                        geticon(point.officialName), // ←引数必須,

                        size: 18,
                      ),
                      const SizedBox(width: 6), // アイコンとテキストの間の余白
                      Text(
                        point.officialName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    point.prefecture,
                    style: TextStyle(
                      color: getFullRegionColor(point.prefecture),
                    ),
                  ),
                  trailing: Text(
                    displayValue,
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(point: point)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isPointInRegion(ObservationPoint p, String? region, String metric) {
    if (region == null) return true;
    final isTemp = tempMetrics.contains(metric);
    if (region == "全国") return true;
    if (region == "島を除く") {
      if (!isTemp) return false;
      if (p.prefecture == "沖縄県") return false;
      return !excludedPrefixes.any(
        (prefix) => p.number.toString().startsWith(prefix),
      );
    }

    if (region == "島嶼部") {
      if (!isTemp) return false;
      if (p.prefecture == "沖縄県") return true;
      return excludedPrefixes.any(
        (prefix) => p.number.toString().startsWith(prefix),
      );
    }

    // 九州・関東などで気温系のみ除外
    if (isTemp &&
        (region == "九州地方" ||
            region == "関東地方" ||
            region == "東京都" ||
            region == "鹿児島県")) {
      if (excludedPrefixes.any(
        (prefix) => p.number.toString().startsWith(prefix),
      )) {
        return false;
      }
    }

    return regionMap[region]?.contains(p.prefecture) ??
        (p.prefecture == region);
  }

  int calculatePrefectureRank(
    List<ObservationPoint> points,
    ObservationPoint target,
    String metric,
    int month,
  ) {
    final sorted =
        points.where((p) => p.monthlyData[metric]?[month] != null).toList()
          ..sort(
            (a, b) => b.monthlyData[metric]![month][0].compareTo(
              a.monthlyData[metric]![month][0],
            ),
          );

    int rank = 1;

    double? prevValue;

    for (var i = 0; i < sorted.length; i++) {
      final value = sorted[i].monthlyData[metric]![month][0].toDouble();

      if (prevValue != null && value == prevValue) {
      } else {
        rank = i + 1;
      }

      prevValue = value;

      if (sorted[i] == target) return rank;
    }

    return rank; // 念のため
  }

  String _getUnit(String metric) {
    const dayMetrics = [
      "ht35",
      "ht30",
      "ht25",
      "lt0",
      "ht0",
      "lt25",
      "p1",
      "p10",
      "p30",
      "p50",
      "p70",
      "p100",
      "ky3",
      "ky5",
      "ky10",
      "ky20",
      "ky50",
      "sy5",
      "sy10",
      "sy20",
      "sy50",
      "sy100",
      "w10",
      "w15",
      "w20",
      "w30",
    ];
    if (dayMetrics.contains(metric)) return "日";
    if (metric == "rain") return "mm";
    if (metric == "temp" || metric == "maxTemp" || metric == "minTemp") {
      return "℃";
    }
    if (metric == "sun") return "時間";
    if (metric == "snow") return "cm";
    if (metric == "wind") return "m/s";
    return "";
  }
}

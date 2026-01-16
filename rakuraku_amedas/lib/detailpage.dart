import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rakuraku_amedas/amedasmap.dart';
import 'package:rakuraku_amedas/circle_chart.dart';
import 'package:rakuraku_amedas/formula.dart';
import 'package:rakuraku_amedas/main.dart';
import 'package:rakuraku_amedas/uonzu.dart';
import 'package:flutter/foundation.dart'; // ← kIsWebを使う場合必須
import 'hyou.dart';

class DetailPage extends StatelessWidget {
  final ObservationPoint point;

  const DetailPage({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0, // 左の余白をなくす
          title: Row(
            children: [
              Icon(
                geticon(point.officialName), // ←引数必須,

                size: 20,
              ),
              const SizedBox(width: 6), // アイコンとテキストの間の余白
              Text(point.officialName, style: const TextStyle(fontSize: 20)),
            ],
          ),
          bottom: TabBar(
            labelColor: getFullRegionColor(
              point.prefecture,
            ).withValues(alpha: 1),
            indicatorColor: getFullRegionColor(
              point.prefecture,
            ).withValues(alpha: 1),
            tabs: [
              Tab(text: "基本情報"),
              Tab(text: "雨温図"),
              Tab(text: "詳細データ"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  DetailInfoPage(point: point),
                  RainTempPage(point: point),
                  TempInfoTabPage(point: point),
                ],
              ),
            ),
            if (!kIsWeb) SizedBox(height: 50, child: const BannerAdWidget()),
          ],
        ),
      ),
    );
  }
}

/// 雨温図ページ
class RainTempPage extends StatelessWidget {
  final ObservationPoint point;
  const RainTempPage({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? null : getBackRegionColor(point.prefecture),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 雨温図
              RainTempChart(
                monthlyRains: point.monthlyData["rain"],
                monthlyTemps: point.monthlyData["temp"],
              ),

              SizedBox(height: 24.h),

              // データ表
              RainTempTable(
                monthlyRains: point.monthlyData["rain"],
                monthlyTemps: point.monthlyData["temp"],
                monthlyMaxTemps: point.monthlyData["maxTemp"],
                monthlyMinTemps: point.monthlyData["minTemp"],
                monthlySuns: point.monthlyData["sun"],
                monthlySnows: point.monthlyData["snow"],
                monthlyWinds: point.monthlyData["wind"],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 気温タブページ（月切り替え対応版）
class TempInfoTabPage extends StatefulWidget {
  final ObservationPoint point;
  const TempInfoTabPage({super.key, required this.point});

  @override
  State<TempInfoTabPage> createState() => _TempInfoTabPageState();
}

class _TempInfoTabPageState extends State<TempInfoTabPage> {
  int selectedMonth = 12; // 0〜11 → 各月, 12 → 通年

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DefaultTabController(
            length: 5,
            child: Column(
              children: [
                Container(
                  color: null,
                  child: TabBar(
                    labelColor: getFullRegionColor(
                      widget.point.prefecture,
                    ).withValues(alpha: 1),
                    indicatorColor: getFullRegionColor(
                      widget.point.prefecture,
                    ).withValues(alpha: 1),
                    isScrollable: false,

                    labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    tabs: const [
                      Tab(text: "気温"),
                      Tab(text: "降水量"),
                      Tab(text: "降雪量"),
                      Tab(text: "積雪量"),
                      Tab(text: "最大風速"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTempContent(),
                      _buildRainContent(),
                      _buildKsnowContent(),
                      _buildSsnowContent(),
                      _buildWindContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// --- 気温 ---
  Widget _buildTempContent() {
    final dayKeys = {
      "猛暑日": "ht35",
      "真夏日": "ht30",
      "夏日": "ht25",
      "冬日": "lt0",
      "真冬日": "ht0",
      "熱帯夜": "lt25",
    };
    final dayData = generateDayData(
      widget.point,
      dayKeys,
      monthIndex: selectedMonth,
    );
    return _buildDayColumn(dayData, dayKeys, div: 10, totalRank: 904);
  }

  /// --- 降水量 ---
  Widget _buildRainContent() {
    final dayKeys = {
      "降水量\n1mm以上": "p1",
      "降水量\n10mm以上": "p10",
      "降水量\n30mm以上": "p30",
      "降水量\n50mm以上": "p50",
      "降水量\n70mm以上": "p70",
      "降水量\n100mm以上": "p100",
    };
    final dayData = generateDayData(
      widget.point,
      dayKeys,
      monthIndex: selectedMonth,
    );
    return _buildDayColumn(dayData, dayKeys, div: 10, totalRank: 1230);
  }

  /// --- 降雪量 ---
  Widget _buildKsnowContent() {
    final dayKeys = {
      "降雪量\n3cm以上": "ky3",
      "降雪量\n5cm以上": "ky5",
      "降雪量\n10cm以上": "ky10",
      "降雪量\n20cm以上": "ky20",
      "降雪量\n50cm以上": "ky50",
    };
    final dayData = generateDayData(
      widget.point,
      dayKeys,
      monthIndex: selectedMonth,
    );
    return _buildDayColumn(dayData, dayKeys, div: 10, totalRank: 320);
  }

  /// --- 積雪量 ---
  Widget _buildSsnowContent() {
    final dayKeys = {
      "積雪量\n5cm以上": "sy5",
      "積雪量\n10cm以上": "sy10",
      "積雪量\n20cm以上": "sy20",
      "積雪量\n50cm以上": "sy50",
      "積雪量\n100cm以上": "sy100",
    };
    final dayData = generateDayData(
      widget.point,
      dayKeys,
      monthIndex: selectedMonth,
    );
    return _buildDayColumn(dayData, dayKeys, div: 10, totalRank: 320);
  }

  /// --- 最大風速 ---
  Widget _buildWindContent() {
    final dayKeys = {
      "平均風速\n10m/s以上": "w10",
      "平均風速\n15m/s以上": "w15",
      "平均風速\n20m/s以上": "w20",
      "平均風速\n30m/s以上": "w30",
    };
    final dayData = generateDayData(
      widget.point,
      dayKeys,
      monthIndex: selectedMonth,
    );
    return _buildDayColumn(dayData, dayKeys, div: 10, totalRank: 874);
  }

  /// 共通カラム
  Widget _buildDayColumn(
    Map<String, double> data,
    Map<String, String> keys, {
    required double div,
    required int totalRank,
  }) {
    final months = List.generate(12, (i) => "${i + 1}月") + ["通年"];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? null : getBackRegionColor(widget.point.prefecture),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(
                alignment: const Alignment(0, -0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // --- ラベルとDropdownを横並びに配置 ---
                    Row(
                      children: [
                        infoLabel(Icons.pie_chart, '割合データ'),
                        const Spacer(),
                        DropdownButton<int>(
                          value: selectedMonth,
                          underline: const SizedBox(),
                          items: List.generate(
                            months.length,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text(
                                months[index],
                                style: TextStyle(
                                  fontSize: min(
                                    16.sp,
                                    16.h,
                                  ), // flutter_screenutil を使う場合
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => selectedMonth = value!);
                          },
                        ),
                        SizedBox(width: 12.w),
                      ],
                    ),

                    SizedBox(height: 2.h),
                    TempPieChart(data: data),

                    // --- 数値データ ---
                    infoLabel(Icons.book, '数値データ'),
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: InfoListWidget(
                        data: keys.map(
                          (displayName, key) => MapEntry(
                            displayName,
                            formatRank(
                              widget.point,
                              key,
                              div: div,
                              totalRank: totalRank,
                              monthIndex: selectedMonth, // ★ ここを追加
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 詳細情報ページ
/// 詳細情報ページ（月切り替え対応版）
class DetailInfoPage extends StatefulWidget {
  final ObservationPoint point;
  const DetailInfoPage({super.key, required this.point});

  @override
  State<DetailInfoPage> createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> {
  int selectedMonth = 12; // 0〜11 → 各月, 12 → 通年

  @override
  Widget build(BuildContext context) {
    final cityClean = widget.point.city.replaceAll(RegExp(r'[\s\r\n]+'), '');
    final months = List.generate(12, (i) => "${i + 1}月") + ["通年"];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? null : getBackRegionColor(widget.point.prefecture),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(
                alignment: const Alignment(0, -0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    infoLabel(Icons.location_on, '位置データ'),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: InfoListWidget(
                        data: {
                          "観測地点/カナ":
                              "${widget.point.name}/${hankakuToZenkakuKana(widget.point.kana)}",
                          "都道府県/市町村": "${widget.point.prefecture}/$cityClean",
                          "緯度,経度":
                              "(${widget.point.latlng.latitude}, ${widget.point.latlng.longitude})",
                          "標高": "${widget.point.elevation} m",
                        },
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // --- 基本データ ---
                    Row(
                      children: [
                        infoLabel(Icons.book, '基本データ'),
                        const Spacer(),
                        DropdownButton<int>(
                          value: selectedMonth,
                          underline: const SizedBox(),
                          items: List.generate(
                            months.length,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text(
                                months[index],
                                style: TextStyle(
                                  fontSize: min(
                                    16.sp,
                                    16.h,
                                  ), // flutter_screenutil を使う場合
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => selectedMonth = value!);
                          },
                        ),
                        SizedBox(width: 12.w),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: InfoListWidget(
                        data: {
                          "平均気温": formatRank(
                            widget.point,
                            "temp",
                            div: 10,
                            totalRank: 904,
                            unit: "℃",
                            monthIndex: selectedMonth,
                          ),
                          "平均最高気温": formatRank(
                            widget.point,
                            "maxTemp",
                            div: 10,
                            totalRank: 904,
                            unit: "℃",
                            monthIndex: selectedMonth,
                          ),
                          "平均最低気温": formatRank(
                            widget.point,
                            "minTemp",
                            div: 10,
                            totalRank: 904,
                            unit: "℃",
                            monthIndex: selectedMonth,
                          ),
                          "年降水量": formatRank(
                            widget.point,
                            "rain",
                            div: 10,
                            totalRank: 1230,
                            unit: "mm",
                            monthIndex: selectedMonth,
                          ),
                          "年降雪量": formatRank(
                            widget.point,
                            "snow",
                            div: 1,
                            totalRank: 320,
                            unit: "cm",
                            monthIndex: selectedMonth,
                          ),
                          "年日照時間": formatRank(
                            widget.point,
                            "sun",
                            div: 10,
                            totalRank: 827,
                            unit: "時間",
                            monthIndex: selectedMonth,
                          ),
                          "平均風速": formatRank(
                            widget.point,
                            "wind",
                            div: 10,
                            totalRank: 874,
                            unit: "m/s",
                            monthIndex: selectedMonth,
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 情報リスト
class InfoListWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const InfoListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.entries.map((entry) {
        final title = entry.key;
        final value = entry.value;
        final regionKeys = {"観測地点/カナ", "都道府県/市町村", "緯度,経度", "標高"};

        final color = regionKeys.contains(title)
            ? getRegionColor(data["都道府県/市町村"])
            : getItemColor(title);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2.r),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.r),
                      bottomLeft: Radius.circular(6.r),
                    ),
                  ),

                  alignment: Alignment.center,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: min(14.sp, 14.h),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: null,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$value',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: min(18.sp, 18.h),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

Widget infoLabel(IconData icon, String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: const Color.fromARGB(126, 117, 117, 117),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: min(18.sp, 18.h)),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: min(16.sp, 16.h),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

/// ランキング表示対応
String formatRank(
  ObservationPoint point,
  String key, {
  double div = 10,
  String unit = "日",
  int totalRank = 904,
  int monthIndex = 12, // ★ 追加
}) {
  final data = point.monthlyData[key];
  if (data == null || data.length <= monthIndex) return "--$unit";

  final val = data[monthIndex][0] / div;
  final rank = data[monthIndex][1];
  if (val == 0 && (!key.contains("temp") || !key.contains("Temp"))) {
    return "${val.toStringAsFixed(1)}$unit (--位/$totalRank)";
  }
  return "${val.toStringAsFixed(1)}$unit ($rank位/$totalRank)";
}

/// 日数データ生成
Map<String, double> generateDayData(
  ObservationPoint point,
  Map<String, String> nameToKey, {
  double totalDays = 365,
  double div = 10,
  int monthIndex = 12, // 0〜11: 各月, 12: 通年
}) {
  final Map<String, double> result = {};

  // --- 月の日数リスト（通年は365固定） ---
  const monthDays = [
    31.0, // 1月
    28.2, // 2月 (閏年考慮はしない)
    31.0, // 3月
    30.0, // 4月
    31.0, // 5月
    30.0, // 6月
    31.0, // 7月
    31.0, // 8月
    30.0, // 9月
    31.0, // 10月
    30.0, // 11月
    31.0, // 12月
  ];

  nameToKey.forEach((displayName, key) {
    final list = point.monthlyData[key];
    if (list != null && list.length > monthIndex) {
      result[displayName] = list[monthIndex][0] / div;
    } else {
      result[displayName] = 0.0;
    }
  });

  // --- 合計日数を追加 ---
  result["合計日数"] = monthIndex == 12 ? totalDays : monthDays[monthIndex];

  // その他は常に0に設定
  result["その他"] = 0;

  return result;
}

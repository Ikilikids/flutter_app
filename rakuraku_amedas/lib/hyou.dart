import 'package:flutter/material.dart';

class RainTempTable extends StatelessWidget {
  final List<List<int>>? monthlyRains;
  final List<List<int>>? monthlyTemps;
  final List<List<int>>? monthlyMaxTemps;
  final List<List<int>>? monthlyMinTemps;
  final List<List<int>>? monthlySuns;
  final List<List<int>>? monthlySnows;
  final List<List<int>>? monthlyWinds;

  const RainTempTable({
    super.key,
    required this.monthlyRains,
    required this.monthlyTemps,
    required this.monthlyMaxTemps,
    required this.monthlyMinTemps,
    required this.monthlySuns,
    required this.monthlySnows,
    required this.monthlyWinds,
  });

  // 値取得関数
  List<String> getValue(
    List<List<int>>? data,
    int index, {
    bool divideBy10 = false,
  }) {
    if (data == null || index >= data.length || data[index].isEmpty) {
      return ["--", "--"];
    }
    int value = data[index][0];
    int rank = data[index][1];
    if (divideBy10) {
      double v = value / 10;
      return [v.toStringAsFixed(1), rank.toString()];
    }
    return [value.toString(), rank.toString()];
  }

  // グラデーション色計算
  Color getColor(
    BuildContext context,
    String metric,
    double value, {
    bool all = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double t;
    Color baseColor;

    switch (metric) {
      case "平均気温":
      case "平均最高気温":
      case "平均最低気温":
        t = ((value + 15) / 50).clamp(0.0, 1.0);
        baseColor = t <= 0.5
            ? Color.lerp(Colors.blue, Colors.white, t / 0.5)!
            : Color.lerp(Colors.white, Colors.red, (t - 0.5) / 0.5)!;
        break;
      case "降水量":
        t = all
            ? (value / 4000).clamp(0.0, 1.0)
            : (value / 800).clamp(0.0, 1.0);
        baseColor = t <= 0.5
            ? Color.lerp(
                const Color.fromARGB(255, 255, 255, 255),
                Colors.blue,
                t / 0.5,
              )!
            : Color.lerp(
                Colors.blue,
                const Color.fromARGB(255, 98, 87, 255),
                (t - 0.5) / 0.5,
              )!;
        break;
      case "日照時間":
        t = all
            ? ((value - 700) / 2100).clamp(0.0, 1.0)
            : (value / 300).clamp(0.0, 1.0);
        baseColor = t <= 0.5
            ? Color.lerp(
                const Color.fromARGB(255, 194, 194, 194),
                Colors.yellow,
                t / 0.5,
              )!
            : Color.lerp(Colors.yellow, Colors.orange, (t - 0.5) / 0.5)!;
        break;
      case "降雪量":
        t = all
            ? (value / 1700).clamp(0.0, 1.0)
            : (value / 500).clamp(0.0, 1.0);
        baseColor = t <= 0.5
            ? Color.lerp(
                const Color.fromARGB(255, 255, 255, 255),
                const Color.fromARGB(255, 170, 96, 219),
                t / 0.5,
              )!
            : Color.lerp(
                const Color.fromARGB(255, 170, 96, 219),
                const Color.fromARGB(255, 224, 44, 149),
                (t - 0.5) / 0.5,
              )!;
        break;
      case "平均風速":
        t = (value / 20).clamp(0.0, 1.0);
        baseColor = t <= 0.5
            ? Color.lerp(
                const Color.fromARGB(255, 255, 255, 255),
                const Color.fromARGB(255, 12, 219, 105),
                t / 0.5,
              )!
            : Color.lerp(
                const Color.fromARGB(255, 12, 219, 105),
                const Color.fromARGB(255, 6, 231, 18),
                (t - 0.5) / 0.5,
              )!;
        break;
      default:
        baseColor = const Color.fromARGB(122, 121, 121, 121);
    }

    // ダークモードなら少し暗くする
    if (isDark) {
      return adjustForDarkMode(baseColor, isDark);
    }

    return baseColor;
  }

  Color adjustForDarkMode(Color color, bool isDark) {
    if (!isDark) return color;

    double factor = 0.7; // 暗くする係数

    return Color.fromARGB(
      ((color.a * 255.0).round() & 0xff),
      ((color.r * factor * 255.0).round() & 0xff),
      ((color.g * factor * 255.0).round() & 0xff),
      ((color.b * factor * 255.0).round() & 0xff),
    );
  }

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (i) => "${i + 1}") + ["通年"];

    final metricMap = {
      "平均気温": monthlyTemps,
      "平均最高気温": monthlyMaxTemps,
      "平均最低気温": monthlyMinTemps,
      "降水量": monthlyRains,
      "日照時間": monthlySuns,
      "降雪量": monthlySnows,
      "平均風速": monthlyWinds,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 800),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: const FixedColumnWidth(120),
            for (int i = 1; i <= 13; i++) i: const FixedColumnWidth(60),
          },
          children: [
            // ヘッダー
            TableRow(
              decoration: BoxDecoration(
                color: const Color.fromARGB(122, 224, 224, 224),
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "月",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...months.map(
                  (m) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      m,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            // データ行
            ...metricMap.entries.map((entry) {
              final metric = entry.key;
              final values = entry.value;
              final metricNamesWithTemp = ["平均気温", "平均最高気温", "平均最低気温"];

              List<Widget> rowCells = [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    metric,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ];

              rowCells.addAll(
                months.map((month) {
                  int index = month == "通年" ? 12 : int.parse(month) - 1;
                  bool divide = metric != "降雪量";
                  String valueStr = getValue(
                    values,
                    index,
                    divideBy10: divide,
                  )[0];
                  String rankStr = getValue(
                    values,
                    index,
                    divideBy10: divide,
                  )[1];

                  double? val = double.tryParse(valueStr);
                  Color? bgColor = val != null
                      ? month == "通年"
                            ? getColor(context, metric, val, all: true)
                            : getColor(context, metric, val)
                      : const Color.fromARGB(218, 133, 133, 133);

                  return Container(
                    color: bgColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          valueStr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          (!metricNamesWithTemp.contains(metric) && val == 0)
                              ? "(--)"
                              : "($rankStr)",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );

              return TableRow(children: rowCells);
            }),
          ],
        ),
      ),
    );
  }
}

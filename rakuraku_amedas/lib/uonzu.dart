import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RainTempChart extends StatelessWidget {
  final List<List<int>>? monthlyRains; // mm (10倍)
  final List<List<int>>? monthlyTemps; // ℃ (10倍)

  const RainTempChart({
    super.key,
    required this.monthlyRains,
    required this.monthlyTemps,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyRains == null) {
      return SizedBox(
        width: 400.w,
        height: 320.h,
        child: Center(
          child: Text("降水量データなし", style: TextStyle(fontSize: min(18.sp, 18.h))),
        ),
      );
    } else {
      final rains = monthlyRains!.map((v) => v[0] / 10.0).toList();
      final temps = monthlyTemps?.map((v) => v[0] / 10.0).toList();

      final hasTemps = temps != null && temps.length == 13;

      double maxRain = 0;
      List<double> displayRains = [];

      maxRain = rains.sublist(0, 12).reduce((a, b) => a > b ? a : b);
      displayRains = rains.map((v) {
        return v;
      }).toList();
      double reserverleft = 30.0.w;
      double reserveright = 20.0.w;
      return SizedBox(
        width: 400.w,
        height: 320.h,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10.r),
            height: 320.h,
            width: 400.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                BarChart(
                  BarChartData(
                    maxY: maxRain < 500 ? 500 : 1000,
                    barGroups: List.generate(12, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: displayRains[i],
                            color: Colors.blue,
                            width: 12.w,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: reserverleft,
                          interval: maxRain < 500 ? 50 : 100,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: EdgeInsets.only(right: 4), // 👈 右側に余白を足す
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: min(10.sp, 10.h),
                                  color: maxRain < 500 ? null : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: reserveright, // ← 数字の代わりに余白だけ確保
                          getTitlesWidget: (value, meta) {
                            return SizedBox.shrink(); // 何も描かない
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28, // 下の余白
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            // 月ラベルのリスト
                            const months = [
                              '1月',
                              '2月',
                              '3月',
                              '4月',
                              '5月',
                              '6月',
                              '7月',
                              '8月',
                              '9月',
                              '10月',
                              '11月',
                              '12月',
                            ];

                            // value は double なので int に変換
                            final index = value.toInt();
                            if (index < 0 || index >= months.length) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              months[index],
                              style: TextStyle(fontSize: min(10.sp, 10.h)),
                            );
                          },
                        ),
                      ),

                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),

                if (hasTemps)
                  LineChart(
                    LineChartData(
                      minX: -0.77,
                      maxX: 11.77,
                      minY: -15,
                      maxY: 35,
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            12,
                            (i) => FlSpot(i.toDouble(), temps[i]),
                          ),
                          isCurved: true,
                          color: Colors.red,
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: reserverleft, // ← 数字の代わりに余白だけ確保
                            getTitlesWidget: (value, meta) {
                              return const SizedBox.shrink(); // 何も描かない
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: reserveright,
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                ), // ← 左側に余白
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: min(10.sp, 10.h),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28, // ← 数字の代わりに余白だけ確保
                            getTitlesWidget: (value, meta) {
                              return SizedBox.shrink(); // 何も描かない
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: true),
                      clipData: const FlClipData.all(),
                    ),
                  ),

                // 波線
              ],
            ),
          ),

          // 右ラベル
        ),
      );
    }
  }
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

import '../providers/eng_review_provider.dart';

class ReviewSetupPage extends HookConsumerWidget {
  const ReviewSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- 状態管理 (Hooks) ---
    final bool isHigh =
        ref.read(currentDetailConfigProvider).appData.appTitle.contains("高校");
    print("復習モード: 高校版かどうか = $isHigh");
    final useStar = useState(false);
    final useHeart = useState(false);
    final selectedMetric = useState(ReviewMetric.accuracyRate);
    final rangeValues = useState(const RangeValues(0, 100));
    final selectedLevels =
        useState<Set<int>>(isHigh ? {1, 2, 3, 4, 5, 6, 7} : {1, 2, 3, 4});
    final selectedParts =
        useState<Set<String>>({"名詞", "動詞", "形容詞", "副詞", "その他"});

    // フィルタ条件が変更されたらプロバイダーを更新
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(engReviewFilterProvider.notifier).state = EngReviewFilter(
          parts: selectedParts.value,
          levels: selectedLevels.value,
          metric: selectedMetric.value,
          range: rangeValues.value,
          star: useStar.value,
          heart: useHeart.value,
        );
      });
      return null;
    }, [
      selectedParts.value,
      selectedLevels.value,
      selectedMetric.value,
      rangeValues.value,
      useStar.value,
      useHeart.value
    ]);

    // 指標が切り替わった時にレンジを初期化
    useEffect(() {
      rangeValues.value =
          RangeValues(selectedMetric.value.min, selectedMetric.value.max);
      return null;
    }, [selectedMetric.value]);

    // --- データ取得 ---
    final totalMatches = ref.watch(filteredReviewCountProvider);
    final integratedAsync = ref.watch(integratedEngQuizProvider);

    return integratedAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text("エラーが発生しました:$err"))),
      data: (integratedData) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. タグ ---
              _buildSectionHeader(context, Icons.local_offer, "タグ"),
              _buildFilterCard(context, [
                _buildTagSwitch(
                    context, '★ 星付き', Icons.star, Colors.orange, useStar),
                _buildTagSwitch(
                    context, '♪ 登録済み', Icons.favorite, Colors.red, useHeart),
              ]),
              const SizedBox(height: 28),

              // --- 2. 指標フィルタ (スライダー) ---
              _buildSectionHeader(context, Icons.tune, "絞り込み指標"),
              _buildMetricRangeSlider(context, selectedMetric, rangeValues),
              const SizedBox(height: 28),

              // --- 3. レベル ---
              _buildSectionHeader(context, Icons.layers, "レベル"),
              _buildLevelChips(context, selectedLevels, isHigh),
              const SizedBox(height: 28),

              // --- 4. 品詞 ---
              _buildSectionHeader(context, Icons.category, "品詞"),
              _buildPartChips(context, selectedParts),

              const SizedBox(height: 48),

              // --- 該当件数表示 ---
              Center(
                child: Text(
                  "該当する問題数: $totalMatches 問",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor1(context).withAlpha(180),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- 開始ボタン ---
              _buildStartButtons(
                context,
                totalMatches,
                ref,
                parts: selectedParts.value,
                levels: selectedLevels.value,
                metric: selectedMetric.value,
                range: rangeValues.value,
                star: useStar.value,
                heart: useHeart.value,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor2(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(30)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTagSwitch(BuildContext context, String title, IconData icon,
      Color color, ValueNotifier<bool> state) {
    return ListTile(
      leading: Icon(icon, color: state.value ? color : Colors.grey),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: Switch(
        value: state.value,
        activeThumbColor: color,
        onChanged: (v) => state.value = v,
      ),
      onTap: () => state.value = !state.value,
    );
  }

  Widget _buildMetricRangeSlider(BuildContext context,
      ValueNotifier<ReviewMetric> metric, ValueNotifier<RangeValues> range) {
    String colorCode;
    switch (metric.value) {
      case ReviewMetric.accuracyRate:
        colorCode = "1";
        break;
      case ReviewMetric.correctCount:
        colorCode = "3";
        break;
      case ReviewMetric.incorrectCount:
        colorCode = "2";
        break;
      case ReviewMetric.recentCorrectCount:
        colorCode = "6";
        break;
      case ReviewMetric.recentIncorrectCount:
        colorCode = "4";
        break;
      case ReviewMetric.totalPlayCount:
        colorCode = "5";
        break;
    }
    final metricColor = getQuizColor2(colorCode, context, 1, 0.5, 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor2(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<ReviewMetric>(
              value: metric.value,
              isExpanded: true,
              items: ReviewMetric.values.map((m) {
                return DropdownMenuItem(value: m, child: Text(m.label));
              }).toList(),
              onChanged: (v) {
                if (v != null) metric.value = v;
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "範囲: ${range.value.start.round()}${metric.value.unit} 〜 ${range.value.end.round()}${metric.value.unit}",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: metricColor),
              ),
            ],
          ),
          RangeSlider(
            values: range.value,
            min: metric.value.min,
            max: metric.value.max,
            divisions: metric.value.max.toInt() == 5 ? 5 : 20,
            activeColor: metricColor,
            inactiveColor: metricColor.withAlpha(50),
            labels: RangeLabels(
              "${range.value.start.round()}${metric.value.unit}",
              "${range.value.end.round()}${metric.value.unit}",
            ),
            onChanged: (v) => range.value = v,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelChips(
      BuildContext context, ValueNotifier<Set<int>> selected, bool isHigh) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(isHigh ? 7 : 4, (index) {
        final level = index + 1;
        final isSelected = selected.value.contains(level);
        return FilterChip(
          label: Text('★$level'),
          selected: isSelected,
          onSelected: (v) {
            final newSet = Set<int>.from(selected.value);
            if (v)
              newSet.add(level);
            else
              newSet.remove(level);
            selected.value = newSet;
          },
          selectedColor: getQuizColor2("6", context, 0.6, 0.2, 0.95),
          checkmarkColor: getQuizColor2("6", context, 1, 0.7, 0.95),
        );
      }),
    );
  }

  Widget _buildPartChips(
      BuildContext context, ValueNotifier<Set<String>> selected) {
    final parts = ["名詞", "動詞", "形容詞", "副詞", "その他"];
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: parts.map((part) {
        final isSelected = selected.value.contains(part);
        return FilterChip(
          label: Text(part),
          selected: isSelected,
          onSelected: (v) {
            final newSet = Set<String>.from(selected.value);
            if (v)
              newSet.add(part);
            else
              newSet.remove(part);
            selected.value = newSet;
          },
          selectedColor:
              getQuizColor2(getSpeechNumber(part), context, 1, 0.2, 0.95),
          checkmarkColor:
              getQuizColor2(getSpeechNumber(part), context, 1, 1, 0.95),
        );
      }).toList(),
    );
  }

  Widget _buildStartButtons(
    BuildContext context,
    int count,
    WidgetRef ref, {
    required Set<String> parts,
    required Set<int> levels,
    required ReviewMetric metric,
    required RangeValues range,
    required bool star,
    required bool heart,
  }) {
    Widget buildButton(int qCount) {
      final bool isEnabled = count >= qCount;
      final Color buttonColor = getQuizColor2("6", context, 1, 0.65, 0.95);
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () {
                      ref.read(selectedQuizIdProvider.notifier).update(
                          QuizId(resisterOrigin: "復習モード", modeType: "z"));
                      ref.read(engReviewFilterProvider.notifier).state =
                          EngReviewFilter(
                        parts: parts,
                        levels: levels,
                        metric: metric,
                        range: range,
                        star: star,
                        heart: heart,
                      );
                      ref
                          .read(quizCountNotifierProvider.notifier)
                          .selectQuizCount(
                            QuizId(resisterOrigin: "復習モード", modeType: "z"),
                            qCount,
                          );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CommonCountdownScreen()),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: qCount == 5 ? buttonColor : bgColor1(context),
                foregroundColor: qCount != 5 ? buttonColor : bgColor1(context),
                disabledBackgroundColor: Colors.grey.withAlpha(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
                side: (qCount == 10 && isEnabled)
                    ? BorderSide(color: buttonColor, width: 2)
                    : null,
              ),
              child: Text(
                '$qCount問で開始',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        buildButton(5),
        buildButton(10),
      ],
    );
  }
}

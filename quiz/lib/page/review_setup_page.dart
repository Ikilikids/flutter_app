import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

import '../providers/eng_review_provider.dart';
import '../providers/word_stats_provider.dart';

class ReviewSetupPage extends HookConsumerWidget {
  const ReviewSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- 状態管理 (Hooks) ---
    final useStar = useState(false);
    final useHeart = useState(false);
    final selectedMetric = useState(ReviewMetric.accuracyRate);
    final rangeValues = useState(const RangeValues(0, 100));
    final selectedLevels = useState<Set<int>>({1, 2, 3, 4});
    final selectedParts =
        useState<Set<String>>({"名詞", "動詞", "形容詞", "副詞", "その他"});

    // 指標が切り替わった時にレンジを初期化
    useEffect(() {
      rangeValues.value =
          RangeValues(selectedMetric.value.min, selectedMetric.value.max);
      return null;
    }, [selectedMetric.value]);

    // --- データ取得 ---
    final statsAsync = ref.watch(wordStatsNotifierProvider);
    final integratedAsync = ref.watch(integratedEngQuizProvider);

    return integratedAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text("エラーが発生しました:$err"))),
      data: (integratedData) {
        final allWords = useMemoized(() {
          final List<EngPartData> allItems = [];
          integratedData.forEach((key, value) {
            allItems.addAll(value);
          });
          return allItems;
        }, [integratedData]);

        final statsMap = statsAsync.value ?? {};

        // --- フィルタリングロジック ---
        final matchingWords = allWords.where((word) {
          final s = statsMap[word.word.toLowerCase()] ?? const WordStats();

          // 1. タグ
          bool tagMatch = false;
          if (useStar.value && s.star) tagMatch = true;
          if (useHeart.value && s.heart) tagMatch = true;
          if (!useStar.value && !useHeart.value) tagMatch = true;

          // 2. 指標 (選択されたメトリクスとレンジ)
          double value = 0;
          switch (selectedMetric.value) {
            case ReviewMetric.accuracyRate:
              value = s.accuracyRate;
              break;
            case ReviewMetric.correctCount:
              value = s.correctCount.toDouble();
              break;
            case ReviewMetric.incorrectCount:
              value = s.incorrectCount.toDouble();
              break;
            case ReviewMetric.recentCorrectCount:
              value = s.recentCorrectCount.toDouble();
              break;
            case ReviewMetric.recentIncorrectCount:
              value = s.recentIncorrectCount.toDouble();
              break;
            case ReviewMetric.totalPlayCount:
              value = s.totalPlayCount.toDouble();
              break;
          }
          bool metricMatch = value >= rangeValues.value.start &&
              value <= rangeValues.value.end;

          // 3. レベル
          bool levelMatch = selectedLevels.value.contains(word.totalScore);

          // 4. 品詞
          bool partMatch = selectedParts.value.contains(word.domain) ||
              (word.domain != "名詞" &&
                  word.domain != "動詞" &&
                  word.domain != "形容詞" &&
                  word.domain != "副詞" &&
                  selectedParts.value.contains("その他"));

          return tagMatch && metricMatch && levelMatch && partMatch;
        }).toList();

        final totalMatches = matchingWords.length;

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
                    context, '♪ 登録済み', Icons.music_note, Colors.red, useHeart),
              ]),
              const SizedBox(height: 28),

              // --- 2. 指標フィルタ (スライダー) ---
              _buildSectionHeader(context, Icons.tune, "絞り込み指標"),
              _buildMetricRangeSlider(context, selectedMetric, rangeValues),
              const SizedBox(height: 28),

              // --- 3. レベル ---
              _buildSectionHeader(context, Icons.layers, "レベル"),
              _buildLevelChips(context, selectedLevels),
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
      BuildContext context, ValueNotifier<Set<int>> selected) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(4, (index) {
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
              getQuizColor2(getSpeechNumber(part), context, 0.6, 0.2, 0.95),
          checkmarkColor:
              getQuizColor2(getSpeechNumber(part), context, 1, 0.7, 0.95),
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
      final isEnabled = count >= qCount;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () {
                      // 1. 英単語専用のフィルタを「登録」
                      ref.read(engReviewFilterProvider.notifier).state =
                          EngReviewFilter(
                        parts: parts,
                        levels: levels,
                        metric: metric,
                        range: range,
                        star: star,
                        heart: heart,
                      );

                      // 2. 問題数をシステム（UserStatus）に「登録」
                      // resisterOrigin: "復習モード", modeType: "z"
                      ref
                          .read(userStatusNotifierProvider.notifier)
                          .updateQcount(
                            "復習モード",
                            "z",
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
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.withAlpha(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
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

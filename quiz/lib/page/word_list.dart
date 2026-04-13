import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

import '../providers/word_stats_provider.dart';

// --- メインWidget ---

enum WordSortOption {
  field,
  word,
  correctCount,
  hintCount,
  incorrectCount,
  accuracyRate
}

class WordListPage extends HookConsumerWidget {
  const WordListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State (Hooks) ---
    final searchQuery = useState("");
    final sortOption = useState(WordSortOption.field);
    final isAscending = useState(true);

    // マーカー絞り込み用State
    final showOnlyStar = useState(false);
    final showOnlyHeart = useState(false);

    // 絞り込み用State
    final selectedDomains = useState<Set<String>>({});
    final selectedLevels = useState<Set<int>>({});

    // --- データ取得 (非同期) ---
    final integratedAsync = ref.watch(integratedEngQuizProvider);
    final integratedData = integratedAsync.value;

    // 初回ロード時のみLoadingを表示
    if (integratedData == null) {
      return integratedAsync.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text("エラーが発生しました: $err"))),
        data: (_) =>
            const SizedBox.shrink(), // integratedDataが非nullになるのでここは通らない
      );
    }

    // ここからはデータがある状態（初回ロード完了後）
    final wordListData = useMemoized(() {
      final List<PartData> allItems = [];
      integratedData.forEach((key, value) {
        allItems.addAll(value);
      });
      return allItems;
    }, [integratedData]);

    // 統計情報の最新状態を監視 (★/♥ の絞り込みや表示更新に必要)
    final statsMap = ref.watch(wordStatsNotifierProvider).value ?? {};

    // カテゴリ（domain）とレベル（totalScore）のユニークな値を取得
    final filterOptions = useMemoized(() {
      final domains = wordListData.map((e) => e.middle).toSet().toList()
        ..sort();
      final levels = wordListData.map((e) => e.totalScore).toSet().toList()
        ..sort();
      return (domains: domains, levels: levels);
    }, [wordListData]);

    // フィルタリングとソートの適用
    final displayListData = useMemoized(() {
      List<PartData> list = List.from(wordListData);

      // 1. カテゴリ絞り込み
      if (selectedDomains.value.isNotEmpty) {
        list = list
            .where((item) => selectedDomains.value.contains(item.middle))
            .toList();
      }

      // 2. レベル絞り込み
      if (selectedLevels.value.isNotEmpty) {
        list = list
            .where((item) => selectedLevels.value.contains(item.totalScore))
            .toList();
      }

      // 2.5 マーカー絞り込み (プロバイダーの最新状態を使用)
      if (showOnlyStar.value) {
        list = list.where((item) {
          final key = (item as EngPartData).word.trim().toLowerCase();
          return statsMap[key]?.star ?? false;
        }).toList();
      }
      if (showOnlyHeart.value) {
        list = list.where((item) {
          final key = (item as EngPartData).word.trim().toLowerCase();
          return statsMap[key]?.heart ?? false;
        }).toList();
      }

      // 3. 検索フィルタリング
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.trim().toLowerCase();
        list = list.where((item) {
          final word =
              item.making.isNotEmpty ? item.making[0].trim().toLowerCase() : "";
          final meaning =
              item.making.length > 1 ? item.making[1].trim().toLowerCase() : "";
          return word.contains(query) || meaning.contains(query);
        }).toList();
      }

      // 4. ソート
      list.sort((a, b) {
        final keyA = (a as EngPartData).word.trim().toLowerCase();
        final keyB = (b as EngPartData).word.trim().toLowerCase();
        final statsA = statsMap[keyA] ?? const WordStats();
        final statsB = statsMap[keyB] ?? const WordStats();

        int cmp;
        switch (sortOption.value) {
          case WordSortOption.field:
            int? fa = int.tryParse(a.field);
            int? fb = int.tryParse(b.field);
            if (fa != null && fb != null) {
              cmp = fa.compareTo(fb);
            } else {
              cmp = a.field.compareTo(b.field);
            }
            break;
          case WordSortOption.word:
            cmp = a.word.compareTo(b.word);
            break;
          case WordSortOption.correctCount:
            cmp = statsA.correctCount.compareTo(statsB.correctCount);
            break;
          case WordSortOption.hintCount:
            cmp = statsA.hintCount.compareTo(statsB.hintCount);
            break;
          case WordSortOption.incorrectCount:
            cmp = statsA.incorrectCount.compareTo(statsB.incorrectCount);
            break;
          case WordSortOption.accuracyRate:
            cmp = statsA.accuracyRate.compareTo(statsB.accuracyRate);
            break;
        }
        return isAscending.value ? cmp : -cmp;
      });

      return list;
    }, [
      wordListData,
      searchQuery.value,
      sortOption.value,
      isAscending.value,
      showOnlyStar.value,
      showOnlyHeart.value,
      selectedDomains.value,
      selectedLevels.value,
      statsMap
    ]);

    // ベースとなるカラーを取得
    final themeColor = getQuizColor2("9", context, 1, 0.65, 1);

    return Column(
      children: [
        // 統合コントロールパネル
        _buildUnifiedControlPanel(
          context,
          searchQuery,
          sortOption,
          isAscending,
          showOnlyStar,
          showOnlyHeart,
          filterOptions,
          selectedDomains,
          selectedLevels,
          displayListData.length,
          themeColor,
        ),

        // 単語一覧表示エリア
        Expanded(
          child: _buildWordList(
            context,
            displayListData,
            themeColor,
          ),
        ),
      ],
    );
  }
}

// --- 統合コントロールパネル ---
Widget _buildUnifiedControlPanel(
  BuildContext context,
  ValueNotifier<String> searchQuery,
  ValueNotifier<WordSortOption> sortOption,
  ValueNotifier<bool> isAscending,
  ValueNotifier<bool> showOnlyStar,
  ValueNotifier<bool> showOnlyHeart,
  ({List<String> domains, List<int> levels}) options,
  ValueNotifier<Set<String>> selectedDomains,
  ValueNotifier<Set<int>> selectedLevels,
  int hitCount,
  Color themeColor,
) {
  final searchController = useTextEditingController(text: searchQuery.value);

  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 検索バー
        TextField(
          controller: searchController,
          onChanged: (value) => searchQuery.value = value,
          decoration: InputDecoration(
            hintText: "検索...",
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      searchQuery.value = "";
                      searchController.clear();
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
        const SizedBox(height: 8),

        // 2. ソート & ヒット件数
        Row(
          children: [
            const Icon(Icons.sort, size: 18),
            const SizedBox(width: 4),
            DropdownButton<WordSortOption>(
              value: sortOption.value,
              isDense: true,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                    value: WordSortOption.field,
                    child: Text("番号", style: TextStyle(fontSize: 13))),
                DropdownMenuItem(
                    value: WordSortOption.word,
                    child: Text("単語", style: TextStyle(fontSize: 13))),
                DropdownMenuItem(
                    value: WordSortOption.correctCount,
                    child: Text("正解数", style: TextStyle(fontSize: 13))),
                DropdownMenuItem(
                    value: WordSortOption.hintCount,
                    child: Text("準正解数", style: TextStyle(fontSize: 13))),
                DropdownMenuItem(
                    value: WordSortOption.incorrectCount,
                    child: Text("不正解数", style: TextStyle(fontSize: 13))),
                DropdownMenuItem(
                    value: WordSortOption.accuracyRate,
                    child: Text("正解率", style: TextStyle(fontSize: 13))),
              ],
              onChanged: (value) =>
                  {if (value != null) sortOption.value = value},
            ),
            IconButton(
              icon: Icon(
                  isAscending.value ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 18),
              onPressed: () => isAscending.value = !isAscending.value,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            // 星フィルタボタン
            IconButton(
              icon: Icon(
                showOnlyStar.value ? Icons.star : Icons.star_border,
                color: showOnlyStar.value ? Colors.orange : null,
                size: 20,
              ),
              onPressed: () => showOnlyStar.value = !showOnlyStar.value,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            // ハートフィルタボタン
            IconButton(
              icon: Icon(
                showOnlyHeart.value ? Icons.favorite : Icons.favorite_border,
                color: showOnlyHeart.value ? Colors.red : null,
                size: 20,
              ),
              onPressed: () => showOnlyHeart.value = !showOnlyHeart.value,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const Spacer(),
            Text("$hitCount件",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            if (selectedDomains.value.isNotEmpty ||
                selectedLevels.value.isNotEmpty ||
                showOnlyStar.value ||
                showOnlyHeart.value ||
                searchQuery.value.isNotEmpty)
              TextButton(
                onPressed: () {
                  searchQuery.value = "";
                  searchController.clear();
                  selectedDomains.value = {};
                  selectedLevels.value = {};
                  showOnlyStar.value = false;
                  showOnlyHeart.value = false;
                },
                child: const Text("リセット", style: TextStyle(fontSize: 12)),
              ),
          ],
        ),

        // 3. カテゴリ・レベル（水平スクロール）
        _buildHorizontalChips(
          "カテゴリ:",
          options.domains,
          selectedDomains.value,
          (val, item) {
            final next = Set<String>.from(selectedDomains.value);
            if (val)
              next.add(item);
            else
              next.remove(item);
            selectedDomains.value = next;
          },
        ),
        _buildHorizontalChips(
          "レベル:",
          options.levels.map((e) => e.toString()).toList(),
          selectedLevels.value.map((e) => e.toString()).toSet(),
          (val, item) {
            final next = Set<int>.from(selectedLevels.value);
            final levelInt = int.parse(item);
            if (val)
              next.add(levelInt);
            else
              next.remove(levelInt);
            selectedLevels.value = next;
          },
          labelBuilder: (item) => "★$item",
        ),
      ],
    ),
  );
}

Widget _buildHorizontalChips<T>(
  String label,
  List<String> items,
  Set<String> selectedItems,
  void Function(bool, String) onSelected, {
  String Function(String)? labelBuilder,
}) {
  if (items.isEmpty) return const SizedBox.shrink();
  return SizedBox(
    height: 40,
    child: Row(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selectedItems.contains(item);
              return FilterChip(
                label: Text(labelBuilder?.call(item) ?? item,
                    style: const TextStyle(fontSize: 10)),
                selected: isSelected,
                onSelected: (val) => onSelected(val, item),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            },
          ),
        ),
      ],
    ),
  );
}

// --- 内部メソッド：リスト構築 ---
Widget _buildWordList(
  BuildContext context,
  List<PartData> data,
  Color defaultThemeColor,
) {
  if (data.isEmpty) {
    return const Center(child: Text("データがありません"));
  }

  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      final part = data[index];
      // 各単語のsubjectに基づいたカラーを取得
      final cardThemeColor = getQuizColor2(part.top, context, 1, 0.65, 1);

      return _WordCard(
        part: part,
        index: index,
        themeColor: cardThemeColor,
      );
    },
  );
}

// --- 単語1行分のカードコンポーネント ---

String _formatMeaning(String rawMeaning) {
  if (rawMeaning.isEmpty) return "";
  if (rawMeaning.contains("、")) {
    final parts = rawMeaning.split("、");
    return "${parts[0]}\n${parts.sublist(1).join("、")}";
  }
  if (rawMeaning.contains("(")) {
    final openIdx = rawMeaning.indexOf("(");
    if (openIdx == 0) {
      final closeIdx = rawMeaning.indexOf(")");
      if (closeIdx != -1 && closeIdx < rawMeaning.length - 1) {
        return "${rawMeaning.substring(0, closeIdx + 1)}\n${rawMeaning.substring(closeIdx + 1)}";
      }
    } else {
      return "${rawMeaning.substring(0, openIdx)}\n${rawMeaning.substring(openIdx)}";
    }
  }
  if (rawMeaning.length >= 7) {
    final splitIndex = (rawMeaning.length / 2).ceil();
    return "${rawMeaning.substring(0, splitIndex)}\n${rawMeaning.substring(splitIndex)}";
  }
  return rawMeaning;
}

class _WordCard extends HookConsumerWidget {
  final PartData part;
  final int index;
  final Color themeColor;

  const _WordCard({
    required this.part,
    required this.index,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = part as EngPartData;
    final badgeColor = themeColor;

    final stats = ref.watch(wordStatsNotifierProvider.select(
      (s) => s.value?[p.word.trim().toLowerCase()] ?? const WordStats(),
    ));

    final toggleMarker = useCallback((String type) async {
      final notifier = ref.read(wordStatsNotifierProvider.notifier);
      if (type == 'star') {
        await notifier.toggleStar(p.word.trim());
      } else {
        await notifier.toggleHeart(p.word.trim());
      }
    }, [p.word]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: themeColor.withAlpha(100), width: 1.5),
          color: bgColor1(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(52, 158, 158, 158),
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 20,
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    p.field,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        p.making[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: textColor1(context),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        const Text(
                          "直近5回",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(
                          5,
                          (index) {
                            QuizResult quizResult = QuizResult.unknown;
                            Color color = Colors.grey.withAlpha(100);
                            if (index < stats.recentResults.length) {
                              quizResult = stats.recentResults[index];
                              if (quizResult == QuizResult.circle)
                                color = Colors.red;
                              if (quizResult == QuizResult.triangle)
                                color = Colors.green;
                              if (quizResult == QuizResult.cross)
                                color = Colors.blue;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                quizResultToEmoji(quizResult),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text("○:${stats.correctCount}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          Text("△:${stats.hintCount}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          Text("×:${stats.incorrectCount}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          Text("${stats.accuracyRate.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 25,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        stats.star ? Icons.star : Icons.star_border,
                        color: stats.star ? Colors.orange : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () => toggleMarker('star'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 2),
                    IconButton(
                      icon: Icon(
                        stats.heart ? Icons.favorite : Icons.favorite_border,
                        color: stats.heart ? Colors.red : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () => toggleMarker('heart'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 40,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Builder(
                  builder: (context) {
                    final rawMeaning = p.making.length > 1 ? p.making[1] : "";
                    final displayMeaning = _formatMeaning(rawMeaning);

                    return Text(
                      displayMeaning,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

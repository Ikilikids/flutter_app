import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

// --- メインWidget ---

enum WordSortOption { field, word }

class WordListPage extends HookConsumerWidget {
  const WordListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State (Hooks) ---
    final isLoading = useState(true);
    final wordListData = useState<List<PartData>>([]);
    final searchQuery = useState("");
    final sortOption = useState(WordSortOption.field);
    final isAscending = useState(true);

    // 絞り込み用State
    final selectedDomains = useState<Set<String>>({});
    final selectedLevels = useState<Set<int>>({});

    // --- データ取得ロジック (Fetch) ---
    useEffect(() {
      Future<void> fetch() async {
        isLoading.value = true;
        final activeConfig = ref.read(currentDetailConfigProvider);
        final loader = LoadQuiz(quizinfo: activeConfig);

        await loader.loadAllQuizData();

        final List<PartData> allItems = [];
        loader.allQuizData.forEach((key, value) {
          allItems.addAll(value);
        });

        if (context.mounted) {
          wordListData.value = allItems;
          isLoading.value = false;
        }
      }

      fetch();
      return null;
    }, []);

    // カテゴリ（domain）とレベル（totalScore）のユニークな値を取得
    final filterOptions = useMemoized(() {
      final domains = wordListData.value.map((e) => e.domain).toSet().toList()
        ..sort();
      final levels =
          wordListData.value.map((e) => e.totalScore).toSet().toList()..sort();
      return (domains: domains, levels: levels);
    }, [wordListData.value]);

    // フィルタリングとソートの適用
    final displayListData = useMemoized(() {
      List<PartData> list = List.from(wordListData.value);

      // 1. カテゴリ絞り込み
      if (selectedDomains.value.isNotEmpty) {
        list = list
            .where((item) => selectedDomains.value.contains(item.domain))
            .toList();
      }

      // 2. レベル絞り込み
      if (selectedLevels.value.isNotEmpty) {
        list = list
            .where((item) => selectedLevels.value.contains(item.totalScore))
            .toList();
      }

      // 3. 検索フィルタリング
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        list = list.where((item) {
          final word =
              item.making.isNotEmpty ? item.making[0].toLowerCase() : "";
          final meaning =
              item.making.length > 1 ? item.making[1].toLowerCase() : "";
          return word.contains(query) || meaning.contains(query);
        }).toList();
      }

      // 4. ソート
      list.sort((a, b) {
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
            final wa = a.making.isNotEmpty ? a.making[0] : "";
            final wb = b.making.isNotEmpty ? b.making[0] : "";
            cmp = wa.compareTo(wb);
            break;
        }
        return isAscending.value ? cmp : -cmp;
      });

      return list;
    }, [
      wordListData.value,
      searchQuery.value,
      sortOption.value,
      isAscending.value,
      selectedDomains.value,
      selectedLevels.value
    ]);

    // ベースとなるカラーを取得
    final themeColor = getQuizColor2("9", context, 1, 0.65, 1);

    return SafeArea(
      child: Column(
        children: [
          // 統合コントロールパネル
          _buildUnifiedControlPanel(
            context,
            searchQuery,
            sortOption,
            isAscending,
            filterOptions,
            selectedDomains,
            selectedLevels,
            displayListData.length,
            themeColor,
          ),

          // 単語一覧表示エリア
          Expanded(
            child: isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildWordList(
                    context,
                    displayListData,
                    themeColor,
                  ),
          ),
        ],
      ),
    );
  }

  // --- 統合コントロールパネル ---
  Widget _buildUnifiedControlPanel(
    BuildContext context,
    ValueNotifier<String> searchQuery,
    ValueNotifier<WordSortOption> sortOption,
    ValueNotifier<bool> isAscending,
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                ],
                onChanged: (value) =>
                    {if (value != null) sortOption.value = value},
              ),
              IconButton(
                icon: Icon(
                    isAscending.value
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 18),
                onPressed: () => isAscending.value = !isAscending.value,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              Text("$hitCount件",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              if (selectedDomains.value.isNotEmpty ||
                  selectedLevels.value.isNotEmpty ||
                  searchQuery.value.isNotEmpty)
                TextButton(
                  onPressed: () {
                    searchQuery.value = "";
                    searchController.clear();
                    selectedDomains.value = {};
                    selectedLevels.value = {};
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
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
        final cardThemeColor = getQuizColor2(part.subject, context, 1, 0.65, 1);

        return _WordCard(
          part: part,
          index: index,
          themeColor: cardThemeColor,
        );
      },
    );
  }
}

// --- 単語1行分のカードコンポーネント ---

/// 日本語の「意味」を最大2行に整形する関数
/// 「、」での分割を優先し、次いで「()」での分割を行う。
String _formatMeaning(String rawMeaning) {
  if (rawMeaning.isEmpty) return "";

  // 1. 「、」を最優先で分割（2行まで）
  if (rawMeaning.contains("、")) {
    final parts = rawMeaning.split("、");
    return "${parts[0]}\n${parts.sublist(1).join("、")}";
  }

  // 2. 「、」がない場合に「( )」で分割
  if (rawMeaning.contains("(")) {
    final openIdx = rawMeaning.indexOf("(");
    if (openIdx == 0) {
      // 先頭がカッコの場合: 最初の下カッコの直後で切る
      final closeIdx = rawMeaning.indexOf(")");
      if (closeIdx != -1 && closeIdx < rawMeaning.length - 1) {
        return "${rawMeaning.substring(0, closeIdx + 1)}\n${rawMeaning.substring(closeIdx + 1)}";
      }
    } else {
      // 途中にカッコがある場合: カッコの直前で切る
      return "${rawMeaning.substring(0, openIdx)}\n${rawMeaning.substring(openIdx)}";
    }
  }

  // 3. カッコ閉じだけがある等のイレギュラー対応
  if (rawMeaning.contains(")")) {
    final closeIdx = rawMeaning.indexOf(")");
    if (closeIdx != -1 && closeIdx < rawMeaning.length - 1) {
      return "${rawMeaning.substring(0, closeIdx + 1)}\n${rawMeaning.substring(closeIdx + 1)}";
    }
  }

  return rawMeaning;
}

class _WordCard extends StatelessWidget {
  final PartData part;
  final int index;
  final Color themeColor;

  const _WordCard({
    required this.part,
    required this.index,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    // 順位（field）に応じたバッジカラーをテーマカラーに変更
    final badgeColor = themeColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(8),
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
            // fieldを表示（順位部分）
            Expanded(
              flex: 20,
              child: Container(
                margin: const EdgeInsets.all(4), // ← 円の外側の余白
                padding: const EdgeInsets.all(8), // ← 円の内側の余白（文字が縁に当たらない用）
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    part.field,
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 単語情報 (making[0])
            Expanded(
              flex: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      part.making[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: textColor1(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 意味表示 (making[1])
            Expanded(
              flex: 40,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Builder(
                  builder: (context) {
                    final rawMeaning =
                        part.making.length > 1 ? part.making[1] : "";
                    final displayMeaning = _formatMeaning(rawMeaning);

                    return Text(
                      displayMeaning,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.1, // 行間を少し詰める
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

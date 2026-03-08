import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// --- データモデル定義 ---

class QuizTabInfo {
  final String id;
  final String display;
  final String? color; // 科目ごとの色を保持
  QuizTabInfo({required this.id, required this.display, this.color});
}

class RankingEntry {
  final String userName;
  final double score;
  final DateTime date;
  final String quizType;
  RankingEntry(this.userName, this.score, this.date, this.quizType);
}

// --- メインWidget ---

class CommonRankingPage extends HookConsumerWidget {
  const CommonRankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State (Hooks) ---
    final selectedModeIndex = useState(0); // 0: 無制限, 1: 限定
    final selectedPeriodIndex = useState(0); // 期間タブのインデックス
    final selectedSubjectIndex = useState(0); // クイズ種別タブのインデックス

    final isLoading = useState(true);
    final rankingData = useState<Map<String, List<RankingEntry>>>({});

    final gameData = allData.mid[selectedModeIndex.value];

    // --- 期間タブの生成 ---
    final periodTabs = useMemoized(
        () => [
              QuizTabInfo(
                  id: buildPeriod()[0], display: l10n(context, 'allPeriod')),
              QuizTabInfo(
                  id: buildPeriod()[1],
                  display: l10n(context, 'monthlyPeriod')),
              QuizTabInfo(
                  id: buildPeriod()[2], display: l10n(context, 'weeklyPeriod')),
            ],
        [context]);

    // --- クイズ種別タブの生成 ---
    final quizTabs = useMemoized(() {
      final seen = <String>{};
      final List<QuizTabInfo> tabs = gameData.detail
          .where((d) => seen.add(d.resisterSub))
          .map((d) => QuizTabInfo(
                id: d.resisterSub,
                display: l10n(context, d.displayRank),
                color: d.color,
              ))
          .toList();

      if (!gameData.isbattle) {
        tabs.insert(0, QuizTabInfo(id: "全合計", display: "全合計", color: "9"));
      }
      return tabs;
    }, [selectedModeIndex.value, context]);

    // モード切り替え時に選択インデックスを安全にリセット
    useEffect(() {
      selectedSubjectIndex.value = 0;
      selectedPeriodIndex.value = 0;
      return null;
    }, [selectedModeIndex.value]);

    // --- Tab Controllers ---
    // keysを指定することで、タブの中身が変わった時にコントローラーを自動再生成
    final quizTabController = useTabController(
      initialLength: quizTabs.length,
      keys: [quizTabs],
    );
    final periodTabController = useTabController(
      initialLength: periodTabs.length,
      keys: [periodTabs],
    );

    // --- データ取得ロジック (Fetch) ---
    useEffect(() {
      // 現在のインデックスから必要なIDを取得
      final subjectId = quizTabs[selectedSubjectIndex.value].id;
      final periodId = periodTabs[selectedPeriodIndex.value].id;

      Future<void> fetch() async {
        isLoading.value = true;
        final modeType = gameData.modeData.modeType;
        // 直接IDを結合してキーを作成
        final rankingKey = "${subjectId}_${modeType}_$periodId";

        final data = await ScoreManager.getRanking(
          context: context,
          rankingId: rankingKey,
          isSmallerBetter: gameData.isSmallerBetter,
        );

        if (context.mounted) {
          final entries = data
              .where((e) => (e['score'] ?? 0) > 0)
              .map((e) => RankingEntry(
                    e['userName'] ?? l10n(context, 'defaultUsername'),
                    (e['score'] as num).toDouble(),
                    (e['date'] ?? DateTime.now()) as DateTime,
                    modeType,
                  ))
              .toList();

          // 取得したデータを保存
          rankingData.value = {...rankingData.value, subjectId: entries};
          isLoading.value = false;
        }
      }

      fetch();
      return null;
    }, [
      selectedModeIndex.value,
      selectedPeriodIndex.value,
      selectedSubjectIndex.value,
    ]);

    // --- デザイン用カラー取得 ---
    // 現在選択されているタブのcolorを直接参照
    final currentColorCode = quizTabs[selectedSubjectIndex.value].color ?? "9";
    final tabColor = getQuizColor2(currentColorCode, context, 1, 0.65, 1);

    return SafeArea(
      child: Column(
        children: [
          // モード選択ボタン（無制限 / 限定）
          _buildModeSelector(context, selectedModeIndex),

          // クイズ種別タブ (TabBar)
          if (quizTabs.isNotEmpty)
            TabBar(
              controller: quizTabController,
              indicatorColor: tabColor,
              labelColor: tabColor,
              unselectedLabelColor: textColor2(context),
              isScrollable: true,
              tabs: quizTabs.map((tab) => Tab(text: tab.display)).toList(),
              onTap: (index) => selectedSubjectIndex.value = index,
            ),

          // 期間選択タブ (TabBar)
          TabBar(
            controller: periodTabController,
            indicatorColor: tabColor,
            labelColor: tabColor,
            unselectedLabelColor: textColor2(context),
            tabs: periodTabs.map((tab) => Tab(text: tab.display)).toList(),
            onTap: (index) => selectedPeriodIndex.value = index,
          ),

          // ランキングリスト表示エリア
          Expanded(
            child: isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildRankingList(
                    context,
                    rankingData
                            .value[quizTabs[selectedSubjectIndex.value].id] ??
                        [],
                    tabColor,
                    gameData,
                  ),
          ),
        ],
      ),
    );
  }

  // --- 内部メソッド：モードセレクター ---
  Widget _buildModeSelector(
      BuildContext context, ValueNotifier<int> selectedModeIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: List.generate(2, (i) {
          final isSelected = selectedModeIndex.value == i;
          final modeColor = i == 0 ? Colors.blue : Colors.red;
          return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(left: i == 0 ? 0 : 8, right: i == 1 ? 0 : 8),
              child: ElevatedButton(
                onPressed: () => selectedModeIndex.value = i,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? bgColor2(context) : Colors.grey,
                  foregroundColor: isSelected ? modeColor : bgColor1(context),
                  side: isSelected
                      ? BorderSide(color: modeColor, width: 3)
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  l10n(context, allData.mid[i].modeTitle!),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- 内部メソッド：リスト構築 ---
  Widget _buildRankingList(
    BuildContext context,
    List<RankingEntry> data,
    Color tabColor,
    dynamic gameData,
  ) {
    if (data.isEmpty) {
      return Center(child: Text(l10n(context, 'noDataAvailable')));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _RankingCard(
          entry: data[index],
          index: index,
          tabColor: tabColor,
          fix: gameData.fix,
          unit: gameData.unit,
        );
      },
    );
  }
}

// --- ランキング1行分のカードコンポーネント ---

class _RankingCard extends StatelessWidget {
  final RankingEntry entry;
  final int index;
  final Color tabColor;
  final int fix;
  final String unit;

  const _RankingCard({
    required this.entry,
    required this.index,
    required this.tabColor,
    required this.fix,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = index == 0
        ? Colors.amber
        : index == 1
            ? Colors.grey
            : index == 2
                ? Colors.brown
                : Colors.grey.withAlpha(100);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: tabColor.withAlpha(100), width: 1.5),
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
            // 順位表示
            Expanded(
              flex: 20,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${index + 1}",
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
            // ユーザー情報
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
                      entry.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: textColor1(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('yyyy/MM/dd HH:mm').format(entry.date),
                      style: TextStyle(color: textColor2(context)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // スコア表示
            Expanded(
              flex: 35,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatScore(entry.score, fix),
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                    Text(
                      l10n(context, unit),
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatScore(double score, int fix) {
    final s = score.toStringAsFixed(fix);
    if (score >= 1 && score <= 9) return "      $s";
    if (score >= 10 && score <= 99) return "   $s";
    return s;
  }
}

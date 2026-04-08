import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// --- データモデル定義 ---

class QuizTabInfo {
  final id;
  final String display;
  final String? color; // 科目ごとの色を保持
  final IconData? icon; // アイコンを保持
  QuizTabInfo({required this.id, required this.display, this.color, this.icon});
}

class RankingEntry {
  final String uid;
  final String userName;
  final double score;
  final DateTime date;
  RankingEntry(
      {required this.uid,
      required this.userName,
      required this.score,
      required this.date});
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
          id: PeriodType.all,
          display: l10n(context, 'allPeriod'),
          icon: Icons.history, // 全期間
        ),
        QuizTabInfo(
          id: PeriodType.month,
          display: l10n(context, 'monthlyPeriod'),
          icon: Icons.calendar_month, // 月間
        ),
        QuizTabInfo(
          id: PeriodType.week,
          display: l10n(context, 'weeklyPeriod'),
          icon: Icons.view_week, // 週間
        ),
      ],
      [context],
    );

    // --- クイズ種別タブの生成 ---
    final quizTabs = useMemoized(() {
      final List<QuizTabInfo> tabs = gameData.rankingList!;
      return tabs;
    }, [selectedModeIndex.value, context]);

    final modeTabs = useMemoized(() {
      return allData.mid.asMap().entries.take(2).map((entry) {
        final int index = entry.key;
        final d = entry.value;

        // 0番目なら青、1番目なら赤、それ以外はデフォルト(9)
        String colorCode;
        if (index == 0) {
          colorCode = "1"; // 青のカラーコード
        } else if (index == 1) {
          colorCode = "2"; // 赤のカラーコード
        } else {
          colorCode = "9";
        }

        return QuizTabInfo(
          id: d.modeData.modeType,
          display: d.modeData.isbattle
              ? l10n(context, d.modeData.modeTitle)
              : l10n(context, 'scoreLabel'),
          color: colorCode,
          icon: d.modeData.isbattle
              ? d.modeData.modeIcon
              : Icons.workspace_premium,
        );
      }).toList();
    }, [context]);

    // モード切り替え時に選択インデックスを安全にリセット
    useEffect(() {
      selectedSubjectIndex.value = 0;
      selectedPeriodIndex.value = 0;
      return null;
    }, [selectedModeIndex.value]);

    // --- Tab Controllers ---
    // keysを指定することで、タブの中身が変わった時にコントローラーを自動再生成
    final modeTabController =
        useTabController(initialLength: allData.mid.length, keys: [modeTabs]);
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
      final periodType = periodTabs[selectedPeriodIndex.value].id;

      Future<void> fetch() async {
        isLoading.value = true;
        final modeType = gameData.modeData.modeType;
        // 直接IDを結合してキーを作成
        final rankingKey = "${subjectId}_${modeType}";

        // ScoreManager.getRanking を再び使用（uidが含まれるようになったため）
        final data = await ScoreManager.getRanking(
          rankingId: rankingKey,
          periodType: periodType,
          isSmallerBetter: gameData.isSmallerBetter,
        );

        if (context.mounted) {
          final entries = data;

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
// 1. 共通のTabBar生成メソッドを作成
    Widget _buildCustomTabBar(
        {required TabController controller,
        required List<dynamic> tabs,
        required Color color,
        required double height,
        required ValueChanged<int> onTap,
        required double bottomBorderWidth}) {
      final bool isScroll = tabs.length >= 4;

      return Container(
        height: height,
        // --- ここでTabBar全体の底に線を引く ---
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300, // 線の色（固定ならグレー、変えるならcolor）
              width: bottomBorderWidth, // ← ここで「下の線の太さ」を自由に設定
            ),
          ),
        ),
        // ----------------------------------
        child: TabBar(
          controller: controller,
          isScrollable: isScroll,
          indicatorColor: color,
          dividerColor: Colors.transparent,
          indicatorWeight: 6.0, // これは「選択中」の線の太さ
          tabAlignment: isScroll ? TabAlignment.start : TabAlignment.fill,
          labelColor: color,
          unselectedLabelColor: Colors.grey,
          labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          onTap: onTap,
          tabs: tabs
              .map((tab) => Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (tab.icon != null) ...[
                              Icon(tab.icon, size: 60),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              l10n(context, tab.display),
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          // モード選択
          _buildCustomTabBar(
            controller: modeTabController,
            tabs: modeTabs,
            // 0の時は青、それ以外（1）は赤
            height: 60,
            bottomBorderWidth: 4.0, // モードタブの下線を太くして強調
            color: selectedModeIndex.value == 0 ? Colors.blue : Colors.red,
            onTap: (index) {
              selectedModeIndex.value = index;
              // 必要に応じてここで全体のテーマカラー（tabColor）も更新する
            },
          ),

          // クイズ種別
          _buildCustomTabBar(
            controller: quizTabController,
            height: 40,
            bottomBorderWidth: 2.0, // クイズ種別タブの下線は細くして控えめに
            tabs: quizTabs,
            color: tabColor,
            onTap: (index) => selectedSubjectIndex.value = index,
          ),

          // 期間選択
          _buildCustomTabBar(
            controller: periodTabController,
            height: 40,
            bottomBorderWidth: 2.0, // クイズ種別タブの下線は細くして控えめに
            tabs: periodTabs,
            color: tabColor,
            onTap: (index) => selectedPeriodIndex.value = index,
          ),

          // ランキングリスト
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
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UserDetailDialog(
                uid: data[index].uid,
                userName: data[index].userName,
              ),
            );
          },
          child: _RankingCard(
            entry: data[index],
            index: index,
            tabColor: tabColor,
            fix: gameData.fix,
            unit: gameData.unit,
          ),
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
                      l10n(context, entry.userName),
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

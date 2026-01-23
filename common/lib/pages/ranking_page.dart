import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommonRankingPage extends StatefulWidget {
  const CommonRankingPage({super.key});

  @override
  State<CommonRankingPage> createState() => _CommonRankingPageState();
}

class RankingEntry {
  final String userName;
  final double score;
  final DateTime date;
  final String quizType;

  RankingEntry(this.userName, this.score, this.date, this.quizType);
}

class _CommonRankingPageState extends State<CommonRankingPage>
    with TickerProviderStateMixin {
  late TabController quizTabController;
  late TabController periodTabController;
  late AppConfig appConfig;
  bool _isAppConfigInitialized = false;
  String selectedPeriod = '全期間';
  String selectedSubject = "";
  bool isLoading = true;
  int selectedModeIndex = 0; // 0: 無制限, 1: 限定
  late List<String> quizTabs;
  bool _areTabsInitialized = false;

  final List<String> periodTabs = ['全期間', '月間', '週間'];
  Map<String, List<RankingEntry>> rankingData = {};

  @override
  void initState() {
    super.initState();
    selectedPeriod = '全期間';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isAppConfigInitialized) {
      appConfig = Provider.of<AppConfig>(context, listen: false);
      _isAppConfigInitialized = true;
    }
  }

  @override
  void dispose() {
    if (_areTabsInitialized) {
      quizTabController.dispose();
      periodTabController.dispose();
    }
    super.dispose();
  }

  void _resetTabs() {
    if (_areTabsInitialized) {
      quizTabController.dispose();
      periodTabController.dispose();
    }
    _areTabsInitialized = false;
  }

  String _periodToV2(String period) {
    switch (period) {
      case '全期間':
        return 'all';
      case '月間':
        return 'monthly';
      case '週間':
        return 'weekly';
      default:
        return 'all';
    }
  }

  Future<void> fetchAllRanking() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final key = selectedSubject;
    final periodV2 = _periodToV2(selectedPeriod);

    final data = await CommonRankingManager.getRanking(
      selectedSubject,
      periodV2,
      rankingtype: appConfig.data[selectedModeIndex].ranking,
      isDescending: appConfig.data[selectedModeIndex].isDescending,
    );

    if (!mounted) return;

    rankingData[key] = data
        .where((e) => (e['score'] ?? 0) > 0)
        .map((e) => RankingEntry(
              e['userName'] ?? '名無し',
              (e['score'] as num).toDouble(),
              (e['date'] ?? DateTime.now()) as DateTime,
              appConfig.data[selectedModeIndex].ranking,
            ))
        .toList();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAppConfigInitialized) {
      return const SizedBox(); // or ローディング
    }

    final gameData = appConfig.data[selectedModeIndex];

    // Tab 初期化
    if (!_areTabsInitialized) {
      quizTabs = appConfig.title == "とことん高校数学" && selectedModeIndex == 0
          ? [
              "全合計",
              "数Ⅰ・数A",
              "数Ⅱ・数B",
              "数Ⅲ・数C",
            ]
          : gameData.detail.map((d) => d.label).toList();
      selectedSubject = quizTabs.first;

      quizTabController = TabController(length: quizTabs.length, vsync: this);
      periodTabController =
          TabController(length: periodTabs.length, vsync: this);

      fetchAllRanking();
      _areTabsInitialized = true;
    }

    // 選択中の科目データ
    final subjectData = gameData.detail.firstWhere(
      (d) => d.label == selectedSubject,
      orElse: () {
        // label で見つからなかった場合
        return gameData.detail.firstWhere(
          (d) => convertLabel(d.sort) == selectedSubject,
          orElse: () => GameDetail(
            sort: "",
            label: "",
            method: "",
            description: "",
            color: "7",
            circleColor: "",
          ),
        );
      },
    );
    print(selectedSubject);
    print(subjectData.label);

    // 色
    final colorKey = subjectData.color;
    print(colorKey);
    Color tabColor = getQuizColor2(colorKey, context, 1, 0.65, 1);

    final fix = gameData.fix;
    final unit = gameData.unit;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CommonModeSelectionPage()),
          );
        },
        child: AppAdScaffold(
          appBar: AppBar(title: const Text("👑ランキング👑")),
          body: SafeArea(
            child: Column(
              children: [
                // モード切替ボタン
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedModeIndex != 0) {
                              setState(() {
                                selectedModeIndex = 0;
                                _resetTabs();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedModeIndex == 0
                                ? Colors.blue
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(appConfig.data[0].title ?? "無制限モード",
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedModeIndex != 1) {
                              setState(() {
                                selectedModeIndex = 1;
                                _resetTabs();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedModeIndex == 1
                                ? Colors.red
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(appConfig.data[1].title ?? "1日限定モード",
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),

                // クイズタブ
                if (_areTabsInitialized)
                  TabBar(
                    controller: quizTabController,
                    indicatorColor: tabColor,
                    labelColor: tabColor,
                    unselectedLabelColor: textColor2(context),
                    tabs: quizTabs.map((name) => Tab(text: name)).toList(),
                    onTap: (index) {
                      setState(() {
                        selectedSubject = quizTabs[index];
                        fetchAllRanking();
                      });
                    },
                  ),

                // 期間タブ
                if (_areTabsInitialized)
                  TabBar(
                    controller: periodTabController,
                    indicatorColor: tabColor,
                    labelColor: tabColor,
                    unselectedLabelColor: textColor2(context),
                    tabs: periodTabs.map((name) => Tab(text: name)).toList(),
                    onTap: (index) {
                      setState(() {
                        selectedPeriod = periodTabs[index];
                        fetchAllRanking();
                      });
                    },
                  ),

                // ランキングリスト
                isLoading
                    ? const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: quizTabController,
                          children: quizTabs.map((quizName) {
                            final key = quizName;
                            List<RankingEntry> data = rankingData[key] ?? [];
                            if (data.isEmpty)
                              return const Center(child: Text('データがありません'));

                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final entry = data[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 10),
                                  child: Container(
                                    height: 110,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: bgColor1(context),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(52, 158, 158, 158),
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 20,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              index == 0
                                                  ? '${index + 1}位🥇'
                                                  : index == 1
                                                      ? '${index + 1}位🥈'
                                                      : index == 2
                                                          ? '${index + 1}位🥉'
                                                          : '${index + 1}位　 ',
                                              style: TextStyle(
                                                  fontSize: 100,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor1(context)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  entry.userName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color:
                                                          textColor1(context)),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  DateFormat('yyyy/MM/dd HH:mm')
                                                      .format(entry.date),
                                                  style: TextStyle(
                                                      color:
                                                          textColor2(context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 35,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  entry.score >= 1 &&
                                                          entry.score <= 9
                                                      ? "      ${entry.score.toStringAsFixed(fix)}"
                                                      : entry.score >= 10 &&
                                                              entry.score <= 99
                                                          ? "   ${entry.score.toStringAsFixed(fix)}"
                                                          : entry.score
                                                              .toStringAsFixed(
                                                                  fix),
                                                  style: TextStyle(
                                                      fontSize: 100,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: tabColor),
                                                ),
                                                Text(unit,
                                                    style: TextStyle(
                                                        fontSize: 50,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: tabColor)),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}

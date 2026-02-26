import 'package:common/common.dart';
import 'package:common/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper class to hold both ID (for DB) and display text (for UI)
class QuizTabInfo {
  final String id; // Japanese string for DB key
  final String display; // Localized string for UI display

  QuizTabInfo({required this.id, required this.display});
}

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
  bool _isAppConfigInitialized = false;
  String selectedPeriod = '';
  String selectedSubjectId = ""; // Now holds the Japanese ID
  bool isLoading = true;
  int selectedModeIndex = 0; // 0: 無制限, 1: 限定
  late List<QuizTabInfo> quizTabs; // Changed to List<QuizTabInfo>
  bool _areTabsInitialized = false;

  late final List<String> periodTabs;
  Map<String, List<RankingEntry>> rankingData = {};

  @override
  void initState() {
    super.initState();
    // Initialization is now handled in build method
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAppConfigInitialized) {
      periodTabs = [
        l10n(context, 'allPeriod'),
        l10n(context, 'monthlyPeriod'),
        l10n(context, 'weeklyPeriod')
      ];
      selectedPeriod = periodTabs.first;
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
    if (period == l10n(context, 'allPeriod')) return 'all';
    if (period == l10n(context, 'monthlyPeriod')) return 'monthly';
    if (period == l10n(context, 'weeklyPeriod')) return 'weekly';
    return 'all';
  }

  Future<void> fetchAllRanking() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final key = selectedSubjectId; // Use the ID for fetching
    final periodV2 = _periodToV2(selectedPeriod);

    final data = await CommonRankingManager.getRanking(
      key, // Pass the Japanese ID
      periodV2,
      rankingtype: allData.mid[selectedModeIndex].ranking,
      isDescending: allData.mid[selectedModeIndex].isDescending,
    );

    if (!mounted) return;

    rankingData[key] = data
        .where((e) => (e['score'] ?? 0) > 0)
        .map((e) => RankingEntry(
              e['userName'] ?? l10n(context, 'defaultUsername'),
              (e['score'] as num).toDouble(),
              (e['date'] ?? DateTime.now()) as DateTime,
              allData.mid[selectedModeIndex].ranking,
            ))
        .toList();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final seen = <String>{};
    if (!_isAppConfigInitialized) {
      return const SizedBox.shrink();
    }

    final gameData = allData.mid[selectedModeIndex];

    if (!_areTabsInitialized) {
      quizTabs = gameData.detail
          .where((d) => seen.add(d.resisterRank))
          .map((d) => QuizTabInfo(
                id: d.resisterRank,
                display: l10n(context, d.displayRank),
              ))
          .toList();
      if (!gameData.isbattle) {
        quizTabs.insert(
          0,
          QuizTabInfo(
            id: "全合計",
            display: "全合計",
          ),
        );
      }
      selectedSubjectId = quizTabs.first.id;

      quizTabController = TabController(length: quizTabs.length, vsync: this);
      periodTabController = TabController(
          length: periodTabs.length,
          vsync: this,
          initialIndex: periodTabs.indexOf(selectedPeriod));

      fetchAllRanking();
      _areTabsInitialized = true;
    }

    final color = gameData.detail
            .where((d) => d.resisterRank == selectedSubjectId)
            .map((d) => d.color)
            .firstOrNull ??
        "9";

    Color tabColor = getQuizColor2(color, context, 1, 0.65, 1);
    final fix = gameData.fix;
    final unit = gameData.unit;

    return AppAdScaffold(
      appBar: AppBar(title: Text(l10n(context, 'rankingTitle'))),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedModeIndex != 0)
                          setState(() {
                            selectedModeIndex = 0;
                            _resetTabs();
                          });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedModeIndex == 0 ? Colors.blue : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(l10n(context, allData.mid[0].modeTitle!),
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedModeIndex != 1)
                          setState(() {
                            selectedModeIndex = 1;
                            _resetTabs();
                          });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedModeIndex == 1 ? Colors.red : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(l10n(context, allData.mid[1].modeTitle!),
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            if (_areTabsInitialized)
              TabBar(
                controller: quizTabController,
                indicatorColor: tabColor,
                labelColor: tabColor,
                unselectedLabelColor: textColor2(context),
                isScrollable: true,
                tabs: quizTabs.map((tab) => Tab(text: tab.display)).toList(),
                onTap: (index) {
                  setState(() {
                    selectedSubjectId = quizTabs[index].id;
                    fetchAllRanking();
                  });
                },
              ),
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
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: quizTabController,
                      children: quizTabs.map((quizTab) {
                        final key = quizTab.id;
                        List<RankingEntry> data = rankingData[key] ?? [];
                        if (data.isEmpty)
                          return Center(
                              child: Text(l10n(context, 'noDataAvailable')));

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final entry = data[index];
                            final localizations = AppLocalizations.of(context)!;
                            String rankText;
                            if (index == 0)
                              rankText = localizations.rank1st;
                            else if (index == 1)
                              rankText = localizations.rank2nd;
                            else if (index == 2)
                              rankText = localizations.rank3rd;
                            else
                              rankText = localizations.rankNth(index + 1);

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
                                        offset: Offset(0, 3))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 20,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          rankText,
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: textColor1(context)),
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
                                                  color: textColor2(context)),
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
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(
                                              entry.score >= 1 &&
                                                      entry.score <= 9
                                                  ? "      ${entry.score.toStringAsFixed(fix)}"
                                                  : entry.score >= 10 &&
                                                          entry.score <= 99
                                                      ? "   ${entry.score.toStringAsFixed(fix)}"
                                                      : entry.score
                                                          .toStringAsFixed(fix),
                                              style: TextStyle(
                                                  fontSize: 100,
                                                  fontWeight: FontWeight.bold,
                                                  color: tabColor),
                                            ),
                                            Text(l10n(context, unit),
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    fontWeight: FontWeight.bold,
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
    );
  }
}

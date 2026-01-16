import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/firebase_score.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/assistance/latex_to_latex2.dart';
import 'package:intl/intl.dart';

class RankingEntry {
  final String userName;
  final int score;
  final DateTime date;
  final String quizType;

  RankingEntry(this.userName, this.score, this.date, this.quizType);
}

class RankingScreen extends StatefulWidget {
  final bool j;
  const RankingScreen({super.key, required this.j});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with TickerProviderStateMixin {
  late TabController quizTabController;
  late TabController periodTabController;

  String selectedPeriod = '全期間';
  String selectedSbject = "数Ⅰ・数A";
  bool isLoading = true;
  bool j = true;
  late String unit; // ここでは late で宣言
  late List<String> quizTabs;

  final List<String> periodTabs = [
    '全期間',
    '月間',
    '週間',
  ];

  Map<String, List<RankingEntry>> rankingData = {};

  @override
  void initState() {
    super.initState();

    j = widget.j;
    unit = j ? "点" : "問";
    selectedPeriod = '全期間';
    selectedSbject = j ? "数Ⅰ・数A" : "全合計";
    quizTabs = j
        ? [
            '数Ⅰ・数A',
            '数Ⅱ・数B',
            '数Ⅲ・数C',
            '全範囲',
          ]
        : subjects
            .map((e) => e[2])
            .where((name) => ![
                  '数Ⅰ・数A',
                  '数Ⅱ・数B',
                  '数Ⅲ・数C',
                  '全範囲',
                ].contains(name))
            .toList();
    quizTabController = TabController(length: quizTabs.length, vsync: this);
    periodTabController = TabController(length: periodTabs.length, vsync: this);
    fetchAllRanking();
  }

  @override
  void dispose() {
    quizTabController.dispose();
    periodTabController.dispose();
    super.dispose();
  }

  void fetchAllRanking() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final data =
        await RankingManager.getRanking(selectedSbject, selectedPeriod, j);
    if (!mounted) return;
    rankingData[selectedSbject] = data
        .where((e) => (e['score'] ?? 0) > 0) // ★ 0 を除外
        .map((e) => RankingEntry(
              e['userName'] ?? '名無し',
              e['score'] ?? 0,
              (e['date'] ?? DateTime.now()) as DateTime,
              selectedSbject,
            ))
        .toList();

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    bool all = selectedSbject == "全範囲" || selectedSbject == "全合計";
    Color tabcolor = all
        ? textColor1(context)
        : getQuizColor2(subjects.firstWhere((s) => s[2] == selectedSbject)[0],
            context, 1, 0.65, 1);
    return DefaultTabController(
      length: quizTabs.length,
      child: SafeArea(
        child: Column(
          children: [
            // クイズタブ
            TabBar(
              controller: quizTabController,
              isScrollable: j ? false : true,
              indicatorColor: tabcolor,
              labelColor: tabcolor,
              unselectedLabelColor: textColor2(context), // 非選択はテーマのデフォルト
              dividerColor: textColor2(context),
              tabs: quizTabs.map((name) => Tab(text: name)).toList(),
              onTap: (index) {
                setState(() {
                  selectedSbject = quizTabs[index];
                  fetchAllRanking();
                });
              },
            ),
            // 期間タブ
            TabBar(
              controller: periodTabController,
              indicatorColor: tabcolor,
              labelColor: tabcolor,
              unselectedLabelColor: textColor2(context), // 非選択はテーマのデフォルト
              dividerColor: textColor2(context),
              tabs: periodTabs.map((name) => Tab(text: name)).toList(),
              onTap: (index) {
                setState(() {
                  selectedPeriod = periodTabs[index];
                  fetchAllRanking();
                });
              },
            ),
            // 下のコンテンツ
            isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: TabBarView(
                      controller: quizTabController,
                      children: quizTabs.map((quizName) {
                        List<RankingEntry> data = rankingData[quizName] ?? [];
                        if (data.isEmpty) {
                          return const Center(child: Text('データがありません'));
                        }

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            RankingEntry entry = data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: bgColor1(context),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(52, 158, 158, 158),
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
                                    if (!j) const SizedBox(width: 8),
                                    Expanded(
                                      flex: 35,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 25,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                entry.score < 10
                                                    ? '　　${entry.score}$unit'
                                                    : entry.score < 100
                                                        ? '　${entry.score}$unit'
                                                        : '${entry.score}$unit',
                                                style: TextStyle(
                                                    fontSize: 100,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor1(context)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          if (j) const SizedBox(width: 10),
                                          if (j)
                                            Expanded(
                                              flex: 10,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment:
                                                    Alignment.centerRight,
                                                child: getRankIconAndImage(
                                                    getRank(
                                                        entry.score, quizName),
                                                    100),
                                              ),
                                            ),
                                        ],
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

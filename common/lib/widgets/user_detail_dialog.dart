import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class UserDetailDialog extends HookConsumerWidget {
  final String uid;
  final String userName;

  const UserDetailDialog({
    super.key,
    required this.uid,
    required this.userName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 0 と 1 固定でモードを取得
    final mode0 = allData.mid[0];
    final mode1 = allData.mid[1];

    final tabController = useTabController(initialLength: 2);
    final selectedIndex =
        useListenableSelector(tabController, () => tabController.index);

    final isLoading = useState(true);
    final scoreMap = useState<Map<String, Map<String, dynamic>>>({});
    final rankMap = useState<Map<String, int>>({});
    final topScoreMap = useState<Map<String, double>>({});

    // データの一括取得
    useEffect(() {
      Future<void> fetchData() async {
        try {
          final scores = <String, Map<String, dynamic>>{};
          final ranks = <String, int>{};
          final tops = <String, double>{};
          final List<Future<void>> futures = [];

          for (var midData in [mode0, mode1]) {
            final rankingTabs = midData.modeData.rankingList ?? [];
            final modeType = midData.modeData.modeType;

            for (var tab in rankingTabs) {
              final docId = "${tab.id}_$modeType";

              futures.add((() async {
                final doc = await FirebaseFirestore.instance
                    .collection('users2')
                    .doc(uid)
                    .collection('scores')
                    .doc(docId)
                    .get();

                if (doc.exists) {
                  final data = doc.data()!;
                  scores[docId] = data;
                  final score = (data['score'] as num?)?.toDouble() ?? 0.0;

                  if (score > 0) {
                    final res = await ScoreManager.getMyRank(
                      quizId:
                          QuizId(resisterOrigin: tab.id, modeType: modeType),
                      myScoreMap: {PeriodType.all: score},
                      isSmallerBetter: midData.modeData.isSmallerBetter,
                      targetPeriods: [PeriodType.all],
                    );
                    if (res.isNotEmpty && res[PeriodType.all]! > 0)
                      ranks[docId] = res[PeriodType.all]!;
                  }
                }

                final top = await ScoreManager.getTopScore(
                  resisterOrigin: tab.id,
                  modeType: modeType,
                  isSmallerBetter: midData.modeData.isSmallerBetter,
                );
                tops[docId] = top;
              })());
            }
          }

          await Future.wait(futures);
          scoreMap.value = scores;
          rankMap.value = ranks;
          topScoreMap.value = tops;
        } catch (e) {
          debugPrint('Error fetching user details: $e');
        } finally {
          isLoading.value = false;
        }
      }

      fetchData();
      return null;
    }, [uid]);

    // モードごとの色を取得

    final activeColor = (selectedIndex == 0 ? Colors.blue : Colors.red);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TabBar(
              controller: tabController,
              labelColor: activeColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: activeColor,
              tabs: [
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          mode0.modeData.isbattle
                              ? mode0.modeData.modeIcon
                              : Icons.workspace_premium,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          mode0.modeData.isbattle
                              ? l10n(context, mode0.modeData.modeTitle)
                              : l10n(context, 'scoreLabel'),
                        ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          mode1.modeData.isbattle
                              ? mode1.modeData.modeIcon
                              : Icons.workspace_premium,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          mode1.modeData.isbattle
                              ? l10n(context, mode1.modeData.modeTitle)
                              : l10n(context, 'scoreLabel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: tabController,
                      children: [
                        _buildScoreList(
                          context: context,
                          midData: mode0,
                          scoreMap: scoreMap.value,
                          rankMap: rankMap.value,
                          topScoreMap: topScoreMap.value,
                          activeColor: Colors.blue,
                        ),
                        _buildScoreList(
                          context: context,
                          midData: mode1,
                          scoreMap: scoreMap.value,
                          rankMap: rankMap.value,
                          topScoreMap: topScoreMap.value,
                          activeColor: Colors.red,
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('閉じる'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreList({
    required BuildContext context,
    required MidData midData,
    required Map<String, Map<String, dynamic>> scoreMap,
    required Map<String, int> rankMap,
    required Map<String, double> topScoreMap,
    required Color activeColor,
  }) {
    // 表示する項目のリストを作成
    final List<RadarChartItem> items = (midData.modeData.rankingList as List)
        .map((tab) => RadarChartItem(tab: tab, midData: midData))
        .toList();

    if (items.isEmpty) {
      return const Center(child: Text('表示するカテゴリがありません'));
    }

    return Column(
      children: [
        UserRadarChart(
          midData: midData,
          scoreMap: scoreMap,
          topScoreMap: topScoreMap,
          activeColor: activeColor,
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              final tab = item.tab;
              final mData = item.midData;
              final modeType = mData.modeData.modeType;
              final unit = mData.modeData.unit;

              final docId = "${tab.id}_$modeType";
              final data = scoreMap[docId];

              final score = (data?['score'] as num?)?.toDouble() ?? 0.0;
              final updatedAt = (data?['updatedAt'] as Timestamp?)?.toDate();
              final rank = rankMap[docId];

              final currentColorCode = tab.color ?? "9";
              final tabColor =
                  getQuizColor2(currentColorCode, context, 1, 0.65, 1);

              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: tab.icon != null
                    ? Icon(tab.icon, color: tabColor, size: 28)
                    : null,
                title: Text(
                  l10n(context, tab.display),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: updatedAt != null
                    ? Text(
                        DateFormat('yyyy/MM/dd HH:mm').format(updatedAt),
                        style: const TextStyle(fontSize: 12),
                      )
                    : const Text('記録なし', style: TextStyle(fontSize: 12)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (rank != null)
                      Text(
                        '$rank${l10n(context, 'rankUnit')} ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    Text(
                      score > 0
                          ? score.toStringAsFixed(mData.modeData.fix)
                          : '--',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                    if (score > 0) ...[
                      const SizedBox(width: 2),
                      Text(
                        l10n(context, unit),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: tabColor,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

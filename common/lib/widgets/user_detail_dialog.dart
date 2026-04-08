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
    final mode0 = allData.mid[0];
    final mode1 = allData.mid[1];

    final tabController = useTabController(initialLength: 2);
    final selectedIndex =
        useListenableSelector(tabController, () => tabController.index);

    final isLoading = useState(true);
    // 複数の Map を廃止し、一つに集約
    final dataMap = useState<Map<String, UserDialogData>>({});

    useEffect(() {
      Future<void> fetchData() async {
        try {
          final newDataMap = <String, UserDialogData>{};
          final List<Future<void>> futures = [];

          for (var midData in [mode0, mode1]) {
            final rankingTabs = midData.modeData.rankingList ?? [];
            final modeType = midData.modeData.modeType;

            for (var tab in rankingTabs) {
              final docId = "${tab.id}_$modeType";
              futures.add((() async {
                final summary = await ScoreManager.getRankingSummary(
                  uid: uid,
                  quizId: QuizId(resisterOrigin: tab.id, modeType: modeType),
                  isSmallerBetter: midData.modeData.isSmallerBetter,
                );
                newDataMap[docId] = summary;
              })());
            }
          }

          await Future.wait(futures);
          dataMap.value = newDataMap;
        } catch (e) {
          debugPrint('Error fetching user details: $e');
        } finally {
          isLoading.value = false;
        }
      }

      fetchData();
      return null;
    }, [uid]);

    final activeColor = (selectedIndex == 0 ? Colors.blue : Colors.red);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints:
            const BoxConstraints(maxHeight: 600, maxWidth: 450), // 元の制約を維持
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
                _buildTabItem(context, mode0),
                _buildTabItem(context, mode1),
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
                          dataMap: dataMap.value,
                          activeColor: Colors.blue,
                        ),
                        _buildScoreList(
                          context: context,
                          midData: mode1,
                          dataMap: dataMap.value,
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

  // 元のタブのレイアウト（FittedBoxなど）を維持
  Widget _buildTabItem(BuildContext context, MidData mid) {
    return Tab(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mid.modeData.isbattle
                  ? mid.modeData.modeIcon
                  : Icons.workspace_premium,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mid.modeData.isbattle
                  ? l10n(context, mid.modeData.modeTitle)
                  : l10n(context, 'scoreLabel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreList({
    required BuildContext context,
    required MidData midData,
    required Map<String, UserDialogData> dataMap,
    required Color activeColor,
  }) {
    final List<dynamic> rankingList = midData.modeData.rankingList ?? [];

    if (rankingList.isEmpty) {
      return const Center(child: Text('表示するカテゴリがありません'));
    }

    return Column(
      children: [
        // 変換なしでそのまま渡せる！
        UserRadarChart(
          midData: midData,
          dataMap: dataMap,
          activeColor: activeColor,
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
            itemCount: rankingList.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tab = rankingList[index];
              final modeType = midData.modeData.modeType;
              final docId = "${tab.id}_$modeType";

              final item = dataMap[docId] ?? UserDialogData.empty();

              final tabColor =
                  getQuizColor2(tab.color ?? "9", context, 1, 0.65, 1);

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
                subtitle: Text(
                  item.updatedAt != null
                      ? DateFormat('yyyy/MM/dd HH:mm').format(item.updatedAt!)
                      : '記録なし',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (item.rank > 0)
                      Text(
                        '${item.rank}${l10n(context, 'rankUnit')} ',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    Text(
                      item.score > 0
                          ? item.score.toStringAsFixed(midData.modeData.fix)
                          : '--',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                    if (item.score > 0) ...[
                      const SizedBox(width: 2),
                      Text(
                        l10n(context, midData.modeData.unit),
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

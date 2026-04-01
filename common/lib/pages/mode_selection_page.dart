import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonModeSelectionPage extends HookConsumerWidget {
  const CommonModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedModeIndexProvider);
    final additionalPage1 = allData.additionalPage1;
    final additionalPage2 = allData.additionalPage2;

    // --- 1. ページの定義をひとまとめにする ---
    final List<PageConfig> pages = [
      // ゲームモード（allData.mid）
      ...allData.mid.asMap().entries.map((e) {
        // builderの中身を外側で定義しておくとスッキリします
        WidgetBuilder pageBuilder;
        if (e.key == 2 && additionalPage1 != null) {
          pageBuilder = (context) => additionalPage1.builder(context);
        } else {
          pageBuilder = (context) => CommonDetailCard(modeIndex: e.key);
        }

        return PageConfig(
          title: l10n(context, e.value.modeData.modeTitle),
          icon: e.value.modeData.modeIcon,
          color: _getGameModeColor(e.key),
          builder: pageBuilder,
          modeDescription: e.value.modeData.modeDescription, // 追加：モード説明を渡す
        );
      }),

      // ランキング
      PageConfig(
          title: l10n(context, 'rankingButton'),
          icon: Icons.emoji_events,
          color: Colors.amber,
          builder: (context) => const CommonRankingPage(),
          modeDescription: "・正解数ランキングは品詞別に集計されます。\n"
              "・ユーザーカードをタップすると他のユーザーの詳細データを確認できます。\n"
              "・レーダーチャートの1位の方の記録をMaxとしています。"),

      // 追加ページ2
      if (additionalPage2 != null)
        PageConfig(
          title: additionalPage2.title,
          icon: additionalPage2.icon,
          color: Colors.deepOrange, // 任意の色
          builder: (context) => additionalPage2.builder(context),
          modeDescription:
              "・上から、単語検索、並び替え,昇順/降順,タグ登録(☆♪)、品詞絞り込み、レベル絞り込みとなっています。\n\n"
              "・それぞれの単語の色は品詞を示しています。(赤：動詞, 青：名詞, 黄：形容詞, 緑：副詞, 紫：その他)\n\n"
              "・単語の下に直近5回の結果とすべての期間の結果を載せています。\n\n"
              "・△はヒントありで正解を示しています。正答率は△を50%として集計しています。",
        ),
    ];

    // インデックスが範囲外にならないようガード
    final safeIndex = selectedIndex >= pages.length ? 0 : selectedIndex;
    final currentPage = pages[safeIndex];

    return PopScope(
      canPop: false,
      child: AppAdScaffold(
        advisible: true,
        // --- 2. AppBarは現在のページ設定から取得 ---
        appBar: AppBar(
          centerTitle: true,
          // 中央：アイコンとタイトル
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentPage.icon),
              const SizedBox(width: 8),
              Text(
                currentPage.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // モード説明がある場合のみiアイコンを表示
              if (currentPage.modeDescription != null)
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  onPressed: () => showModeDescription(context, currentPage),
                ),
            ],
          ),
          // 右上：設定ボタン
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const SizedBox(width: 8), // 右端に少し余白
          ],
        ),
        // --- 3. IndexedStack もリストから生成 ---
        body: IndexedStack(
          index: safeIndex,
          children: pages.map((p) => p.builder(context)).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: (index) =>
              ref.read(selectedModeIndexProvider.notifier).update(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: currentPage.color,
          unselectedItemColor: Colors.grey,
          // --- 4. BottomNavigationBarItem も同じリストから生成 ---
          items: pages
              .map((p) => BottomNavigationBarItem(
                    icon: Icon(p.icon),
                    label: p.title,
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ゲームモードの色分けだけ残す
  Color _getGameModeColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}

// 内部管理用のクラス
class PageConfig {
  final String title;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;
  String? modeDescription; // 追加：モード説明用のフィールド
  PageConfig(
      {required this.title,
      required this.icon,
      required this.color,
      required this.builder,
      this.modeDescription});
}

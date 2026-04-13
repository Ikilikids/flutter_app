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
        if (e.key == 0 || e.key == 1) {
          WidgetBuilder pageBuilder =
              (context) => CommonDetailCard(modeIndex: e.key);

          return PageConfig(
            title: l10n(context, e.value.modeData.modeTitle),
            icon: e.value.modeData.modeIcon,
            color: _getGameModeColor(e.key),
            builder: pageBuilder,
            modeDescription: e.value.modeData.modeDescription, // 追加：モード説明を渡す
          );
        }
      }).whereType<PageConfig>(), // nullを除外
      if (additionalPage1 != null) additionalPage1,

      PageConfig(
          title: l10n(context, 'rankingButton'),
          icon: Icons.emoji_events,
          color: Colors.amber,
          builder: (context) => const CommonRankingPage(),
          modeDescription: "・ユーザーカードをタップすると他のユーザーの詳細データを確認できます。\n"
              "・レーダーチャートの1位の方の記録をMaxとしています。"),

      // 追加ページ2
      if (additionalPage2 != null) additionalPage2
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
      default:
        return Colors.blueGrey;
    }
  }
}

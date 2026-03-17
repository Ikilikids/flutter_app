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
    final List<_PageConfig> pages = [
      // ゲームモード（allData.mid）
      ...allData.mid.asMap().entries.map((e) {
        // builderの中身を外側で定義しておくとスッキリします
        WidgetBuilder pageBuilder;
        if (e.key == 2 && additionalPage1 != null) {
          pageBuilder = (context) => additionalPage1.builder(context);
        } else {
          pageBuilder = (context) => CommonDetailCard(modeIndex: e.key);
        }

        return _PageConfig(
          title: l10n(context, e.value.modeData.modeTitle ?? ''),
          icon: e.value.modeData.modeIcon ?? Icons.play_arrow,
          color: _getGameModeColor(e.key),
          builder: pageBuilder,
        );
      }),

      // ランキング
      _PageConfig(
        title: l10n(context, 'rankingButton'),
        icon: Icons.emoji_events,
        color: Colors.amber,
        builder: (context) => const CommonRankingPage(),
      ),

      // 設定
      _PageConfig(
        title: l10n(context, 'settingsButton'),
        icon: Icons.settings,
        color: Colors.green,
        builder: (context) => const SettingsPage(),
      ),

      // 追加ページ2
      if (additionalPage2 != null)
        _PageConfig(
          title: additionalPage2.title,
          icon: additionalPage2.icon,
          color: Colors.deepOrange, // 任意の色
          builder: (context) => additionalPage2.builder(context),
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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentPage.icon),
              const SizedBox(width: 8),
              Text(currentPage.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(currentPage.icon),
            ],
          ),
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
        return Colors.indigo;
      default:
        return Colors.blueGrey;
    }
  }
}

// 内部管理用のクラス
class _PageConfig {
  final String title;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;
  _PageConfig(
      {required this.title,
      required this.icon,
      required this.color,
      required this.builder});
}

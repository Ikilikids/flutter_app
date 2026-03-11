import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonModeSelectionPage extends HookConsumerWidget {
  const CommonModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // グローバルな状態（現在のタブIndex）を監視
    final selectedIndex = ref.watch(selectedModeIndexProvider);
    final additionalPage = allData.additionalPage;

    return PopScope(
      canPop: false,
      child: AppAdScaffold(
        appBar: _buildAppBar(context, selectedIndex),
        advisible: true,
        body: IndexedStack(
          index: selectedIndex,
          children: [
            ...allData.mid
                .asMap()
                .entries
                .map((e) => CommonDetailCard(modeIndex: e.key)),
            const CommonRankingPage(),
            const SettingsPage(),
            if (additionalPage != null) additionalPage.builder(context),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) =>
              ref.read(selectedModeIndexProvider.notifier).update(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _getTabColor(selectedIndex),
          unselectedItemColor: Colors.grey,
          items: [
            ...allData.mid
                .asMap()
                .entries
                .map((e) => _buildGameNavItem(context, e.key)),
            BottomNavigationBarItem(
              icon: const Icon(Icons.emoji_events),
              label: l10n(context, 'rankingButton'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: l10n(context, 'settingsButton'),
            ),
            if (additionalPage != null)
              BottomNavigationBarItem(
                icon: Icon(additionalPage.icon), // クラスで定義したアイコン
                label: additionalPage.title, // クラスで定義したタイトル
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, int index) {
    String title = '';
    IconData? icon;

    // index が 0 or 1 の時だけ allData.mid を参照する
    if (index < allData.mid.length) {
      final midData = allData.mid[index];
      title = l10n(context, midData.modeData.modeTitle ?? '');
      icon = midData.modeData.modeIcon;
    } else if (index == allData.mid.length) {
      title = l10n(context, 'rankingTitle');
      icon = Icons.emoji_events;
    } else if (index == allData.mid.length + 1) {
      title = l10n(context, 'settingsTitle');
      icon = Icons.settings;
    } else if (index == allData.mid.length + 2 &&
        allData.additionalPage != null) {
      title = allData.additionalPage!.title;
      icon = allData.additionalPage!.icon;
    }

    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon),
            const SizedBox(width: 8),
          ],
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon),
          ],
        ],
      ),
    );
  }

  // 名前を _buildGameNavItem に変更し、ゲーム用であることを明示
  BottomNavigationBarItem _buildGameNavItem(BuildContext context, int index) {
    // 安全装置：万が一範囲外ならデフォルトを出す
    if (index >= allData.mid.length) {
      return const BottomNavigationBarItem(
        icon: Icon(Icons.help),
        label: 'Error',
      );
    }

    final midData = allData.mid[index];
    return BottomNavigationBarItem(
      icon: Icon(midData.modeData.modeIcon ?? Icons.play_arrow),
      label: l10n(context, midData.modeData.modeTitle ?? ''),
    );
  }

  Color _getTabColor(int index) {
    final midLength = allData.mid.length;

    // ゲームモード
    if (index < midLength) {
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

    // ランキング
    if (index == midLength) {
      return Colors.amber; // 黄色
    }

    // 設定
    if (index == midLength + 1) {
      return Colors.green;
    }

    // 追加ページ
    if (index == midLength + 2) {
      return Colors.purple;
    }

    return Colors.grey;
  }
}

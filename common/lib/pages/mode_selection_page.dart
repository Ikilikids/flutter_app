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
            const CommonDetailCard(modeIndex: 0),
            const CommonDetailCard(modeIndex: 1),
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
            // インデックスを固定で渡さず、必要な情報を直接渡すか
            // allData.mid の範囲内であることを保証して呼ぶ
            _buildGameNavItem(context, 0),
            _buildGameNavItem(context, 1),
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
    } else if (index == 2) {
      title = l10n(context, 'rankingTitle');
      icon = Icons.emoji_events;
    } else if (index == 3) {
      title = l10n(context, 'settingsTitle');
      icon = Icons.settings;
    } else if (index == 4 && allData.additionalPage != null) {
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
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      case 4:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

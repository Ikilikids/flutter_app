import 'package:audioplayers/audioplayers.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CommonModeSelectionPage extends HookConsumerWidget {
  const CommonModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedModeIndexProvider);
    final uid = ref.watch(appUidProvider).requireValue;
    final userName = ref.watch(appUserNameProvider).requireValue;
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

    return VisibilityDetector(
        key: const Key('CommonModeSelectionPageKey'),
        onVisibilityChanged: (info) {
          // 画面が少しでも（0より大きく）見えた時、かつ「完全に」戻ってきたタイミング（1.0）
          if (info.visibleFraction == 1.0) {
            final player = ref.read(audioPlayerManagerProvider);

            // もし止まっていたら、どのIndexだろうとお構いなしに鳴らす
            if (player.state != PlayerState.playing) {
              ref
                  .read(audioPlayerManagerProvider.notifier)
                  .play('assets/sounds/Thunderbolt.mp3');
            }
          }
        },
        child: PopScope(
          canPop: false,
          child: AppAdScaffold(
            advisible: true,
            // --- 2. AppBarは現在のページ設定から取得 ---
            appBar: AppBar(
              // 中央：アイコンとタイトル
              title: ConstrainedBox(
                // AppBarの高さ（kToolbarHeight）を上限にする制約をかける
                constraints: const BoxConstraints(maxHeight: kToolbarHeight),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                  child: FittedBox(
                    fit: BoxFit.contain, // 高さいっぱいに収まるようにリサイズ
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => UserDetailDialog(
                                uid: uid,
                                userName: userName,
                              ),
                            );
                          },
                          child: Icon(Icons.account_circle_rounded,
                              size: 200, color: textColor1(context)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          userName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 100,
                              color: textColor1(context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 右上：設定ボタン
              actions: [
                if (currentPage.modeDescription != null)
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => showModeDescription(context, currentPage),
                  ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
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
        ));
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

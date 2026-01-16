import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonModeSelectionPage extends StatelessWidget {
  const CommonModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appConfig = Provider.of<AppConfig>(context);
    final title = appConfig.title;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CommonFirstPage(),
            ),
          );
        }
      },
      child: AppAdScaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// ===== 無制限モード =====
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    alignment: const Alignment(0, 0.5),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textColor1(context),
                        shadows: [
                          Shadow(
                            offset: Offset(1, 2), // 下方向
                            blurRadius: 4,
                            color: textColor2(context).withAlpha(128),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: _bigModeButton(
                  context: context,
                  color: Colors.blue,
                  icon: Icons.all_inclusive,
                  title: "無制限モード",
                  sub1: "---いつでも遊べる---",
                  sub2: "ハイスコアを目指そう！",
                  onPressed: () =>
                      _navigateToDetail(context, isLimitedMode: false),
                ),
              ),

              /// ===== 1日限定モード =====
              Expanded(
                flex: 2,
                child: _bigModeButton(
                  context: context,
                  color: Colors.red,
                  icon: Icons.timer,
                  title: "1日限定モード",
                  sub1: "---1日1回だけ挑戦---",
                  sub2: "集中して記録を狙おう！",
                  onPressed: () =>
                      _navigateToDetail(context, isLimitedMode: true),
                ),
              ),

              /// ===== 下段ボタン =====
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: _smallButton(
                        context: context,
                        color: Colors.grey,
                        text: "⚙ 設定",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingsPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _smallButton(
                        context: context,
                        color: Colors.orange,
                        text: "👑 ランキング",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommonRankingPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===== 大ボタン =====
  Widget _bigModeButton({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required String title,
    required String sub1,
    required String sub2,
    required VoidCallback onPressed,
  }) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox.expand(
            // ★必須

            child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    child: Icon(icon, color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                    child: Text(
                      sub1,
                      style: const TextStyle(
                        color: Color.fromARGB(150, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                    child: Text(
                      sub2,
                      style: const TextStyle(
                        color: Color.fromARGB(150, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  /// ===== 小ボタン =====
  Widget _smallButton({
    required BuildContext context,
    required Color color,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox.expand(
          // ★必須

          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: FittedBox(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 100),
              ),
            ),
          ),
        ));
  }

  void _navigateToDetail(BuildContext context, {required bool isLimitedMode}) {
    Provider.of<QuizStateProvider>(context, listen: false)
        .setLimitedMode(isLimitedMode);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommonDetailCard(
          isLimitedMode: isLimitedMode,
        ),
      ),
    );
  }
}

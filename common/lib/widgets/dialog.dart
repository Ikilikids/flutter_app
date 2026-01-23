import 'package:common/assistance/ad_manager.dart';
import 'package:common/pages/countdown_screen.dart';
import 'package:common/pages/detail_card.dart';
import 'package:common/widgets/color.dart';
import 'package:flutter/material.dart';

Future<void> showMenuDialog(
  BuildContext context,
  VoidCallback onSetGameOver,
  bool isLimitedMode,
) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("メニュー"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MenuButton(
              icon: Icons.close,
              label: "キャンセル",
              onPressed: () => Navigator.of(context).pop(false),
            ),
            _MenuButton(
              icon: Icons.refresh,
              label: "やり直し",
              onPressed: isLimitedMode
                  ? null
                  : () {
                      onSetGameOver(); // ← 呼び出し元のisGameOverを変更できる
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdInterstitialNavigator(
                            nextScreen: CommonCountdownScreen(),
                          ),
                        ),
                      );
                    },
            ),
            _MenuButton(
              icon: Icons.home,
              label: "ホームへ",
              onPressed: () {
                onSetGameOver();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdInterstitialNavigator(nextScreen: CommonDetailCard()),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}

/// 丸ボタン＋テキスト共通部品
class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed; // 変更

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

Widget menuButton(
  BuildContext context,
  VoidCallback onSetGameOver,
  bool isLimitedMode,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 5, right: 5),
    child: FittedBox(
      fit: BoxFit.contain,
      child: ElevatedButton(
        onPressed: () async {
          await showMenuDialog(context, onSetGameOver, isLimitedMode);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor1(context), // 0〜255 の範囲、128は約50%,
          elevation: 0, // 影をなくす
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 角丸
          ),
          fixedSize: const Size(60, 60), // ← 正方形に固定
          padding: EdgeInsets.all(8),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Icon(Icons.menu, size: 40, color: textColor2(context)),
        ),
      ),
    ),
  );
}

Future<void> showFlyingDialog(
  BuildContext context,
  VoidCallback onSetGameOver,
  bool isLimitedMode,
) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(buildContext).pop();
        },
        child: AlertDialog(
          title: const Text("おてつき！"),
          content: isLimitedMode
              ? const Text("また次回挑戦!!")
              : const Text("もう一度挑戦しますか？"),
          actions: [
            TextButton(
              child: const Text("ホームへ"),
              onPressed: () {
                onSetGameOver();
                Navigator.of(buildContext).pop();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdInterstitialNavigator(nextScreen: CommonDetailCard()),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: isLimitedMode
                  ? null
                  : () {
                      onSetGameOver();
                      Navigator.of(buildContext).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => AdInterstitialNavigator(
                            nextScreen: CommonCountdownScreen(),
                          ),
                        ),
                      );
                    },
              child: const Text("🔥もう一度 ▸"),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

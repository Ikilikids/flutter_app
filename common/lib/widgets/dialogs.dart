import 'package:common/common.dart';
import 'package:flutter/material.dart';

// CountdownScreen, DetailCard は呼び出し元のアプリのPageから import する必要があるので、ビルダー関数で渡す

Future<void> showMenuDialog({
  required BuildContext context,
  // quizinfo は使われていないので削除
  required VoidCallback onSetGameOver,
  required bool isLimitedMode,
  required Widget Function({required bool isLimitedMode}) countdownScreenBuilder, // CountdownScreenのビルダー
  required Widget Function({required bool isLimitedMode}) detailCardBuilder, // DetailCardのビルダー
}) async {
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
                      onSetGameOver();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdInterstitialNavigator(
                            nextScreen:
                                countdownScreenBuilder(isLimitedMode: isLimitedMode),
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
                    builder: (_) => AdInterstitialNavigator(
                        nextScreen: detailCardBuilder(isLimitedMode: isLimitedMode)),
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

Future<void> showFlyingDialog({
  required BuildContext context,
  required bool isLimitedMode,
  required Widget Function({required bool isLimitedMode}) countdownScreenBuilder, // CountdownScreenのビルダー
  required Widget Function({required bool isLimitedMode}) detailCardBuilder, // DetailCardのビルダー
}) async {
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
          title: const Text("フライング！"),
          content: isLimitedMode
              ? const Text("また次回挑戦!!")
              : const Text("もう一度挑戦しますか？"),
          actions: [
            TextButton(
              child: const Text("ホームへ"),
              onPressed: () {
                Navigator.of(buildContext).pop();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdInterstitialNavigator(
                        nextScreen: detailCardBuilder(isLimitedMode: isLimitedMode)),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: isLimitedMode
                  ? null
                  : () {
                      Navigator.of(buildContext).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => AdInterstitialNavigator(
                            nextScreen:
                                countdownScreenBuilder(isLimitedMode: isLimitedMode),
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

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

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

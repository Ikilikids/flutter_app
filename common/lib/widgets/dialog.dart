import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/providers/quiz_session_provider.dart';

// =====================
// メニューボタン（これだけ使う）
// =====================
class MenuButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () {
          openDialog(context);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          fixedSize: const Size(60, 60),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Icon(Icons.menu, size: 36),
      ),
    );
  }

  static void openDialog(BuildContext context, {bool isFlying = false}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      barrierLabel: 'MenuDialog',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return _GameMenuDialog(isFlying: isFlying);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: child,
          ),
        );
      },
    );
  }
}

// =====================
// Dialog本体
// =====================
class _GameMenuDialog extends ConsumerWidget {
  final bool isFlying;
  const _GameMenuDialog({required this.isFlying});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLimitedMode =
        ref.watch(currentDetailConfigProvider).modeData.islimited;
    final quizMode = ref.watch(
      quizSessionNotifierProvider.select((s) => s.currentQuestion?.mode),
    );
    final cancelProcess = quizMode != null
        ? ref.read(quizSessionNotifierProvider.notifier).cancelGame
        : null;
    return PopScope(
      canPop: !isFlying,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Material(
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              surfaceTintColor: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isFlying
                          ? l10n(context, 'dialogMistakeTitle')
                          : l10n(context, 'dialogMenuTitle'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _GameMenuButton(
                            icon: Icons.refresh,
                            label: l10n(context, 'retryButton'),
                            onPressed: isLimitedMode
                                ? null
                                : () {
                                    cancelProcess?.call();
                                    Navigator.pop(context);
                                    InterstitialAdHelper.navigate(
                                      context,
                                      CommonCountdownScreen(),
                                    );
                                  },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _GameMenuButton(
                            icon: Icons.home,
                            label: l10n(context, 'dialogHomeButton'),
                            onPressed: () {
                              cancelProcess?.call();
                              Navigator.pop(context);
                              InterstitialAdHelper.navigate(context, null);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================
// ボタン部品
// =====================
class _GameMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _GameMenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 48),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}

void showModeDescription(BuildContext context, PageConfig currentPage) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(currentPage.icon), Text('${currentPage.title}')],
        ),
        content: Text(
          currentPage.modeDescription!,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      );
    },
  );
}

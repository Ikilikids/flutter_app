import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayButton extends HookConsumerWidget {
  final QuizId quizId;
  final int? qcount;

  const PlayButton({
    required this.quizId,
    this.qcount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(quizDetailProvider(quizId));
    final detail = config.detail;
    final buttonType = config.buttonType;
    final accentColor = getQuizColor2(detail.color, context, 1, 0.55, 0.95);
    final isPlayedToday = buttonType == QuizButtonType.alreadyPlayed;

    // --- ロジック定義 (buildスコープの変数を使用) ---

    Future<void> handlePlay() async {
      ref.read(selectedQuizIdProvider.notifier).update(quizId);
      if (qcount != null) {
        ref
            .read(userStatusNotifierProvider.notifier)
            .updateQcount(quizId, qcount!);
      }
      if (config.modeData.islimited) {
        await ref.read(userStatusNotifierProvider.notifier).recordPlay(quizId);
      }
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CommonCountdownScreen()),
        );
      }
    }

    void handleWatchAd() {
      if (RewardedAdManager.isAdReady) {
        RewardedAdManager.showAd(onReward: () async {
          await ref
              .read(userStatusNotifierProvider.notifier)
              .grantReward(quizId);
        });
      } else {
        RewardedAdManager.loadAd();
      }
    }

    void showAdDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n(context, 'challengeAgainDialogTitle')),
          content: Text(l10n(context, 'challengeAgainDialogContent')),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n(context, 'cancelButton'))),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                handleWatchAd();
              },
              child: Text(l10n(context, 'watchAdButton')),
            ),
          ],
        ),
      );
    }

    // --- ButtonDataの生成ロジック ---

    ButtonData getButtonData() {
      // 基本テキストの設定
      String text;
      if (qcount != null && buttonType == QuizButtonType.play) {
        text = AppLocalizations.of(context)!.playButtonWithCount(qcount!);
      } else {
        final key = {
          QuizButtonType.play: 'playButton',
          QuizButtonType.playSecond: 'playButtonSecondTime',
          QuizButtonType.watchAd: 'watchAdToPlayButton',
          QuizButtonType.alreadyPlayed: 'playedTodayButton',
        }[buttonType]!;
        text = l10n(context, key);
      }

      // 背景色と文字色の設定
      Color bg;
      Color fg;
      BorderSide? border;

      if (isPlayedToday) {
        bg = Colors.grey;
        fg = Colors.white;
      } else if (qcount == 10) {
        bg = bgColor1(context);
        fg = accentColor;
        border = BorderSide(color: accentColor, width: 2);
      } else {
        bg = accentColor;
        fg = bgColor1(context);
      }

      // アクションの設定
      VoidCallback? action;
      if (!isPlayedToday) {
        action =
            (buttonType == QuizButtonType.watchAd) ? showAdDialog : handlePlay;
      }

      return ButtonData(
        buttonText: text,
        backgroundColor: bg,
        foregroundColor: fg,
        borderSide: border,
        onPressed: action,
      );
    }

    final data = getButtonData();

    // --- Widgetの生成 ---

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: ElevatedButton(
          onPressed: data.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: data.backgroundColor,
            foregroundColor: data.foregroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: data.borderSide,
          ),
          child: FittedBox(
            child: Text(
              data.buttonText,
              style:
                  const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonData {
  final String buttonText;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide? borderSide;
  final VoidCallback? onPressed;

  ButtonData({
    required this.buttonText,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide,
    this.onPressed,
  });
}

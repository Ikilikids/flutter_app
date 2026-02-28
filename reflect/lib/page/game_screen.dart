import 'dart:async';
import 'dart:math';

import 'package:common/common.dart';
import 'package:common/freezed/ui_config.dart';
import 'package:common/providers/app_sound.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'games/color_game.dart';
import 'games/grid_game.dart';
import 'games/number_game.dart';

class Gamescreen extends ConsumerStatefulWidget {
  final DetailConfig quizinfo;
  const Gamescreen({super.key, required this.quizinfo});

  @override
  ConsumerState<Gamescreen> createState() => _GamescreenState();
}

class _GamescreenState extends ConsumerState<Gamescreen> {
  late String mode;
  int trialCount = 0;
  final int maxTrials = 3;
  List<int> results = []; // ミリ秒単位

  // Game State
  bool isWaiting = true; // 準備中・遅延中
  bool isReadyToAct = false; // 反応受付中
  bool showResult = false; // 1回の試行結果表示中
  bool isGameOver = false;

  DateTime? startTime;
  Timer? _delayTimer;

  // Color Mode specific
  Color currentColor = Colors.grey;

  // Number Mode specific
  int targetNumber = -1;

  // Grid Mode specific
  int activeGridIndex = -1; // 0-8 for 3x3
  final int gridSize = 4;

  @override
  void initState() {
    super.initState();
    // quizinfo[0] に sort キーが入っている
    mode = widget.quizinfo.detail.sort;

    startTrial();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  void startTrial() {
    setState(() {
      isWaiting = true;
      isReadyToAct = false;
      showResult = false;

      // Reset specific states
      if (mode == "color") {
        currentColor = Colors.grey[400]!;
      }
      targetNumber = -1;
      activeGridIndex = -1;
    });

    // Random delay between 2 to 5 seconds
    final random = Random();
    final delay = Duration(milliseconds: 1500 + random.nextInt(4000));

    _delayTimer = Timer(delay, () {
      if (!mounted) return;
      prepareAction();
    });
  }

  void prepareAction() {
    setState(() {
      isWaiting = false;
      isReadyToAct = true;
      startTime = DateTime.now();

      switch (mode) {
        case "color":
          // ランダムな色にする
          currentColor = Colors.green;

          break;
        case "number":
          targetNumber = Random().nextInt(9) + 1; // 0-9
          break;
        case "grid":
          activeGridIndex = Random().nextInt(gridSize * gridSize);
          break;
      }
    });
  }

  void onAction({int? inputNumber, int? inputGridIndex}) {
    if (isWaiting) {
      // お手付き

      _delayTimer?.cancel();
      ref.read(appSoundProvider).requireValue.playSound('peke.mp3');
      showFlyingDialog(context, () {}, widget.quizinfo.modeData.islimited);
      return;
    }

    if (!isReadyToAct) return;

    bool isCorrect = false;

    if (mode == "color") {
      isCorrect = true; // タップすればOK
    } else if (mode == "number") {
      if (inputNumber == targetNumber) isCorrect = true;
    } else if (mode == "grid") {
      if (inputGridIndex == activeGridIndex) isCorrect = true;
    }

    if (isCorrect) {
      final endTime = DateTime.now();
      final elapsed = endTime.difference(startTime!).inMilliseconds;
      ref.read(appSoundProvider).requireValue.playSound('maru.mp3');

      handleSuccess(elapsed);
    } else {
      // 間違ったボタンやマスを押した場合（お手つき）

      showFlyingDialog(context, () {}, widget.quizinfo.modeData.islimited);
      ref.read(appSoundProvider).requireValue.playSound('peke.mp3');
    }
  }

  void handleSuccess(int elapsed) {
    setState(() {
      isReadyToAct = false;
      showResult = true;
      results.add(elapsed);
      trialCount++;
      if (trialCount >= maxTrials) {
        isGameOver = true;
      }
    });
    print(isGameOver);
    if (!mounted) return;
    if (trialCount >= maxTrials) {
      Future.delayed(const Duration(milliseconds: 500), () {
        finishGame();
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        startTrial();
      });
    }
  }

  void finishGame() {
    int finalScore;
    ref.read(appSoundProvider).requireValue.playSound('hoi.mp3');
    if (mode == "color") {
      // 最も悪い（遅い）記録を取得 (最大値)
      finalScore = results.reduce(max);
    } else {
      // 平均タイム
      finalScore = (results.reduce((a, b) => a + b) / results.length).round();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PipiScreen(totalScore: finalScore)),
    );
  }

  Widget _buildScoreHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...List.generate(maxTrials, (index) {
            final isCurrent = index == trialCount && !showResult;
            final isDone = index < results.length;
            String text = "";
            if (isDone) {
              text = "${results[index]}${l10n.unitMillisecond}";
            } else {
              text = l10n.tryNumber((index + 1).toString());
            }

            return Container(
              width: 80,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCurrent
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontWeight:
                      isCurrent || isDone ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            );
          }),
          menuButton(
            context,
            () => setState(() {}),
            widget.quizinfo.modeData.islimited,
            istap: !isGameOver,
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    final l10n = AppLocalizations.of(context)!;
    if (showResult) {
      // 試行ごとの結果表示（一瞬）
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.timeResultTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '${results.last} ${l10n.unitMillisecond}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    switch (mode) {
      case "color":
        return ColorGame(
          isWaiting: isWaiting,
          currentColor: currentColor,
          onTap: () => onAction(),
        );
      case "number":
        return NumberGame(
          isWaiting: isWaiting,
          targetNumber: targetNumber,
          onNumberSelected: (a) => onAction(inputNumber: a),
        );
      case "grid":
        return GridGame(
          isWaiting: isWaiting,
          isReadyToAct: isReadyToAct,
          activeGridIndex: activeGridIndex,
          gridSize: gridSize,
          onGridSelected: (idx) => onAction(inputGridIndex: idx),
        );
      default:
        return Center(child: Text(l10n.unknownMode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        isGameOver
            ? null
            : showMenuDialog(
                context,
                () => setState(() {
                  isGameOver = true;
                }),
                widget.quizinfo.modeData.islimited,
              );
      },
      child: AppAdScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(flex: 1, child: _buildScoreHeader()),
              Expanded(flex: 7, child: _buildGameArea()),
            ],
          ),
        ),
      ),
    );
  }
}

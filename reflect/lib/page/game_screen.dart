import 'dart:async';
import 'dart:math';

import 'package:common/common.dart';
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
  List<int> results = [];

  bool isWaiting = true;
  bool isReadyToAct = false;
  bool showResult = false;
  bool isGameOver = false;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _delayTimer;

  Color currentColor = Colors.grey;
  int targetNumber = -1;
  int activeGridIndex = -1;
  final int gridSize = 4;

  @override
  void initState() {
    super.initState();
    mode = widget.quizinfo.detail.sort;
    startTrial();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  /// サウンド再生の共通処理
  void _safePlaySound(String assetName) {
    final soundAction = ref.read(appSoundProvider).valueOrNull;
    if (soundAction != null) {
      soundAction.playSound(assetName);
    }
  }

  void startTrial() {
    if (!mounted) return;
    setState(() {
      isWaiting = true;
      isReadyToAct = false;
      showResult = false;
      if (mode == "color") currentColor = Colors.grey[400]!;
      targetNumber = -1;
      activeGridIndex = -1;
    });

    final random = Random();
    final delay = Duration(milliseconds: 1500 + random.nextInt(4000));

    _delayTimer = Timer(delay, () {
      if (!mounted) return;
      prepareAction();
    });
  }

  void prepareAction() {
    // 次の垂直同期（VSYNC）タイミングに合わせて実行
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        isWaiting = false;
        isReadyToAct = true;

        switch (mode) {
          case "color":
            currentColor = Colors.green;
            break;
          case "number":
            final availableNumbers = [1, 2, 3, 4, 6, 7, 8, 9];
            targetNumber =
                availableNumbers[Random().nextInt(availableNumbers.length)];
            break;
          case "grid":
            activeGridIndex = Random().nextInt(gridSize * gridSize);
            break;
        }
      });

      // 画面の描き換えが完了した瞬間に計測開始
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && isReadyToAct) {
          _stopwatch.reset();
          _stopwatch.start();
        }
      });
    });
  }

  void onAction({int? inputNumber, int? inputGridIndex}) {
    // 1. お手付き
    if (isWaiting) {
      _handleFoul();
      return;
    }

    // 2. すでに判定中（連打防止）
    if (!isReadyToAct || showResult) return;

    bool isCorrect = false;
    if (mode == "color") {
      isCorrect = true;
    } else if (mode == "number") {
      isCorrect = (inputNumber == targetNumber);
    } else if (mode == "grid") {
      isCorrect = (inputGridIndex == activeGridIndex);
    }

    if (isCorrect) {
      // 瞬時に停止して計測
      _stopwatch.stop();
      final elapsed = _stopwatch.elapsedMilliseconds;
      _safePlaySound('maru.mp3');
      handleSuccess(elapsed);
    } else {
      _handleFoul();
    }
  }

  void _handleFoul() {
    if (!isReadyToAct && !isWaiting) return; // すでに終了してたら無視

    _stopwatch.stop();
    _delayTimer?.cancel();
    _safePlaySound('peke.mp3');

    // 判定無効化
    setState(() => isReadyToAct = false);
    isGameOver = false;
    showMenuDialog(context,
        isLimitedMode: widget.quizinfo.modeData.islimited, isFlying: true);
  }

  void handleSuccess(int elapsed) {
    setState(() {
      isReadyToAct = false;
      showResult = true;
      results.add(elapsed);
      trialCount++;
      if (trialCount >= maxTrials) isGameOver = true;
    });

    if (!mounted) return;

    // 規定回数終了ならリザルトへ、続くなら次へ
    final nextStep =
        (trialCount >= maxTrials) ? () => finishGame() : () => startTrial();
    final delay = (trialCount >= maxTrials) ? 500 : 1000;

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) nextStep();
    });
  }

  void finishGame() {
    _safePlaySound('hoi.mp3');
    if (results.isEmpty) return;

    final int finalScore = (mode == "color")
        ? results.reduce(max) // 最も遅い記録
        : (results.reduce((a, b) => a + b) / results.length).round(); // 平均

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PipiScreen(totalScore: finalScore)),
    );
  }

  // --- UI構築（変更なしのため省略可能ですが、構造維持のため配置） ---
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
            final text = isDone
                ? "${results[index]}${l10n.unitMillisecond}"
                : l10n.tryNumber((index + 1).toString());
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
                    width: isCurrent ? 2 : 1),
              ),
              child: Text(text,
                  style: TextStyle(
                      fontWeight: isCurrent || isDone
                          ? FontWeight.bold
                          : FontWeight.normal)),
            );
          }),
          menuButton(context,
              isLimitedMode: widget.quizinfo.modeData.islimited,
              istap: !isGameOver),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    final l10n = AppLocalizations.of(context)!;
    if (showResult) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.timeResultTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text('${results.last} ${l10n.unitMillisecond}',
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
    switch (mode) {
      case "color":
        return ColorGame(
            isWaiting: isWaiting,
            currentColor: currentColor,
            onTap: () => onAction());
      case "number":
        return NumberGame(
            isWaiting: isWaiting,
            targetNumber: targetNumber,
            onNumberSelected: (a) => onAction(inputNumber: a));
      case "grid":
        return GridGame(
            isWaiting: isWaiting,
            isReadyToAct: isReadyToAct,
            activeGridIndex: activeGridIndex,
            onGridSelected: (idx) => onAction(inputGridIndex: idx));
      default:
        return Center(child: Text(l10n.unknownMode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || isGameOver) return;
        showMenuDialog(context,
            isLimitedMode: widget.quizinfo.modeData.islimited);
      },
      child: AppAdScaffold(
        body: SafeArea(
          child: Column(children: [
            Expanded(flex: 1, child: _buildScoreHeader()),
            Expanded(flex: 7, child: _buildGameArea()),
          ]),
        ),
      ),
    );
  }
}

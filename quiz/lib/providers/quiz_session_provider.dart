import 'dart:async';

import 'package:common/common.dart';
import "package:quiz/quiz.dart";
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_session_provider.g.dart';

// --- クイズ全体の進行状態 ---
class QuizSessionState {
  final MakingData? currentQuestion;
  final int totalScore;
  final int correctCount;
  final int remainingTime;
  final double elapsedTime;
  final bool isGameOver;
  final String resultMark;
  final bool isAnswerChecked;
  final List<String> marks;
  final List<MakingData> solvedQuestions;
  final DateTime? startTime;
  final int currentIndex;
  final String scoreFeedback1;
  final String scoreFeedback2;

  QuizSessionState({
    this.currentQuestion,
    this.totalScore = 0,
    this.correctCount = 0,
    this.remainingTime = 60,
    this.elapsedTime = 0,
    this.isGameOver = false,
    this.resultMark = '',
    this.isAnswerChecked = false,
    this.marks = const [],
    this.solvedQuestions = const [],
    this.startTime,
    this.currentIndex = 0,
    this.scoreFeedback1 = '',
    this.scoreFeedback2 = '',
  });

  QuizSessionState copyWith({
    MakingData? currentQuestion,
    int? totalScore,
    int? correctCount,
    int? remainingTime,
    double? elapsedTime,
    bool? isGameOver,
    String? resultMark,
    bool? isAnswerChecked,
    List<String>? marks,
    List<MakingData>? solvedQuestions,
    DateTime? startTime,
    int? currentIndex,
    String? scoreFeedback1,
    String? scoreFeedback2,
  }) {
    return QuizSessionState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalScore: totalScore ?? this.totalScore,
      correctCount: correctCount ?? this.correctCount,
      remainingTime: remainingTime ?? this.remainingTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isGameOver: isGameOver ?? this.isGameOver,
      resultMark: resultMark ?? this.resultMark,
      isAnswerChecked: isAnswerChecked ?? this.isAnswerChecked,
      marks: marks ?? this.marks,
      solvedQuestions: solvedQuestions ?? this.solvedQuestions,
      startTime: startTime ?? this.startTime,
      currentIndex: currentIndex ?? this.currentIndex,
      scoreFeedback1: scoreFeedback1 ?? this.scoreFeedback1,
      scoreFeedback2: scoreFeedback2 ?? this.scoreFeedback2,
    );
  }
}

@riverpod
class QuizSessionNotifier extends _$QuizSessionNotifier {
  Timer? _timer;

  @override
  QuizSessionState build() {
    ref.onDispose(() => _timer?.cancel());
    return QuizSessionState();
  }

  void init(DetailConfig config) {
    state = QuizSessionState(
      remainingTime: config.modeData.isbattle ? 60 : 0,
      elapsedTime: 0,
      marks: List.filled(config.qcount, ""),
      solvedQuestions: [],
      currentIndex: 0,
    );
    if (config.modeData.isbattle) {
      _startTimer(config);
    }
  }

  void _startTimer(DetailConfig config) {
    _timer?.cancel();
    if (config.appData.appTitle == "appTitle") {
      final startAt = DateTime.now();

      _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        final now = DateTime.now();
        final double diff = now.difference(startAt).inMilliseconds / 1000.0;

        state = state.copyWith(elapsedTime: diff);
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.remainingTime > 1) {
          state = state.copyWith(remainingTime: state.remainingTime - 1);
          ref.read(appSoundProvider).requireValue.playSound('ry.mp3');
        } else {
          state = state.copyWith(remainingTime: 0, isGameOver: true);
          timer.cancel();
        }
      });
    }
  }

  // ★ 追加：ゲームを即座に終了させる（バツ判定なし）
  void endGame() {
    _timer?.cancel();
  }

  void updateQuestion(MakingData question) {
    state = state.copyWith(
      currentQuestion: question,
      resultMark: '',
      isAnswerChecked: false,
      startTime: DateTime.now(),
      scoreFeedback1: '',
      scoreFeedback2: '',
    );
  }

  void nextQuestionIndex() {
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      solvedQuestions: state.currentQuestion != null
          ? [...state.solvedQuestions, state.currentQuestion!]
          : state.solvedQuestions,
    );
  }

  void handlePartPoint(int points) {
    final added = points;
    state = state.copyWith(
      totalScore: state.totalScore + added,
      scoreFeedback1: '+$added点',
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(scoreFeedback1: '');
    });
  }

  void judge(String result, DetailConfig config, {bool isHintUsed = false}) {
    if (state.isGameOver) return;

    final updatedMarks = List<String>.from(state.marks);
    if (state.currentIndex < updatedMarks.length) {
      updatedMarks[state.currentIndex] = result == "maru" ? "◯" : "×";
    }

    if (result == "peke") {
      ref.read(appSoundProvider).requireValue.playSound('peke.mp3');
      state = state.copyWith(
        resultMark: '×',
        isAnswerChecked: true,
        marks: updatedMarks,
        totalScore: (state.totalScore - 10).clamp(0, 999999),
        scoreFeedback1: '-10点',
      );
    } else {
      final p = state.currentQuestion!;
      int lastScore = 0;
      int soundLevel = 1;
      int bonus = 0;

      if (p is EngMakingData) {
        bonus = p.totalScore * 2;
        if (isHintUsed) {
          bonus = 0;
        }
        lastScore = p.word.length;
        soundLevel = 2;
      } else if (p is LatexMakingData && p.indexDataA.isNotEmpty) {
        lastScore = p.indexDataA.last.score * 10;
        soundLevel = p.indexDataA.length;

        int sumscore = p.totalScore * 10;
        Duration elapsed =
            DateTime.now().difference(state.startTime ?? DateTime.now());
        double decrease =
            elapsed.inMilliseconds * 0.002 / (sumscore > 0 ? sumscore : 1);
        bonus = (sumscore * (1 - decrease).clamp(0.0, 1.0)).round();
      } else {
        lastScore = p.totalScore * 10;

        int sumscore = p.totalScore * 10;
        Duration elapsed =
            DateTime.now().difference(state.startTime ?? DateTime.now());
        double decrease =
            elapsed.inMilliseconds * 0.002 / (sumscore > 0 ? sumscore : 1);
        bonus = (sumscore * (1 - decrease).clamp(0.0, 1.0)).round();
      }

      state = state.copyWith(
        resultMark: '◯',
        isAnswerChecked: true,
        marks: updatedMarks,
        totalScore: state.totalScore + lastScore + bonus,
        correctCount: state.correctCount + 1,
        scoreFeedback1: '+$lastScore点',
        scoreFeedback2: bonus > 0 ? '+$bonus点' : '',
      );

      if (soundLevel > 1) {
        ref.read(appSoundProvider).requireValue.playSound('marumaru.mp3');
      } else {
        ref.read(appSoundProvider).requireValue.playSound('maru.mp3');
      }
    }
  }
}

// --- LatexInputNotifierは変更なし ---
class LatexInputState {
  final List<String> latexOutputs;
  final int currentBoxIndex;
  final int boxSubIndex;
  final List<String> allEnteredSymbols;
  final Map<String, bool> buttonVisibility;

  LatexInputState({
    required this.latexOutputs,
    this.currentBoxIndex = 0,
    this.boxSubIndex = 0,
    this.allEnteredSymbols = const [],
    this.buttonVisibility = const {},
  });

  LatexInputState copyWith({
    List<String>? latexOutputs,
    int? currentBoxIndex,
    int? boxSubIndex,
    List<String>? allEnteredSymbols,
    Map<String, bool>? buttonVisibility,
  }) {
    return LatexInputState(
      latexOutputs: latexOutputs ?? this.latexOutputs,
      currentBoxIndex: currentBoxIndex ?? this.currentBoxIndex,
      boxSubIndex: boxSubIndex ?? this.boxSubIndex,
      allEnteredSymbols: allEnteredSymbols ?? this.allEnteredSymbols,
      buttonVisibility: buttonVisibility ?? this.buttonVisibility,
    );
  }
}

@riverpod
class LatexInputNotifier extends _$LatexInputNotifier {
  @override
  LatexInputState build() {
    final question =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));

    if (question is LatexMakingData) {
      final boxSymbols = RegExp("[◯○□☆]").allMatches(question.initialLatexA);
      final outputs = boxSymbols.map((m) => m.group(0)!).toList();
      final initialConfig =
          question.indexDataA.isNotEmpty ? question.indexDataA[0].button : "";

      return LatexInputState(
        latexOutputs: outputs,
        buttonVisibility: _calculateInitialVisibility(initialConfig),
        allEnteredSymbols: [],
        currentBoxIndex: 0,
        boxSubIndex: 0,
      );
    }
    return LatexInputState(latexOutputs: []);
  }

  Map<String, bool> _calculateInitialVisibility(String config) {
    final visibility = <String, bool>{};
    const labels = [
      "e",
      "p",
      "7",
      "8",
      "9",
      "r",
      "4",
      "5",
      "6",
      "f",
      "1",
      "2",
      "3",
      "-",
      "0",
      "+",
      "l",
      "s",
      "c",
      "t",
      "i",
      "^"
    ];
    for (var k in labels) {
      visibility[k] = false;
    }

    if (config == "a") {
      for (var k in ['s', 'c', 't', 'l']) {
        visibility[k] = true;
      }
    } else if (config == "[+-]") {
      for (var k in ['+', '-']) {
        visibility[k] = true;
      }
    } else {
      final hideChars = config.split('').toSet();
      for (var k in labels) {
        if (!hideChars.contains(k)) {
          visibility[k] = true;
        }
      }
    }
    visibility["f"] = false;
    visibility["^"] = false;
    return visibility;
  }

  void updateVisibility(String lastSymbol, int nextBoxSubIndex) {
    final nextVisibility = Map<String, bool>.from(state.buttonVisibility);
    if (nextBoxSubIndex >= 1) {
      for (var k in ["+", "-", "l", "s", "c", "t"]) {
        nextVisibility[k] = false;
      }
    }

    if ("0123456789p".contains(lastSymbol)) {
      nextVisibility["f"] = true;
      nextVisibility["^"] = true;
      nextVisibility["i"] = false;
    } else if (lastSymbol == "e") {
      nextVisibility["f"] = false;
      nextVisibility["^"] = true;
      nextVisibility["i"] = false;
    } else if (lastSymbol == "f") {
      nextVisibility["f"] = false;
      nextVisibility["^"] = false;
      nextVisibility["r"] = true;
    } else if (lastSymbol == "r" || lastSymbol == "^") {
      nextVisibility["r"] = false;
      nextVisibility["^"] = false;
      if (lastSymbol == "^") {
        nextVisibility["-"] = true;
      }
    }
    state = state.copyWith(buttonVisibility: nextVisibility);
  }

  void moveToNextBox(String nextConfig) {
    state = state.copyWith(
      currentBoxIndex: state.currentBoxIndex + 1,
      boxSubIndex: 0,
      buttonVisibility: _calculateInitialVisibility(nextConfig),
    );
  }

  void updateLatexOutput(int index, String value) {
    if (index >= state.latexOutputs.length) {
      return;
    }
    final newOutputs = List<String>.from(state.latexOutputs);
    newOutputs[index] = value;
    state = state.copyWith(latexOutputs: newOutputs);
  }

  void processSymbol(String symbol, DetailConfig config) {
    final sessionState = ref.read(quizSessionNotifierProvider);
    final sessionNotifier = ref.read(quizSessionNotifierProvider.notifier);
    final question = sessionState.currentQuestion;

    if (question is! LatexMakingData) return;
    if (sessionState.isAnswerChecked || sessionState.isGameOver) return;

    // シンボルを追加
    state = state.copyWith(
      allEnteredSymbols: [...state.allEnteredSymbols, symbol],
      boxSubIndex: state.boxSubIndex + 1,
    );

    final flatA = question.indexDataA.expand((e) => e.tokenList).toList();
    final flatB = question.indexDataB.expand((e) => e.tokenList).toList();

    bool isPrefixMatch(List<String> target) {
      if (target.isEmpty) return false;
      if (state.allEnteredSymbols.length > target.length) return false;
      for (int i = 0; i < state.allEnteredSymbols.length; i++) {
        if (target[i] != state.allEnteredSymbols[i]) return false;
      }
      return true;
    }

    bool matchA = isPrefixMatch(flatA);
    bool matchB = flatB.isNotEmpty && isPrefixMatch(flatB);

    if (matchA || matchB) {
      final currentPath = matchA ? question.indexDataA : question.indexDataB;
      final currentBoxTokens = currentPath[state.currentBoxIndex].tokenList;

      if (state.boxSubIndex == currentBoxTokens.length) {
        if (state.currentBoxIndex >= currentPath.length - 1) {
          sessionNotifier.judge("maru", config);
        } else {
          ref.read(appSoundProvider).requireValue.playSound('maru.mp3');
          sessionNotifier
              .handlePartPoint(currentPath[state.currentBoxIndex].score * 10);
          moveToNextBox(currentPath[state.currentBoxIndex + 1].button);
        }
      } else {
        updateVisibility(symbol, state.boxSubIndex);
      }
    } else {
      sessionNotifier.judge("peke", config);
    }
  }

  void addSymbol(String symbol) {
    state = state.copyWith(
      allEnteredSymbols: [...state.allEnteredSymbols, symbol],
      boxSubIndex: state.boxSubIndex + 1,
    );
  }
}

// --- EngInputState & EngInputNotifier ---
class EngInputState {
  final String enteredText;
  final List<String> availableButtons;
  final bool isHintUsed;

  EngInputState({
    required this.enteredText,
    required this.availableButtons,
    this.isHintUsed = false,
  });

  EngInputState copyWith({
    String? enteredText,
    List<String>? availableButtons,
    bool? isHintUsed,
  }) {
    return EngInputState(
      enteredText: enteredText ?? this.enteredText,
      availableButtons: availableButtons ?? this.availableButtons,
      isHintUsed: isHintUsed ?? this.isHintUsed,
    );
  }
}

final engInputNotifierProvider =
    NotifierProvider<EngInputNotifier, EngInputState>(EngInputNotifier.new);

class EngInputNotifier extends Notifier<EngInputState> {
  @override
  EngInputState build() {
    final question =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));

    if (question is EngMakingData) {
      return EngInputState(
        enteredText: "",
        availableButtons: List.from(question.buttons),
        isHintUsed: false,
      );
    }
    return EngInputState(
        enteredText: "", availableButtons: [], isHintUsed: false);
  }

  void processLetter(int index, DetailConfig config) {
    final sessionState = ref.read(quizSessionNotifierProvider);
    final sessionNotifier = ref.read(quizSessionNotifierProvider.notifier);
    final question = sessionState.currentQuestion;

    if (question is! EngMakingData) return;
    if (sessionState.isAnswerChecked || sessionState.isGameOver) return;

    final buttons = List<String>.from(state.availableButtons);
    final char = buttons[index];
    if (char.endsWith('*')) return; // 使用済み

    final nextText = state.enteredText + char;
    buttons[index] = '$char*'; // 使用済みマークを付ける

    state = state.copyWith(
      enteredText: nextText,
      availableButtons: buttons,
    );

    final targetWord = question.word.toLowerCase();

    if (targetWord.startsWith(nextText)) {
      if (nextText.length == targetWord.length) {
        // 完成時は judge でボーナス加算（最後の1文字の部分点もここで出すなら追加可能）
        sessionNotifier.judge("maru", config, isHintUsed: state.isHintUsed);
      } else {
        // 途中の正解入力：部分点10点
        sessionNotifier.handlePartPoint(nextText.length);
        ref.read(appSoundProvider).requireValue.playSound('maru.mp3');
      }
    } else {
      sessionNotifier.judge("peke", config);
    }
  }

  void giveHint(DetailConfig config) {
    final sessionState = ref.read(quizSessionNotifierProvider);
    final question = sessionState.currentQuestion;
    if (question is! EngMakingData) return;
    if (state.enteredText.isNotEmpty) return; // 1文字目のみ

    state = state.copyWith(isHintUsed: true);

    final firstChar = question.word[0].toLowerCase();
    // 未使用のボタンの中から、最初の1文字目を探す
    final index = state.availableButtons.indexWhere((b) => b == firstChar);
    if (index != -1) {
      processLetter(index, config);
    }
  }

  void backspace() {
    if (state.enteredText.isNotEmpty) {
      final lastChar = state.enteredText[state.enteredText.length - 1];
      final nextText =
          state.enteredText.substring(0, state.enteredText.length - 1);

      final buttons = List<String>.from(state.availableButtons);
      // 最後に使用されたその文字のボタン（末尾が*のもの）を探して元に戻す
      final marker = '$lastChar*';
      final index = buttons.lastIndexOf(marker);
      if (index != -1) {
        buttons[index] = lastChar;
      }

      state = state.copyWith(
        enteredText: nextText,
        availableButtons: buttons,
      );
    }
  }
}

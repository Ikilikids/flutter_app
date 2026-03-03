import 'dart:async';
import 'package:math_quiz/math_quiz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:common/freezed/ui_config.dart';
import 'package:common/providers/app_sound.dart';

part 'quiz_session_provider.g.dart';

// --- クイズ全体の進行状態 ---
class QuizSessionState {
  final MakingData? currentQuestion;
  final int totalScore;
  final int correctCount;
  final int remainingTime;
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
      marks: List.filled(config.qcount, ""),
      solvedQuestions: [],
      currentIndex: 0,
    );
    if (config.modeData.isbattle) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
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

  // ★ 追加：ゲームを即座に終了させる（バツ判定なし）
  void endGame() {
    _timer?.cancel();
    state = state.copyWith(isGameOver: true);
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
    final added = points * 10;
    state = state.copyWith(
      totalScore: state.totalScore + added,
      scoreFeedback1: '+$added点',
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(scoreFeedback1: '');
    });
  }

  void judge(String result, DetailConfig config) {
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

      if (p is LatexMakingData && p.indexDataA.isNotEmpty) {
        lastScore = p.indexDataA.last.score * 10;
        soundLevel = p.indexDataA.length;
      } else {
        lastScore = p.totalScore * 10;
      }

      int sumscore = p.totalScore * 10;
      Duration elapsed = DateTime.now().difference(state.startTime ?? DateTime.now());
      double decrease = elapsed.inMilliseconds * 0.002 / (sumscore > 0 ? sumscore : 1);
      int bonus = (sumscore * (1 - decrease).clamp(0.0, 1.0)).round();

      state = state.copyWith(
        resultMark: '◯',
        isAnswerChecked: true,
        marks: updatedMarks,
        totalScore: state.totalScore + lastScore + bonus,
        correctCount: state.correctCount + 1,
        scoreFeedback1: '+$lastScore点',
        scoreFeedback2: '+$bonus点',
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
    final question = ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));
    
    if (question is LatexMakingData) {
      final boxSymbols = RegExp("[◯○□☆]").allMatches(question.initialLatexA);
      final outputs = boxSymbols.map((m) => m.group(0)!).toList();
      final initialConfig = question.indexDataA.isNotEmpty ? question.indexDataA[0].button : "";
      
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
    const labels = ["e", "p", "7", "8", "9", "r", "4", "5", "6", "f", "1", "2", "3", "-", "0", "+", "l", "s", "c", "t", "i", "^"];
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
          sessionNotifier.handlePartPoint(currentPath[state.currentBoxIndex].score);
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

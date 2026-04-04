import 'dart:async';

import 'package:common/common.dart';
import "package:quiz/quiz.dart";
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'word_stats_provider.dart';

part 'quiz_session_provider.g.dart';

// --- クイズ全体の進行状態 ---
class QuizSessionState {
  final MakingData? currentQuestion;
  final int totalScore;
  final int correctCount;
  final int remainingTime;
  final double elapsedTime;
  final bool isGameOver;
  final QuizResult resultMark;
  final bool isAnswerChecked;
  final List<QuizResult> marks;
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
    this.resultMark = QuizResult.unknown,
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
    QuizResult? resultMark,
    bool? isAnswerChecked,
    List<QuizResult>? marks,
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

enum QuizResult { circle, cross, triangle, unknown }

String quizResultToEmoji(QuizResult r) {
  switch (r) {
    case QuizResult.circle:
      return '○';
    case QuizResult.cross:
      return '×';
    case QuizResult.triangle:
      return '△';
    case QuizResult.unknown:
      return '？';
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
      marks: config.modeData.isbattle
          ? []
          : List.filled(config.qcount, QuizResult.unknown),
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
          ref.read(appSoundProvider).playSound('ry.mp3');
        } else {
          state = state.copyWith(remainingTime: 0, isGameOver: true);
          timer.cancel();
        }
      });
    }
  }

  void endGame() {
    _timer?.cancel();
  }

  void updateQuestion(MakingData question) {
    state = state.copyWith(
      currentQuestion: question,
      resultMark: QuizResult.unknown,
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

  void judge(
    QuizResult quizResult,
    DetailConfig config,
  ) {
    if (state.isGameOver) return;
    final bool isHintUsed = quizResult == QuizResult.triangle;
    final currentQ = state.currentQuestion;
    if (currentQ is EngMakingData) {
      final statsNotifier = ref.read(wordStatsNotifierProvider.notifier);
      statsNotifier.recordResult(currentQ.word, quizResult);
    }
    final updatedMarks = List<QuizResult>.from(state.marks);
    if (state.currentIndex < updatedMarks.length) {
      updatedMarks[state.currentIndex] = quizResult;
    } else {
      updatedMarks.add(quizResult);
    }

    if (quizResult == QuizResult.cross) {
      final manager = ref.read(appSoundProvider);
      manager.playSound('peke.mp3');
      state = state.copyWith(
        resultMark: QuizResult.cross,
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
        resultMark: quizResult,
        isAnswerChecked: true,
        marks: updatedMarks,
        totalScore: state.totalScore + lastScore + bonus,
        correctCount: state.correctCount + 1,
        scoreFeedback1: '+$lastScore点',
        scoreFeedback2: bonus > 0 ? '+$bonus点' : '',
      );

      if (soundLevel > 1) {
        ref.read(appSoundProvider).playSound('marumaru.mp3');
      } else {
        ref.read(appSoundProvider).playSound('maru.mp3');
      }
    }
  }
}

import 'dart:async';

import 'package:common/common.dart';
import "package:quiz/quiz.dart";
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'word_stats_provider.dart';

part 'quiz_session_provider.g.dart';

@Riverpod(keepAlive: true)
class QuizSessionNotifier extends _$QuizSessionNotifier {
  @override
  QuizSessionState build() {
    return QuizSessionState();
  }

  void init(DetailConfig config) {
    state = QuizSessionState(
      historyMarks: config.modeData.isbattle
          ? []
          : List.filled(config.qcount, QuizResult.unknown),
      historyQuestions: [],
      currentIndex: 0,
    );
    if (config.modeData.isbattle) {
      _startTimer(config);
    }
  }

  void _startTimer(DetailConfig config) {
    if (config.timeMode == TimeMode.timeAttack) {
      ref.read(quizElapsedTimerProvider.notifier).start();
    } else if (config.timeMode == TimeMode.countDown) {
      ref.read(quizRemainingTimerProvider.notifier).start();
    }
  }

  void cancelGame() {
    print("Game cancelled by user.");
    _stopAllTimers();
    state = state.copyWith(
      status: QuizSessionStatus.cancelled,
      isGameOver: true,
    );
  }

  void endGame() {
    _stopAllTimers();
    state = state.copyWith(
      status: QuizSessionStatus.finished,
      isGameOver: true,
    );
  }

  void _stopAllTimers() {
    ref.read(quizElapsedTimerProvider.notifier).stop();
    ref.read(quizRemainingTimerProvider.notifier).stop();
  }

  void handlePartPoint(int points, {bool isHintUsed = false}) {
    final sound = isHintUsed ? 'pi.mp3' : 'maru.mp3';
    ref.read(appSoundProvider).playSound(sound);
    final added = points;
    state = state.copyWith(
      totalScore: state.totalScore + added,
      scoreFeedback1: '+$added点',
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(scoreFeedback1: '');
    });
  }

  void judge(QuizResult quizResult) {
    final config = ref.read(currentDetailConfigProvider);

    // 1. 各種データの更新値を計算（state自体はまだ書き換えない）
    updateSound(quizResult);
    final updatedCategoryScores =
        _calculateCategoryScoreMap(config, quizResult);
    final updatedHistoryMarks = _calculateHistoryMarks(quizResult);
    final updatedHistoryQuestions = _calculateHistoryQuestions();

    // 2. スコアとフィードバックの計算
    final scoreResult = _calculateScoreUpdate(quizResult, config);

    // 英単語モードなら単語ごとの統計も更新
    _recordEngWord(quizResult);

    // 3. 最後に一括で state を更新
    state = state.copyWith(
      resultMark: quizResult,
      categortScore: updatedCategoryScores,
      historyMarks: updatedHistoryMarks,
      historyQuestions: updatedHistoryQuestions,
      totalScore: scoreResult.totalScore,
      scoreFeedback1: scoreResult.feedback1,
      scoreFeedback2: scoreResult.feedback2,
      isAnswerChecked: true,
    );

    handlePostAnswer();
  }

  // --- 内部計算用ロジック（値を返すだけで state は触らない） ---
  void updateSound(QuizResult quizResult) {
    final timeMode = ref.read(currentDetailConfigProvider).timeMode;

    if (quizResult == QuizResult.cross) {
      ref.read(appSoundProvider).playSound('peke.mp3');
    } else if (quizResult == QuizResult.triangle ||
        timeMode == TimeMode.timeAttack) {
      ref.read(appSoundProvider).playSound('maru.mp3');
    } else if (quizResult == QuizResult.circle) {
      ref.read(appSoundProvider).playSound('marumaru.mp3');
    }
  }

  Map<String, int> _calculateCategoryScoreMap(
      DetailConfig config, QuizResult quizResult) {
    final updatedScores = Map<String, int>.from(state.categortScore);
    final currentQuestion = state.currentQuestion!;
    String? category;

    if (currentQuestion.mode == QuizMode.eng) {
      category = generateEngLabel(currentQuestion.domain);
    } else if (currentQuestion.mode.isMath) {
      category = generateMathLabel(currentQuestion.subject);
    }

    if (category != null && quizResult == QuizResult.circle) {
      updatedScores[category] = (updatedScores[category] ?? 0) + 1;
    }
    return updatedScores;
  }

  List<QuizResult> _calculateHistoryMarks(QuizResult quizResult) {
    final updatedMarks = List<QuizResult>.from(state.historyMarks);
    if (state.currentIndex < updatedMarks.length) {
      updatedMarks[state.currentIndex] = quizResult;
    } else {
      updatedMarks.add(quizResult);
    }
    return updatedMarks;
  }

  List<MakingData> _calculateHistoryQuestions() {
    return state.currentQuestion != null
        ? [...state.historyQuestions, state.currentQuestion!]
        : state.historyQuestions;
  }

  void _recordEngWord(QuizResult quizResult) {
    if (state.currentQuestion is! EngMakingData) return;
    String word = (state.currentQuestion as EngMakingData).word;
    ref.read(wordStatsNotifierProvider.notifier).recordResult(word, quizResult);
  }

  // スコア計算の結果をまとめて返すためのクラスまたはレコード
  ({int totalScore, String feedback1, String feedback2}) _calculateScoreUpdate(
      QuizResult quizResult, DetailConfig config) {
    int totalScore = state.totalScore;
    String feedback1 = '';
    String feedback2 = '';

    if (quizResult == QuizResult.cross) {
      totalScore = (totalScore - 10).clamp(0, 1000);
      feedback1 = '-10点';
    } else if (quizResult == QuizResult.triangle) {
      final p = state.currentQuestion as EngMakingData;
      int lastScore = p.word.length;
      totalScore += lastScore;
      feedback1 = '+$lastScore点';
    } else if (quizResult == QuizResult.circle) {
      final p = state.currentQuestion!;
      int lastScore = 0;
      int bonus = 0;

      if (p is EngMakingData) {
        bonus = p.totalScore * 2;
        lastScore = p.word.length;
      } else if (p is LatexMakingData || p is OptionMakingData) {
        int sumscore = p.totalScore * 10;
        if (p is LatexMakingData) {
          lastScore = p.indexDataA.last.score * 10;
        } else if (p is OptionMakingData) {
          lastScore = p.totalScore * 10;
        }
        Duration elapsed =
            DateTime.now().difference(state.startTime ?? DateTime.now());
        double decrease = elapsed.inMilliseconds * 0.002 / sumscore;
        bonus = (sumscore * (1 - decrease).clamp(0.0, 1.0)).round();
      }
      totalScore += (lastScore + bonus);
      feedback1 = '+$lastScore点';
      feedback2 = bonus > 0 ? '+$bonus点' : '';
    }

    return (totalScore: totalScore, feedback1: feedback1, feedback2: feedback2);
  }
  // --- 問題選出・更新ロジック ---

  void updateQuestionFlow({bool isInitial = false}) {
    if (!isInitial) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
      );
    }
    final ct = _chooseRandomByScoreRange();
    final question = MakingData.fromPart(ct);

    state = state.copyWith(
      currentQuestion: question,
      resultMark: QuizResult.unknown,
      isAnswerChecked: false,
      startTime: DateTime.now(),
      scoreFeedback1: '',
      scoreFeedback2: '',
    );
  }

  PartData _chooseRandomByScoreRange() {
    final quizinfo = ref.read(currentDetailConfigProvider);
    final filteredMapByScore = ref.read(activeGameMapProvider);
    final mode = filteredMapByScore[1]!.first.mode;

    return mode.pick(
      filteredMapByScore: filteredMapByScore,
      currentIndex: state.currentIndex,
      correctCount: state.correctCount,
      sortKey: quizinfo.detail.sort,
      isBattleMode: quizinfo.modeData.isbattle,
    );
  }
// quiz_session_provider.dart 内

  Future<void> handlePostAnswer() async {
    final config = ref.read(currentDetailConfigProvider);
    final mode = state.currentQuestion!.mode;
    final delayMs = mode.isMath ? 400 : 150;

    if (state.isGameOver) return;

    final bool shouldFinish = switch (config.timeMode) {
      TimeMode.timeAttack => state.correctCount >= config.qcount,
      TimeMode.countDown => false,
      TimeMode.learning => state.currentIndex >= config.qcount - 1,
    };

    if (shouldFinish) {
      endGame();
    } else {
      await Future.delayed(Duration(milliseconds: delayMs));
      if (state.isGameOver) return;
      updateQuestionFlow();
    }
  }
}

String generateMathLabel(String sort) {
  if (sort == "1" || sort == "A") return "数Ⅰ・数A";
  if (sort == "2" || sort == "B") return "数Ⅱ・数B";
  if (sort == "3" || sort == "C") return "数Ⅲ・数C";
  return sort;
}

String generateEngLabel(String domain) {
  if (domain == "動詞") {
    return "動詞";
  } else if (domain == "形容詞" || domain == "副詞") {
    return "形容詞・副詞";
  } else {
    return "名詞・その他";
  }
}

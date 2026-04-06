import 'package:freezed_annotation/freezed_annotation.dart';

import '../quiz.dart';

part 'quiz_session_state.freezed.dart';

@freezed
class QuizSessionState with _$QuizSessionState {
  const QuizSessionState._();

  const factory QuizSessionState({
    MakingData? currentQuestion,
    @Default([]) List<MakingData> historyQuestions,
    @Default({}) Map<String, int> categortScore, // タイポも今のうちに修正！
    @Default(0) int totalScore,
    @Default(false) bool isGameOver,
    @Default(QuizSessionStatus.playing) QuizSessionStatus status,
    @Default(QuizResult.unknown) QuizResult resultMark,
    @Default(false) bool isAnswerChecked,
    @Default([]) List<QuizResult> historyMarks,
    DateTime? startTime,
    @Default(0) int currentIndex,
    @Default('') String scoreFeedback1,
    @Default('') String scoreFeedback2,
  }) = _QuizSessionState;
  // ★ Getter を定義
  int get correctCount =>
      historyMarks.where((m) => m == QuizResult.circle).length;
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

enum QuizSessionStatus {
  playing,
  finished, // 完走して終了
  cancelled, // 中断して終了
}

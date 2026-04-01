import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_status.freezed.dart';

@freezed
class QuizId with _$QuizId {
  const QuizId._();

  const factory QuizId({
    required String resisterOrigin,
    required String modeType,
  }) = _QuizId;

  @override
  String toString() => '${resisterOrigin}_$modeType';
}

enum QuizButtonType {
  play,
  playSecond,
  watchAd,
  alreadyPlayed,
}

@freezed
class QuizStatus with _$QuizStatus {
  const factory QuizStatus({
    required QuizId id,
    @Default(0) num highScore,
    @Default(QuizButtonType.play) QuizButtonType buttonType,
    @Default(0) int playCount,
    @Default(5) int qCount,
  }) = _QuizStatus;
}

@freezed
class UserStatus with _$UserStatus {
  const factory UserStatus({
    required Map<QuizId, QuizStatus> quizzes,
  }) = _UserStatus;
}

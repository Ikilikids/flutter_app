import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_status.freezed.dart';

@freezed
class QuizStatus with _$QuizStatus {
  const factory QuizStatus({
    required String id, // "${detail.resisterOrigin}_${modeType}"
    @Default(0) num highScore,
    @Default('playButton') String buttonText,
    @Default(0) int playCount,
    @Default(5) int qCount,
  }) = _QuizStatus;
}

@freezed
class ModeStatus with _$ModeStatus {
  const factory ModeStatus({
    required String modeType,
  }) = _ModeStatus;
}

@freezed
class UserStatus with _$UserStatus {
  const factory UserStatus({
    required List<QuizStatus> quizzes,
    required List<ModeStatus> modes,
    @Default('') String selectedModeId,
    @Default('') String selectedDetailId,
  }) = _UserStatus;
}

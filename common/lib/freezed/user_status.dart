import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_status.freezed.dart';

@freezed
class QuizId with _$QuizId {
  const QuizId._();

  const factory QuizId({
    required String resisterOrigin,
    required String modeType,
  }) = _QuizId;

  factory QuizId.fromString(String key) {
    final parts = key.split('_'); // 't_101' -> ['t', '101']
    return QuizId(
      resisterOrigin: parts[0],
      modeType: parts[1],
    );
  }

  @override
  String toString() => '${resisterOrigin}_$modeType';
}

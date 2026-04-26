import 'package:common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'status.freezed.dart';
part 'status.g.dart';

@freezed
class QuizStatus with _$QuizStatus {
  const factory QuizStatus({
    @Default(0) num highScore,
    @Default(QuizButtonType.play) QuizButtonType buttonType,
    @Default(5) int qCount,
  }) = _QuizStatus;
}

enum QuizButtonType {
  play,
  playSecond,
  watchAd,
  alreadyPlayed,
}

@Riverpod(keepAlive: true) // これが必要
Future<Map<QuizId, QuizStatus>> quizStatusMap(Ref ref) async {
  // すでにロジックを持っている各Notifierの「結果」だけを監視
  final scores = await ref.watch(scoreNotifierProvider.future);
  final buttonTypes = await ref.watch(buttonNotifierProvider.future);
  final quizCounts = await ref.watch(quizCountNotifierProvider.future);

  // すべてのキー（QuizId）を抽出
  final allIds = <QuizId>{
    ...scores.keys,
    ...buttonTypes.keys,
    ...quizCounts.keys,
  };

  return {
    for (final id in allIds)
      id: QuizStatus(
        highScore: scores[id] ?? 0.0,
        buttonType: buttonTypes[id] ?? QuizButtonType.play, // デフォルト値は適宜
        qCount: quizCounts[id] ?? 5,
      ),
  };
}

String getDateKey() {
  final now = DateTime.now();
  return "${now.year}-${now.month}-${now.day}";
}

import 'package:common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'score.g.dart';

@Riverpod(keepAlive: true)
class ScoreNotifier extends _$ScoreNotifier {
  @override
  Future<Map<QuizId, double>> build() async {
    final allScoresMap = await ScoreManager.getScoresAll();
    return allScoresMap;
  }

  Future<void> updateScoreLocally(QuizId id, num newScore) async {
    final currentScores = state.requireValue;
    final updatedScores = Map<QuizId, double>.from(currentScores);
    updatedScores[id] = newScore.toDouble();
    state = AsyncData(updatedScores);
  }
}

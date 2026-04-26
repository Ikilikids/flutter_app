import 'package:common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_count.g.dart';

@Riverpod(keepAlive: true)
class QuizCountNotifier extends _$QuizCountNotifier {
  @override
  Future<Map<QuizId, int>> build() async {
    final Map<QuizId, int> result = {};
    return result;
  }

  Future<void> selectQuizCount(QuizId id, int quizCount) async {
    final currentCounts = state.requireValue;
    final updatedCounts = Map<QuizId, int>.from(currentCounts);
    updatedCounts[id] = quizCount;
    state = AsyncData(updatedCounts);
  }
}

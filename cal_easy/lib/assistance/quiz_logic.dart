import 'dart:math';

List<String> prepareQuizDirectives(String selectedSortString) {
  final quizTypes = selectedSortString.split('');
  if (quizTypes.isEmpty) {
    return [];
  }

  List<String> quizDirectives = [];
  final int numCategories = quizTypes.length;
  final int baseCount = 20 ~/ numCategories;
  final int remainder = 20 % numCategories;

  for (int i = 0; i < numCategories; i++) {
    final int count = baseCount + (i < remainder ? 1 : 0);
    for (int j = 0; j < count; j++) {
      quizDirectives.add(quizTypes[i]);
    }
  }

  quizDirectives.shuffle(Random());
  return quizDirectives;
}

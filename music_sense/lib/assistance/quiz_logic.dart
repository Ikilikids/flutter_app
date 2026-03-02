import 'dart:math';

List<String> prepareQuizDirectives(String selectedSortString) {
  int count = 20;
  if (selectedSortString == "4867") {
    count = 10;
  }
  final quizTypes = selectedSortString.split('');
  if (quizTypes.isEmpty) {
    return [];
  }

  List<String> quizDirectives = [];
  final int numCategories = quizTypes.length;
  final int baseCount = count ~/ numCategories;
  final int remainder = count % numCategories;

  for (int i = 0; i < numCategories; i++) {
    final int count = baseCount + (i < remainder ? 1 : 0);
    for (int j = 0; j < count; j++) {
      quizDirectives.add(quizTypes[i]);
    }
  }

  quizDirectives.shuffle(Random());
  return quizDirectives;
}

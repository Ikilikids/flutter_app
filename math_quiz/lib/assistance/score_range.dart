import 'dart:math';

List<int> getScoreRange(int correctCount, String quizinfo) {
  int minScore = 0;
  int maxScore = 0;
  if (quizinfo == "1A2B3C") {
    if (correctCount <= 1) {
      minScore = 1;
      maxScore = 1;
    } else if (correctCount <= 3) {
      minScore = 2;
      maxScore = 2;
    } else if (correctCount <= 5) {
      minScore = 3;
      maxScore = 3;
    } else if (correctCount <= 7) {
      minScore = 4;
      maxScore = 4;
    } else if (correctCount <= 9) {
      minScore = 5;
      maxScore = 5;
    } else if (correctCount <= 11) {
      minScore = 6;
      maxScore = 6;
    } else {
      minScore = 7;
      maxScore = 9;
    }
  } else {
    minScore = min(correctCount + 1, 9);
    maxScore = min(correctCount + 1, 9);
  }
  return [minScore, maxScore];
}

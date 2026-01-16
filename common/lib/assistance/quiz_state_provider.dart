import 'package:flutter/material.dart';

class QuizStateProvider extends ChangeNotifier {
  List<dynamic> quizinfo = [];

  void setValues({
    required List<dynamic> quizinfo,
  }) {
    this.quizinfo = quizinfo;
    notifyListeners();
  }

  void setLimitedMode(bool isLimitedMode) {}
}

import 'package:common/config/app_config.dart';
import 'package:flutter/material.dart';

class QuizStateProvider extends ChangeNotifier {
  QuizData quizinfo = QuizData(
    unit: "",
    fix: 0,
    islimited: false,
    isbattle: false,
    sort: "",
    label: "",
    method: "",
    description: "",
    color: "",
    circleColor: "",
    isDescending: false,
    ranking: "",
  );

  // ここでquizinfoの中身をすべてgetterで公開

  String get unit => quizinfo.unit;
  int get fix => quizinfo.fix;
  bool get isLimited => quizinfo.islimited;
  bool get isBattle => quizinfo.isbattle;
  String get sort => quizinfo.sort;
  String get label => quizinfo.label;
  String get method => quizinfo.method;
  String get description => quizinfo.description;
  String get color => quizinfo.color;
  String get circleColor => quizinfo.circleColor;
  bool get isDescending => quizinfo.isDescending;

  void setValues({required QuizData quizinfo}) {
    this.quizinfo = quizinfo;
    notifyListeners();
  }
}

class MidStateProvider extends ChangeNotifier {
  GameData midinfo = GameData(
      title: "",
      unit: "",
      fix: 0,
      islimited: false,
      isbattle: false,
      detail: [],
      isDescending: false,
      ranking: "");

  // ここでmidinfoの中身をすべてgetterで公開
  List<GameDetail> get detail => midinfo.detail;
  String get unit => midinfo.unit;
  int get fix => midinfo.fix;
  bool get isLimited => midinfo.islimited;
  bool get isBattle => midinfo.isbattle;
  bool get isDescending => midinfo.isDescending;
  String get ranking => midinfo.ranking;
  String? get title => midinfo.title;

  void setValues({required GameData midinfo}) {
    this.midinfo = midinfo;
    notifyListeners();
  }
}

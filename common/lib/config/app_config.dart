import 'package:flutter/material.dart';

typedef GamePageBuilder = Widget Function(
    BuildContext context, QuizData quizinfo);

typedef LoadBuilder = void Function(BuildContext context, QuizData quizinfo);

typedef EndBuilder = Widget Function(
  BuildContext context,
  num totalScore,
  dynamic originalData, // ← 型は実際の型に合わせて
  QuizData quizinfo,
);
typedef SettingWidgetsBuilder = List<Widget> Function(
    BuildContext, String, Function);

class AppConfig {
  final String title;
  final IconData icon;
  final List<String> symbols;
  final bool isRotation;
  final List<GameData> data;
  final GamePageBuilder mainGame;
  final LoadBuilder? loadGame;
  final EndBuilder? endBuilder;
  final SettingWidgetsBuilder? settingWidgets;
  final String? BannerId;
  final String? InterId;
  final String? RewardId;

  const AppConfig(
      {required this.title,
      required this.icon,
      required this.symbols,
      required this.isRotation,
      required this.data,
      required this.mainGame, // ← 追加
      this.loadGame,
      this.endBuilder,
      this.settingWidgets,
      this.BannerId,
      this.InterId,
      this.RewardId});
}

class GameData {
  final String unit;
  final int fix;
  final bool islimited;
  final bool isbattle;
  final List<GameDetail> detail;
  final IconData? icon;
  final String? title;
  final String? sub1;
  final String? sub2;
  final bool isDescending; // ← final にする
  final String ranking;

  GameData({
    required this.unit,
    required this.fix,
    required this.islimited,
    required this.isbattle,
    required this.detail,
    this.icon,
    this.title,
    this.sub1,
    this.sub2,
    this.isDescending = false,
    required this.ranking,
  });

  factory GameData.fromMap(Map<String, dynamic> map) {
    return GameData(
      unit: map['unit'],
      fix: map['fix'],
      islimited: map['islimited'],
      isbattle: map['isbattle'],
      icon: map['icon'],
      title: map['title'],
      sub1: map['sub1'],
      sub2: map['sub2'],
      isDescending: map['isDescending'] ?? false,
      ranking: map['ranking'],
      detail:
          (map['detail'] as List).map((e) => GameDetail.fromMap(e)).toList(),
    );
  }
}

class GameDetail {
  final String sort;
  final String label;
  final String method;
  final String description;
  final String color;
  final String circleColor;

  GameDetail({
    required this.sort,
    required this.label,
    required this.method,
    required this.description,
    required this.color,
    required this.circleColor,
  });

  factory GameDetail.fromMap(Map<String, dynamic> map) {
    return GameDetail(
      sort: map['sort'],
      label: map['label'],
      method: map['method'],
      description: map['description'],
      color: map['color'],
      circleColor: map['circleColor'],
    );
  }
}

class QuizData {
  final String unit;
  final fix;
  final bool islimited;
  final bool isbattle;
  final String sort;
  final String label;
  final String method;
  final String description;
  final String color;
  final String circleColor;
  List<Map<String, String>>? chosedData;
  final bool isDescending;
  final String ranking;
  final int? questionCount; // ← 追加

  QuizData({
    required this.unit,
    required this.fix,
    required this.islimited,
    required this.isbattle,
    required this.sort,
    required this.label,
    required this.method,
    required this.description,
    required this.color,
    required this.circleColor,
    this.chosedData,
    required this.isDescending,
    required this.ranking,
    this.questionCount,
  });
}

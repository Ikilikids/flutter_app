import 'package:common/common.dart';
import 'package:flutter/material.dart';

typedef GamePageBuilder = Widget Function(
    BuildContext context, DetailConfig quizinfo);

typedef LoadBuilder = void Function(
    BuildContext context, DetailConfig quizinfo);

typedef EndBuilder = Widget Function(
  BuildContext context,
  num totalScore,
  dynamic originalData, // ← 型は実際の型に合わせて
  DetailConfig quizinfo,
);
typedef SettingWidgetsBuilder = List<Widget> Function(
    BuildContext, String, Function);

class AllData {
  final AppData appData;
  final List<MidData> mid;

  const AllData({
    required this.appData,
    required this.mid,
  });

  get appTitle => appData.appTitle;
  get appIcon => appData.appIcon;
  get symbols => appData.symbols;
  get isRotation => appData.isRotation;
  get mainGame => appData.mainGame;
  get loadGame => appData.loadGame;
  get endBuilder => appData.endBuilder;
  get settingWidgets => appData.settingWidgets;
  get BannerId => appData.bannerId;
  get InterId => appData.interId;
  get RewardId => appData.rewardId;
}

class AppData {
  final String appTitle;
  final IconData appIcon;
  final List<String> symbols;
  final bool isRotation;
  final GamePageBuilder mainGame;
  final LoadBuilder? loadGame;
  final EndBuilder? endBuilder;
  final SettingWidgetsBuilder? settingWidgets;
  final String? bannerId;
  final String? interId;
  final String? rewardId;

  const AppData(
      {required this.appTitle,
      required this.appIcon,
      required this.symbols,
      required this.isRotation,
      required this.mainGame, // ← 追加
      this.loadGame,
      this.endBuilder,
      this.settingWidgets,
      this.bannerId,
      this.interId,
      this.rewardId});
}

class MidData {
  final ModeData modeData;
  final List<DetailData> detail;

  MidData({
    required this.modeData,
    required this.detail,
  });
  get unit => modeData.unit;
  get fix => modeData.fix;
  get islimited => modeData.islimited;
  get isbattle => modeData.isbattle;
  get modeIcon => modeData.modeIcon;
  get modeTitle => modeData.modeTitle;
  get sub1 => modeData.sub1;
  get sub2 => modeData.sub2;
  get isDescending => modeData.isDescending;
  get ranking => modeData.ranking;
}

class ModeData {
  final String unit;
  final int fix;
  final bool islimited;
  final bool isbattle;
  final IconData? modeIcon;
  final String? modeTitle;
  final String? sub1;
  final String? sub2;
  final bool isDescending; // ← final にする
  final String ranking;
  String badgeText = '';

  ModeData({
    required this.unit,
    required this.fix,
    required this.islimited,
    required this.isbattle,
    this.modeIcon,
    this.modeTitle,
    this.sub1,
    this.sub2,
    this.isDescending = false,
    required this.ranking,
  });
}

class DetailData {
  final String sort;
  final String displayLabel;
  final String displayRank;
  final String resisterRank;
  final String resisterUser;
  final String method;
  final String description;
  final String color;
  final String circleColor;
  String buttonText = '';
  num highScore = 0;
  int? qcount;

  DetailData({
    required this.sort,
    required this.displayLabel,
    required this.displayRank,
    required this.resisterRank,
    required this.resisterUser,
    required this.method,
    required this.description,
    required this.color,
    required this.circleColor,
  });
}

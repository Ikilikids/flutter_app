import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'ui_config.dart';

part 'app_data.freezed.dart';

// --- Typedefs ---
typedef GamePageBuilder = Widget Function(
    BuildContext context, DetailConfig quizinfo);
typedef LoadBuilder = void Function(
    BuildContext context, WidgetRef ref, DetailConfig quizinfo);
typedef EndBuilder = Widget Function(
  BuildContext context,
  num totalScore,
  dynamic originalData,
  DetailConfig quizinfo,
);
typedef SettingWidgetsBuilder = List<Widget> Function(
    BuildContext, String, Function);

@freezed
class AdditionalPageConfig with _$AdditionalPageConfig {
  const factory AdditionalPageConfig({
    required String title,
    required IconData icon,
    required AdditionalPageBuilder builder,
  }) = _AdditionalPageConfig;
}

// 既存のTypedef
typedef AdditionalPageBuilder = Widget Function(BuildContext context);

@freezed
class AllData with _$AllData {
  const factory AllData({
    required AppData appData,
    required List<MidData> mid,
  }) = _AllData;

  const AllData._();

  String get appTitle => appData.appTitle;
  IconData get appIcon => appData.appIcon;
  List<String> get symbols => appData.symbols;
  bool get isRotation => appData.isRotation;
  String get URL => appData.URL;
  GamePageBuilder get mainGame => appData.mainGame;
  AdditionalPageConfig? get additionalPage => appData.additionalPage;
  LoadBuilder? get loadGame => appData.loadGame;
  EndBuilder? get endBuilder => appData.endBuilder;
  SettingWidgetsBuilder? get settingWidgets => appData.settingWidgets;

  String? get BannerId => appData.bannerId;
  String? get InterId => appData.interId;
  String? get RewardId => appData.rewardId;
}

@freezed
class AppData with _$AppData {
  const factory AppData({
    required String appTitle,
    required IconData appIcon,
    required List<String> symbols,
    required bool isRotation,
    required String URL,
    required GamePageBuilder mainGame,
    LoadBuilder? loadGame,
    EndBuilder? endBuilder,
    SettingWidgetsBuilder? settingWidgets,
    AdditionalPageConfig? additionalPage,
    String? bannerId,
    String? interId,
    String? rewardId,
  }) = _AppData;
}

@freezed
class MidData with _$MidData {
  const factory MidData({
    required ModeData modeData,
    required List<DetailData> detail,
  }) = _MidData;

  const MidData._();

  String get unit => modeData.unit;
  int get fix => modeData.fix;
  bool get islimited => modeData.islimited;
  bool get isbattle => modeData.isbattle;
  IconData? get modeIcon => modeData.modeIcon;
  String? get modeTitle => modeData.modeTitle;
  String? get sub1 => modeData.sub1;
  String? get sub2 => modeData.sub2;
  bool get isSmallerBetter => modeData.isSmallerBetter;
  String get modeType => modeData.modeType;
}

@freezed
class ModeData with _$ModeData {
  const factory ModeData({
    required String unit,
    required int fix,
    required bool islimited,
    required bool isbattle,
    required bool isSmallerBetter,
    required String modeType,
    IconData? modeIcon,
    String? modeTitle,
    String? sub1,
    String? sub2,
  }) = _ModeData;
}

@freezed
class DetailData with _$DetailData {
  const factory DetailData({
    required String sort,
    required String displayLabel,
    required String displayRank,
    required String resisterSub,
    required String resisterOrigin,
    required String method,
    required String description,
    required String color,
    required String circleColor,
  }) = _DetailData;
}

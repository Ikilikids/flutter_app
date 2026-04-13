import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../common.dart';

part 'app_data.freezed.dart';

// --- Typedefs ---
typedef GamePageBuilder = Widget Function(
    BuildContext context, DetailConfig quizinfo);
typedef LoadBuilder = void Function(
    BuildContext context, WidgetRef ref, DetailConfig quizinfo);
typedef SettingWidgetsBuilder = List<Widget> Function(
    BuildContext, String, Function);

@freezed
class PageConfig with _$PageConfig {
  const factory PageConfig({
    required String title,
    required IconData icon,
    required Color color,
    String? modeDescription,
    required AdditionalPageBuilder builder,
  }) = _PageConfig;
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
  PageConfig? get additionalPage1 => appData.additionalPage1;
  PageConfig? get additionalPage2 => appData.additionalPage2;
  LoadBuilder? get loadGame => appData.loadGame;
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
    SettingWidgetsBuilder? settingWidgets,
    PageConfig? additionalPage1,
    PageConfig? additionalPage2,
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

  // 既存のgetter
  String get unit => modeData.unit;
  int get fix => modeData.fix;
  bool get islimited => modeData.islimited;
  bool get isbattle => modeData.isbattle;
  IconData get modeIcon => modeData.modeIcon;
  String get modeTitle => modeData.modeTitle;
  String? get modeDescription => modeData.modeDescription;
  List<QuizTabInfo>? get rankingList => modeData.rankingList;
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
    required IconData modeIcon,
    required String modeTitle,
    String? modeDescription,
    List<QuizTabInfo>? rankingList, // ← 追加
  }) = _ModeData;
}

@freezed
class DetailData with _$DetailData {
  const factory DetailData({
    required QuizId quizId, // ← 追加
    required String sort,
    required String displayLabel,
    required String method,
    required String description,
    required String color,
    required String circleColor,
    IconData? detailIcon,
  }) = _DetailData;

  const DetailData._();
  String get resisterOrigin => quizId.resisterOrigin; // 下位互換用
}

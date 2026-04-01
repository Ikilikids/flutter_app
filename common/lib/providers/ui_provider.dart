import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common.dart';

part 'ui_provider.g.dart';

/// ① 今どのタブ（モード）を選択しているか (0:無制限, 1:1日限定, 2:ランキング, 3:設定)
@Riverpod(keepAlive: true)
class SelectedModeIndex extends _$SelectedModeIndex {
  @override
  int build() => 0;
  void update(int index) => state = index;
}

/// ② 今どの詳細（詳細カード）を選択しているか
@Riverpod(keepAlive: true)
class SelectedDetailIndex extends _$SelectedDetailIndex {
  @override
  int build() => 0;
  void update(int index) => state = index;
}

/// ③ 原本と成績を合体させた「現在のモード」の全データ
@Riverpod(
    keepAlive: true, dependencies: [UserStatusNotifier, SelectedModeIndex])
MidConfig currentMidConfig(Ref ref) {
  // ユーザー状態を監視 (同期)
  final status = ref.watch(userStatusNotifierProvider).requireValue;
  // 現在のタブIndexを監視
  final selectedIndex = ref.watch(selectedModeIndexProvider);

  // タブIndexに基づいて、原本から該当するモードを取得
  final midIndex = selectedIndex < allData.mid.length ? selectedIndex : 0;
  final masterMid = allData.mid[midIndex];

  // 個別のクイズ原本に成績を合体させる
  final details = masterMid.detail.map((d) {
    final qStatus = status.quizzes[d.quizId];

    return DetailConfig(
      appData: allData.appData,
      modeData: masterMid.modeData,
      detail: d,
      highScore: qStatus?.highScore ?? 0.0,
      buttonType: qStatus?.buttonType ?? QuizButtonType.play,
      qcount: qStatus?.qCount ?? 5,
    );
  }).toList();

  return MidConfig(
    appData: allData.appData,
    modeData: masterMid.modeData,
    details: details,
  );
}

/// ④ 今まさに「選ばれている1件」の DetailConfig
@Riverpod(
    keepAlive: true, dependencies: [currentMidConfig, SelectedDetailIndex])
DetailConfig currentDetailConfig(Ref ref) {
  final midConfig = ref.watch(currentMidConfigProvider);
  final selectedIndex = ref.watch(selectedDetailIndexProvider);

  // インデックスが範囲内かチェック、範囲外なら0番目を返す
  final index = (selectedIndex < midConfig.details.length) ? selectedIndex : 0;

  return midConfig.details[index];
}

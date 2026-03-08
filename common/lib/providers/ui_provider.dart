import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../bootstrap.dart';
import '../freezed/ui_config.dart'; // MidConfig, DetailConfig
import 'user_status_provider.dart'; // UserStatusNotifier

part 'ui_provider.g.dart';

/// ① 今どのタブ（モード）を選択しているか (0:無制限, 1:1日限定, 2:ランキング, 3:設定)
@riverpod
class SelectedModeIndex extends _$SelectedModeIndex {
  @override
  int build() => 0;

  void update(int index) => state = index;
}

/// ② 原本と成績を合体させた「現在のモード」の全データ
@riverpod
MidConfig currentMidConfig(Ref ref) {
  // ユーザー状態を監視 (同期)
  final status = ref.watch(userStatusNotifierProvider);
  // 現在のタブIndexを監視
  final selectedIndex = ref.watch(selectedModeIndexProvider);

  // タブIndexに基づいて、原本から該当するモードを取得
  final masterMid = allData.mid[selectedIndex < 2 ? selectedIndex : 0];
  final selectedModeId = masterMid.modeData.modeType;

  // 高速化：クイズのステータスをIDをキーにしたMapに変換しておく
  final quizMap = {for (var q in status.quizzes) q.id: q};

  // 個別のクイズ原本に成績を合体させる
  final details = masterMid.detail.map((d) {
    final targetId = "${d.resisterOrigin}_$selectedModeId";
    final qStatus = quizMap[targetId];

    return DetailConfig(
      appData: allData.appData,
      modeData: masterMid.modeData,
      detail: d,
      highScore: qStatus?.highScore ?? 0.0,
      buttonText: qStatus?.buttonText ?? 'playButton',
      qcount: qStatus?.qCount ?? 5,
    );
  }).toList();

  return MidConfig(
    appData: allData.appData,
    modeData: masterMid.modeData,
    details: details,
  );
}

/// ③ 今まさに「選ばれている1件」の DetailConfig
@riverpod
DetailConfig currentDetailConfig(Ref ref) {
  final midConfig = ref.watch(currentMidConfigProvider);
  final status = ref.watch(userStatusNotifierProvider);

  final selectedDetailId = status.selectedDetailId;

  return midConfig.details.firstWhere(
    (d) => d.detail.resisterOrigin == selectedDetailId,
    orElse: () => midConfig.details.first,
  );
}

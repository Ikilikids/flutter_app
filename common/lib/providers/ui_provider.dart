import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../bootstrap.dart';
import '../freezed/ui_config.dart'; // MidConfig, DetailConfig
import 'user_status_provider.dart'; // UserStatusNotifier

part 'ui_provider.g.dart';

/// ① 今どのタブ（モード）を選択しているか (0:無制限, 1:1日限定, 2:ランキング, 3:設定)
@Riverpod(keepAlive: true)
class SelectedModeIndex extends _$SelectedModeIndex {
  @override
  int build() => 0;

  void update(int index) => state = index;
}

/// ② 原本と成績を合体させた「現在のモード」の全データ
@Riverpod(keepAlive: true)
MidConfig currentMidConfig(Ref ref) {
  // ユーザー状態を監視 (同期)
  final status = ref.watch(userStatusNotifierProvider);
  // 現在のタブIndexを監視
  final selectedIndex = ref.watch(selectedModeIndexProvider);

  // タブIndexに基づいて、原本から該当するモードを取得
  // Indexがmidの範囲外（ランキング・設定など）の場合は、デフォルトとして0番目の設定を使用する
  final midIndex = selectedIndex < allData.mid.length ? selectedIndex : 0;
  final masterMid = allData.mid[midIndex];
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
@Riverpod(keepAlive: true)
class CurrentDetailConfig extends _$CurrentDetailConfig {
  DetailConfig? _manualValue;

  @override
  DetailConfig build() {
    // 1. 依存先をwatch（自動更新のトリガー）
    final midConfig = ref.watch(currentMidConfigProvider);
    final status = ref.watch(userStatusNotifierProvider);

    // 2. 手動でセットされた値があれば、それを優先して返す（自動更新をブロック）
    if (_manualValue != null) {
      return _manualValue!;
    }

    // 3. 通常時の自動計算
    return midConfig.details.firstWhere(
      (d) => d.detail.resisterOrigin == status.selectedDetailId,
      orElse: () => midConfig.details.first,
    );
  }

  /// 【更新】手動で値を固定する
  void updateConfig(DetailConfig newConfig) {
    _manualValue = newConfig;
    state = newConfig;
  }

  /// 【捨てる】手動モードを解除して自動更新に戻す
  void clearManualMode() {
    _manualValue = null;
    ref.invalidateSelf(); // buildを再実行させて自動計算に戻す
  }
}

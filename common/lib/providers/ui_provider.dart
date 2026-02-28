import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../bootstrap.dart';
import '../freezed/ui_config.dart'; // MidConfig, DetailConfig
import 'user_status_provider.dart'; // UserStatusNotifier

part 'ui_provider.g.dart';

/// ② 原本と成績を合体させた「現在のモード」の全データ
@riverpod
MidConfig currentMidConfig(Ref ref) {
  // ユーザー状態（成績 ＋ 選択中のID）を監視
  final statusAsync = ref.watch(userStatusNotifierProvider);

  // データのロードが終わっていない場合の初期表示（空データ）
  final initialMid = MidConfig(
    appData: allData.appData,
    modeData: allData.mid.first.modeData,
    details: [],
    badgeText: '',
  );

  return statusAsync.maybeWhen(
    data: (status) {
      // UserStatus 内に保存されている「選択中のモードID」を取得
      final selectedModeId = status.selectedModeId;

      // 原本(allData)から該当するモードを探す
      final masterMid = allData.mid.firstWhere(
        (m) => m.modeData.modeType == selectedModeId,
        orElse: () => allData.mid.first,
      );

      // モードの成績(バッジなど)を取得
      final mStatus = status.modes.firstWhere(
        (m) => m.modeType == selectedModeId,
        orElse: () => status.modes.first,
      );

      // 個別のクイズ原本に成績を合体させる
      final details = masterMid.detail.map((d) {
        final qStatus = status.quizzes.firstWhere(
          (q) => q.id == "${d.resisterOrigin}_$selectedModeId",
        );

        return DetailConfig(
          appData: allData.appData,
          modeData: masterMid.modeData,
          detail: d,
          highScore: qStatus.highScore,
          buttonText: qStatus.buttonText,
          qcount: qStatus.qCount, // 状態から取得
        );
      }).toList();

      return MidConfig(
        appData: allData.appData,
        modeData: masterMid.modeData,
        details: details,
        badgeText: mStatus.badgeText,
      );
    },
    orElse: () => initialMid,
  );
}

/// ③ 今まさに「選ばれている1件」の DetailConfig
@riverpod
DetailConfig currentDetailConfig(Ref ref) {
  final midConfig = ref.watch(currentMidConfigProvider);
  final status = ref.watch(userStatusNotifierProvider).value;

  // 統合された UserStatus から「選択中のクイズID」を取得
  // 非NULL(String)で統一したので、空文字チェックだけで済む
  final selectedDetailId = status?.selectedDetailId ?? '';

  // 選択されたIDに一致する合体済みデータを1件だけ返す
  // 初期値で allData.mid.first.detail.first.resisterOrigin を入れているので必ず見つかる
  return midConfig.details.firstWhere(
    (d) => d.detail.resisterOrigin == selectedDetailId,
    orElse: () => midConfig.details.first,
  );
}

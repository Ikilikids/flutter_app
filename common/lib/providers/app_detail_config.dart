import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common.dart';

part 'app_detail_config.g.dart';

@riverpod
class AppDetailConfig extends _$AppDetailConfig {
  @override
  DetailConfig build() {
    final initialMode = allData.mid.first.modeData;
    final initialDetail = allData.mid.first.detail.first;

    return DetailConfig(
      appData: allData.appData,
      modeData: initialMode,
      detail: initialDetail,
    );
  }

  /// detail 選択
  void selectDetail(DetailData detail, ModeData modeData, int? qcount) {
    detail.qcount = qcount;
    state = state.copyWith(detail: detail, modeData: modeData);
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common.dart';

part 'app_mid_config.g.dart';

@riverpod
class AppMidConfig extends _$AppMidConfig {
  @override
  MidConfig build() {
    // 初期選択: AllData の先頭 mode
    final initialMid = allData.mid.first;
    return MidConfig(
      appData: allData.appData,
      mid: initialMid,
    );
  }

  /// mode 選択・更新
  void selectMid(MidData mid) {
    state = state.copyWith(mid: mid);
  }
}

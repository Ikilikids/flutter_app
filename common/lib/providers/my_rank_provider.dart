import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common.dart';

part 'my_rank_provider.g.dart';

@Riverpod(keepAlive: true)
class MyRankMap extends _$MyRankMap {
  @override
  Map<PeriodType, int> build() {
    return {};
  }

  // 上書き
  void setMap(Map<PeriodType, int> newMap) {
    state = newMap;
  }
}

@Riverpod(keepAlive: true)
class MyScoreMap extends _$MyScoreMap {
  @override
  Map<PeriodType, double> build() {
    return {};
  }

  // 上書き
  void setMap(Map<PeriodType, double> newMap) {
    state = newMap;
  }
}

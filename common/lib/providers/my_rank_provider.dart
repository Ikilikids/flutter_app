import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_rank_provider.g.dart';

@Riverpod(keepAlive: true)
class MyRankList extends _$MyRankList {
  @override
  List<int> build() {
    return [];
  }

  // 上書き
  void setList(List<int> newList) {
    state = newList;
  }
}

@Riverpod(keepAlive: true)
class MyScoreList extends _$MyScoreList {
  @override
  List<double> build() {
    return [];
  }

  // 上書き
  void setList(List<double> newList) {
    state = newList;
  }
}

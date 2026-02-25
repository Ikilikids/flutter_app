import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_detail.g.dart';

@Riverpod(keepAlive: true)
class AppDetail extends _$AppDetail {
  @override
  int build() {
    return 0;
  }

  void selectDetail(int index) {
    state = index;
  }
}

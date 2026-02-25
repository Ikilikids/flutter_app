import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_mode.g.dart';

@Riverpod(keepAlive: true)
class AppMode extends _$AppMode {
  @override
  int build() {
    return 0;
  }

  void selectMid(int index) {
    state = index;
  }
}

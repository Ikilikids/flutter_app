import 'package:common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_sound.g.dart';

@Riverpod(keepAlive: true)
class AppSound extends _$AppSound {
  @override
  Future<SoundManager> build() async {
    // 1. インスタンス作成
    final manager = SoundManager();

    // 2. 音源のロード完了を待つ
    await manager.loadSounds();

    // 3. お片付け（dispose）の登録
    // クラス形式でも ref.onDispose は build 内で登録します
    ref.onDispose(() {
      manager.dispose();
    });

    // 4. ロード済みの manager を state として返す
    return manager;
  }

  // 今後、例えば「全消音」などの操作を足したくなったらここに書ける
  // Future<void> muteAll() async { ... }
}

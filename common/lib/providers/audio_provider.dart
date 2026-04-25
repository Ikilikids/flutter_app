import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_provider.g.dart';

@Riverpod(keepAlive: true)
class AudioPlayerManager extends _$AudioPlayerManager {
  @override
  AudioPlayer build() {
    final player = AudioPlayer();

    // パッケージ跨ぎのパス解決用にprefixを空にする
    player.audioCache = AudioCache(prefix: '');
    player.setReleaseMode(ReleaseMode.loop);
    ref.onDispose(() {
      player.dispose();
    });

    return player;
  }

  /// commonパッケージ内の音源を再生
  /// pathには 'assets/sounds/Thunderbolt.mp3' を渡す
  Future<void> play(String path) async {
    final fullPath = 'packages/common/$path';
    try {
      await state.setVolume(0.2);
      await state.play(AssetSource(fullPath));
    } catch (e) {
      // 予期せぬエラー時のみ最低限の把握ができるよう、ここだけ残すかはお好みで
    }
  }

  Future<void> pause() async {
    await state.pause();
  }

  Future<void> resume() async {
    await state.resume();
  }

  Future<void> stop() async {
    await state.stop();
  }

  Future<void> seekTo(int seconds) async {
    await state.seek(Duration(seconds: seconds));
  }

  Future<void> setVolume(double volume) async {
    await state.setVolume(volume.clamp(0.0, 1.0));
  }
}

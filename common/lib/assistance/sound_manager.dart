import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class SoundManager {
  late Soundpool _soundpool;
  final Map<String, int> _soundIds = {};

  SoundManager() {
    _soundpool = Soundpool.fromOptions(
      options:
          const SoundpoolOptions(streamType: StreamType.music, maxStreams: 6),
    );
  }

  Future<void> loadSounds() async {
    final soundFiles = <String>{
      'countdown1.mp3',
      'countdown2.mp3',
      'marumaru.mp3',
      'maru.mp3',
      'peke.mp3',
      'ry.mp3',
      "hoi.mp3",
      "pipi.mp3",
      "pi.mp3",
      for (int i = 0; i <= 9; i++) '$i.mp3',
    };
    for (var file in soundFiles) {
      final data = await rootBundle.load('assets/sounds/$file');

      final id = await _soundpool.load(data);
      _soundIds[file] = id;
    }
  }

  void playSound(String name) {
    final id = _soundIds[name];
    if (id != null) _soundpool.play(id);
  }

  void dispose() {
    _soundpool.release();
  }
}

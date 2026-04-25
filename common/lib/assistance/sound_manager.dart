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

  Future<void> firstLoadSounds() async {
    final primarySoundFiles = <String>{
      'countdown1.mp3',
      'countdown2.mp3',
    };
    for (var file in primarySoundFiles) {
      final data = await rootBundle.load('packages/common/assets/sounds/$file');
      final id = await _soundpool.load(data);
      _soundIds[file] = id;
    }
  }

  Future<void> secondloadSounds() async {
    final secondSoundFiles = <String>{
      'marumaru.mp3',
      'maru.mp3',
      'peke.mp3',
      'ry.mp3',
      "hoi.mp3",
      "pipi.mp3",
      "pi.mp3",
      "star.mp3",
      "heart.mp3",
      for (int i = 0; i <= 9; i++) '$i.mp3',
    };
    for (var file in secondSoundFiles) {
      final data = await rootBundle.load('packages/common/assets/sounds/$file');
      final id = await _soundpool.load(data);
      _soundIds[file] = id;
    }
  }

  void playSound(String name) {
    print("Playing sound: $name");
    final id = _soundIds[name];
    if (id != null) _soundpool.play(id);
  }

  void dispose() {
    _soundpool.release();
  }
}

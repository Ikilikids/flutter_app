import 'package:common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_sound.g.dart';

@riverpod
SoundManager appSound(Ref ref) {
  // ここで throw しておくことで、Bootstrapでの上書きを強制する
  throw UnimplementedError('BootstrapでappSoundProviderを上書きしてください');
}

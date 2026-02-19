import 'package:freezed_annotation/freezed_annotation.dart';

import '../common.dart';

part 'detail_config.freezed.dart';

@freezed
class DetailConfig with _$DetailConfig {
  const factory DetailConfig({
    required AppData appData,
    required ModeData modeData,
    required DetailData detail,
  }) = _DetailConfig;
}

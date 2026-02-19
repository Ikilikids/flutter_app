import 'package:freezed_annotation/freezed_annotation.dart';

import '../common.dart';

part 'mid_config.freezed.dart';

@freezed
class MidConfig with _$MidConfig {
  const factory MidConfig({
    required AppData appData,
    required MidData mid,
  }) = _MidConfig;
}

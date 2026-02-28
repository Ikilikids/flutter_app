import 'package:freezed_annotation/freezed_annotation.dart';

// 原本の型（ModeData, DetailData, AppData）を参照するためにインポート
import 'app_data.dart';

part 'ui_config.freezed.dart';

@freezed
class MidConfig with _$MidConfig {
  const factory MidConfig({
    required AppData appData,
    required ModeData modeData,
    required List<DetailConfig> details, // 原本と成績を合体させたリスト
    required String badgeText,
  }) = _MidConfig;
}

@freezed
class DetailConfig with _$DetailConfig {
  const factory DetailConfig({
    required AppData appData,
    required ModeData modeData,
    required DetailData detail, // 原本のカタログデータ
    required num highScore, // 状態：最新スコア
    required String buttonText, // 状態：ボタンの文字
    required int qcount, // 状態：選択された問題数
  }) = _DetailConfig;
}

import 'package:freezed_annotation/freezed_annotation.dart';

// 原本の型（ModeData, DetailData, AppData）を参照するためにインポート
import '../common.dart';

part 'ui_config.freezed.dart';

@freezed
class MidConfig with _$MidConfig {
  const factory MidConfig({
    required AppData appData,
    required ModeData modeData,
    required List<DetailConfig> details, // 原本と成績を合体させたリスト
  }) = _MidConfig;
}

@freezed
class DetailConfig with _$DetailConfig {
  // ★ これを追加することで、Getterやメソッドが定義可能になります
  const DetailConfig._();

  const factory DetailConfig({
    required AppData appData,
    required ModeData modeData,
    required DetailData detail,
    required num highScore,
    required QuizButtonType buttonType,
    required int qcount,
  }) = _DetailConfig;

  // --- 追加したいGetterの例 ---

  /// 例：特定のアプリタイトルかどうか
  TimeMode get timeMode {
    final title = appData.appTitle;
    final isBattle = modeData.isbattle;

    if (title == "appTitle" || title == "reflectTitle") {
      return TimeMode.timeAttack;
    } else if (isBattle) {
      return TimeMode.countDown;
    } else if (!isBattle) {
      return TimeMode.learning;
    } else {
      return TimeMode.learning; // デフォルト
    }
  }
}

enum TimeMode { timeAttack, countDown, learning }

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'とことん四則演算';

  @override
  String get tapToStart => 'タップしてスタート';

  @override
  String get addSubtract => '足し算・引き算';

  @override
  String get addSubtract2Digits => '2桁の足し算・引き算';

  @override
  String get fourArithmeticOperations => '四則演算';

  @override
  String get compete20Questions => '20問の正解タイムで競う';

  @override
  String get compete10Questions => '10問の正解タイムで競う';

  @override
  String get addSubtractDesc => '足し算・引き算、気軽にプレイ!!';

  @override
  String get fourArithmeticOperationsDesc => '足し算・引き算・掛け算・割り算、素早く判断!!';

  @override
  String get addSubtract2DigitsDesc => '2桁の足し算・引き算、計算力を鍛えよう!!';

  @override
  String get unlimitedModeTitle => '無制限モード';

  @override
  String get unlimitedModeSub1 => '---いつでも遊べる---';

  @override
  String get unlimitedModeSub2 => 'ハイスコアを目指そう！';

  @override
  String get dailyLimitedModeTitle => '1日限定モード';

  @override
  String get dailyLimitedModeSub1 => '---1日1回だけ挑戦---';

  @override
  String get dailyLimitedModeSub2 => '集中して記録を狙おう！';

  @override
  String get settingsButton => '⚙ 設定';

  @override
  String get rankingButton => '👑 ランキング';

  @override
  String get playableStatus => 'プレイ可能';

  @override
  String get playableWithAdStatus => '広告を見てプレイ可能';

  @override
  String get unitSecond => '秒';

  @override
  String get playButton => 'プレイ！';

  @override
  String playButtonWithCount(Object count) {
    return '$count問プレイ';
  }

  @override
  String get playButtonSecondTime => 'プレイ！(2回目)';

  @override
  String get watchAdToPlayButton => '広告を見てプレイ';

  @override
  String get playedTodayButton => '本日プレイ済み';

  @override
  String get challengeAgainDialogTitle => '🎁 もう一度チャレンジ！';

  @override
  String get challengeAgainDialogContent => '広告を1本見ると\n今日の挑戦をもう一度できます！';

  @override
  String get cancelButton => 'やめる';

  @override
  String get watchAdButton => '広告を見て続ける ▶';

  @override
  String get adLoadingSnackbar => '広告を準備中です。少し待ってからもう一度お試しください。';

  @override
  String get allScores => '全合計';

  @override
  String get settingsTitle => '⚙設定';

  @override
  String get currentUsernameLabel => '現在のユーザー名: ';

  @override
  String get defaultUsername => '名無し';

  @override
  String get newUsernameLabel => '新しいユーザー名';

  @override
  String get saveButton => '保存';

  @override
  String get lightModeLabel => 'ライトモード';

  @override
  String get darkModeLabel => 'ダークモード';

  @override
  String get contactLabel => 'お問い合わせ先 : tokoton.math@gmail.com';

  @override
  String get saveCompleteDialogTitle => '完了';

  @override
  String get saveCompleteDialogContent => '保存しました！';

  @override
  String get okButton => 'OK';

  @override
  String get rankingTitle => '👑ランキング👑';

  @override
  String get allPeriod => '全期間';

  @override
  String get monthlyPeriod => '月間';

  @override
  String get weeklyPeriod => '週間';

  @override
  String get noDataAvailable => 'データがありません';

  @override
  String get rank1st => '1位🥇';

  @override
  String get rank2nd => '2位🥈';

  @override
  String get rank3rd => '3位🥉';

  @override
  String rankNth(Object rank) {
    return '$rank位　 ';
  }

  @override
  String get mathA => '数Ⅰ・数A';

  @override
  String get mathB => '数Ⅱ・数B';

  @override
  String get mathC => '数Ⅲ・数C';

  @override
  String get timeLabel => 'タイム';

  @override
  String get scoreLabel => '正解数';

  @override
  String get highScorePrefix => '最高記録：';

  @override
  String get rankUnit => '位';

  @override
  String get retryButton => 'もう一度';

  @override
  String get menuButton => 'メニュー';

  @override
  String get reflectTitle => 'とことん反射神経';

  @override
  String get unitMillisecond => 'ミリ秒';

  @override
  String get colorReact => '色で反応';

  @override
  String get colorReactMethod => '3回のうち一番遅いタイムで競う';

  @override
  String get colorReactDesc => '色が変わったらタップ！';

  @override
  String get numberReact => '数字で反応';

  @override
  String get reactMethodAverage => '3回の平均タイムで競う';

  @override
  String get numberReactDesc => '表示された数字のボタンをタップ！';

  @override
  String get gridReact => 'マス目で反応';

  @override
  String get gridReactDesc => '光ったマスをタップ！';

  @override
  String get finishingText => '終了!';

  @override
  String get timeHeader => 'タイム';

  @override
  String get pointHeader => 'POINT';

  @override
  String get dialogMenuTitle => 'メニュー';

  @override
  String get dialogHomeButton => 'ホームへ';

  @override
  String get dialogMistakeTitle => 'おてつき！';

  @override
  String get dialogNextTime => 'また次回挑戦!!';

  @override
  String get dialogTryAgain => 'もう一度挑戦しますか？';

  @override
  String get dialogRetryButtonWithIcon => '🔥もう一度 ▸';

  @override
  String get colorGameTapNow => 'タップ！';

  @override
  String tryNumber(Object number) {
    return '$number 回目';
  }

  @override
  String get timeResultTitle => 'タイム！';

  @override
  String get unknownMode => '不明なモード';

  @override
  String get accountSectionTitle => 'アカウント';

  @override
  String get appearanceSectionTitle => '外観';

  @override
  String get languageSectionTitle => '言語';

  @override
  String get aboutSectionTitle => 'このアプリについて';

  @override
  String get usernameLabel => 'ユーザー名';

  @override
  String get languageLabel => '言語';

  @override
  String get languageSelectionTitle => '言語を選択';

  @override
  String get guestUsername => 'ゲスト';

  @override
  String get saveUsernameSuccessTitle => '完了';

  @override
  String get saveUsernameSuccessContent => '新しい名前を保存しました！';

  @override
  String get buttonLayout => 'ボタン配置';

  @override
  String get selectButtonLayout => 'ボタン配置を選択';

  @override
  String get mobileMode => '携帯モード';

  @override
  String get calculatorMode => '電卓モード';

  @override
  String get detailSetting => '詳細設定';

  @override
  String get soundSectionTitle => 'サウンド';

  @override
  String get volumeLabel => '音量';
}

import 'package:common/src/generated/l10n/app_localizations_ja.dart';

// A helper class to translate localization keys specifically to Japanese,
// regardless of the current app locale. This is used for database consistency.
class JapaneseTranslator {
  static final _ja = AppLocalizationsJa();

  static String translateKeyToJapanese(String key) {
    switch (key) {
      // Keys from main.dart
      case 'appTitle':
        return _ja.appTitle;
      case 'addSubtract':
        return _ja.addSubtract;
      case 'addSubtract2Digits':
        return _ja.addSubtract2Digits;
      case 'fourArithmeticOperations':
        return _ja.fourArithmeticOperations;
      case 'compete20Questions':
        return _ja.compete20Questions;
      case 'compete10Questions':
        return _ja.compete10Questions;
      case 'addSubtractDesc':
        return _ja.addSubtractDesc;
      case 'fourArithmeticOperationsDesc':
        return _ja.fourArithmeticOperationsDesc;
      case 'addSubtract2DigitsDesc':
        return _ja.addSubtract2DigitsDesc;
      case 'unitSecond':
        return _ja.unitSecond;
      
      // Keys from mode_selection_page.dart
      case 'unlimitedModeTitle':
        return _ja.unlimitedModeTitle;
      case 'unlimitedModeSub1':
        return _ja.unlimitedModeSub1;
      case 'unlimitedModeSub2':
        return _ja.unlimitedModeSub2;
      case 'dailyLimitedModeTitle':
        return _ja.dailyLimitedModeTitle;
      case 'dailyLimitedModeSub1':
        return _ja.dailyLimitedModeSub1;
      case 'dailyLimitedModeSub2':
        return _ja.dailyLimitedModeSub2;
      case 'settingsButton':
        return _ja.settingsButton;
      case 'rankingButton':
        return _ja.rankingButton;
      case 'playableStatus':
        return _ja.playableStatus;
      case 'playableWithAdStatus':
        return _ja.playableWithAdStatus;

      // Keys from detail_card.dart
      case 'playButton':
        return _ja.playButton;
      case 'playButtonSecondTime':
        return _ja.playButtonSecondTime;
      case 'watchAdToPlayButton':
        return _ja.watchAdToPlayButton;
      case 'playedTodayButton':
        return _ja.playedTodayButton;
      case 'challengeAgainDialogTitle':
        return _ja.challengeAgainDialogTitle;
      case 'challengeAgainDialogContent':
        return _ja.challengeAgainDialogContent;
      case 'cancelButton':
        return _ja.cancelButton;
      case 'watchAdButton':
        return _ja.watchAdButton;
      case 'adLoadingSnackbar':
        return _ja.adLoadingSnackbar;

      // Key for "All Scores"
      case 'allScores':
        return _ja.allScores;

      // Keys from settings_page.dart
      case 'settingsTitle':
        return _ja.settingsTitle;
      case 'currentUsernameLabel':
        return _ja.currentUsernameLabel;
      case 'defaultUsername':
        return _ja.defaultUsername;
      case 'newUsernameLabel':
        return _ja.newUsernameLabel;
      case 'saveButton':
        return _ja.saveButton;
      case 'lightModeLabel':
        return _ja.lightModeLabel;
      case 'darkModeLabel':
        return _ja.darkModeLabel;
      case 'contactLabel':
        return _ja.contactLabel;
      case 'saveCompleteDialogTitle':
        return _ja.saveCompleteDialogTitle;
      case 'saveCompleteDialogContent':
        return _ja.saveCompleteDialogContent;
      case 'okButton':
        return _ja.okButton;

      // Keys from ranking_page.dart (non-parameterized)
      case 'rankingTitle':
        return _ja.rankingTitle;
      case 'allPeriod':
        return _ja.allPeriod;
      case 'monthlyPeriod':
        return _ja.monthlyPeriod;
      case 'weeklyPeriod':
        return _ja.weeklyPeriod;
      case 'noDataAvailable':
        return _ja.noDataAvailable;
      case 'rank1st':
        return _ja.rank1st;
      case 'rank2nd':
        return _ja.rank2nd;
      case 'rank3rd':
        return _ja.rank3rd;
      case 'mathA':
        return _ja.mathA;
      case 'mathB':
        return _ja.mathB;
      case 'mathC':
        return _ja.mathC;
      
      // Keys from end_screen.dart
      case 'timeLabel':
        return _ja.timeLabel;
      case 'scoreLabel':
        return _ja.scoreLabel;
      case 'highScorePrefix':
        return _ja.highScorePrefix;
      case 'rankUnit':
        return _ja.rankUnit;
      case 'retryButton':
        return _ja.retryButton;
      case 'menuButton':
        return _ja.menuButton;

      // Keys for Reflect App
      case 'reflectTitle':
        return _ja.reflectTitle;
      case 'unitMillisecond':
        return _ja.unitMillisecond;
      case 'colorReact':
        return _ja.colorReact;
      case 'colorReactMethod':
        return _ja.colorReactMethod;
      case 'colorReactDesc':
        return _ja.colorReactDesc;
      case 'numberReact':
        return _ja.numberReact;
      case 'reactMethodAverage':
        return _ja.reactMethodAverage;
      case 'numberReactDesc':
        return _ja.numberReactDesc;
      case 'gridReact':
        return _ja.gridReact;
      case 'gridReactDesc':
        return _ja.gridReactDesc;

      default:
        // If no key matches, return the key itself as a fallback.
        return key;
    }
  }
}

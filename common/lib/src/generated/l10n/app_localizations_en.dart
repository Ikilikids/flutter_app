// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Arithmetic Battle';

  @override
  String get tapToStart => 'Tap to Start';

  @override
  String get addSubtract => 'Addition/Subtraction';

  @override
  String get addSubtract2Digits => '2-Digit Addition/Subtraction';

  @override
  String get fourArithmeticOperations => 'Four Arithmetic Operations';

  @override
  String get compete20Questions =>
      'Compete with the time for 20 correct answers';

  @override
  String get compete10Questions =>
      'Compete with the time for 10 correct answers';

  @override
  String get addSubtractDesc =>
      'Feel free to play with addition and subtraction!!';

  @override
  String get fourArithmeticOperationsDesc =>
      'Quickly judge addition, subtraction, multiplication, and division!!';

  @override
  String get addSubtract2DigitsDesc =>
      'Train your calculation skills with 2-digit addition and subtraction!!';

  @override
  String get unlimitedModeTitle => 'Unlimited Mode';

  @override
  String get unlimitedModeSub1 => '--- Play Anytime ---';

  @override
  String get unlimitedModeSub2 => 'Aim for High Score!';

  @override
  String get dailyLimitedModeTitle => 'Daily Limited Mode';

  @override
  String get dailyLimitedModeSub1 => '--- Challenge Once Daily ---';

  @override
  String get dailyLimitedModeSub2 => 'Focus and Aim for Record!';

  @override
  String get settingsButton => '⚙ Settings';

  @override
  String get rankingButton => '👑 Ranking';

  @override
  String get playableStatus => 'Playable';

  @override
  String get playableWithAdStatus => 'Playable with Ad';

  @override
  String get unitSecond => 'sec';

  @override
  String get playButton => 'Play!';

  @override
  String playButtonWithCount(Object count) {
    return '$count Questions';
  }

  @override
  String get playButtonSecondTime => 'Play! (2nd)';

  @override
  String get watchAdToPlayButton => 'Watch Ad to Play';

  @override
  String get playedTodayButton => 'Played Today';

  @override
  String get challengeAgainDialogTitle => '🎁 Challenge Again!';

  @override
  String get challengeAgainDialogContent =>
      'Watch one ad to get another try for today!';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get watchAdButton => 'Watch Ad ▶';

  @override
  String get adLoadingSnackbar => 'Ad is loading. Please wait and try again.';

  @override
  String get allScores => 'All Scores';

  @override
  String get settingsTitle => '⚙ Settings';

  @override
  String get currentUsernameLabel => 'Current Username: ';

  @override
  String get defaultUsername => 'Guest';

  @override
  String get newUsernameLabel => 'New Username';

  @override
  String get saveButton => 'Save';

  @override
  String get lightModeLabel => 'Light Mode';

  @override
  String get darkModeLabel => 'Dark Mode';

  @override
  String get contactLabel => 'Contact: tokoton.math@gmail.com';

  @override
  String get saveCompleteDialogTitle => 'Complete';

  @override
  String get saveCompleteDialogContent => 'Saved successfully!';

  @override
  String get okButton => 'OK';

  @override
  String get rankingTitle => '👑 Ranking 👑';

  @override
  String get allPeriod => 'All Period';

  @override
  String get monthlyPeriod => 'Monthly';

  @override
  String get weeklyPeriod => 'Weekly';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get rank1st => '1st🥇';

  @override
  String get rank2nd => '2nd🥈';

  @override
  String get rank3rd => '3rd🥉';

  @override
  String rankNth(Object rank) {
    return '${rank}th ';
  }

  @override
  String get mathA => 'Math I/A';

  @override
  String get mathB => 'Math II/B';

  @override
  String get mathC => 'Math III/C';

  @override
  String get timeLabel => 'Time';

  @override
  String get scoreLabel => 'Score';

  @override
  String get highScorePrefix => 'High Score: ';

  @override
  String get rankUnit => 'th';

  @override
  String get retryButton => 'Retry';

  @override
  String get menuButton => 'Menu';

  @override
  String get reflectTitle => 'Reflect Master';

  @override
  String get unitMillisecond => 'ms';

  @override
  String get colorReact => 'Color Reaction';

  @override
  String get colorReactMethod => 'Compete with the slowest of 3 tries';

  @override
  String get colorReactDesc => 'Tap when the screen color changes!';

  @override
  String get numberReact => 'Number Reaction';

  @override
  String get reactMethodAverage => 'Compete with the average of 3 tries';

  @override
  String get numberReactDesc => 'Tap the button with the displayed number!';

  @override
  String get gridReact => 'Grid Reaction';

  @override
  String get gridReactDesc => 'Tap the highlighted square!';

  @override
  String get finishingText => 'Finishing...';

  @override
  String get timeHeader => 'TIME';

  @override
  String get pointHeader => 'POINT';

  @override
  String get dialogMenuTitle => 'Menu';

  @override
  String get dialogHomeButton => 'Go Home';

  @override
  String get dialogMistakeTitle => 'Mistake!';

  @override
  String get dialogNextTime => 'Try again next time!!';

  @override
  String get dialogTryAgain => 'Try again?';

  @override
  String get dialogRetryButtonWithIcon => '🔥Retry ▸';

  @override
  String get colorGameTapNow => 'Tap!';

  @override
  String tryNumber(Object number) {
    return 'Try $number';
  }

  @override
  String get timeResultTitle => 'Time!';

  @override
  String get unknownMode => 'Unknown Mode';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get appearanceSectionTitle => 'Appearance';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get aboutSectionTitle => 'About';

  @override
  String get usernameLabel => 'Username';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSelectionTitle => 'Select Language';

  @override
  String get guestUsername => 'Guest';

  @override
  String get saveUsernameSuccessTitle => 'Complete';

  @override
  String get saveUsernameSuccessContent => 'New name saved successfully!';

  @override
  String get buttonLayout => 'Button Layout';

  @override
  String get selectButtonLayout => 'Select Button Layout';

  @override
  String get mobileMode => 'Mobile Mode';

  @override
  String get calculatorMode => 'Calculator Mode';

  @override
  String get detailSetting => 'Detail Setting';

  @override
  String get soundSectionTitle => 'Sound';

  @override
  String get volumeLabel => 'Volume';

  @override
  String get loadingProblem => 'Loading problem, please wait a moment';
}

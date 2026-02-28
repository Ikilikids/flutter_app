import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Arithmetic Battle'**
  String get appTitle;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to Start'**
  String get tapToStart;

  /// No description provided for @addSubtract.
  ///
  /// In en, this message translates to:
  /// **'Addition/Subtraction'**
  String get addSubtract;

  /// No description provided for @addSubtract2Digits.
  ///
  /// In en, this message translates to:
  /// **'2-Digit Addition/Subtraction'**
  String get addSubtract2Digits;

  /// No description provided for @fourArithmeticOperations.
  ///
  /// In en, this message translates to:
  /// **'Four Arithmetic Operations'**
  String get fourArithmeticOperations;

  /// No description provided for @compete20Questions.
  ///
  /// In en, this message translates to:
  /// **'Compete with the time for 20 correct answers'**
  String get compete20Questions;

  /// No description provided for @compete10Questions.
  ///
  /// In en, this message translates to:
  /// **'Compete with the time for 10 correct answers'**
  String get compete10Questions;

  /// No description provided for @addSubtractDesc.
  ///
  /// In en, this message translates to:
  /// **'Feel free to play with addition and subtraction!!'**
  String get addSubtractDesc;

  /// No description provided for @fourArithmeticOperationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Quickly judge addition, subtraction, multiplication, and division!!'**
  String get fourArithmeticOperationsDesc;

  /// No description provided for @addSubtract2DigitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Train your calculation skills with 2-digit addition and subtraction!!'**
  String get addSubtract2DigitsDesc;

  /// No description provided for @unlimitedModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Mode'**
  String get unlimitedModeTitle;

  /// No description provided for @unlimitedModeSub1.
  ///
  /// In en, this message translates to:
  /// **'--- Play Anytime ---'**
  String get unlimitedModeSub1;

  /// No description provided for @unlimitedModeSub2.
  ///
  /// In en, this message translates to:
  /// **'Aim for High Score!'**
  String get unlimitedModeSub2;

  /// No description provided for @dailyLimitedModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Limited Mode'**
  String get dailyLimitedModeTitle;

  /// No description provided for @dailyLimitedModeSub1.
  ///
  /// In en, this message translates to:
  /// **'--- Challenge Once Daily ---'**
  String get dailyLimitedModeSub1;

  /// No description provided for @dailyLimitedModeSub2.
  ///
  /// In en, this message translates to:
  /// **'Focus and Aim for Record!'**
  String get dailyLimitedModeSub2;

  /// No description provided for @settingsButton.
  ///
  /// In en, this message translates to:
  /// **'⚙ Settings'**
  String get settingsButton;

  /// No description provided for @rankingButton.
  ///
  /// In en, this message translates to:
  /// **'👑 Ranking'**
  String get rankingButton;

  /// No description provided for @playableStatus.
  ///
  /// In en, this message translates to:
  /// **'Playable'**
  String get playableStatus;

  /// No description provided for @playableWithAdStatus.
  ///
  /// In en, this message translates to:
  /// **'Playable with Ad'**
  String get playableWithAdStatus;

  /// No description provided for @unitSecond.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get unitSecond;

  /// No description provided for @playButton.
  ///
  /// In en, this message translates to:
  /// **'Play!'**
  String get playButton;

  /// No description provided for @playButtonWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Questions'**
  String playButtonWithCount(Object count);

  /// No description provided for @playButtonSecondTime.
  ///
  /// In en, this message translates to:
  /// **'Play! (2nd)'**
  String get playButtonSecondTime;

  /// No description provided for @watchAdToPlayButton.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad to Play'**
  String get watchAdToPlayButton;

  /// No description provided for @playedTodayButton.
  ///
  /// In en, this message translates to:
  /// **'Played Today'**
  String get playedTodayButton;

  /// No description provided for @challengeAgainDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'🎁 Challenge Again!'**
  String get challengeAgainDialogTitle;

  /// No description provided for @challengeAgainDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Watch one ad to get another try for today!'**
  String get challengeAgainDialogContent;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @watchAdButton.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad ▶'**
  String get watchAdButton;

  /// No description provided for @adLoadingSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Ad is loading. Please wait and try again.'**
  String get adLoadingSnackbar;

  /// No description provided for @allScores.
  ///
  /// In en, this message translates to:
  /// **'All Scores'**
  String get allScores;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'⚙ Settings'**
  String get settingsTitle;

  /// No description provided for @currentUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Username: '**
  String get currentUsernameLabel;

  /// No description provided for @defaultUsername.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get defaultUsername;

  /// No description provided for @newUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'New Username'**
  String get newUsernameLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @lightModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightModeLabel;

  /// No description provided for @darkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeLabel;

  /// No description provided for @contactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact: tokoton.math@gmail.com'**
  String get contactLabel;

  /// No description provided for @saveCompleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get saveCompleteDialogTitle;

  /// No description provided for @saveCompleteDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully!'**
  String get saveCompleteDialogContent;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @rankingTitle.
  ///
  /// In en, this message translates to:
  /// **'👑 Ranking 👑'**
  String get rankingTitle;

  /// No description provided for @allPeriod.
  ///
  /// In en, this message translates to:
  /// **'All Period'**
  String get allPeriod;

  /// No description provided for @monthlyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyPeriod;

  /// No description provided for @weeklyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyPeriod;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @rank1st.
  ///
  /// In en, this message translates to:
  /// **'1st🥇'**
  String get rank1st;

  /// No description provided for @rank2nd.
  ///
  /// In en, this message translates to:
  /// **'2nd🥈'**
  String get rank2nd;

  /// No description provided for @rank3rd.
  ///
  /// In en, this message translates to:
  /// **'3rd🥉'**
  String get rank3rd;

  /// No description provided for @rankNth.
  ///
  /// In en, this message translates to:
  /// **'{rank}th '**
  String rankNth(Object rank);

  /// No description provided for @mathA.
  ///
  /// In en, this message translates to:
  /// **'Math I/A'**
  String get mathA;

  /// No description provided for @mathB.
  ///
  /// In en, this message translates to:
  /// **'Math II/B'**
  String get mathB;

  /// No description provided for @mathC.
  ///
  /// In en, this message translates to:
  /// **'Math III/C'**
  String get mathC;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreLabel;

  /// No description provided for @highScorePrefix.
  ///
  /// In en, this message translates to:
  /// **'High Score: '**
  String get highScorePrefix;

  /// No description provided for @rankUnit.
  ///
  /// In en, this message translates to:
  /// **'th'**
  String get rankUnit;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @menuButton.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuButton;

  /// No description provided for @reflectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflect Master'**
  String get reflectTitle;

  /// No description provided for @unitMillisecond.
  ///
  /// In en, this message translates to:
  /// **'ms'**
  String get unitMillisecond;

  /// No description provided for @colorReact.
  ///
  /// In en, this message translates to:
  /// **'Color Reaction'**
  String get colorReact;

  /// No description provided for @colorReactMethod.
  ///
  /// In en, this message translates to:
  /// **'Compete with the slowest of 3 tries'**
  String get colorReactMethod;

  /// No description provided for @colorReactDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap when the screen color changes!'**
  String get colorReactDesc;

  /// No description provided for @numberReact.
  ///
  /// In en, this message translates to:
  /// **'Number Reaction'**
  String get numberReact;

  /// No description provided for @reactMethodAverage.
  ///
  /// In en, this message translates to:
  /// **'Compete with the average of 3 tries'**
  String get reactMethodAverage;

  /// No description provided for @numberReactDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the button with the displayed number!'**
  String get numberReactDesc;

  /// No description provided for @gridReact.
  ///
  /// In en, this message translates to:
  /// **'Grid Reaction'**
  String get gridReact;

  /// No description provided for @gridReactDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the highlighted square!'**
  String get gridReactDesc;

  /// No description provided for @finishingText.
  ///
  /// In en, this message translates to:
  /// **'Finishing...'**
  String get finishingText;

  /// No description provided for @timeHeader.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get timeHeader;

  /// No description provided for @pointHeader.
  ///
  /// In en, this message translates to:
  /// **'POINT'**
  String get pointHeader;

  /// No description provided for @dialogMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get dialogMenuTitle;

  /// No description provided for @dialogHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get dialogHomeButton;

  /// No description provided for @dialogMistakeTitle.
  ///
  /// In en, this message translates to:
  /// **'Mistake!'**
  String get dialogMistakeTitle;

  /// No description provided for @dialogNextTime.
  ///
  /// In en, this message translates to:
  /// **'Try again next time!!'**
  String get dialogNextTime;

  /// No description provided for @dialogTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again?'**
  String get dialogTryAgain;

  /// No description provided for @dialogRetryButtonWithIcon.
  ///
  /// In en, this message translates to:
  /// **'🔥Retry ▸'**
  String get dialogRetryButtonWithIcon;

  /// No description provided for @colorGameTapNow.
  ///
  /// In en, this message translates to:
  /// **'Tap!'**
  String get colorGameTapNow;

  /// No description provided for @tryNumber.
  ///
  /// In en, this message translates to:
  /// **'Try {number}'**
  String tryNumber(Object number);

  /// No description provided for @timeResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Time!'**
  String get timeResultTitle;

  /// No description provided for @unknownMode.
  ///
  /// In en, this message translates to:
  /// **'Unknown Mode'**
  String get unknownMode;

  /// No description provided for @accountSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionTitle;

  /// No description provided for @appearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSectionTitle;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @aboutSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSectionTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelectionTitle;

  /// No description provided for @guestUsername.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestUsername;

  /// No description provided for @saveUsernameSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get saveUsernameSuccessTitle;

  /// No description provided for @saveUsernameSuccessContent.
  ///
  /// In en, this message translates to:
  /// **'New name saved successfully!'**
  String get saveUsernameSuccessContent;

  /// No description provided for @buttonLayout.
  ///
  /// In en, this message translates to:
  /// **'Button Layout'**
  String get buttonLayout;

  /// No description provided for @selectButtonLayout.
  ///
  /// In en, this message translates to:
  /// **'Select Button Layout'**
  String get selectButtonLayout;

  /// No description provided for @mobileMode.
  ///
  /// In en, this message translates to:
  /// **'Mobile Mode'**
  String get mobileMode;

  /// No description provided for @calculatorMode.
  ///
  /// In en, this message translates to:
  /// **'Calculator Mode'**
  String get calculatorMode;

  /// No description provided for @detailSetting.
  ///
  /// In en, this message translates to:
  /// **'Detail Setting'**
  String get detailSetting;

  /// No description provided for @soundSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get soundSectionTitle;

  /// No description provided for @volumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volumeLabel;

  /// No description provided for @loadingProblem.
  ///
  /// In en, this message translates to:
  /// **'Loading problem, please wait a moment'**
  String get loadingProblem;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please update to the latest version for a better experience.'**
  String get updateRequiredMessage;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

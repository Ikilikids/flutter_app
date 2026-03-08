// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '산수 전투';

  @override
  String get tapToStart => '탭하여 시작';

  @override
  String get addSubtract => '덧셈/뺄셈';

  @override
  String get addSubtract2Digits => '두 자릿수 덧셈/뺄셈';

  @override
  String get fourArithmeticOperations => '사칙연산';

  @override
  String get compete20Questions => '20문제 정답 시간 경쟁';

  @override
  String get compete10Questions => '10문제 정답 시간 경쟁';

  @override
  String get addSubtractDesc => '덧셈과 뺄셈을 마음껏 즐겨보세요!';

  @override
  String get fourArithmeticOperationsDesc => '덧셈, 뺄셈, 곱셈, 나눗셈을 빠르게 판단하세요!';

  @override
  String get addSubtract2DigitsDesc => '두 자릿수 덧셈과 뺄셈으로 계산 능력을 훈련하세요!';

  @override
  String get unlimitedModeTitle => '무제한 모드';

  @override
  String get unlimitedModeSub1 => '--- 언제든지 플레이 ---';

  @override
  String get unlimitedModeSub2 => '최고 점수를 노려보세요!';

  @override
  String get dailyLimitedModeTitle => '일일 제한 모드';

  @override
  String get dailyLimitedModeSub1 => '--- 하루에 한 번 도전 ---';

  @override
  String get dailyLimitedModeSub2 => '집중해서 기록을 노리세요!';

  @override
  String get settingsButton => '설정';

  @override
  String get rankingButton => '랭킹';

  @override
  String get playableStatus => '플레이 가능';

  @override
  String get playableWithAdStatus => '광고 시청 후 플레이 가능';

  @override
  String get unitSecond => '초';

  @override
  String get playButton => '플레이!';

  @override
  String playButtonWithCount(Object count) {
    return '$count문제';
  }

  @override
  String get playButtonSecondTime => '플레이! (2회차)';

  @override
  String get watchAdToPlayButton => '광고 보고 플레이';

  @override
  String get playedTodayButton => '오늘 플레이 완료';

  @override
  String get challengeAgainDialogTitle => '🎁 다시 도전!';

  @override
  String get challengeAgainDialogContent =>
      '광고를 한 편 시청하면 오늘 도전을 한 번 더 할 수 있습니다!';

  @override
  String get cancelButton => '취소';

  @override
  String get watchAdButton => '광고 보기 ▶';

  @override
  String get adLoadingSnackbar => '광고를 로드하는 중입니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get allScores => '모든 점수';

  @override
  String get settingsTitle => '설정';

  @override
  String get currentUsernameLabel => '현재 사용자 이름: ';

  @override
  String get defaultUsername => '게스트';

  @override
  String get newUsernameLabel => '새 사용자 이름';

  @override
  String get saveButton => '저장';

  @override
  String get lightModeLabel => '라이트 모드';

  @override
  String get darkModeLabel => '다크 모드';

  @override
  String get contactLabel => '문의: tokoton.math@gmail.com';

  @override
  String get saveCompleteDialogTitle => '완료';

  @override
  String get saveCompleteDialogContent => '성공적으로 저장되었습니다!';

  @override
  String get okButton => '확인';

  @override
  String get rankingTitle => '랭킹';

  @override
  String get allPeriod => '전체 기간';

  @override
  String get monthlyPeriod => '월간';

  @override
  String get weeklyPeriod => '주간';

  @override
  String get noDataAvailable => '데이터가 없습니다';

  @override
  String get rank1st => '1위🥇';

  @override
  String get rank2nd => '2위🥈';

  @override
  String get rank3rd => '3위🥉';

  @override
  String rankNth(Object rank) {
    return '$rank위 ';
  }

  @override
  String get mathA => '수학 I/A';

  @override
  String get mathB => '수학 II/B';

  @override
  String get mathC => '수학 III/C';

  @override
  String get timeLabel => '시간';

  @override
  String get scoreLabel => '점수';

  @override
  String get highScorePrefix => '최고 기록: ';

  @override
  String get rankUnit => '위';

  @override
  String get retryButton => '다시 시도';

  @override
  String get menuButton => '메뉴';

  @override
  String get reflectTitle => '토코톤 반사신경';

  @override
  String get unitMillisecond => '밀리초';

  @override
  String get colorReact => '색상 반응';

  @override
  String get colorReactMethod => '3회 중 가장 느린 시간으로 경쟁';

  @override
  String get colorReactDesc => '화면 색이 바뀌면 탭하세요!';

  @override
  String get numberReact => '숫자 반응';

  @override
  String get reactMethodAverage => '3회 평균 시간으로 경쟁';

  @override
  String get numberReactDesc => '표시된 숫자의 버튼을 탭하세요!';

  @override
  String get gridReact => '그리드 반응';

  @override
  String get gridReactDesc => '빛나는 칸을 탭하세요!';

  @override
  String get finishingText => '종료하는 중...';

  @override
  String get timeHeader => '시간';

  @override
  String get pointHeader => '포인트';

  @override
  String get dialogMenuTitle => '메뉴';

  @override
  String get dialogHomeButton => '홈으로';

  @override
  String get dialogMistakeTitle => '실수!';

  @override
  String get dialogNextTime => '다음에 다시 도전하세요!!';

  @override
  String get dialogTryAgain => '다시 도전하시겠습니까?';

  @override
  String get dialogRetryButtonWithIcon => '🔥다시 시도 ▸';

  @override
  String get colorGameTapNow => '탭하세요!';

  @override
  String tryNumber(Object number) {
    return '$number번째 시도';
  }

  @override
  String get timeResultTitle => '시간!';

  @override
  String get unknownMode => '알 수 없는 모드';

  @override
  String get accountSectionTitle => '계정';

  @override
  String get appearanceSectionTitle => '테마';

  @override
  String get languageSectionTitle => '언어';

  @override
  String get aboutSectionTitle => '정보';

  @override
  String get usernameLabel => '사용자 이름';

  @override
  String get languageLabel => '언어';

  @override
  String get languageSelectionTitle => '언어 선택';

  @override
  String get guestUsername => '게스트';

  @override
  String get saveUsernameSuccessTitle => '완료';

  @override
  String get saveUsernameSuccessContent => '새 이름이 성공적으로 저장되었습니다!';

  @override
  String get buttonLayout => '버튼 레이아웃';

  @override
  String get selectButtonLayout => '버튼 레이아웃 선택';

  @override
  String get mobileMode => '모바일 모드';

  @override
  String get calculatorMode => '계산기 모드';

  @override
  String get detailSetting => '상세 설정';

  @override
  String get soundSectionTitle => '소리';

  @override
  String get volumeLabel => '볼륨';

  @override
  String get loadingProblem => '문제 로드 중, 잠시만 기다려 주십시오';

  @override
  String get updateRequiredTitle => '업데이트 알림';

  @override
  String get updateRequiredMessage => '더 나은 환경을 위해 최신 버전으로 업데이트해 주세요.';

  @override
  String get updateButton => '지금 업데이트';
}

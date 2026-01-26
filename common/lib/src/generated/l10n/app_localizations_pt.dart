// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Batalha Aritmética';

  @override
  String get tapToStart => 'Toque para começar';

  @override
  String get addSubtract => 'Adição/Subtração';

  @override
  String get addSubtract2Digits => 'Adição/Subtração de 2 dígitos';

  @override
  String get fourArithmeticOperations => 'Quatro operações aritméticas';

  @override
  String get compete20Questions =>
      'Compita com o tempo para 20 respostas corretas';

  @override
  String get compete10Questions =>
      'Compita com o tempo para 10 respostas corretas';

  @override
  String get addSubtractDesc =>
      'Sinta-se à vontade para brincar com adição e subtração!';

  @override
  String get fourArithmeticOperationsDesc =>
      'Julgue rapidamente adição, subtração, multiplicação e divisão!';

  @override
  String get addSubtract2DigitsDesc =>
      'Treine suas habilidades de cálculo com adição e subtração de 2 dígitos!';

  @override
  String get unlimitedModeTitle => 'Modo Ilimitado';

  @override
  String get unlimitedModeSub1 => '--- Jogue a qualquer hora ---';

  @override
  String get unlimitedModeSub2 => 'Almeje a pontuação máxima!';

  @override
  String get dailyLimitedModeTitle => 'Modo Limitado Diário';

  @override
  String get dailyLimitedModeSub1 => '--- Desafie uma vez por dia ---';

  @override
  String get dailyLimitedModeSub2 => 'Concentre-se e almeje um recorde!';

  @override
  String get settingsButton => '⚙ Configurações';

  @override
  String get rankingButton => '👑 Ranking';

  @override
  String get playableStatus => 'Jogável';

  @override
  String get playableWithAdStatus => 'Jogável com Anúncio';

  @override
  String get unitSecond => 'seg';

  @override
  String get playButton => 'Jogar!';

  @override
  String playButtonWithCount(Object count) {
    return '$count Perguntas';
  }

  @override
  String get playButtonSecondTime => 'Jogar! (2ª vez)';

  @override
  String get watchAdToPlayButton => 'Assistir Anúncio para Jogar';

  @override
  String get playedTodayButton => 'Jogado Hoje';

  @override
  String get challengeAgainDialogTitle => '🎁 Desafie novamente!';

  @override
  String get challengeAgainDialogContent =>
      'Assista a um anúncio para ter outra tentativa hoje!';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get watchAdButton => 'Assistir Anúncio ▶';

  @override
  String get adLoadingSnackbar =>
      'O anúncio está carregando. Por favor, aguarde e tente novamente.';

  @override
  String get allScores => 'Pontuações Totais';

  @override
  String get settingsTitle => '⚙ Configurações';

  @override
  String get currentUsernameLabel => 'Nome de usuário atual: ';

  @override
  String get defaultUsername => 'Convidado';

  @override
  String get newUsernameLabel => 'Novo nome de usuário';

  @override
  String get saveButton => 'Salvar';

  @override
  String get lightModeLabel => 'Modo Claro';

  @override
  String get darkModeLabel => 'Modo Escuro';

  @override
  String get contactLabel => 'Contato: tokoton.math@gmail.com';

  @override
  String get saveCompleteDialogTitle => 'Concluído';

  @override
  String get saveCompleteDialogContent => 'Salvo com sucesso!';

  @override
  String get okButton => 'OK';

  @override
  String get rankingTitle => '👑 Ranking 👑';

  @override
  String get allPeriod => 'Todo o período';

  @override
  String get monthlyPeriod => 'Mensal';

  @override
  String get weeklyPeriod => 'Semanal';

  @override
  String get noDataAvailable => 'Nenhum dado disponível';

  @override
  String get rank1st => '1º🥇';

  @override
  String get rank2nd => '2º🥈';

  @override
  String get rank3rd => '3º🥉';

  @override
  String rankNth(Object rank) {
    return '$rankº ';
  }

  @override
  String get mathA => 'Matemática I/A';

  @override
  String get mathB => 'Matemática II/B';

  @override
  String get mathC => 'Matemática III/C';

  @override
  String get timeLabel => 'Tempo';

  @override
  String get scoreLabel => 'Pontuação';

  @override
  String get highScorePrefix => 'Pontuação Máxima: ';

  @override
  String get rankUnit => 'º';

  @override
  String get retryButton => 'Tentar Novamente';

  @override
  String get menuButton => 'Menu';

  @override
  String get reflectTitle => 'Mestre dos Reflexos';

  @override
  String get unitMillisecond => 'ms';

  @override
  String get colorReact => 'Reação de Cor';

  @override
  String get colorReactMethod => 'Compita com o mais lento de 3 tentativas';

  @override
  String get colorReactDesc => 'Toque quando a cor da tela mudar!';

  @override
  String get numberReact => 'Reação de Número';

  @override
  String get reactMethodAverage => 'Compita com a média de 3 tentativas';

  @override
  String get numberReactDesc => 'Toque no botão com o número exibido!';

  @override
  String get gridReact => 'Reação de Grade';

  @override
  String get gridReactDesc => 'Toque no quadrado destacado!';

  @override
  String get finishingText => 'Finalizando...';

  @override
  String get timeHeader => 'TEMPO';

  @override
  String get pointHeader => 'PONTOS';

  @override
  String get dialogMenuTitle => 'Menu';

  @override
  String get dialogHomeButton => 'Ir para o Início';

  @override
  String get dialogMistakeTitle => 'Erro!';

  @override
  String get dialogNextTime => 'Tente da próxima vez!!';

  @override
  String get dialogTryAgain => 'Tentar novamente?';

  @override
  String get dialogRetryButtonWithIcon => '🔥Tentar Novamente ▸';

  @override
  String get colorGameTapNow => 'Toque!';

  @override
  String tryNumber(Object number) {
    return 'Tentativa $number';
  }

  @override
  String get timeResultTitle => 'Tempo!';

  @override
  String get unknownMode => 'Modo Desconhecido';

  @override
  String get accountSectionTitle => 'Conta';

  @override
  String get appearanceSectionTitle => 'Aparência';

  @override
  String get languageSectionTitle => 'Idioma';

  @override
  String get aboutSectionTitle => 'Sobre';

  @override
  String get usernameLabel => 'Nome de usuário';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageSelectionTitle => 'Selecionar Idioma';

  @override
  String get guestUsername => 'Convidado';

  @override
  String get saveUsernameSuccessTitle => 'Concluído';

  @override
  String get saveUsernameSuccessContent => 'Novo nome salvo com sucesso!';

  @override
  String get buttonLayout => 'Layout do botão';

  @override
  String get selectButtonLayout => 'Selecionar layout do botão';

  @override
  String get mobileMode => 'Modo móvel';

  @override
  String get calculatorMode => 'Modo calculadora';

  @override
  String get detailSetting => 'Configuração detalhada';

  @override
  String get soundSectionTitle => 'Som';

  @override
  String get volumeLabel => 'Volume';
}

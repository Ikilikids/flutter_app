// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Batalla aritmética';

  @override
  String get tapToStart => 'Toca para empezar';

  @override
  String get addSubtract => 'Suma/Resta';

  @override
  String get addSubtract2Digits => 'Suma/Resta de 2 dígitos';

  @override
  String get fourArithmeticOperations => 'Cuatro operaciones aritméticas';

  @override
  String get compete20Questions =>
      'Compite con el tiempo para 20 respuestas correctas';

  @override
  String get compete10Questions =>
      'Compite con el tiempo para 10 respuestas correctas';

  @override
  String get addSubtractDesc =>
      '¡Siéntete libre de jugar con la suma y la resta!';

  @override
  String get fourArithmeticOperationsDesc =>
      '¡Juzga rápidamente la suma, resta, multiplicación y división!';

  @override
  String get addSubtract2DigitsDesc =>
      '¡Entrena tus habilidades de cálculo con la suma y resta de 2 dígitos!';

  @override
  String get unlimitedModeTitle => 'Modo Ilimitado';

  @override
  String get unlimitedModeSub1 => '--- Juega en cualquier momento ---';

  @override
  String get unlimitedModeSub2 => '¡Apunta a la puntuación más alta!';

  @override
  String get dailyLimitedModeTitle => 'Modo Limitado Diario';

  @override
  String get dailyLimitedModeSub1 => '--- Desafío una vez al día ---';

  @override
  String get dailyLimitedModeSub2 => '¡Concéntrate y apunta a un récord!';

  @override
  String get settingsButton => 'Ajustes';

  @override
  String get rankingButton => 'Ranking';

  @override
  String get playableStatus => 'Jugable';

  @override
  String get playableWithAdStatus => 'Jugable con Anuncio';

  @override
  String get unitSecond => 'seg';

  @override
  String get playButton => '¡Jugar!';

  @override
  String playButtonWithCount(Object count) {
    return '$count Preguntas';
  }

  @override
  String get playButtonSecondTime => '¡Jugar! (2ª vez)';

  @override
  String get watchAdToPlayButton => 'Ver Anuncio para Jugar';

  @override
  String get playedTodayButton => 'Jugado Hoy';

  @override
  String get challengeAgainDialogTitle => '🎁 ¡Desafía de nuevo!';

  @override
  String get challengeAgainDialogContent =>
      '¡Mira un anuncio para tener otro intento hoy!';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get watchAdButton => 'Ver Anuncio ▶';

  @override
  String get adLoadingSnackbar =>
      'El anuncio se está cargando. Por favor, espera e inténtalo de nuevo.';

  @override
  String get allScores => 'Puntuaciones Totales';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get currentUsernameLabel => 'Nombre de usuario actual: ';

  @override
  String get defaultUsername => 'Invitado';

  @override
  String get newUsernameLabel => 'Nuevo nombre de usuario';

  @override
  String get saveButton => 'Guardar';

  @override
  String get lightModeLabel => 'Modo Claro';

  @override
  String get darkModeLabel => 'Modo Oscuro';

  @override
  String get contactLabel => 'Contacto: tokoton.math@gmail.com';

  @override
  String get saveCompleteDialogTitle => 'Completado';

  @override
  String get saveCompleteDialogContent => '¡Guardado exitosamente!';

  @override
  String get okButton => 'OK';

  @override
  String get rankingTitle => 'Ranking';

  @override
  String get allPeriod => 'Todo el período';

  @override
  String get monthlyPeriod => 'Mensual';

  @override
  String get weeklyPeriod => 'Semanal';

  @override
  String get noDataAvailable => 'No hay datos disponibles';

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
  String get mathA => 'Matemáticas I/A';

  @override
  String get mathB => 'Matemáticas II/B';

  @override
  String get mathC => 'Matemáticas III/C';

  @override
  String get timeLabel => 'Tiempo';

  @override
  String get scoreLabel => 'Puntuación';

  @override
  String get highScorePrefix => 'Puntuación Máxima: ';

  @override
  String get rankUnit => 'º';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get menuButton => 'Menú';

  @override
  String get reflectTitle => 'Maestro del Reflejo';

  @override
  String get unitMillisecond => 'ms';

  @override
  String get colorReact => 'Reacción de Color';

  @override
  String get colorReactMethod => 'Compite con el más lento de 3 intentos';

  @override
  String get colorReactDesc => '¡Toca cuando cambie el color de la pantalla!';

  @override
  String get numberReact => 'Reacción de Número';

  @override
  String get reactMethodAverage => 'Compite con el promedio de 3 intentos';

  @override
  String get numberReactDesc => '¡Toca el botón con el número mostrado!';

  @override
  String get gridReact => 'Reacción de Cuadrícula';

  @override
  String get gridReactDesc => '¡Toca el cuadrado iluminado!';

  @override
  String get finishingText => 'Finalizando...';

  @override
  String get timeHeader => 'TIEMPO';

  @override
  String get pointHeader => 'PUNTOS';

  @override
  String get dialogMenuTitle => 'Menú';

  @override
  String get dialogHomeButton => 'Ir al Inicio';

  @override
  String get dialogMistakeTitle => '¡Error!';

  @override
  String get dialogNextTime => '¡Inténtalo la próxima vez!';

  @override
  String get dialogTryAgain => '¿Intentar otra vez?';

  @override
  String get dialogRetryButtonWithIcon => '🔥Reintentar ▸';

  @override
  String get colorGameTapNow => '¡Toca!';

  @override
  String tryNumber(Object number) {
    return 'Intento $number';
  }

  @override
  String get timeResultTitle => '¡Tiempo!';

  @override
  String get unknownMode => 'Modo Desconocido';

  @override
  String get accountSectionTitle => 'Cuenta';

  @override
  String get appearanceSectionTitle => 'Apariencia';

  @override
  String get languageSectionTitle => 'Idioma';

  @override
  String get aboutSectionTitle => 'Acerca de';

  @override
  String get usernameLabel => 'Nombre de usuario';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageSelectionTitle => 'Seleccionar idioma';

  @override
  String get guestUsername => 'Invitado';

  @override
  String get saveUsernameSuccessTitle => 'Completado';

  @override
  String get saveUsernameSuccessContent => '¡Nuevo nombre guardado con éxito!';

  @override
  String get buttonLayout => 'Diseño de botones';

  @override
  String get selectButtonLayout => 'Seleccionar diseño de botones';

  @override
  String get mobileMode => 'Modo móvil';

  @override
  String get calculatorMode => 'Modo calculadora';

  @override
  String get detailSetting => 'Ajustes detallados';

  @override
  String get soundSectionTitle => 'Sonido';

  @override
  String get volumeLabel => 'Volumen';

  @override
  String get loadingProblem => 'Cargando problema, por favor espere un momento';

  @override
  String get updateRequiredTitle => 'Actualización requerida';

  @override
  String get updateRequiredMessage =>
      'Actualice a la última versión para una mejor experiencia.';

  @override
  String get updateButton => 'Actualizar ahora';
}

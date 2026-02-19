import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'assistance/quiz_logic.dart';
import 'firebase_options.dart';
import 'page/quiz_screen.dart';

final _appConfig = AllData(
  appTitle: "とことん四則演算",
  appIcon: Icons.calculate,
  symbols: ["+", "-", "×", "÷"],
  isRotation: false,
  mid: [
    MidData(
      unit: "秒",
      fix: 2,
      islimited: false,
      isbattle: true,
      ranking: "t",
      detail: [
        DetailData(
          sort: "32",
          label: "足し算・引き算",
          method: "20問の正解タイムで競う",
          description: "足し算・引き算、気軽にプレイ!!",
          color: "2",
          circleColor: "32",
        ),
        DetailData(
          sort: "3251",
          label: "四則演算",
          method: "20問の正解タイムで競う",
          description: "足し算・引き算・掛け算・割り算、素早く判断!!",
          color: "5",
          circleColor: "3251",
        ),
        DetailData(
          sort: "46",
          label: "2桁の足し算・引き算",
          method: "10問の正解タイムで競う",
          description: "2桁の足し算・引き算、計算力を鍛えよう!!",
          color: "4",
          circleColor: "46",
        ),
      ],
    ),
    MidData(
      unit: "秒",
      fix: 2,
      islimited: true,
      isbattle: true,
      ranking: "g",
      detail: [
        DetailData(
          sort: "32",
          label: "足し算・引き算",
          method: "20問の正解タイムで競う",
          description: "足し算・引き算、気軽にプレイ!!",
          color: "3",
          circleColor: "32",
        ),
        DetailData(
          sort: "3251",
          label: "四則演算",
          method: "20問の正解タイムで競う",
          description: "足し算・引き算・掛け算・割り算、素早く判断!!",
          color: "1",
          circleColor: "3251",
        ),
        DetailData(
          sort: "46",
          label: "2桁の足し算・引き算",
          method: "10問の正解タイムで競う",
          description: "2桁の足し算・引き算、計算力を鍛えよう!!",
          color: "6",
          circleColor: "46",
        ),
      ],
    ),
  ],
  mainGame: (BuildContext context, QuizData quizinfo) => Quizscreen(
    quizDirectives: prepareQuizDirectives(quizinfo.sort),
    quizinfo: quizinfo,
  ),
);
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final options = DefaultFirebaseOptions.currentPlatform;

  runApp(
    Bootstrap(
      appConfig: _appConfig,
      firebaseOptions: options,
    ),
  );
}

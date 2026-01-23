import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'page/game_screen.dart';

final _appConfig = AppConfig(
  title: "とことん反射神経",
  icon: Icons.flash_on,
  symbols: ["!!", "◯", "*", "♪"],
  isRotation: true,
  data: [
    GameData(
      fix: 0,
      unit: "ミリ秒",
      islimited: false,
      isbattle: true,
      ranking: "t",
      detail: [
        GameDetail(
          sort: "color",
          label: "色で反応",
          method: "3回のうち一番遅いタイムで競う",
          description: "画面の色が変わったらタップ！",
          color: "2",
          circleColor: "2",
        ),
        GameDetail(
          sort: "number",
          label: "数字で反応",
          method: "3回の平均タイムで競う",
          description: "表示された数字のボタンをタップ！",
          color: "5",
          circleColor: "5",
        ),
        GameDetail(
          sort: "grid",
          label: "マス目で反応",
          method: "3回の平均タイムで競う",
          description: "光ったマスをタップ！",
          color: "4",
          circleColor: "4",
        ),
      ],
    ),
    GameData(
      fix: 0,
      unit: "ミリ秒",
      islimited: true,
      isbattle: true,
      ranking: "g",
      detail: [
        GameDetail(
          sort: "color",
          label: "色で反応",
          method: "3回のうち一番遅いタイムで競う",
          description: "画面の色が変わったらタップ！",
          color: "3",
          circleColor: "3",
        ),
        GameDetail(
          sort: "number",
          label: "数字で反応",
          method: "3回の平均タイムで競う",
          description: "表示された数字のボタンをタップ！",
          color: "1",
          circleColor: "1",
        ),
        GameDetail(
          sort: "grid",
          label: "マス目で反応",
          method: "3回の平均タイムで競う",
          description: "光ったマスをタップ！",
          color: "6",
          circleColor: "6",
        ),
      ],
    ),
  ],
  mainGame: (BuildContext context, QuizData quizinfo) => Gamescreen(
    quizinfo: quizinfo,
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Bootstrap(
      appConfig: _appConfig,
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    ),
  );
}

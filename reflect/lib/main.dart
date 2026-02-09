import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'page/game_screen.dart';

final _appConfig = AppConfig(
  title: "reflectTitle",
  icon: Icons.flash_on,
  symbols: ["!!", "◯", "*", "♪"],
  isRotation: true,
  BannerId: "ca-app-pub-1440692612851416/6348678971",
  InterId: "ca-app-pub-1440692612851416/5035597308",
  RewardId: "ca-app-pub-1440692612851416/6205218489",
  data: [
    GameData(
      fix: 0,
      unit: "unitMillisecond",
      islimited: false,
      isbattle: true,
      ranking: "t",
      title: "unlimitedModeTitle",
      sub1: "unlimitedModeSub1",
      sub2: "unlimitedModeSub2",
      detail: [
        GameDetail(
          sort: "color",
          label: "colorReact",
          method: "colorReactMethod",
          description: "colorReactDesc",
          color: "2",
          circleColor: "2",
        ),
        GameDetail(
          sort: "number",
          label: "numberReact",
          method: "reactMethodAverage",
          description: "numberReactDesc",
          color: "5",
          circleColor: "5",
        ),
        GameDetail(
          sort: "grid",
          label: "gridReact",
          method: "reactMethodAverage",
          description: "gridReactDesc",
          color: "4",
          circleColor: "4",
        ),
      ],
    ),
    GameData(
      fix: 0,
      unit: "unitMillisecond",
      islimited: true,
      isbattle: true,
      ranking: "g",
      title: "dailyLimitedModeTitle",
      sub1: "dailyLimitedModeSub1",
      sub2: "dailyLimitedModeSub2",
      detail: [
        GameDetail(
          sort: "color",
          label: "colorReact",
          method: "colorReactMethod",
          description: "colorReactDesc",
          color: "3",
          circleColor: "3",
        ),
        GameDetail(
          sort: "number",
          label: "numberReact",
          method: "reactMethodAverage",
          description: "numberReactDesc",
          color: "1",
          circleColor: "1",
        ),
        GameDetail(
          sort: "grid",
          label: "gridReact",
          method: "reactMethodAverage",
          description: "gridReactDesc",
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

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

final _appConfig = AllData(
  appData: AppData(
    appTitle: "reflectTitle",
    appIcon: Icons.flash_on,
    symbols: ["!!", "◯", "*", "♪"],
    isRotation: true,
    URL: "https://play.google.com/store/apps/details?id=jp.ponta.reflect",
    bannerId: "ca-app-pub-1440692612851416/6348678971",
    interId: "ca-app-pub-1440692612851416/5035597308",
    rewardId: "ca-app-pub-1440692612851416/6205218489",
  ),
  mid: [
    MidData(
      modeData: ModeData(
        fix: 0,
        unit: "unitMillisecond",
        islimited: false,
        isbattle: true,
        isSmallerBetter: true,
        modeType: "t",
        modeTitle: "unlimitedModeTitle",
        modeIcon: Icons.all_inclusive,
        modeDescription: "・1日に何回でも挑戦できます！\n"
            "・ハイスコアを目指そう！",
        rankingList: [
          QuizTabInfo(
              id: "色で反応",
              display: "colorReact",
              color: "2",
              icon: Icons.palette),
          QuizTabInfo(
              id: "数字で反応", display: "numberReact", color: "5", icon: Icons.pin),
          QuizTabInfo(
              id: "マス目で反応",
              display: "gridReact",
              color: "4",
              icon: Icons.grid_4x4)
        ],
      ),
      detail: [
        DetailData(
          quizId: const QuizId(resisterOrigin: "色で反応", modeType: "t"),
          sort: "color",
          displayLabel: "colorReact",
          method: "colorReactMethod",
          description: "colorReactDesc",
          color: "2",
          circleColor: "2",
          detailIcon: Icons.palette,
        ),
        DetailData(
          quizId: const QuizId(resisterOrigin: "数字で反応", modeType: "t"),
          sort: "number",
          displayLabel: "numberReact",
          method: "reactMethodAverage",
          description: "numberReactDesc",
          color: "5",
          circleColor: "5",
          detailIcon: Icons.pin,
        ),
        DetailData(
          quizId: const QuizId(resisterOrigin: "マス目で反応", modeType: "t"),
          sort: "grid",
          displayLabel: "gridReact",
          method: "reactMethodAverage",
          description: "gridReactDesc",
          color: "4",
          circleColor: "4",
          detailIcon: Icons.grid_4x4,
        ),
      ],
    ),
    MidData(
      modeData: ModeData(
        fix: 0,
        unit: "unitMillisecond",
        islimited: true,
        isbattle: true,
        isSmallerBetter: true,
        modeType: "g",
        modeTitle: "dailyLimitedModeTitle",
        modeIcon: Icons.timer,
        modeDescription: "・1日1回限定！\n"
            "・集中して挑もう！",
        rankingList: [
          QuizTabInfo(
              id: "色で反応",
              display: "colorReact",
              color: "3",
              icon: Icons.palette),
          QuizTabInfo(
              id: "数字で反応", display: "numberReact", color: "1", icon: Icons.pin),
          QuizTabInfo(
              id: "マス目で反応",
              display: "gridReact",
              color: "6",
              icon: Icons.grid_4x4)
        ],
      ),
      detail: [
        DetailData(
          quizId: const QuizId(resisterOrigin: "色で反応", modeType: "g"),
          sort: "color",
          displayLabel: "colorReact",
          method: "colorReactMethod",
          description: "colorReactDesc",
          color: "3",
          circleColor: "3",
          detailIcon: Icons.palette,
        ),
        DetailData(
          quizId: const QuizId(resisterOrigin: "数字で反応", modeType: "g"),
          sort: "number",
          displayLabel: "numberReact",
          method: "reactMethodAverage",
          description: "numberReactDesc",
          color: "1",
          circleColor: "1",
          detailIcon: Icons.pin,
        ),
        DetailData(
          quizId: const QuizId(resisterOrigin: "マス目で反応", modeType: "g"),
          sort: "grid",
          displayLabel: "gridReact",
          method: "reactMethodAverage",
          description: "gridReactDesc",
          color: "6",
          circleColor: "6",
          detailIcon: Icons.grid_4x4,
        ),
      ],
    ),
  ],
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

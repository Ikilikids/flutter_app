import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';
import 'page/game_screen.dart';

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
      mainGame: (BuildContext context, DetailConfig quizinfo) =>
          Gamescreen(quizinfo: quizinfo)),
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
      ),
      detail: [
        DetailData(
          sort: "color",
          displayLabel: "colorReact",
          displayRank: "colorReact",
          resisterSub: "色で反応",
          resisterOrigin: "色で反応",
          method: "colorReactMethod",
          description: "colorReactDesc",
          color: "2",
          circleColor: "2",
          detailIcon: Icons.palette,
        ),
        DetailData(
          sort: "number",
          displayLabel: "numberReact",
          displayRank: "numberReact",
          resisterSub: "数字で反応",
          resisterOrigin: "数字で反応",
          method: "reactMethodAverage",
          description: "numberReactDesc",
          color: "5",
          circleColor: "5",
          detailIcon: Icons.pin,
        ),
        DetailData(
          sort: "grid",
          displayLabel: "gridReact",
          displayRank: "gridReact",
          resisterSub: "マス目で反応",
          resisterOrigin: "マス目で反応",
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
      ),
      detail: [
        DetailData(
          sort: "color",
          displayLabel: "colorReact",
          displayRank: "colorReact",
          resisterSub: "色で反応",
          resisterOrigin: "色で反応",
          method: "colorReactMethod",
          description: "colorReactDesc",
          color: "3",
          circleColor: "3",
          detailIcon: Icons.palette,
        ),
        DetailData(
          sort: "number",
          displayLabel: "numberReact",
          displayRank: "numberReact",
          resisterSub: "数字で反応",
          resisterOrigin: "数字で反応",
          method: "reactMethodAverage",
          description: "numberReactDesc",
          color: "1",
          circleColor: "1",
          detailIcon: Icons.pin,
        ),
        DetailData(
          sort: "grid",
          displayLabel: "gridReact",
          displayRank: "gridReact",
          resisterSub: "マス目で反応",
          resisterOrigin: "マス目で反応",
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
    ProviderScope(
      child: Bootstrap(
        appConfig: _appConfig,
        firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      ),
    ),
  );
}

import 'package:common/common.dart';
import 'package:common/freezed/app_data.dart';
import 'package:common/freezed/ui_config.dart';
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
        sub1: "unlimitedModeSub1",
        sub2: "unlimitedModeSub2",
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
        modeIcon: Icons.all_inclusive,
        sub1: "dailyLimitedModeSub1",
        sub2: "dailyLimitedModeSub2",
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

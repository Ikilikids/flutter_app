import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'assistance/quiz_logic.dart';
import 'firebase_options.dart';
import 'page/quiz_screen.dart';
import 'page/setting_widgets.dart';

final _appConfig = AllData(
  appData: AppData(
      appTitle: "appTitle",
      appIcon: Icons.calculate,
      symbols: ["+", "-", "×", "÷"],
      isRotation: false,
      bannerId: "ca-app-pub-1440692612851416/5101110710",
      interId: "ca-app-pub-1440692612851416/6696946185",
      rewardId: "ca-app-pub-1440692612851416/5939549664",
      mainGame: (BuildContext context, DetailConfig quizinfo) => Quizscreen(
          quizDirectives: prepareQuizDirectives(quizinfo.detail.sort),
          quizinfo: quizinfo),
      settingWidgets:
          (BuildContext context, String currentNumber, Function function) => [
                const Divider(height: 1),
                buildSectionHeader(context),
                buildNumberButtonTile(context, currentNumber, function),
              ]),
  mid: [
    MidData(
      modeData: ModeData(
        unit: "unitSecond",
        fix: 2,
        islimited: false,
        isbattle: true,
        isDescending: false,
        ranking: "t",
        modeTitle: "unlimitedModeTitle",
        modeIcon: Icons.all_inclusive,
        sub1: "unlimitedModeSub1",
        sub2: "unlimitedModeSub2",
      ),
      detail: [
        DetailData(
          sort: "32",
          displayLabel: "addSubtract",
          displayRank: "addSubtract",
          resisterRank: "足し算・引き算",
          resisterUser: "足し算・引き算",
          method: "compete20Questions",
          description: "addSubtractDesc",
          color: "2",
          circleColor: "32",
        ),
        DetailData(
          sort: "3251",
          displayLabel: "fourArithmeticOperations",
          displayRank: "fourArithmeticOperations",
          resisterRank: "四則演算",
          resisterUser: "四則演算",
          method: "compete20Questions",
          description: "fourArithmeticOperationsDesc",
          color: "5",
          circleColor: "3251",
        ),
        DetailData(
          sort: "4867",
          displayLabel: "addSubtract2Digits",
          displayRank: "addSubtract2Digits",
          resisterRank: "2桁の足し算・引き算",
          resisterUser: "2桁の足し算・引き算",
          method: "compete10Questions",
          description: "addSubtract2DigitsDesc",
          color: "4",
          circleColor: "46",
        ),
      ],
    ),
    MidData(
      modeData: ModeData(
        unit: "unitSecond",
        fix: 2,
        islimited: true,
        isbattle: true,
        isDescending: false,
        ranking: "g",
        modeTitle: "dailyLimitedModeTitle",
        modeIcon: Icons.timer,
        sub1: "dailyLimitedModeSub1",
        sub2: "dailyLimitedModeSub2",
      ),
      detail: [
        DetailData(
          sort: "32",
          displayLabel: "addSubtract",
          displayRank: "addSubtract",
          resisterRank: "足し算・引き算",
          resisterUser: "足し算・引き算",
          method: "compete20Questions",
          description: "addSubtractDesc",
          color: "3",
          circleColor: "32",
        ),
        DetailData(
          sort: "3251",
          displayLabel: "fourArithmeticOperations",
          displayRank: "fourArithmeticOperations",
          resisterRank: "四則演算",
          resisterUser: "四則演算",
          method: "compete20Questions",
          description: "fourArithmeticOperationsDesc",
          color: "1",
          circleColor: "3251",
        ),
        DetailData(
          sort: "4867",
          displayLabel: "addSubtract2Digits",
          displayRank: "addSubtract2Digits",
          resisterRank: "2桁の足し算・引き算",
          resisterUser: "2桁の足し算・引き算",
          method: "compete10Questions",
          description: "addSubtract2DigitsDesc",
          color: "6",
          circleColor: "46",
        ),
      ],
    ),
  ],
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

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'assistance/quiz_logic.dart';
import 'firebase_options.dart';
import 'page/quiz_screen.dart';
import 'page/setting_widgets.dart';

final _appConfig = AppConfig(
    title: "appTitle",
    icon: Icons.calculate,
    symbols: ["+", "-", "×", "÷"],
    isRotation: false,
    BannerId: "ca-app-pub-1440692612851416/5101110710",
    InterId: "ca-app-pub-1440692612851416/6696946185",
    RewardId: "ca-app-pub-1440692612851416/5939549664",
    data: [
      GameData(
        unit: "unitSecond",
        fix: 2,
        islimited: false,
        isbattle: true,
        ranking: "t",
        title: "unlimitedModeTitle",
        sub1: "unlimitedModeSub1",
        sub2: "unlimitedModeSub2",
        detail: [
          GameDetail(
            sort: "32",
            label: "addSubtract",
            method: "compete20Questions",
            description: "addSubtractDesc",
            color: "2",
            circleColor: "32",
          ),
          GameDetail(
            sort: "3251",
            label: "fourArithmeticOperations",
            method: "compete20Questions",
            description: "fourArithmeticOperationsDesc",
            color: "5",
            circleColor: "3251",
          ),
          GameDetail(
            sort: "4867",
            label: "addSubtract2Digits",
            method: "compete10Questions",
            description: "addSubtract2DigitsDesc",
            color: "4",
            circleColor: "46",
          ),
        ],
      ),
      GameData(
        unit: "unitSecond",
        fix: 2,
        islimited: true,
        isbattle: true,
        ranking: "g",
        title: "dailyLimitedModeTitle",
        sub1: "dailyLimitedModeSub1",
        sub2: "dailyLimitedModeSub2",
        detail: [
          GameDetail(
            sort: "32",
            label: "addSubtract",
            method: "compete20Questions",
            description: "addSubtractDesc",
            color: "3",
            circleColor: "32",
          ),
          GameDetail(
            sort: "3251",
            label: "fourArithmeticOperations",
            method: "compete20Questions",
            description: "fourArithmeticOperationsDesc",
            color: "1",
            circleColor: "3251",
          ),
          GameDetail(
            sort: "4867",
            label: "addSubtract2Digits",
            method: "compete10Questions",
            description: "addSubtract2DigitsDesc",
            color: "6",
            circleColor: "46",
          ),
        ],
      ),
    ],
    mainGame: (BuildContext context, QuizData quizinfo) => Quizscreen(
        quizDirectives: prepareQuizDirectives(quizinfo.sort),
        quizinfo: quizinfo),
    settingWidgets:
        (BuildContext context, String currentNumber, Function function) => [
              const Divider(height: 1),
              buildSectionHeader(context),
              buildNumberButtonTile(context, currentNumber, function),
            ]);
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

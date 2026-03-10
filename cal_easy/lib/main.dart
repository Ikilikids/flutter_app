import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'firebase_options.dart';
import 'setting_widgets.dart';

final _appConfig = AllData(
  appData: AppData(
      appTitle: "appTitle",
      appIcon: Icons.calculate,
      symbols: ["+", "-", "×", "÷"],
      isRotation: false,
      URL: "https://play.google.com/store/apps/details?id=jp.ponta.cal_easy",
      bannerId: "ca-app-pub-1440692612851416/5101110710",
      interId: "ca-app-pub-1440692612851416/6696946185",
      rewardId: "ca-app-pub-1440692612851416/5939549664",
      loadGame:
          (BuildContext context, WidgetRef ref, DetailConfig quizinfo) async {
        // 1. パース済みの全データを取得
        LoadQuiz(quizinfo: quizinfo).init(ref);
      },
      mainGame: (BuildContext context, DetailConfig quizinfo) =>
          const Quizscreen(), // const を追加
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
        isSmallerBetter: true,
        modeType: "t",
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
          resisterSub: "足し算・引き算",
          resisterOrigin: "足し算・引き算",
          method: "compete20Questions",
          description: "addSubtractDesc",
          color: "2",
          circleColor: "32",
        ),
        DetailData(
          sort: "3251",
          displayLabel: "fourArithmeticOperations",
          displayRank: "fourArithmeticOperations",
          resisterSub: "四則演算",
          resisterOrigin: "四則演算",
          method: "compete20Questions",
          description: "fourArithmeticOperationsDesc",
          color: "5",
          circleColor: "3251",
        ),
        DetailData(
          sort: "4867",
          displayLabel: "addSubtract2Digits",
          displayRank: "addSubtract2Digits",
          resisterSub: "2桁の足し算・引き算",
          resisterOrigin: "2桁の足し算・引き算",
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
        isSmallerBetter: true,
        modeType: "g",
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
          resisterSub: "足し算・引き算",
          resisterOrigin: "足し算・引き算",
          method: "compete20Questions",
          description: "addSubtractDesc",
          color: "3",
          circleColor: "32",
        ),
        DetailData(
          sort: "3251",
          displayLabel: "fourArithmeticOperations",
          displayRank: "fourArithmeticOperations",
          resisterSub: "四則演算",
          resisterOrigin: "四則演算",
          method: "compete20Questions",
          description: "fourArithmeticOperationsDesc",
          color: "1",
          circleColor: "3251",
        ),
        DetailData(
          sort: "4867",
          displayLabel: "addSubtract2Digits",
          displayRank: "addSubtract2Digits",
          resisterSub: "2桁の足し算・引き算",
          resisterOrigin: "2桁の足し算・引き算",
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
    ProviderScope(
      child: Bootstrap(
        appConfig: _appConfig,
        firebaseOptions: options,
      ),
    ),
  );
}

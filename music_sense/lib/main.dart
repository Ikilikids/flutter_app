import 'package:common/common.dart';
import 'package:common/freezed/app_data.dart';
import 'package:common/freezed/ui_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'assistance/quiz_logic.dart';
import 'firebase_options.dart';
import 'page/quiz_screen.dart';
import 'page/setting_widgets.dart';

final _appConfig = AllData(
  appData: AppData(
      appTitle: "英単語クイズ",
      appIcon: Icons.abc,
      symbols: ["A", "B", "C", "D"],
      isRotation: false,
      URL: "https://play.google.com/store/apps/details?id=jp.ponta.eng_quiz",
      mainGame: (BuildContext context, DetailConfig quizinfo) => Quizscreen(
          quizDirectives: prepareQuizDirectives(quizinfo.detail.sort),
          quizinfo: quizinfo),
      settingWidgets:
          (BuildContext context, String currentNumber, Function function) => [
                const Divider(height: 1),
                buildSectionHeader(context),
              ]),
  mid: [
    MidData(
      modeData: ModeData(
        unit: "問",
        fix: 0,
        islimited: false,
        isbattle: false,
        modeType: "t",
        modeIcon: Icons.school,
        modeTitle: "学習モード",
        sub1: "分野別に学習しよう！",
        sub2: "数Ⅰ～数Cまで対応！",
        isSmallerBetter: false,
      ),
      detail: [
        DetailData(
          sort: "32",
          displayLabel: "英単語",
          displayRank: "英単語",
          resisterSub: "英単語",
          resisterOrigin: "英単語",
          method: "20問に挑戦",
          description: "英単語をスペルで答えよう",
          color: "2",
          circleColor: "32",
        ),
      ],
    ),
    MidData(
      modeData: ModeData(
        unit: "点",
        fix: 0,
        islimited: false,
        isbattle: true,
        modeIcon: Icons.local_fire_department,
        modeType: "g",
        modeTitle: "実践モード",
        sub1: "時間制限あり(教科別)です",
        sub2: "ハイスコアを目指そう!!",
        isSmallerBetter: false,
      ),
      detail: [
        DetailData(
          sort: "32",
          displayLabel: "英単語",
          displayRank: "英単語",
          resisterSub: "英単語",
          resisterOrigin: "英単語",
          method: "20問に挑戦",
          description: "英単語をスペルで答えよう",
          color: "3",
          circleColor: "32",
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

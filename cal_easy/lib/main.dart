import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:quiz/quiz.dart';

import 'firebase_options.dart';
import 'setting_widgets.dart';

// クイズの不変データをカタログ化
const _quizMaster = {
  "足し算・引き算": (
    sort: "32",
    label: "addSubtract",
    circle: "32",
    icon: Icons.exposure,
    q: 20
  ),
  "四則演算": (
    sort: "3251",
    label: "fourArithmeticOperations",
    circle: "3251",
    icon: Icons.calculate,
    q: 20
  ),
  "2桁の足し算・引き算": (
    sort: "4867",
    label: "addSubtract2Digits",
    circle: "46",
    icon: Icons.filter_9_plus,
    q: 10
  ),
};

DetailData _q(String origin, String mode, String color) {
  final d = _quizMaster[origin]!;
  return DetailData(
    quizId: QuizId(resisterOrigin: origin, modeType: mode),
    sort: d.sort,
    displayLabel: d.label,
    method: "compete${d.q}Questions",
    description: "${d.label}Desc",
    color: color,
    circleColor: d.circle,
    detailIcon: d.icon,
  );
}

MidData _m(
    {required String type,
    required String title,
    required IconData icon,
    required String desc,
    required bool limited,
    required Map<String, String> colors}) {
  return MidData(
    modeData: ModeData(
        unit: "unitSecond",
        fix: 2,
        islimited: limited,
        isbattle: true,
        isSmallerBetter: true,
        modeType: type,
        modeIcon: icon,
        modeTitle: title,
        modeDescription: desc,
        rankingList: colors.entries
            .map((e) => QuizTabInfo(
                id: e.key,
                display: _quizMaster[e.key]!.label,
                color: e.value,
                icon: _quizMaster[e.key]!.icon))
            .toList()),
    detail: colors.entries.map((e) => _q(e.key, type, e.value)).toList(),
  );
}

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
      loadGame: (context, ref, quizinfo) async =>
          LoadQuiz(quizinfo: quizinfo).init(ref),
      mainGame: (context, quizinfo) => const Quizscreen(),
      settingWidgets: (context, currentNumber, function) => [
            const Divider(height: 1),
            buildSectionHeader(context),
            buildNumberButtonTile(context, currentNumber, function)
          ]),
  mid: [
    _m(
        type: "t",
        title: "unlimitedModeTitle",
        icon: Icons.all_inclusive,
        limited: false,
        desc: "・1日に何回でも挑戦できます！\n・ハイスコアを目指そう！",
        colors: {"足し算・引き算": "2", "四則演算": "5", "2桁の足し算・引き算": "4"}),
    _m(
        type: "g",
        title: "dailyLimitedModeTitle",
        icon: Icons.timer,
        limited: true,
        desc: "・1日1回限定！\n・集中して挑もう！",
        colors: {"足し算・引き算": "3", "四則演算": "1", "2桁の足し算・引き算": "6"}),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Bootstrap(
      appConfig: _appConfig,
      firebaseOptions: DefaultFirebaseOptions.currentPlatform));
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:math_quiz/assistance/quiz_download.dart';
import 'package:math_quiz/math_quiz.dart';
import 'package:provider/provider.dart';

import 'assistance/formula.dart';

final List<GameDetail> gameDetails = subjects.map((s) {
  return GameDetail(
    sort: s[0],
    label: s[2],
    method: s[1],
    description: s[3],
    color: s[0],
    circleColor: s[0],
  );
}).toList();

final _appConfig = AppConfig(
  title: "とことん高校数学",
  icon: Icons.calculate,
  symbols: ["π", "√", "α", "β", "∫", "Σ", "∽", "!"],
  isRotation: false,
  BannerId: "ca-app-pub-1440692612851416/6568630311",
  InterId: "ca-app-pub-1440692612851416/7404533363",
  data: [
    GameData(
      unit: "問",
      fix: 0,
      islimited: false,
      isbattle: false,
      ranking: "t",
      icon: Icons.school,
      title: "学習モード",
      sub1: "分野別に学習しよう！",
      sub2: "数Ⅰ～数Cまで対応！",
      isDescending: true,
      detail: gameDetails,
    ),
    GameData(
      unit: "点",
      fix: 0,
      islimited: false,
      isbattle: true,
      icon: Icons.local_fire_department,
      ranking: "g",
      title: "実践モード",
      sub1: "時間制限あり(教科別)です",
      sub2: "ハイスコアを目指そう!!",
      isDescending: true,
      detail: [
        GameDetail(
          sort: "1A",
          label: "数Ⅰ・数A",
          method: "数I・数Aの全範囲",
          description: "高1向け!",
          color: "A",
          circleColor: "1A",
        ),
        GameDetail(
          sort: "2B",
          label: "数Ⅱ・数B",
          method: "数Ⅱ・数Bの全範囲",
          description: "高2向け!",
          color: "B",
          circleColor: "2B",
        ),
        GameDetail(
          sort: "3C",
          label: "数Ⅲ・数C",
          method: "数Ⅲ・数Cの全範囲",
          description: "理系受験生向け!!",
          color: "C",
          circleColor: "3C",
        ),
      ],
    ),
  ],
  loadGame: (BuildContext context, QuizData quizinfo) {
    final choseProvider = Provider.of<ChoseProvider>(context, listen: false);
    List<Map<String, String>> filteredMap = choseProvider.quizData
        .where((item) => quizinfo.isbattle
            ? quizinfo.sort.contains(item["123abc"]!)
            : item["sub"] == quizinfo.label)
        .toList();

    quizinfo.chosedData = filteredMap;
  },
  mainGame: (BuildContext context, QuizData quizinfo) =>
      Quizscreen(quizinfo: quizinfo),
  endBuilder: (context, totalScore, originalData, quizinfo) => NtEndScreen(
      correctCount: totalScore.round(), P: originalData, quizinfo: quizinfo),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final options = DefaultFirebaseOptions.currentPlatform;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ChoseProvider()..initAll(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => QuizProvider()..initAll(),
        ),
      ],
      child: Bootstrap(
        appConfig: _appConfig,
        firebaseOptions: options,
      ),
    ),
  );
}

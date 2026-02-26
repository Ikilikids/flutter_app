import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:math_quiz/assistance/quiz_download.dart';
import 'package:math_quiz/math_quiz.dart';
import 'package:math_quiz/providers/filtered_quiz_provider.dart';
import 'package:provider/provider.dart';

import 'assistance/formula.dart';

final List<DetailData> gameDetails = subjects.map((s) {
  return DetailData(
    sort: s[0],
    displayLabel: s[2],
    displayRank: generateRankLabel(s[0]),
    resisterRank: generateRankLabel(s[0]),
    resisterUser: s[2],
    method: s[1],
    description: s[3],
    color: s[0],
    circleColor: s[0],
  );
}).toList();

String generateRankLabel(String sort) {
  if (sort == "1" || sort == "A") return "数Ⅰ・数A";
  if (sort == "2" || sort == "B") return "数Ⅱ・数B";
  if (sort == "3" || sort == "C") return "数Ⅲ・数C";
  return sort;
}

final _appConfig = AllData(
  appData: AppData(
    appTitle: "とことん高校数学",
    appIcon: Icons.calculate,
    symbols: ["π", "√", "α", "β", "∫", "Σ", "→", "γ"],
    isRotation: false,
    bannerId: "ca-app-pub-1440692612851416/6568630311",
    interId: "ca-app-pub-1440692612851416/7404533363",
    loadGame: (BuildContext context, DetailConfig quizinfo) {
      final quizProvider = context.watch<QuizProvider>();
      final scoreIndexMap = quizProvider.scoreIndexMap;

      // score が上のフラット Map
      final filtered = <int, List<PartData>>{};

      scoreIndexMap.forEach((score, partList) {
        final newList = partList.where((part) {
          if (!quizinfo.modeData.isbattle) {
            // 非battle: field で絞る
            return part.field == quizinfo.detail.displayLabel;
          } else {
            // battle: subject sort リストで絞る
            return quizinfo.detail.sort.contains(part.subject);
          }
        }).toList();

        if (newList.isNotEmpty) {
          filtered[score] = newList;
        }
      });

      // フィルタ済みリストを Provider にセット
      Provider.of<FilteredQuizProvider>(context, listen: false)
          .setFilteredListByScore(filtered);
    },
    mainGame: (BuildContext context, DetailConfig quizinfo) {
      final filteredList =
          Provider.of<FilteredQuizProvider>(context, listen: false)
              .filteredListByScore;
      return Quizscreen(
        quizinfo: quizinfo,
        filteredMap: filteredList,
      );
    },
    endBuilder: (context, totalScore, originalData, quizinfo) => NtEndScreen(
      correctCount: totalScore.round(),
      P: originalData[0],
      marks: originalData[1],
      quizinfo: quizinfo,
    ),
  ),
  mid: [
    MidData(
      modeData: ModeData(
        unit: "問",
        fix: 0,
        islimited: false,
        isbattle: false,
        ranking: "t",
        modeIcon: Icons.school,
        modeTitle: "学習モード",
        sub1: "分野別に学習しよう！",
        sub2: "数Ⅰ～数Cまで対応！",
        isDescending: true,
      ),
      detail: gameDetails,
    ),
    MidData(
      modeData: ModeData(
        unit: "点",
        fix: 0,
        islimited: false,
        isbattle: true,
        modeIcon: Icons.local_fire_department,
        ranking: "g",
        modeTitle: "実践モード",
        sub1: "時間制限あり(教科別)です",
        sub2: "ハイスコアを目指そう!!",
        isDescending: true,
      ),
      detail: [
        DetailData(
          sort: "1A",
          displayLabel: "数Ⅰ・数A",
          displayRank: "数Ⅰ・数A",
          resisterRank: "数Ⅰ・数A",
          resisterUser: "数Ⅰ・数A",
          method: "数I・数Aの全範囲(因数分解, 三角比, 確率など)",
          description: "高1向け! 60秒での点数で競おう!!",
          color: "A",
          circleColor: "1A",
        ),
        DetailData(
          sort: "2B",
          displayLabel: "数Ⅱ・数B",
          displayRank: "数Ⅱ・数B",
          resisterRank: "数Ⅱ・数B",
          resisterUser: "数Ⅱ・数B",
          method: "数Ⅱ・数Bの全範囲(対数, 積分, 統計など)",
          description: "高2向け! 60秒での点数で競おう!!",
          color: "B",
          circleColor: "2B",
        ),
        DetailData(
          sort: "3C",
          displayLabel: "数Ⅲ・数C",
          displayRank: "数Ⅲ・数C",
          resisterRank: "数Ⅲ・数C",
          resisterUser: "数Ⅲ・数C",
          method: "数Ⅲ・数Cの全範囲(極限, 二次曲線, ベクトルなど)",
          description: "理系向け! 60秒での点数で競おう!!",
          color: "C",
          circleColor: "3C",
        ),
      ],
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final options = DefaultFirebaseOptions.currentPlatform;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => QuizProvider()..initAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => FilteredQuizProvider(),
        ),
      ],
      child: Bootstrap(appConfig: _appConfig, firebaseOptions: options),
    ),
  );
}

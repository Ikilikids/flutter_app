import 'package:common/common.dart';
import 'package:common/freezed/app_data.dart';
import 'package:common/freezed/ui_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_quiz/math_quiz.dart';

import 'assistance/formula.dart';
import 'providers/quiz_data_provider.dart';

final List<DetailData> gameDetails = subjects.map((s) {
  return DetailData(
    sort: s[0],
    displayLabel: s[2],
    displayRank: generateRankLabel(s[0]),
    resisterSub: generateRankLabel(s[0]),
    resisterOrigin: s[2],
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
    URL: "https://play.google.com/store/apps/details?id=jp.ponta.mathquiz",
    bannerId: "ca-app-pub-1440692612851416/6568630311",
    interId: "ca-app-pub-1440692612851416/7404533363",
    loadGame:
        (BuildContext context, WidgetRef ref, DetailConfig quizinfo) async {
      // 1. パース済みの全データを取得
      final allDataValue = await ref.read(quizDataProvider.future);
      // 2. フィルタリングロジックを実行
      final filtered = <int, List<PartData>>{};
      allDataValue.forEach((score, partList) {
        final newList = partList.where((part) {
          if (!quizinfo.modeData.isbattle) {
            return part.field == quizinfo.detail.displayLabel;
          } else {
            return quizinfo.detail.sort.contains(part.subject);
          }
        }).toList();

        if (newList.isNotEmpty) filtered[score] = newList;
      });
      // 3. Riverpod の状態を更新
      ref.read(activeGameMapProvider.notifier).update(filtered);
    },
    mainGame: (BuildContext context, DetailConfig quizinfo) {
      return const Quizscreen(); // const を追加
    },
    endBuilder: (context, totalScore, originalData, quizinfo) {
      // 念のため、中身をキャストして渡す
      final List<MakingData> pData = List<MakingData>.from(originalData[0]);
      final List<String> markData = List<String>.from(originalData[1]);

      return NtEndScreen(
        correctCount: totalScore.round(),
        P: pData,
        marks: markData,
      );
    },
  ),
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
      detail: gameDetails,
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
          sort: "1A",
          displayLabel: "数Ⅰ・数A",
          displayRank: "数Ⅰ・数A",
          resisterSub: "数Ⅰ・数A",
          resisterOrigin: "数Ⅰ・数A",
          method: "数I・数Aの全範囲(因数分解, 三角比, 確率など)",
          description: "高1向け! 60秒での点数で競おう!!",
          color: "A",
          circleColor: "1A",
        ),
        DetailData(
          sort: "2B",
          displayLabel: "数Ⅱ・数B",
          displayRank: "数Ⅱ・数B",
          resisterSub: "数Ⅱ・数B",
          resisterOrigin: "数Ⅱ・数B",
          method: "数Ⅱ・数Bの全範囲(対数, 積分, 統計など)",
          description: "高2向け! 60秒での点数で競おう!!",
          color: "B",
          circleColor: "2B",
        ),
        DetailData(
          sort: "3C",
          displayLabel: "数Ⅲ・数C",
          displayRank: "数Ⅲ・数C",
          resisterSub: "数Ⅲ・数C",
          resisterOrigin: "数Ⅲ・数C",
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
    ProviderScope(
      child: Bootstrap(appConfig: _appConfig, firebaseOptions: options),
    ),
  );
}

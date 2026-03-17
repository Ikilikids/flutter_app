import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'firebase_options.dart';

final _appConfig = AllData(
  appData: AppData(
    appTitle: "とことん高校英単語",
    appIcon: Icons.translate,
    symbols: ["A", "B", "C", "D", "E", "F", "G", "H"],
    isRotation: false,
    URL: "https://play.google.com/store/apps/details?id=jp.ponta.music_sense",
    loadGame:
        (BuildContext context, WidgetRef ref, DetailConfig quizinfo) async {
      // 1. パース済みの全データを取得
      LoadQuiz(quizinfo: quizinfo).init(ref);
    },
    mainGame: (BuildContext context, DetailConfig quizinfo) =>
        const Quizscreen(),
    endBuilder: (context, totalScore, originalData, quizinfo) {
      final List<MakingData> pData = List<MakingData>.from(originalData[0]);
      final List<String> markData = List<String>.from(originalData[1]);

      return NtEndScreen(
        correctCount: totalScore.round(),
        P: pData,
        marks: markData,
      );
    },
    additionalPage1: AdditionalPageConfig(
        builder: (BuildContext context) => const WordListPage(),
        title: "単語リスト",
        icon: Icons.style),
    additionalPage2: AdditionalPageConfig(
        builder: (BuildContext context) => const WordListPage(),
        title: "単語リスト",
        icon: Icons.style),
  ),
  mid: [
    MidData(
      modeData: ModeData(
        unit: "問",
        fix: 0,
        islimited: false,
        isbattle: false,
        modeType: "t",
        modeIcon: Icons.menu_book,
        modeTitle: "トレーニング",
        sub1: "じっくりスペルを覚えよう！",
        sub2: "基礎から応用まで対応",
        isSmallerBetter: false,
      ),
      detail: [
        DetailData(
          sort: "12345;456",
          displayLabel: "全単語",
          displayRank: "全単語",
          resisterSub: "全単語",
          resisterOrigin: "全単語",
          method: "★4~★6レベルの全種類、1200単語",
          description: "品詞、難易度問わずランダムに出題",
          color: "6",
          circleColor: "12345",
        ),
        DetailData(
          sort: "3;4",
          displayLabel: "動詞(★4)",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞(★4)",
          method: "★4レベルの動詞、108単語",
          description: "まずはここから！最重要！",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "3;5",
          displayLabel: "動詞(★5)",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞(★5)",
          method: "★5レベルの動詞、98単語",
          description: "動詞は最重要品詞、マスターしよう！",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "3;6",
          displayLabel: "動詞(★6)",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞(★6)",
          method: "★6レベルの動詞、97単語",
          description: "高校上級レベルの動詞、頑張ろう！",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "15;4",
          displayLabel: "形容詞・副詞(★4)",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞(★4)",
          method: "★4レベルの形容詞・副詞、107単語",
          description: "動詞の次に重要！",
          color: "1",
          circleColor: "15",
        ),
        DetailData(
          sort: "15;5",
          displayLabel: "形容詞・副詞(★5)",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞(★5)",
          method: "★5レベルの形容詞・副詞、84単語",
          description: "形容詞と副詞の違いを意識すると良い！",
          color: "1",
          circleColor: "15",
        ),
        DetailData(
          sort: "15;6",
          displayLabel: "形容詞・副詞(★6)",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞(★6)",
          method: "★6レベルの形容詞・副詞、87単語",
          description: "高校上級レベルの修飾語、頑張ろう！",
          color: "1",
          circleColor: "15",
        ),
        DetailData(
          sort: "24;4",
          displayLabel: "名詞・その他(★4)",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他(★4)",
          method: "★4レベルの名詞など、184単語",
          description: "名詞や代名詞、接続詞、前置詞など",
          color: "2",
          circleColor: "24",
        ),
        DetailData(
          sort: "24;5",
          displayLabel: "名詞・その他(★5)",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他(★5)",
          method: "★5レベルの名詞など、218単語",
          description: "覚えていると長文が読みやすくなる！",
          color: "2",
          circleColor: "24",
        ),
        DetailData(
          sort: "24;6",
          displayLabel: "名詞・その他(★6)",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他(★6)",
          method: "★6レベルの名詞など、216単語",
          description: "高校上級レベルの名詞など、頑張ろう！",
          color: "2",
          circleColor: "24",
        ),
        DetailData(
          sort: "12345;123",
          displayLabel: "中学レベル",
          displayRank: "中学レベル",
          resisterSub: "中学レベル",
          resisterOrigin: "中学レベル",
          method: "★1~★3レベルの全種類、1200単語",
          description: "まずはここから！復習しよう！",
          color: "6",
          circleColor: "6",
        ),
        DetailData(
          sort: "12345;7",
          displayLabel: "ハイレベル(★7)",
          displayRank: "ハイレベル",
          resisterSub: "ハイレベル",
          resisterOrigin: "ハイレベル(★7)",
          method: "★7レベルの全種類、400単語(高校難関レベル)",
          description: "高校難関レベルの単語も収録！さらに上を目指す人に！",
          color: "6",
          circleColor: "6",
        ),
      ],
    ),
    MidData(
      modeData: ModeData(
        unit: "点",
        fix: 0,
        islimited: false,
        isbattle: true,
        modeIcon: Icons.timer,
        modeType: "g",
        modeTitle: "タイムアタック",
        sub1: "60秒で何単語解けるか挑戦！",
        sub2: "ハイスコアを目指そう!!",
        isSmallerBetter: false,
      ),
      detail: [
        DetailData(
          sort: "12345;123456",
          displayLabel: "全単語",
          displayRank: "全単語",
          resisterSub: "全単語",
          resisterOrigin: "全単語",
          method: "★1~★6レベルの全種類、1200単語",
          description: "60秒での点数で競おう!!",
          color: "6",
          circleColor: "6",
        ),
        DetailData(
          sort: "3;123456",
          displayLabel: "動詞",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞",
          method: "★1~★6レベルの動詞、303単語",
          description: "60秒での点数で競おう!!",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "15;123456",
          displayLabel: "形容詞・副詞",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞",
          method: "★1~★6レベルの形容詞・副詞、278単語",
          description: "60秒での点数で競おう!!",
          color: "5",
          circleColor: "15",
        ),
        DetailData(
          sort: "24;123456",
          displayLabel: "名詞・その他",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他",
          method: "★1~★6レベルの名詞など、618単語",
          description: "60秒での点数で競おう!!",
          color: "4",
          circleColor: "24",
        ),
      ],
    ),
    MidData(
      modeData: ModeData(
        unit: "問",
        fix: 0,
        islimited: false,
        isbattle: false,
        modeIcon: Icons.find_replace,
        modeType: "z",
        modeTitle: "復習モード",
        sub1: "自由に条件を選んで復習しよう！",
        sub2: "苦手克服への近道！",
        isSmallerBetter: false,
      ),
      detail: [],
    )
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

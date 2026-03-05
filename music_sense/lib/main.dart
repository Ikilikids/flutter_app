import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'firebase_options.dart';

final _appConfig = AllData(
  appData: AppData(
    appTitle: "とことん中学英単語",
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
          sort: "12345;123",
          displayLabel: "全単語",
          displayRank: "全単語",
          resisterSub: "全単語",
          resisterOrigin: "全単語",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "6",
          circleColor: "6",
        ),
        DetailData(
          sort: "3;1",
          displayLabel: "動詞(★1)",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞(★1)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "3;2",
          displayLabel: "動詞(★2)",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞(★2)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "3;3",
          displayLabel: "動詞(★3)",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞(★3)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "15;1",
          displayLabel: "形容詞・副詞(★1)",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞(★1)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "1",
          circleColor: "15",
        ),
        DetailData(
          sort: "15;2",
          displayLabel: "形容詞・副詞(★2)",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞(★2)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "1",
          circleColor: "15",
        ),
        DetailData(
          sort: "15;3",
          displayLabel: "形容詞・副詞(★3)",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞(★3)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "1",
          circleColor: "15",
        ),
        DetailData(
          sort: "24;1",
          displayLabel: "名詞・その他(★1)",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他(★1)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "2",
          circleColor: "24",
        ),
        DetailData(
          sort: "24;2",
          displayLabel: "名詞・その他(★2)",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他(★2)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "2",
          circleColor: "24",
        ),
        DetailData(
          sort: "24;3",
          displayLabel: "名詞・その他(★3)",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他(★3)",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "2",
          circleColor: "24",
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
        sub1: "60秒で何単語書けるか挑戦！",
        sub2: "ハイスコアを目指そう!!",
        isSmallerBetter: false,
      ),
      detail: [
        DetailData(
          sort: "12345;123",
          displayLabel: "全単語",
          displayRank: "全単語",
          resisterSub: "全単語",
          resisterOrigin: "全単語",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "6",
          circleColor: "6",
        ),
        DetailData(
          sort: "3;123",
          displayLabel: "動詞",
          displayRank: "動詞",
          resisterSub: "動詞",
          resisterOrigin: "動詞",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "3",
          circleColor: "3",
        ),
        DetailData(
          sort: "15;123",
          displayLabel: "形容詞・副詞",
          displayRank: "形容詞・副詞",
          resisterSub: "形容詞・副詞",
          resisterOrigin: "形容詞・副詞",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "5",
          circleColor: "15",
        ),
        DetailData(
          sort: "24;123",
          displayLabel: "名詞・その他",
          displayRank: "名詞・その他",
          resisterSub: "名詞・その他",
          resisterOrigin: "名詞・その他",
          method: "日常会話でよく使われる基礎的な英単語",
          description: "まずはここから！基本単語をマスターしよう",
          color: "4",
          circleColor: "24",
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

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:quiz/quiz.dart';

import 'firebase_options.dart';

final _appConfig = AllData(
  appData: AppData(
    appTitle: "とことん高校英単語",
    appIcon: Icons.translate,
    symbols: ["A", "B", "C", "D", "E", "F", "G", "H"],
    isRotation: false,
    URL: "https://play.google.com/store/apps/details?id=jp.ponta.high_eng",
    additionalPage1: PageConfig(
      builder: (BuildContext context) => const ReviewSetupPage(),
      title: "復習モード",
      icon: Icons.find_replace,
      color: Colors.green,
      modeDescription: "・条件で問題を絞り込めるモードです。\n"
          "・トレーニングモードと同じく5問または10問を選ぶことができます\n"
          "・ヒントは最後の2文字以外利用できます。",
    ),
    additionalPage2: PageConfig(
      builder: (BuildContext context) => const WordListPage(),
      title: "単語リスト",
      icon: Icons.style,
      color: Colors.deepOrange,
      modeDescription:
          "・上から、単語検索、並び替え,昇順/降順,タグ登録(☆♪)、品詞絞り込み、レベル絞り込みとなっています。\n\n"
          "・それぞれの単語の色は品詞を示しています。(赤：動詞, 青：名詞, 黄：形容詞, 緑：副詞, 紫：その他)\n\n"
          "・単語の下に直近5回の結果とすべての期間の結果を載せています。\n\n"
          "・△はヒントありで正解を示しています。正答率は△を50%として集計しています。",
    ),
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
        modeDescription: "・5問モードと10問モードを選べます。\n"
            "・左下は今までの総正解数です。\n"
            "・ランキングは品詞別に集計されます。\n"
            "・ヒントは最後の2文字以外利用できます。",
        isSmallerBetter: false,
        rankingList: [
          QuizTabInfo(
              id: "全合計", display: "全合計", color: "9", icon: Icons.functions),
          QuizTabInfo(
              id: "動詞", display: "動詞", color: "3", icon: Icons.directions_run),
          QuizTabInfo(
              id: "形容詞・副詞",
              display: "形容詞・副詞",
              color: "1",
              icon: Icons.auto_awesome),
          QuizTabInfo(
              id: "名詞・その他",
              display: "名詞・その他",
              color: "2",
              icon: Icons.extension),
        ],
      ),
      detail: [
        DetailData(
            quizId: const QuizId(resisterOrigin: "全単語", modeType: "t"),
            sort: "12345;1234567",
            displayLabel: "全単語",
            method: "★1~★7レベルの全種類、2708単語",
            description: "品詞、難易度問わずランダムに出題",
            color: "6",
            circleColor: "12345",
            detailIcon: Icons.language),
        DetailData(
            quizId: const QuizId(resisterOrigin: "動詞(★4)", modeType: "t"),
            sort: "3;4",
            displayLabel: "動詞(★4)",
            method: "★4レベルの動詞、108単語",
            description: "まずはここから！最重要！",
            color: "3",
            circleColor: "3",
            detailIcon: Icons.directions_run),
        DetailData(
            quizId: const QuizId(resisterOrigin: "動詞(★5)", modeType: "t"),
            sort: "3;5",
            displayLabel: "動詞(★5)",
            method: "★5レベルの動詞、98単語",
            description: "動詞は最重要品詞、マスターしよう！",
            color: "3",
            circleColor: "3",
            detailIcon: Icons.directions_run),
        DetailData(
            quizId: const QuizId(resisterOrigin: "動詞(★6)", modeType: "t"),
            sort: "3;6",
            displayLabel: "動詞(★6)",
            method: "★6レベルの動詞、97単語",
            description: "高校上級レベルの動詞、頑張ろう！",
            color: "3",
            circleColor: "3",
            detailIcon: Icons.directions_run),
        DetailData(
            quizId: const QuizId(resisterOrigin: "動詞(★7)", modeType: "t"),
            sort: "3;7",
            displayLabel: "動詞(★7)",
            method: "★7レベルの動詞、97単語",
            description: "高校難関レベルの動詞、頑張ろう！",
            color: "3",
            circleColor: "3",
            detailIcon: Icons.directions_run),
        DetailData(
            quizId: const QuizId(resisterOrigin: "形容詞・副詞(★4)", modeType: "t"),
            sort: "15;4",
            displayLabel: "形容詞・副詞(★4)",
            method: "★4レベルの形容詞・副詞、107単語",
            description: "動詞の次に重要！",
            color: "1",
            circleColor: "15",
            detailIcon: Icons.auto_awesome),
        DetailData(
            quizId: const QuizId(resisterOrigin: "形容詞・副詞(★5)", modeType: "t"),
            sort: "15;5",
            displayLabel: "形容詞・副詞(★5)",
            method: "★5レベルの形容詞・副詞、84単語",
            description: "形容詞と副詞の違いを意識すると良い！",
            color: "1",
            circleColor: "15",
            detailIcon: Icons.auto_awesome),
        DetailData(
            quizId: const QuizId(resisterOrigin: "形容詞・副詞(★6)", modeType: "t"),
            sort: "15;6",
            displayLabel: "形容詞・副詞(★6)",
            method: "★6レベルの形容詞・副詞、87単語",
            description: "高校上級レベルの修飾語、頑張ろう！",
            color: "1",
            circleColor: "15",
            detailIcon: Icons.auto_awesome),
        DetailData(
            quizId: const QuizId(resisterOrigin: "形容詞・副詞(★7)", modeType: "t"),
            sort: "15;7",
            displayLabel: "形容詞・副詞(★7)",
            method: "★7レベルの形容詞・副詞、87単語",
            description: "高校難関レベルの修飾語、頑張ろう！",
            color: "1",
            circleColor: "15",
            detailIcon: Icons.auto_awesome),
        DetailData(
            quizId: const QuizId(resisterOrigin: "名詞・その他(★4)", modeType: "t"),
            sort: "24;4",
            displayLabel: "名詞・その他(★4)",
            method: "★4レベルの名詞など、184単語",
            description: "名詞や代名詞、接続詞、前置詞など",
            color: "2",
            circleColor: "24",
            detailIcon: Icons.extension),
        DetailData(
            quizId: const QuizId(resisterOrigin: "名詞・その他(★5)", modeType: "t"),
            sort: "24;5",
            displayLabel: "名詞・その他(★5)",
            method: "★5レベルの名詞など、218単語",
            description: "覚えていると長文が読みやすくなる！",
            color: "2",
            circleColor: "24",
            detailIcon: Icons.extension),
        DetailData(
            quizId: const QuizId(resisterOrigin: "名詞・その他(★6)", modeType: "t"),
            sort: "24;6",
            displayLabel: "名詞・その他(★6)",
            method: "★6レベルの名詞など、216単語",
            description: "高校上級レベルの名詞など、頑張ろう！",
            color: "2",
            circleColor: "24",
            detailIcon: Icons.extension),
        DetailData(
            quizId: const QuizId(resisterOrigin: "名詞・その他(★7)", modeType: "t"),
            sort: "24;7",
            displayLabel: "名詞・その他(★7)",
            method: "★7レベルの名詞など、216単語",
            description: "高校上級レベルの名詞など、頑張ろう！",
            color: "2",
            circleColor: "24",
            detailIcon: Icons.extension),
        DetailData(
            quizId: const QuizId(resisterOrigin: "初級レベル", modeType: "t"),
            sort: "12345;123",
            displayLabel: "初級レベル",
            method: "初級レベルの全種類、1200単語",
            description: "じっくりやりたい人は、「とことん中学英単語」へ!!",
            color: "6",
            circleColor: "12345",
            detailIcon: Icons.trending_up),
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
        modeDescription: "・60秒での点数で競いあうモードです、左下は最高点です。\n"
            "・1文字目は1点、2文字目は2点...\n"
            "・単語を答えきることができればボーナスポイント！(★レベル×2点分)\n"
            "・1文字目のみヒントが利用できます、ヒントを使うとボーナス点がなくなります。\n"
            "・パスや不正解は-10点です。",
        isSmallerBetter: false,
        rankingList: [
          QuizTabInfo(
              id: "全単語", display: "全単語", color: "6", icon: Icons.language),
          QuizTabInfo(
              id: "動詞", display: "動詞", color: "3", icon: Icons.directions_run),
          QuizTabInfo(
              id: "形容詞・副詞",
              display: "形容詞・副詞",
              color: "5",
              icon: Icons.auto_awesome),
          QuizTabInfo(
              id: "名詞・その他",
              display: "名詞・その他",
              color: "4",
              icon: Icons.extension),
        ],
      ),
      detail: [
        DetailData(
            quizId: const QuizId(resisterOrigin: "全単語", modeType: "g"),
            sort: "12345;1234567",
            displayLabel: "全単語",
            method: "★1~★7レベルの全種類、1200単語",
            description: "60秒での点数で競おう!!",
            color: "6",
            circleColor: "12345",
            detailIcon: Icons.language),
        DetailData(
            quizId: const QuizId(resisterOrigin: "動詞", modeType: "g"),
            sort: "3;1234567",
            displayLabel: "動詞",
            method: "★1~★7レベルの動詞、303単語",
            description: "60秒での点数で競おう!!",
            color: "3",
            circleColor: "3",
            detailIcon: Icons.directions_run),
        DetailData(
            quizId: const QuizId(resisterOrigin: "形容詞・副詞", modeType: "g"),
            sort: "15;1234567",
            displayLabel: "形容詞・副詞",
            method: "★1~★7レベルの形容詞・副詞、278単語",
            description: "60秒での点数で競おう!!",
            color: "5",
            circleColor: "15",
            detailIcon: Icons.auto_awesome),
        DetailData(
            quizId: const QuizId(resisterOrigin: "名詞・その他", modeType: "g"),
            sort: "24;1234567",
            displayLabel: "名詞・その他",
            method: "★1~★7レベルの名詞など、618単語",
            description: "60秒での点数で競おう!!",
            color: "4",
            circleColor: "24",
            detailIcon: Icons.extension),
      ],
    ),
    MidData(
      modeData: ModeData(
        unit: "問",
        fix: 0,
        islimited: false,
        isbattle: false,
        modeIcon: Icons.history,
        modeType: "z",
        modeTitle: "復習モード",
        modeDescription: "・条件で問題を絞り込めるモードです。\n"
            "・トレーニングモードと同じく5問または10問を選ぶことができます\n"
            "・ヒントは最後の2文字以外利用できます。",
        isSmallerBetter: false,
      ),
      detail: [
        DetailData(
          quizId: const QuizId(resisterOrigin: "復習モード", modeType: "z"),
          sort: "",
          displayLabel: "復習モード",
          method: "",
          description: "",
          color: "6",
          circleColor: "",
        ),
      ],
    )
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final options = DefaultFirebaseOptions.currentPlatform;

  runApp(
    Bootstrap(appConfig: _appConfig, firebaseOptions: options),
  );
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

final List<DetailData> gameDetails = subjects.map((s) {
  return DetailData(
      quizId: QuizId(resisterOrigin: s[2], modeType: "t"),
      sort: s[0],
      displayLabel: s[2],
      method: s[1],
      description: s[3],
      color: s[0],
      circleColor: s[0],
      detailIcon: getIconForCategory(s[1]));
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
        modeDescription: "・分野別に学習しよう！\n"
            "・5問モードと10問モードが選択可能",
        isSmallerBetter: false,
        rankingList: [
          QuizTabInfo(
              id: "全合計", display: "全合計", color: "9", icon: Icons.functions),
          QuizTabInfo(
              id: "数Ⅰ・数A", display: "数Ⅰ・数A", color: "1", icon: Icons.filter_1),
          QuizTabInfo(
              id: "数Ⅱ・数B", display: "数Ⅱ・数B", color: "2", icon: Icons.filter_2),
          QuizTabInfo(
              id: "数Ⅲ・数C", display: "数Ⅲ・数C", color: "3", icon: Icons.filter_3),
        ],
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
        modeDescription: "・60秒の点数で競おう！\n"
            "・答えるごとに問題のレベル(★)が上がります。速く答えるとボーナス点がもらえます！",
        isSmallerBetter: false,
        rankingList: [
          QuizTabInfo(
              id: "数Ⅰ・数A", display: "数Ⅰ・数A", color: "A", icon: Icons.filter_1),
          QuizTabInfo(
              id: "数Ⅱ・数B", display: "数Ⅱ・数B", color: "B", icon: Icons.filter_2),
          QuizTabInfo(
              id: "数Ⅲ・数C", display: "数Ⅲ・数C", color: "C", icon: Icons.filter_3),
        ],
      ),
      detail: [
        DetailData(
          quizId: QuizId(resisterOrigin: "数Ⅰ・数A", modeType: "g"),
          sort: "1A",
          displayLabel: "数Ⅰ・数A",
          method: "数I・数Aの全範囲(因数分解, 三角比, 確率など)",
          description: "高1向け! 60秒での点数で競おう!!",
          color: "A",
          circleColor: "1A",
          detailIcon: Icons.filter_1,
        ),
        DetailData(
          quizId: QuizId(resisterOrigin: "数Ⅱ・数B", modeType: "g"),
          sort: "2B",
          displayLabel: "数Ⅱ・数B",
          method: "数Ⅱ・数Bの全範囲(対数, 積分, 統計など)",
          description: "高2向け! 60秒での点数で競おう!!",
          color: "B",
          circleColor: "2B",
          detailIcon: Icons.filter_2,
        ),
        DetailData(
          quizId: QuizId(resisterOrigin: "数Ⅲ・数C", modeType: "g"),
          sort: "3C",
          displayLabel: "数Ⅲ・数C",
          method: "数Ⅲ・数Cの全範囲(極限, 二次曲線, ベクトルなど)",
          description: "理系向け! 60秒での点数で競おう!!",
          color: "C",
          circleColor: "3C",
          detailIcon: Icons.filter_3,
        ),
      ],
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final options = DefaultFirebaseOptions.currentPlatform;

  runApp(
    Bootstrap(appConfig: _appConfig, firebaseOptions: options),
  );
}

final List<List<String>> subjects = [
  ["1", "数と式", "展開", "(ax+b)(cx+d)の係数を求める"],
  ["1", "数と式", "因数分解", "たすき掛け因数分解など"],
  ["1", "数と式", "二重根号", "\\sqrt{a+b+2\\sqrt{ab}}=\\sqrt{a}+\\sqrt{b}に直す"],
  ["1", "数と式", "循環小数", "0.\\dot{9}\\dot{8}などを分数に直す"],
  ["1", "二次関数", "平方完成", "y=(x-p)^2+qに変形する"],
  ["1", "二次関数", "二次方程式の解", "因数分解して求める"],
  ["1", "二次関数", "最大値・最小値", "グラフと定義域の位置関係"],
  //["1", "二次関数", "対称移動", "x^2,x,定数項の符号を変える"],
  //["1", "二次関数", "判別式", "方程式が解を持つか、ある直線と交わるかなど"],
  ["1", "三角比", "三角比の値", "三角比の基本"],
  ["1", "三角比", "相互関係", "マイナスに注意"],
  ["1", "三角比", "図形問題", "三角比の値、面積など"],
  //["1", "三角比", "三角比の不等式", "単位円で考える"],
  //["1", "三角比", "三角比の値域", "単位円で考える"],
  ["2", "解と方程式", "解と係数の関係", "\\alpha+\\beta,\\alpha\\betaを利用"],
  ["2", "図形と方程式", "点と直線の距離", "d=(ax+by+c)/\\sqrt{a^2+b^2}を利用"],
  ["2", "図形と方程式", "直線の方程式", "傾きと切片を考える"],
  ["2", "図形と方程式", "円の方程式", "半径と中心の座標を考える"],
  ["2", "図形と方程式", "点と点の距離", "三平方の定理を利用"],
  ["2", "図形と方程式", "中点・内分・外分", "公式利用,計算量が多い"],
  ["2", "三角関数", "三角関数の値", "ラジアン追加,一般角以外も追加"],
  ["2", "三角関数", "合成", "\\sin合成,単位円で考える"],
  ["2", "三角関数", "積和・和積の公式", "覚えにくい公式"],
  //["2", "三角関数", "三角関数の不等式", "数Ⅰの発展問題,単位円で考える"],
  //["2", "三角関数", "三角関数の値域", "数Ⅰの発展問題,単位円で考える"],
  ["2", "指数・対数", "対数の計算", "底の変換を利用"],
  //["2", "指数・対数", "指数の不等式", "グラフを思い浮かべる"],
  //["2", "指数・対数", "対数の不等式", "グラフを思い浮かべる"],
  ["2", "積分", "1分のn公式", "覚えてると積分計算を飛ばせる"],
  ["2", "積分", "定積分", "x,x^2,x^3の積分,係数に注意"],
  ["3", "極限", "極限", "発散速度,eの定義,分子の有理化など"],
  ["3", "微分", "色々な微分", "\\sin,\\cos,e,x^nの微分"],
  ["3", "積分", "不定積分", "\\sin,\\cos,e,x^nの積分"],
  ["A", "確率", "CP!の値", "\\huge{}_n C_r,n!の計算など"],
  ["A", "確率", "場合の数", "組み分け,円順列など"],
  ["A", "確率", "確率", "球の取り出し,条件つき確率など"],
  ["A", "整数", "素因数分解", "指数部分を計算"],
  ["A", "整数", "記数法", "n進法を10進法に変換"],
  ["A", "整数", "ガウス記号", "xを超えない最大の整数"],
  ["A", "幾何", "チェバ・メネラウス", "適応する三角形を意識する"],
  ["B", "数列", "数列の和", "公式を利用すると早い"],
  ["B", "数列", "一般項", "初項と公差,特性方程式など"],
  ["B", "統計", "統計", "平均,分散,標準偏差など"],
  ["C", "二次曲線", "双曲線", "漸近線,焦点など"],
  ["C", "二次曲線", "楕円", "長軸,焦点など"],
  ["C", "二次曲線", "放物線", "準線,焦点など"],
  ["C", "ベクトル", "内積", "大きさと組み合わせる"],
  ["C", "複素数平面", "ドモアブルの定理", "合成の上位互換,難しい"],
  ["C", "複素数平面", "回転", "90°,-90°回転を考える"],
];
IconData? getIconForCategory(String category) {
  switch (category) {
    case '二次関数':
      return Icons.superscript; // 関数のアイコン
    case '数と式':
      return Icons.calculate; // 計算のアイコン
    case '三角比':
      return Icons.change_history; // 三角形アイコン
    case '図形と方程式':
      return Icons.square_foot; // 図形っぽいアイコン
    case '解と方程式':
      return Icons.low_priority; // 図形っぽいアイコン
    case '積分':
      return Icons.line_axis; // 積分アイコン（Flutterにない場合は代替アイコン）
    case '微分':
      return Icons.exposure; // 微分っぽいアイコンとして代用
    case '三角関数':
      return Icons.waves; // 三角関数向けに波っぽいイメージ
    case '論証':
      return Icons.gavel; // 論証→裁判のハンマーアイコン
    case '確率':
      return Icons.casino; // 確率 → ギャンブル系アイコン
    case '数列':
      return Icons.format_list_numbered; // 数列 → 番号付きリストアイコン
    case '指数・対数':
      return Icons.turn_sharp_right; // 指数っぽいイメージ
    case 'データ':
      return Icons.bar_chart; // データ→棒グラフ
    case '統計':
      return Icons.pie_chart; // 統計→円グラフ
    case '幾何':
      return Icons.architecture; // 図形→三角形アイコン
    case '整数':
      return Icons.looks_one; // 整数→番号的なアイコン
    case '複素数平面':
      return Icons.format_italic; // 複素数平面→散布図アイコン
    case 'ベクトル':
      return Icons.text_rotation_none; // ベクトル→矢印アイコン
    case '極限':
      return Icons.all_inclusive; // 極限→∞マーク風アイコン
    case '数Ⅲ　関数':
      return Icons.functions; // 数Ⅲ 関数も関数アイコンでよし
    case '二次曲線':
      return Icons.vignette;
    default:
      return null;
  }
}

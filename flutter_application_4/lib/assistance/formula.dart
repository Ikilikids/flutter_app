import 'package:flutter/material.dart';

final List<List<String>> subjects = [
  ["1A2B3C", "その他", "全合計", ""],
  ["1", "数と式", "展開", "(ax+b)(cx+d)の係数を求める"],
  ["1", "数と式", "因数分解", "たすき掛け因数分解など"],
  ["1", "数と式", "二重根号", "\\sqrt{a+b+2\\sqrt{ab}}=\\sqrt{a}+\\sqrt{b}に直す"],
  ["1", "数と式", "循環小数", "0.\\dot{9}\\dot{8}などを分数に直す"],
  ["1", "二次関数", "平方完成", "y=(x-p)^2+qに変形する"],
  ["1", "二次関数", "二次方程式の解", "因数分解して求める"],
  ["1", "二次関数", "最大値・最小値", "グラフと定義域の位置関係"],
  ["1", "三角比", "三角比の値", "三角比の基本"],
  ["1", "三角比", "相互関係", "マイナスに注意"],
  ["1", "三角比", "図形問題", "三角比の値、面積など"],
  ["2", "解と方程式", "解と係数の関係", "\\alpha+\\beta,\\alpha\\betaを利用"],
  ["2", "図形と方程式", "点と直線の距離", "d=(ax+by+c)/\\sqrt{a^2+b^2}を利用"],
  ["2", "図形と方程式", "直線の方程式", "傾きと切片を考える"],
  ["2", "図形と方程式", "円の方程式", "半径と中心の座標を考える"],
  ["2", "図形と方程式", "点と点の距離", "三平方の定理を利用"],
  ["2", "図形と方程式", "中点・内分・外分", "公式利用,計算量が多い"],
  ["2", "三角関数", "三角関数の値", "ラジアン追加,一般角以外も追加"],
  ["2", "三角関数", "合成", "\\sin合成,単位円で考える"],
  ["2", "三角関数", "積和・和積の公式", "覚えにくい公式"],
  ["2", "指数・対数", "対数の計算", "底の変換を利用"],
  ["2", "指数・対数", "常用対数", "桁数など"],
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
  ["1A", "高1向け!!", "数Ⅰ・数A", "数Ⅰ・数Aの全範囲"],
  ["2B", "高2向け!!", "数Ⅱ・数B", "数Ⅱ・数Bの全範囲"],
  ["3C", "高3(理系)向け!!", "数Ⅲ・数C", "数Ⅲ・数Cの全範囲"],
  ["1A2B3C", "受験生(理系)向け!!", "全範囲", "数Ⅰ・A・Ⅱ・B・Ⅲ・Cの全範囲"],
];

String getSubjectFromSymbol(String symbol) {
  if (symbol == "1") return "Ⅰ";
  if (symbol == "2") return "Ⅱ";
  if (symbol == "3") return "Ⅲ";
  if (symbol == "A") return "A";
  if (symbol == "B") return "B";
  if (symbol == "C") return "C";
  if (symbol == "abc123") return "全分野";
  return "";
}

Color getQuizColor3(String title, BuildContext context) {
  if (title == ('1A2B3C')) {
    return const Color.fromARGB(255, 148, 20, 162);
  }
  if (title.contains('1')) {
    return const Color.fromARGB(255, 233, 155, 66);
  } else if (title.contains('2')) {
    return const Color.fromARGB(255, 94, 169, 230);
  } else if (title.contains('3')) {
    return const Color.fromARGB(255, 228, 96, 96);
  } else if (title.contains('A')) {
    return const Color.fromARGB(255, 229, 106, 147);
  } else if (title.contains('B')) {
    return const Color.fromARGB(255, 80, 176, 80);
  } else if (title.contains('C')) {
    return const Color.fromARGB(255, 124, 89, 194);
  } else {
    return const Color.fromARGB(255, 192, 192, 192);
  }
}

Color getColorByIndex(
    double index, double alpha, double saturation, double value) {
  const totalColors = 6;
  final hue = ((360 / totalColors) * index + 80) % 360;
  final hsvColor = HSVColor.fromAHSV(alpha, hue, saturation, value);
  return hsvColor.toColor();
}

Color getQuizColor2(
  String title,
  BuildContext context,
  double alpha,
  double saturation,
  double value,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  value = isDark ? value * 0.8 : value;
  if (title.contains('1A2B3C')) {
    return getColorByIndex(5.2, alpha, 0, value - 0.2);
  }
  if (title.contains('1')) {
    return getColorByIndex(5.2, alpha, saturation, value);
  } else if (title.contains('2')) {
    return getColorByIndex(2, alpha, saturation, value);
  } else if (title.contains('3')) {
    return getColorByIndex(4.6, alpha, saturation, value);
  } else if (title.contains('A')) {
    return getColorByIndex(3.8, alpha, saturation, value);
  } else if (title.contains('B')) {
    return getColorByIndex(0.7, alpha, saturation * 0.9, value * 0.9);
  } else if (title.contains('C')) {
    return getColorByIndex(2.9, alpha, saturation, value);
  } else {
    return getColorByIndex(5.2, alpha, 0, value - 0.3);
  }
}

Color bgColor1(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xff252a31) : Color(0xffffffff);
}

Color bgColor2(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xff141920) : Color(0xfff5f5f5);
}

Color textColor1(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xffe6e6e6) : Color(0xff444444);
}

Color textColor2(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xffc0c0c0) : Color(0xff777777);
}

Color textColor3(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xffe6e6e6) : Color(0xfff6f6f6);
}

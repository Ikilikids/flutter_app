import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_quiz/math_quiz.dart';

String plus(List<String> inputs) {
  final filtered = inputs.where((e) => e != "0").toList();
  if (filtered.isEmpty) return "0";
  if (filtered.length == 1) return finalclean(filtered[0]);

  ParsedFraction? sum;

  for (final input in filtered) {
    final frac = parseFraction(tocalculate(input));
    if (sum == null) {
      sum = frac;
    } else {
      final newNumerator = sum.ni * frac!.di + sum.di * frac.ni;
      final newDenominator = sum.di * frac.di;
      sum = ParsedFraction(newNumerator, sum.ns, newDenominator);
    }
  }

  final num = "${sum!.ni}\\sqrt{${sum.ns}}";
  final den = "${sum.di}";

  return finalclean("\\frac{$num}{$den}");
}

String pluskai(List<String> inputs) {
  final pattern = RegExp(r'[+-]?[^+-]+');
  final Map<String, List<String>> grouped = {};

  for (final input in inputs) {
    for (final m in pattern.allMatches(input)) {
      final term = m.group(0)!.replaceFirst('+', '');
      final calculated = tocalculate(term);
      final parsed = parseFraction(calculated);

      if (parsed == null) {
        continue;
      }

      final ns = parsed.ns.toString();
      grouped.putIfAbsent(ns, () => []).add(calculated);
    }
  }
  List<String> results = [];
  for (final group in grouped.values) {
    final summed = plus(group);
    if (!(summed == "0")) {
      results.add(summed.startsWith('-') ? summed : '+$summed');
    }
  }

  String result = results.join();
  result = plusminusreplace(result);
  if (result == "") {
    result = "0";
  }

  return result.startsWith('+') ? result.substring(1) : result;
}

String times(List<String> inputs) {
  final filtered = inputs.where((e) => e != "1").toList();
  if (filtered.contains("0")) return "0";
  if (filtered.isEmpty) return "1";
  if (filtered.length == 1) return finalclean(filtered[0]);

  ParsedFraction? product;

  for (final input in filtered) {
    final frac = parseFraction(tocalculate(input));
    if (frac == null) continue;

    if (product == null) {
      product = frac;
    } else {
      int newNumerator = product.ni * frac.ni;
      int newRoot = product.ns * frac.ns;
      int newDenominator = product.di * frac.di;

      product = ParsedFraction(newNumerator, newRoot, newDenominator);
    }
  }

  if (product == null) return "1";

  final num = "${product.ni}\\sqrt{${product.ns}}";
  final den = "${product.di}";

  return finalclean("\\frac{$num}{$den}");
}

String timeskai(List<String> inputs) {
  final pattern = RegExp(r'[+-]?[^+-]+');
  final List<List<String>> grouped = [];

  for (final input in inputs) {
    final List<String> terms = [];

    for (final m in pattern.allMatches(input)) {
      final term = m.group(0)!.replaceFirst('+', '');
      final calculated = tocalculate(term);
      if (parseFraction(calculated) == null) continue;

      terms.add(calculated);
    }

    if (terms.isNotEmpty) {
      grouped.add(terms);
    }
  }

  List<List<String>> extracted = cartesianProduct(grouped);

  List<String> results = [];
  for (final group in extracted) {
    final timemed = times(group);

    if (timemed != "0") {
      results.add(timemed.startsWith('-') ? timemed : '+$timemed');
    }
  }

  String result = results.join();
  result = plusminusreplace(result);
  result = pluskai([result]);
  return result.startsWith('+') ? result.substring(1) : result;
}

String div(List<String> inputs) {
  if (inputs[0] == "0") {
    return "0";
  } else if (inputs[1] == "0") {
    return "0除算やで";
  } else {
    final calcinput2 = parseFraction(tocalculate(inputs[1]));

    String newinput2 = finalclean(
        "\\frac{${calcinput2?.di}}{${calcinput2?.ni}\\sqrt{${calcinput2?.ns}}}");

    return timeskai([inputs[0], newinput2]);
  }
}

String divkai(List<String> inputs) {
  if (inputs[0] == "0") {
    return "0";
  } else if (inputs[1] == "0") {
    return "0除算やで";
  } else {
    final calcinput2 = parseFraction(tocalculate(inputs[1]));
    String newinput2 = finalclean(
        "\\frac{${calcinput2?.di}}{${calcinput2?.ni}\\sqrt{${calcinput2?.ns}}}");

    return timeskai([inputs[0], newinput2]);
  }
}

String minus(List<String> inputs) {
  inputs[1] = toM(inputs[1]);
  return pluskai([inputs[0], inputs[1]]);
}

String powkai(List<String> inputs) {
  String base = inputs[0];
  String timesandz = inputs[1];
  double? times = 0;
  if (timesandz == "z") {
    timesandz = "1";
    base = abs(base);
  } else if (timesandz.contains("z")) {
    timesandz = timesandz.replaceAll("z", "");
    base = abs(base);
  }

  times = double.tryParse(timesandz);

  if (times == null) return "1"; // 無効な入力

  if (times == 0) {
    return "1";
  } else if (base == "0") {
    return "0";
  } else if (times == 0.5) {
    return sqr(base);
  } else if (times == 0.6) {
    return sqr2(base);
  } else if (times == 1) {
    return base;
  } else if (times % 1 != 0) {
    // 小数だけど0.5以外のとき（必要に応じて別対応）
    return "$base^$times"; // そのまま返す（あるいはエラー処理も可）
  } else {
    int intTimes = times.toInt();
    List<String> result = [];
    for (int i = 0; i < intTimes; i++) {
      result.add(base);
    }
    return timeskai(result);
  }
}

String sqr(String input) {
  if (input == "0") {
    return "0";
  }
  input = abs(input);
  final parsed = parseFraction(tocalculate(input));
  return finalclean("\\frac{\\sqrt{${parsed!.ni}}}{\\sqrt{${parsed.di}}}");
}

String sqr2(String input) {
  if (input == "0") {
    return "0";
  }
  input = abs(input);
  final fracpattern = RegExp(r'\\frac\{(\d*)\}\{(\d*)\}');
  final fracmatch = fracpattern.firstMatch(input);
  String ni = "";
  String di = "";
  String ns = "";
  String ds = "";
  String n = "";
  String d = "";
  if (fracmatch != null) //分数の場合
  {
    ni = fracmatch.group(1) ?? "1";
    di = fracmatch.group(2) ?? "1";
    List<int> cleaned2 = sqrtcrean(1, int.parse(ni));
    List<int> cleaned1 = sqrtcrean(1, int.parse(di));
    ni = cleaned1[0].toString();
    ns = cleaned1[1].toString();
    di = cleaned2[0].toString();
    ds = cleaned2[1].toString();
    int g = gcd(int.parse(ni), int.parse(di));
    ni = (int.parse(ni) ~/ g).toString();
    di = (int.parse(di) ~/ g).toString();
    if (ni == "1") {
      n = "\\sqrt{$ns}";
    } else if (ns == "1") {
      n = ni;
    } else {
      n = "$ni\\sqrt{$ns}";
    }
    if (di == "1" && ds == "1") {
      d = "1";
    } else if (di == "1") {
      d = "\\sqrt{$ds}";
    } else if (ds == "1") {
      d = di;
    } else {
      d = "$di\\sqrt{$ds}";
    }
    return "\\frac{$d}{$n}";
  } else {
    List<int> cleaned2 = sqrtcrean(1, int.parse(input));
    di = cleaned2[0].toString();
    ds = cleaned2[1].toString();
    if (di == "1" && ds == "1") {
      d = "1";
    } else if (di == "1") {
      d = "\\sqrt{$ds}";
    } else if (ds == "1") {
      d = di;
    } else {
      d = "$di\\sqrt{$ds}";
    }
    return d;
  }
}

String abs(String input) {
  input = input.replaceAll("-", "");
  return input;
}

String toM(String input) {
  if (input == "0") {
    return "0";
  } else {
    input = "+$input";
    input = input
        .replaceFirst("+-", "-")
        .replaceAll('-', 'TEMP_MINUS')
        .replaceAll('+', '-')
        .replaceAll('TEMP_MINUS', '+');

    return input;
  }
}

String normalize(String value) {
  if (value == "") return "0";
  if (value == "1") return "";
  if (value == "-1") return "-";
  return value;
}

String normalizek(String value) {
  if (value == "") return "0";
  if (value == "1") return "k";
  if (value == "-1") return "-k";
  return value;
}

double latextonumber(String input) {
  final parsed = parseFraction(tocalculate(input));
  double result = 0;
  final raw =
      parsed!.ni.toDouble() * sqrt(parsed.ns.toDouble()) / parsed.di.toDouble();
  result = (raw * 1000).roundToDouble() / 1000;
  result = zeroIfClose(result);
  return result;
}

double zeroIfClose(double value) {
  const double epsilon = 1e-4;
  return value.abs() < epsilon ? 0.0 : value;
}

String returnsqrt(String input) {
  if (input == "0") {
    return "0";
  } else {
    final parsed = parseFraction(tocalculate(input));
    String pm = parsed!.ni > 0 ? "" : "-";
    int ani = (parsed.ni * parsed.ns).abs();
    String cni = (ani ~/ gcd(ani, parsed.di)).toString();
    String cdi = (parsed.di ~/ gcd(ani, parsed.di)).toString();
    String cds = (parsed.ns).toString();
    if (cdi == "1" && cds == "1") {
      return "$pm$cni";
    } else if (cdi == "1") {
      return "$pm\\frac{$cni}{\\sqrt{$cds}}";
    } else if (cds == "1") {
      return "$pm\\frac{$cni}{$cdi}";
    } else {
      return "$pm\\frac{$cni}{$cdi\\sqrt{$cds}}";
    }
  }
}

String wrapIfNeeded(String s) {
  final plusCount = RegExp(r'\+').allMatches(s).length;
  final minusCount = RegExp(r'-').allMatches(s).length;
  if (plusCount >= 1 || minusCount >= 2) {
    // すでに丸括弧で囲まれていたらそのまま返す例外処理もあると安全
    if (s.startsWith('(') && s.endsWith(')')) return s;
    return '($s)';
  }
  return s;
}

String makingFanction1D(String sa, String sb) {
  sa = sa.replaceAll("--", "");
  sb = sb.replaceAll("--", "");
  sa = normalize(sa);

  sa = wrapIfNeeded(sa);
  sb = wrapIfNeeded(sb);
  if (sa == "0" && sb == "0") {
    return "0";
  }
  List<String> terms = [];
  if (sa != "0") terms.add("${sa}x");
  if (sb != "0") terms.add(sb);
  String result = terms.join("+");

  result = result.replaceAll("+-", "-");

  return result;
}

String makingFanction2D(String sa, String sb, String sc) {
  sa = sa.replaceAll("--", "");
  sb = sb.replaceAll("--", "");
  sc = sc.replaceAll("--", "");
  sa = normalize(sa);
  sb = normalize(sb);

  sa = wrapIfNeeded(sa);
  sb = wrapIfNeeded(sb);
  sc = wrapIfNeeded(sc);

  List<String> terms = [];
  if (sa != "0") terms.add("${sa}x^{2}");
  if (sb != "0") terms.add("${sb}x");
  if (sc != "0") terms.add(sc);
  String result = terms.join("+");
  result = result.replaceAll("+-", "-");

  return result;
}

String makingFanction3D(String sa, String sb, String sc, String sd) {
  sa = normalize(sa);
  sb = normalize(sb);
  sc = normalize(sc);

  sa = wrapIfNeeded(sa);
  sb = wrapIfNeeded(sb);
  sc = wrapIfNeeded(sc);
  sd = wrapIfNeeded(sd);

  List<String> terms = [];

  if (sa != "0") terms.add("${sa}x^{3}");
  if (sb != "0") terms.add("${sb}x^{2}");
  if (sc != "0") terms.add("${sc}x");
  if (sd != "0") terms.add(sd);

  String result = terms.join("+");
  result = result.replaceAll("+-", "-");

  return result;
}

String makingFanctionLine(String sa, String sb, String sc) {
  sa = normalize(sa);
  sb = normalize(sb);
  List<String> terms = [];
  if (sa != "0") terms.add("${sa}x");
  if (sb != "0") terms.add("${sb}y");
  if (sc != "0") terms.add(sc);
  String result = terms.join("+");
  result = result.replaceAll("+-", "-");

  return result;
}

String dtol(double value) {
  value = zeroIfClose(value);
  String format(double value) {
    // xまたはyが3.14にぴったりならばπを表示
    if (value == 3.14) return r'\pi';
    if (value == -3.14) return r'-\pi';
    if (value == 1.57) return r'\frac{\pi}{2}';
    if (value == -1.57) return r'-\frac{\pi}{2}';
    if (value == 1.05) return r'\frac{\pi}{3}';
    if (value == -1.05) return r'-\frac{\pi}{3}';
    if (value == 2.09) return r'\frac{2\pi}{3}';
    if (value == -2.09) return r'-\frac{2\pi}{3}';
    if (value == 4.19) return r'\frac{4\pi}{3}';
    if (value == -4.19) return r'-\frac{4\pi}{3}';
    if (value == 0.52) return r'\frac{\pi}{6}';
    if (value == -0.52) return r'-\frac{\pi}{6}';
    if (value == 2.62) return r'\frac{5\pi}{6}';
    if (value == -2.62) return r'-\frac{5\pi}{6}';
    if (value == 3.66) return r'\frac{7\pi}{6}';
    if (value == -3.66) return r'-\frac{7\pi}{6}';
    if (value == 0.26) return r'\frac{\pi}{12}';
    if (value == -0.26) return r'-\frac{\pi}{12}';
    if (value == 1.3) return r'\frac{5\pi}{12}';
    if (value == -1.3) return r'-\frac{5\pi}{12}';
    if (value == 1.84) return r'\frac{7\pi}{12}';
    if (value == -1.84) return r'-\frac{7\pi}{12}';
    if (value == 2.88) return r'\frac{11\pi}{12}';
    if (value == -2.88) return r'-\frac{11\pi}{12}';
    if (value == 3.41) return r'\frac{13\pi}{12}';
    if (value == -3.41) return r'-\frac{13\pi}{12}';
    if (value == 0.78) return r'\frac{\pi}{4}';
    if (value == -0.78) return r'-\frac{\pi}{4}';
    if (value == 2.36) return r'\frac{3\pi}{4}';
    if (value == -2.36) return r'-\frac{3\pi}{4}';
    if (value == 0.39) return r'\frac{\pi}{8}';
    if (value == -0.39) return r'-\frac{\pi}{8}';
    if (value == 1.18) return r'\frac{3\pi}{8}';
    if (value == -1.18) return r'-\frac{3\pi}{8}';
    if (value == 0.25) return r'\frac{1}{4}';
    if (value == -0.25) return r'-\frac{1}{4}';
    if (value == 0.75) return r'\frac{3}{4}';
    if (value == -0.75) return r'-\frac{3}{4}';
    if (value == 0.33) return r'\frac{1}{3}';
    if (value == -0.33) return r'-\frac{1}{3}';
    if (value == 0.66) return r'\frac{2}{3}';
    if (value == -0.66) return r'-\frac{2}{3}';
    if (value == 0.5) return r'\frac{1}{2}';
    if (value == -0.5) return r'-\frac{1}{2}';
    if (value == 1.5) return r'\frac{3}{2}';
    if (value == -1.5) return r'-\frac{3}{2}';
    if (value == 2.5) return r'\frac{5}{2}';
    if (value == -2.5) return r'-\frac{5}{2}';
    if (value == 2.72) return 'e';
    if (value == -2.72) return '-e';
    if (value == 1.41) return r'\sqrt{2}';
    if (value == -1.41) return r'-\sqrt{2}';
    if (value == 1.73) return r'\sqrt{3}';
    if (value == -1.73) return r'-\sqrt{3}';
    if (value == 2.83) return r'2\sqrt{2}';
    if (value == -2.83) return r'-2\sqrt{2}';
    if (value == 3.46) return r'2\sqrt{3}';
    if (value == -3.46) return r'-2\sqrt{3}';
    if (value == 0.71) return r'\frac{1}{\sqrt{2}}';
    if (value == -0.71) return r'-\frac{1}{\sqrt{2}}';

    // 値が整数の場合はそのまま表示
    if (value == value.toInt().toDouble()) {
      return value.toInt().toString();
    }
    return value.toString(); // 通常の数値
  }

  // xとyの両方を確認して文字列を作成
  return format(value);
}

bool hasSquareFactor(int n) {
  for (int i = 2; i * i <= n; i++) {
    int square = i * i;
    if (n % square == 0) {
      return true; // 平方因子を持っている
    }
  }
  return false; // 平方因子を持っていない
}

int factorial(int n) {
  return (n <= 1) ? 1 : n * factorial(n - 1);
}

int combination(int b, int a) {
  if (a > b) return 0; // 不正な場合
  return factorial(b) ~/ (factorial(a) * factorial(b - a));
}

int permutation(int b, int a) {
  if (a > b) return 0;
  return factorial(b) ~/ factorial(b - a);
}

String toBase(int value, int base) {
  if (base < 2 || base > 36) {
    throw ArgumentError('base must be between 2 and 36');
  }
  return value.toRadixString(base);
}

int randomint(int a, int b) {
  Random random = Random();
  return random.nextInt(b - a + 1) + a;
}

String nrandomint(int a, int b) {
  Random random = Random();
  String k = (random.nextInt(b - a + 1) + a).toString();
  if (k == "1") {
    k = "";
  }
  return k;
}

int countDivisors(int n) {
  int count = 0;
  for (int i = 1; i <= n; i++) {
    if (n % i == 0) count++;
  }
  return count;
}

int getRandomTrueDivisor(int n) {
  if (n <= 3) {
    throw ArgumentError("真の約数が存在しません（n > 3 の数を指定してください）");
  }

  final List<int> divisors = [];
  for (int i = 2; i < n; i++) {
    if (n % i == 0) {
      divisors.add(i);
    }
  }

  if (divisors.isEmpty) {
    throw Exception("真の約数が存在しません（素数です）");
  }

  final random = Random();
  return divisors[random.nextInt(divisors.length)];
}

String getIntegralText(String sort) {
  if (sort == ('数と式')) {
    return r'\surd{{x}^2}=|x|';
  } else if (sort == ('二次関数')) {
    return r'\footnotesize D=b^2-4ac';
  } else if (sort == ('三角比')) {
    return r'\sin{\theta}';
  } else if (sort == ('解と方程式')) {
    return r'\alpha\beta\gamma';
  } else if (sort == ('図形と方程式')) {
    return r'x^2+y^2=1';
  } else if (sort == ('指数・対数')) {
    return r'\log(x)';
  } else if (sort == ('三角関数')) {
    return r'\sin{x}';
  } else if (sort == ('積分')) {
    return r'\int f(x)dx';
  } else if (sort == ('極限')) {
    return r'{\lim_{n\to \infty} a_n}';
  } else if (sort == ('微分')) {
    return r'\frac{d}{dx}f(x)';
  } else if (sort == ('確率')) {
    return r'\Large {}_n \mathrm{C}_k';
  } else if (sort == ('整数')) {
    return r'1001_{(2)}';
  } else if (sort == ('幾何')) {
    return r'\angle{a}=\angle{b}';
  } else if (sort == ('数列')) {
    return r'a_n=\sum\limits_{k=1}^n b_n';
  } else if (sort == ('統計')) {
    return r'B(m,\rho^2)';
  } else if (sort == ('二次曲線')) {
    return r'{y^2=4px}';
  } else if (sort == ('ベクトル')) {
    return r'\Large{\underset{AB}{\to}}';
  } else if (sort == ('複素数平面')) {
    return r'z\bar{z}=|z|^2';
  } else if (sort == ('論証')) {
    return r'\{1,2...\}';
  } else if (sort == ('データ')) {
    return r'r=\frac{s_{xy}}{s_{x}s_{y}}';
  } else if (sort == ('数Ⅲ関数')) {
    return r'{(f\circ g)(x)}';
  } else if (sort == ('その他')) {
    return r'other';
  } else {
    return ''; // 他のsortには何も表示しない
  }
}

Color getBackColor(String title, BuildContext context) {
  if (title.contains('1')) {
    return const Color(0x66D1A05A); // 渋いオレンジ
  } else if (title.contains('2')) {
    return const Color(0x6690AFCF); // 渋い青
  } else if (title.contains('3')) {
    return const Color(0x66D18484); // 渋い赤
  } else if (title.contains('A')) {
    return const Color(0x66D1A0B6); // 渋いピンク
  } else if (title.contains('B')) {
    return const Color(0x6690C79A); // 渋い緑
  } else if (title.contains('C')) {
    return const Color(0x669D90CF); // 渋い紫
  } else {
    return Colors.white;
  }
}

Color getQuizColor(String title, BuildContext context) {
  if (title.contains('1')) {
    return const Color(0x80F0B066);
  } else if (title.contains('2')) {
    return const Color(0x8094BFE3);
  } else if (title.contains('3')) {
    return const Color(0x80E58C8C);
  } else if (title.contains('A')) {
    return const Color(0x80E3A5BA);
  } else if (title.contains('B')) {
    return const Color(0x80A4D8A4);
  } else if (title.contains('C')) {
    return const Color(0x80B5A1DD);
  } else {
    return Colors.white;
  }
}

String getRank(int score, String sort) {
  if (sort == "1A2B3C" || sort == "全範囲" || sort == "全分野") {
    if (score >= 1000) {
      return 'S';
    } else if (score >= 800) {
      return 'A';
    } else if (score >= 600) {
      return 'B';
    } else if (score >= 500) {
      return 'C';
    } else if (score >= 400) {
      return 'D';
    } else if (score >= 300) {
      return 'E';
    } else if (score >= 200) {
      return 'F';
    } else {
      return 'G'; // Gランク
    }
  } else {
    if (score >= 500) {
      return 'S';
    } else if (score >= 400) {
      return 'A';
    } else if (score >= 300) {
      return 'B';
    } else if (score >= 250) {
      return 'C';
    } else if (score >= 200) {
      return 'D';
    } else if (score >= 150) {
      return 'E';
    } else if (score >= 100) {
      return 'F';
    } else {
      return 'G'; // Gランク
    }
  }
}

Widget getRankIconAndImage(String rank, int size) {
  CustomPainter painter;
  switch (rank) {
    case 'S':
      painter = SRankPainter(radius: size / 1.6);
      break;
    case 'A':
      painter = ARankPainter(radius: size / 1.6);
      break;
    case 'B':
      painter = BRankPainter(radius: size / 1.6);
      break;
    case 'C':
      painter = CRankPainter(radius: size / 1.6);
      break;
    case 'D':
      painter = DRankPainter(radius: size / 1.6);
      break;
    case 'E':
      painter = ERankPainter(radius: size / 1.6);
      break;
    case 'F':
      painter = FRankPainter(radius: size / 1.6);
      break;
    case 'G':
    default:
      painter = GRankPainter(radius: size / 1.6);
      break;
  }
  return CustomPaint(
    size: Size(size.toDouble(), size.toDouble()),
    painter: painter,
  );
}

IconData getIconForCategory(String category) {
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
      return Icons.vignette; // 二次曲線→時間軸風
    case 'その他':
      return Icons.more_horiz; // その他→「…」のアイコン
    default:
      return Icons.category; // デフォルトアイコン
  }
}

String randomQuadratic(int a, int p, int q) {
  String xPart;
  if (p > 0) {
    xPart = "(x - $p)";
  } else if (p < 0) {
    xPart = "(x + ${-p})";
  } else {
    xPart = "x";
  }

  // a の表示
  String aStr;
  if (a == 1) {
    aStr = ""; // 省略
  } else if (a == -1) {
    aStr = "-"; // マイナスだけ
  } else {
    aStr = "$a";
  }

  // y= の式を組み立て
  String result = "y = $aStr$xPart^2";

  if (q > 0) {
    result += " + $q";
  } else if (q < 0) {
    result += " - ${-q}";
  }

  return result;
}

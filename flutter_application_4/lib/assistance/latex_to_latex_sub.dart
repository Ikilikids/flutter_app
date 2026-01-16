String tocalculate(String input) //\frac{a\sqrt{b}}{c\sqrt{d}}の形に
{
  final fracpattern = RegExp(
      r'(-)?\\frac\{(\d*)?(\\sqrt\{(\d+)\})?\}\{(\d*)?(\\sqrt\{(\d+)\})?\}');
  final nofracpattern = RegExp(r'(-)?(\d*)?(\\sqrt\{(\d+)\})?');
  final fracmatch = fracpattern.firstMatch(input);
  final nofracmatch = nofracpattern.firstMatch(input);
  String pm = "";
  String ni = "";
  String ns = "";
  String di = "";
  String ds = "";
  if (fracmatch != null || nofracmatch != null) {
    if (fracmatch != null) //分数の場合
    {
      pm = fracmatch.group(1) ?? "";
      ni = fracmatch.group(2) ?? "1";
      ns = fracmatch.group(4) ?? "1";
      di = fracmatch.group(5) ?? "1";
      ds = fracmatch.group(7) ?? "1";
    } else if (nofracmatch != null) //分数ではない場合
    {
      pm = nofracmatch.group(1) ?? "";
      ni = nofracmatch.group(2) ?? "1";
      ns = nofracmatch.group(4) ?? "1";
      di = "1";
      ds = "1";
    }
    ns = (int.parse(ns) * int.parse(ds)).toString();
    di = (int.parse(di) * int.parse(ds)).toString();
    List<int> cleaned = sqrtcrean(int.parse(ni), int.parse(ns));
    ni = cleaned[0].toString();
    ns = cleaned[1].toString();
    int g = gcd(int.parse(ni), int.parse(di));
    ni = (int.parse(ni) ~/ g).toString();
    di = (int.parse(di) ~/ g).toString();

    return "$pm\\frac{$ni\\sqrt{$ns}}{$di}";
  } else {
    return "nullやで";
  }
}

String finalclean(String input) //最終的な整形
{
  if (input.contains("{-")) //マイナスを外に出す
  {
    input = "-${input.replaceAll("{-", "{")}";
    input = input.replaceAll("--", "");
  }
  input = tocalculate(input);
  final pattern = RegExp(r'(-)?\\frac\{(\d*)(\\sqrt\{(\d+)\})\}\{(\d*)\}');
  final match = pattern.firstMatch(input);
  if (match != null) {
    String pm = match.group(1) ?? "";
    String ni = match.group(2) ?? "1";
    String ns = match.group(4) ?? "1";
    String di = match.group(5) ?? "1";
    if (ni == "0") {
      return "0";
    }

    if (ns == "1" && di == "1") {
      return "$pm$ni";
    } else if (ns == "1") {
      return "$pm\\frac{$ni}{$di}";
    } else if (di == "1") {
      if (ni == "1") {
        return "$pm\\sqrt{$ns}";
      } else {
        return "$pm$ni\\sqrt{$ns}";
      }
    } else {
      if (ni == "1") {
        return "$pm\\frac{\\sqrt{$ns}}{$di}";
      } else {
        return "$pm\\frac{$ni\\sqrt{$ns}}{$di}";
      }
    }
  } else {
    return "nullやで(finalclean)";
  }
}

List<int> sqrtcrean(int a, int b) //有理化
{
  for (int i = 2; i * i <= b; i++) {
    while (b % (i * i) == 0) {
      b ~/= i * i;
      a *= i;
    }
  }
  return [a, b];
}

int gcd(int a, int b) //約分
{
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a.abs();
}

class ParsedFraction {
  int ni, ns, di;
  ParsedFraction(this.ni, this.ns, this.di);
}

ParsedFraction? parseFraction(String input) //\frac{a\sqrt{b}}{c}を抽出
{
  final pattern = RegExp(r'(-)?\\frac\{(\d*)(\\sqrt\{(\d+)\})\}\{(\d*)\}');
  final match = pattern.firstMatch(input);
  if (match != null) {
    String sign = match.group(1) ?? "";
    int ni = int.parse(match.group(2) ?? "");
    int ns = int.parse(match.group(4) ?? "");
    int di = int.parse(match.group(5) ?? "");
    //マイナスを中に
    ni = (sign == "-") ? -ni : ni;

    return ParsedFraction(ni, ns, di);
  } else {
    return null;
  }
}

String plusminusreplace(String input) {
  input = input.replaceAll("++", "+");
  input = input.replaceAll("+-", "-");
  input = input.replaceAll("-+", "-");
  input = input.replaceAll("--", "+");

  return input;
}

List<List<T>> cartesianProduct<T>(List<List<T>> lists) {
  List<List<T>> results = [[]];

  for (var list in lists) {
    List<List<T>> temp = [];
    for (var result in results) {
      for (var element in list) {
        temp.add([...result, element]);
      }
    }
    results = temp;
  }

  return results;
}

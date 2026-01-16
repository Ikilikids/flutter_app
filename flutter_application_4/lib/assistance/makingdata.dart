import 'dart:math';

import 'package:flutter_application_4/assistance/convertsankaku.dart';
import 'package:flutter_application_4/assistance/latex_to_latex2.dart';
import 'package:flutter_application_4/assistance/parser.dart';

class OriginCentral {
  Map<String, String> ct;
  Map<String, dynamic> numberData;

  OriginCentral({required this.ct, required this.numberData});

  Map<String, dynamic> makingvariable() {
    Map<String, dynamic> result = {
      "ctscore": <int>[],
      "index": <int>[],
      "unindex": <int>[],
    };
    final random = Random();
    List<String> values = [];
    result["lc"] = ct["lc"] ?? "";
    result['st1'] = ct["st1"] ?? "";
    result['st2'] = ct["st2"] ?? "";
    result['st3'] = ct["st3"] ?? "";
    result['dt'] = ct["dt"] ?? "";
    result["fi1"] = ct["fi1"] ?? "";
    result["fi2"] = ct["fi2"] ?? "";
    result["fi3"] = ct["fi3"] ?? "";
    result["usedScoreValue"] = ct["usedScoreValue"] ?? "";
    String mainsort = ct["st1"] ?? "";
    String detailsort = ct["st2"] ?? "";
    String numbersort = ct["st3"] ?? "";
    String dataset = ct["dt"] ?? "";
    if (dataset != "n") {
      List<dynamic> chosednumberDeta = numberData[dataset];
      int chosedList = random.nextInt(chosednumberDeta.length);
      int p = chosednumberDeta[chosedList].length;
      for (int i = 0; i < p; i++) {
        values.add(chosednumberDeta[chosedList][i].toString());
      }
    }
    String s1 = "";
    String s2 = "";
    String ss1 = "";
    String ss2 = "";
    String q1 = "";
    String q2 = "";
    String q3 = "";
    String q4 = "";

    result["fb"] = ct["fb"] ?? "";
    result["button1"] = ct["b1"] ?? "";
    result["button2"] = ct["b2"] ?? "";
    result["button3"] = ct["b3"] ?? "";
    result["button4"] = ct["b4"] ?? "";
    result["scoreA"] = ct["scoreA"] ?? "";
    result["scoreB"] = ct["scoreB"] ?? "";
    result["scoreC"] = ct["scoreC"] ?? "";
    result["scoreD"] = ct["scoreD"] ?? "";
    result["ctchosed"] = ct["usedScore"] ?? "";
    List<String> labels = ['A', 'B', 'C', 'D'];
    for (int i = 0; i < labels.length; i++) {
      String label = labels[i];
      String scoreKey = "score$label";
      if ((result["ctchosed"] ?? "").contains(label)) {
        result["ctscore"].add(int.tryParse(
                result[scoreKey].replaceAll("a", "").replaceAll("b", "") ??
                    "") ??
            0);
        result["index"].add(i);
      } else {
        result["unindex"].add(i);
      }
    }

    if (mainsort == "sekimen") {
      List<List<double>> generatePairs(List<double> numbers,
          {bool skipSame = false}) {
        List<List<double>> result = [];
        for (int i = 0; i < numbers.length; i++) {
          for (int j = 0; j < numbers.length; j++) {
            if (skipSame && i == j) continue;

            double a = numbers[i];
            double b = numbers[j];

            if ((a - b).abs() <= 3) {
              result.add([a, b]);
            }
          }
        }
        return result;
      }

      double a1 = 0;
      double a2 = 0;
      double x1 = 0;
      double y1 = 0;
      double x2 = 0;
      double y2 = 0;

      List<double> anumbers = [];
      List<double> xnumbers = [];
      List<double> ynumbers = [];

      List<double> anumbersint = [-1, 1];
      List<double> xynumbersint = [-4, -3, -2, -1, 0, 1, 2, 3, 4];
      List<double> anumbersfrac = [
        -2.5,
        -1.5,
        -0.5,
        0.5,
        1.5,
        2.5,
        -3,
        -2,
        2,
        3
      ];
      List<double> xnumberssqrt2 = [-2.83, -1.41, 0, 1.41, 2.83];
      List<double> xnumberssqrt3 = [-3.46, -1.73, 0, 1.73, 3.46];
      List<double> ynumberssqrt2 = [0, 1.41, 2.83];
      List<double> ynumberssqrt3 = [0, 1.73, 3.46];
      if (numbersort == "normal") {
        anumbers = anumbersint;
        xnumbers = xynumbersint;
        ynumbers = xynumbersint;
      }
      if (numbersort == "a=frac") {
        anumbers = anumbersfrac;
        xnumbers = xynumbersint;
        ynumbers = xynumbersint;
      }
      if (numbersort == "x=sqrt{2}") {
        anumbers = anumbersint;
        xnumbers = xnumberssqrt2;
        ynumbers = ynumberssqrt2;
      }
      if (numbersort == "x=sqrt{3}") {
        anumbers = anumbersint;
        xnumbers = xnumberssqrt3;
        ynumbers = ynumberssqrt3;
      }
      List<List<double>> xpairs = generatePairs(xnumbers, skipSame: true);
      List<List<double>> ypairs = generatePairs(ynumbers, skipSame: false);
      List<List<double>> apairs = generatePairs(anumbers, skipSame: true);

      for (int attempt = 0; attempt < 1000; attempt++) {
        List<List<double>> xypointlist = [];

        while (true) {
          int xvalue = random.nextInt(xpairs.length);
          int yvalue = random.nextInt(ypairs.length);
          // ランダムに2ペア選ぶ
          List<List<double>> trial = [
            [xpairs[xvalue][0], ypairs[yvalue][0]],
            [xpairs[xvalue][1], ypairs[yvalue][1]]
          ];

          // 両方のpair[0]が負でなければ採用
          if ((trial[0][0] > 1 || trial[0][1] > 0) &&
              (trial[1][0] > 1 || trial[1][1] > 0)) {
            xypointlist = trial;
            break;
          }
        }

        a1 = anumbers[random.nextInt(anumbers.length)];
        x1 = xypointlist[0][0];
        y1 = xypointlist[0][1];
        x2 = xypointlist[1][0];
        y2 = xypointlist[1][1];

        double b1 = ((y1 - y2) / (x1 - x2)) - a1 * (x1 + x2);
        double c1 = y1 - a1 * x1 * x1 - b1 * x1;
        double px1 = -b1 / (2 * a1);
        double py1 = a1 * px1 * px1 + b1 * px1 + c1;
        if (detailsort == 'pd') {
          if (py1.abs() < 4.5 && ((x1 - x2).abs() > 1 || a1.abs() > 1)) {
            break;
          }
        } else if (detailsort == 'pp') {
          int avalue = random.nextInt(apairs.length);
          a1 = apairs[avalue][0];
          a2 = apairs[avalue][1];

          double b1 = ((y1 - y2) / (x1 - x2)) - a1 * (x1 + x2);
          double c1 = y1 - a1 * x1 * x1 - b1 * x1;
          double px1 = -b1 / (2 * a1);
          double py1 = a1 * px1 * px1 + b1 * px1 + c1;
          double b2 = ((y1 - y2) / (x1 - x2)) - a2 * (x1 + x2);
          double c2 = y1 - a2 * x1 * x1 - b2 * x1;
          double px2 = -b2 / (2 * a2);
          double py2 = a2 * px2 * px2 + b2 * px2 + c2;
          if (py1.abs() < 4.5 &&
              py2.abs() < 4.5 &&
              ((x1 - x2).abs() > 1 || (a1 - a2).abs() > 1)) {
            result["a2"] = dtol(a2);
            break;
          }
        } else if (detailsort == 'pss') {
          double m = (x1 + x2) / 2;
          double la = 2 * a1 * x1 + b1;
          double lb = y1 - la * x1;
          double k = m * la + lb;
          if (k.abs() < 4.5 && ((x1 - x2).abs() > 1 || (a1 - a2).abs() > 1)) {
            break;
          }
        } else if (detailsort == 'pps') {
          double m = (x1 + x2) / 2;
          double b1 = ((y1 - y2) / (x1 - x2)) - 2 * a1 * x1;
          double c1 = y1 - a1 * x1 * x1 - b1 * x1;
          double k = m * m * a1 + m * b1 + c1;
          if (k.abs() < 4.5 && ((x1 - x2).abs() > 1 || a1.abs() > 1)) {
            break;
          }
        } else if (detailsort == 'psd') {
          double b1 = ((y1 - y2) / (x1 - x2)) - 2 * a1 * x1;
          double c1 = y1 - a1 * x1 * x1 - b1 * x1;
          double k = a1 * x2 * x2 + b1 * x2 + c1;

          if (k.abs() < 4.5 && ((x1 - x2).abs() > 1 || a1.abs() > 1)) {
            break;
          }
        } else if (detailsort == 'cs' && y1 >= 0) {
          double b1 = -a1 * (2.0 * x1 + x2);
          double c1 = (a1 * (x1 * x1 * x1 + x1 * x1 * x2 - 2 * x1 * x2 * x2) +
                  y1 -
                  y2) /
              (x1 - x2);
          double d1 = (-a1 * x1 * x1 * x1 * x2 +
                  a1 * x1 * x1 * x2 * x2 +
                  x1 * y2 -
                  x2 * y1) /
              (x1 - x2);
          double A = 3.0 * a1;
          double B = 2.0 * b1;
          double C = c1;

          double discriminant = B * B - 4 * A * C;

          if (discriminant < 0 && ((x1 - x2).abs() != 1 || a1.abs() != 1)) {
            break;
          }

          double sqrtD = sqrt(discriminant);
          double sx1 = (-B + sqrtD) / (2 * A);
          double sx2 = (-B - sqrtD) / (2 * A);

          double sfx1 = a1 * pow(sx1, 3) + b1 * pow(sx1, 2) + c1 * sx1 + d1;
          double sfx2 = a1 * pow(sx2, 3) + b1 * pow(sx2, 2) + c1 * sx2 + d1;
          if (sfx1.abs() < 4.5 &&
              sfx2.abs() < 4.5 &&
              ((x1 - x2).abs() > 1 || a1.abs() > 1)) {
            break;
          }
        }
      }
      result["a1"] = dtol(a1);
      result["a2"] = dtol(a2);
      result["points"] = [
        [dtol(x1), dtol(y1)],
        [dtol(x2), dtol(y2)]
      ];
      String aDiff = "(${dtol(a1)}-${dtol(a2)})^z";
      String xDiff = "(${dtol(x1)}-${dtol(x2)})^z";

      switch (detailsort) {
        case 'pd':
          s1 = lc("$aDiff*(1/6)*($xDiff)^3");
          break;
        case 'pp':
          s1 = lc("$aDiff*(1/6)^z*($xDiff)^3");
          break;
        case 'pss':
        case 'pps':
          s1 = lc("$aDiff*(1/12)*($xDiff)^3");
          break;
        case 'psd':
          s1 = lc("$aDiff*(1/3)*($xDiff)^3");
          break;
        case 'cs':
          s1 = lc("$aDiff*(1/12)*($xDiff)^4");
          break;
      }
      s2 = s1;
      ss1 = "S=[$s1]";
      ss2 = "S=[$s2]";
    } else if (mainsort == "pointlined") {
      final List<int> nonZeroRange = [-4, -3, -2, -1, 1, 2, 3, 4];
      for (int attempt = 0; attempt < 1000; attempt++) {
        List<int> values = List.generate(
            5, (_) => nonZeroRange[random.nextInt(nonZeroRange.length)]);
        int x = 0;
        int y = 0;
        if ((numbersort == "x=0_y=0")) {
          x = 0;
          y = 0;
        } else if ((numbersort == "x!=0_y=0")) {
          if (values[0] % 2 == 0) {
            x = 0;
            y = values[1].abs();
          } else {
            x = values[1];
            y = 0;
          }
        } else if ((numbersort == "x!=0_y!=0")) {
          x = values[0];
          y = values[1].abs();
        }
        int a, b;
        do {
          a = randomint(-5, 5);
          b = randomint(-5, 5);
        } while (hasSquareFactor(a * a + b * b) || a == 0 || b == 0);
        int c = randomint(-5, 5);

        // 条件チェック（例）
        double kx = (b * b * x - a * c - a * b * y) / (a * a + b * b);
        double ky = (-a / b) * kx - (c / b);
        if ((kx.abs() < 4.5) &&
            (ky.abs() < 4.5) &&
            (((a * x + b * y + c).abs() / sqrt(a * a + b * b)) > 1)) {
          String sx = x.toString();
          String sy = y.toString();
          String sa = a.toString();
          String sb = b.toString();
          String sc = c.toString();
          s1 = lc("($sa*$sx+$sb*$sy+$sc)^z/(($sa^2+$sb^2)^0.5)");
          result["x"] = x.toString();
          result["y"] = y.toString();
          result["a"] = a.toString();
          result["b"] = b.toString();
          result["c"] = c.toString();
          break;
        }
      }

      s2 = returnsqrt(s1);
      ss1 = "d=[$s1]";
      ss2 = "d=[$s2]";
    } else if (mainsort == "hyperbola" || mainsort == "ellipse") {
      int a = 0;
      int b = 0;
      int c = 0;

      for (int attempt = 0; attempt < 1000; attempt++) {
        List<int> values = List.generate(3, (_) => random.nextInt(9) + 1);
        if ((numbersort == "c=1")) {
          c = 1;
        } else if ((numbersort == "c!=1")) {
          c = values[2] == 1 ? random.nextInt(8) + 2 : values[2];
        }

        a = values[0];
        b = values[1];

        if (((a * a + b * b) * c <= 100) && a != b) {
          break;
        }
      }
      String sa = a.toString();
      String sb = b.toString();
      String sc = c.toString();
      String scala = lc("$sa*$sc^0.5");
      String scalb = lc("$sb*$sc^0.5");
      String sf = "";
      String sxTerm = a == 1 ? "x^2" : "${lc("1/$sa^2")}x^2";
      String syTerm = b == 1 ? "y^2" : "${lc("1/$sb^2")}y^2";
      String sz = lc("$sb/$sa");

      if (mainsort == "hyperbola") {
        c = random.nextBool() ? c : -c;
        sf = lc("($scala^2+$scalb^2)^0.5");
        q1 = "$sxTerm - $syTerm = $c";
        switch (detailsort) {
          case "vertex":
            if (c > 0) {
              ss1 = "頂点：([$scala],[0])([${toM(scala)}],[0])";
              ss2 = "頂点：([${toM(scala)}],[0])([$scala],[0])";
            } else if (c < 0) {
              ss1 = "頂点：([0],[$scalb])([0],[${toM(scalb)}])";
              ss2 = "頂点：([0],[${toM(scalb)}])([0],[$scalb])";
            }
            break;
          case "asymptote":
            ss1 = "\\small{漸近線：y=[$sz]" "x,y=[${toM(sz)}]" "x}";
            ss2 = "\\small{漸近線：y=[${toM(sz)}]" "x,y=[$sz]" "x}";
            break;
          case "focus":
            if (c > 0) {
              ss1 = "焦点：([$sf],[0])([${toM(sf)}],[0])";
              ss2 = "焦点：([${toM(sf)}],[0])([$sf],[0])";
            } else if (c < 0) {
              ss1 = "焦点：([0],[$sf])([0],[${toM(sf)}])";
              ss2 = "焦点：([0],[${toM(sf)}])([0],[$sf])";
            }
            break;
        }
      } else if (mainsort == "ellipse") {
        sf = lc("($scala^2-$scalb^2)^0.5z");
        q1 = "$sxTerm + $syTerm = $c";
        switch (detailsort) {
          case 'long':
            if (a > b) {
              ss1 = "長軸：[${lc("2*$scala")}]";
            } else if (a < b) {
              ss1 = "長軸：[${lc("2*$scalb")}]";
            }
            ss2 = ss1;
            break;
          case 'short':
            if (a > b) {
              ss1 = "短軸：[${lc("2*$scalb")}]";
            } else if (a < b) {
              ss1 = "短軸：[${lc("2*$scala")}]";
            }
            ss2 = ss1;
            break;
          case "focus":
            if (a > b) {
              ss1 = "焦点：([$sf],[0])([${toM(sf)}],[0])";
              ss2 = "焦点：([${toM(sf)}],[0])([$sf],[0])";
            } else if (a < b) {
              ss1 = "焦点：([0],[$sf])([0],[${toM(sf)}])";
              ss2 = "焦点：([0],[${toM(sf)}])([0],[$sf])";
            }
            break;
          case 'area':
            ss1 = "面積S：[${lc("$scala*$scalb")}\\pi]";
            ss2 = ss1;
            break;
        }
      }
    } else if (mainsort == "parabora") {
      int a = 0;
      int b = 0;
      int c = 0;
      final List<int> nonZeroRange = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];

      List<int> values = List.generate(
          3, (_) => nonZeroRange[random.nextInt(nonZeroRange.length)]);
      if ((numbersort == "a=0_b=0")) {
        a = 0;
        b = 0;
      } else if ((numbersort == "a!=0_b=0")) {
        if (values[0] > 0) {
          a = 0;
          b = values[1];
        } else {
          a = values[1];
          b = 0;
        }
      } else if ((numbersort == "a!=0_b!=0")) {
        a = values[0];
        b = values[1];
      }
      c = values[2];

      final options = ['x^2', 'y^2'];
      final xory = options[random.nextInt(2)];
      String sa = a.toString();
      String sb = b.toString();
      String sc = c.toString();
      String skTerm = normalize(sc);
      String sp = lc("$sc/4");
      if (xory == "y^2") {
        String sxTerm = sa == "0"
            ? "x"
            : sc == "1"
                ? plusminusreplace("x-$sa")
                : plusminusreplace("(x-$sa)");
        String syTerm = sb == "0" ? "y^2" : plusminusreplace("(y-$sb)^2");
        q1 = "$syTerm = $skTerm$sxTerm";
        if (detailsort == "directrix") {
          ss1 = "準線：x=[${lc("$sa-$sp")}]";
        } else if (detailsort == "focus") {
          ss1 = "焦点：([${lc("$sa+$sp")}],[$sb])";
        }
      }
      if (xory == "x^2") {
        String syTerm = sa == "0"
            ? "y"
            : sc == "1"
                ? plusminusreplace("y-$sa")
                : plusminusreplace("(y-$sa)");
        String sxTerm = sb == "0" ? "x^2" : plusminusreplace("(x-$sb)^2");
        q1 = "$sxTerm = $skTerm$syTerm";
        if (detailsort == "directrix") {
          ss1 = "準線：y=[${lc("$sa-$sp")}]";
        } else if (detailsort == "focus") {
          ss1 = "焦点：([$sb],[${lc("$sa+$sp")}])";
        }
      }
      ss2 = ss1;
    } else if (mainsort == "solandcoe") {
      final List<int> nonZeroRange = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
      int a = 0;
      int b = 0;
      int c = 0;
      for (int attempt = 0; attempt < 1000; attempt++) {
        List<int> values = List.generate(
            3, (_) => nonZeroRange[random.nextInt(nonZeroRange.length)]);
        a = 0;
        if (numbersort == "a=1") {
          a = 1;
        } else {
          a = values[0];
        }
        b = values[1];
        c = values[2];
        if (b * b - 4 * a * c > 0) {
          break;
        }
      }
      String sa = a.toString();
      String sb = b.toString();
      String sc = c.toString();
      q1 = "${makingFanction2D(sa, sb, sc)}=0;解を\\alpha,\\betaとすると,";
      String sum = lc("-$sb/$sa");
      String times = lc("$sc/$sa");
      if (detailsort == "p+q") {
        ss1 = "\\alpha+\\beta=[$sum]";
      } else if (detailsort == "pq") {
        ss1 = "\\alpha\\beta=[$times]";
      } else if (detailsort == "p^2+q^2") {
        String result = lc("$sum^2-2*$times");
        ss1 =
            "\\alpha+\\beta=[$sum],\\alpha\\beta=[$times];\\alpha^2+\\beta^2=[$result]";
      } else if (detailsort == "|p-q|") {
        String result = lc("($sum^2-4*$times)^0.5z");
        ss1 =
            "\\alpha+\\beta=[$sum],\\alpha\\beta=[$times];|\\alpha-\\beta|=[$result]";
      } else if (detailsort == "(p+1)(q+1)") {
        String result = lc("$sum+$times+1");
        ss1 =
            "\\alpha+\\beta=[$sum],\\alpha\\beta=[$times];(\\alpha+1)(\\beta+1)=[$result]";
      } else if (detailsort == "(p-1)(q-1)") {
        String result = lc("$times-$sum+1");
        ss1 =
            "\\alpha+\\beta=[$sum],\\alpha\\beta=[$times];(\\alpha-1)(\\beta-1)=[$result]";
      } else if (detailsort == "1/p+1/q") {
        String result = lc("$sum/$times");
        ss1 =
            "\\alpha+\\beta=[$sum],\\alpha\\beta=[$times];\\frac{1}{\\alpha}+\\frac{1}{\\beta}=[$result]";
      }

      ss2 = ss1;
    } else if (mainsort == "squarecomp") {
      final List<int> nonZeroRange = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
      int a = 0;
      int b = 0;
      int c = 0;
      for (int attempt = 0; attempt < 1000; attempt++) {
        List<int> values = List.generate(
            3, (_) => nonZeroRange[random.nextInt(nonZeroRange.length)]);
        a = values[0];
        if (numbersort == "a=1") {
          a = 1;
        }
        b = values[1];
        c = values[2];
        if (b * b - 4 * a * c != 0) {
          break;
        }
      }

      String sa = a.toString();
      String sb = b.toString();
      String sc = c.toString();
      String na = normalize(sa);
      q1 = "y=${makingFanction2D(sa, sb, sc)};平方完成すると,";
      String p = lc("$sb/(2*$sa)");
      String pm = p.startsWith("-") ? "-" : "+";
      p = p.replaceFirst("-", "");
      String q = lc("$sc-$p^2*$sa");
      String qm = q.startsWith("-") ? "-" : "+";
      q = q.replaceFirst("-", "");
      if (detailsort == "p") {
        ss1 = "y=$na\\left(x[$pm][$p]\\right)^2$qm$q";
      } else if (detailsort == "q") {
        ss1 = "y=$na\\left(x$pm$p\\right)^2[$qm][$q]";
      } else if (detailsort == "pq") {
        ss1 = "y=$na\\left(x[$pm][$p]\\right)^2[$qm][$q]";
      }
      ss2 = ss1;
    } else if (mainsort == "doublesqrt") {
      List<List<int>> validPairs = [];
      for (int a = 1; a <= 9; a++) {
        for (int b = a + 1; b <= 10; b++) {
          int product = a * b;
          if (!hasSquareFactor(product)) {
            validPairs.add([a, b]);
          }
        }
      }
      List<int> pair = validPairs[random.nextInt(validPairs.length)];
      int a = pair[0];
      int b = pair[1];

      int c = int.parse(numbersort);
      int sum = a + b;
      int times = a * b;
      q1 = "\\sqrt{${sum * c}+${2 * c}\\sqrt{$times}}";
      ss1 = "[${lc("\\sqrt{${b * c}}+0")}]+[${lc("\\sqrt{${a * c}}+0")}]";

      ss2 = "[${lc("\\sqrt{${a * c}}+0")}]+[${lc("\\sqrt{${b * c}}+0")}]";
    } else if (mainsort == "sekiwa") {
      int a, b;
      do {
        a = randomint(1, 5);
        b = randomint(1, 5);
      } while (a == b || a + b == 1 || (a - b).abs() == 1);
      String sa = normalize("$a");
      String sb = normalize("$b");
      int p = randomint(1, 4);
      if (p == 1) {
        q1 = "\\sin(${sa}x)\\cos(${sb}x)";
      } else if (p == 2) {
        q1 = "\\cos(${sa}x)\\sin(${sb}x)";
      } else if (p == 4) {
        q1 = "\\cos(${sa}x)\\cos(${sb}x)";
      } else if (p == 3) {
        q1 = "\\sin(${sa}x)\\sin(${sb}x)";
      }
      List<String> part = [];
      String sum = "${a + b}";
      String minus = "${a - b}";
      if (p == 1 || p == 2 || p == 4) {
        part.add("\\frac{1}{2}");
      } else if (p == 3) {
        part.add("-\\frac{1}{2}");
      }
      if (p == 1 || p == 2) {
        part.add("\\left\\{[\\sin]");
        part.add("[\\sin]");
      } else if (p == 4 || p == 3) {
        part.add("\\left\\{[\\cos]");
        part.add("[\\cos]");
      }
      if (p == 1 || p == 4) {
        part.insert(2, "+");
      } else if (p == 2 || p == 3) {
        part.insert(2, "-");
      }
      part.insert(2, sum);
      part.add(minus);
      if (detailsort == "2s+s") {
        part[0] = "[${part[0]}]";
        part[3] = "[${part[3]}]";
        part[2] = "(${part[2]}x)";
        if (part[5].contains("-")) {
          part[5] = "(\\mathord{-}${abs(part[5])}x)";
        } else {
          part[5] = "(${part[5]}x)";
        }
      } else if (detailsort == "s1s1") {
        part[2] = "([${part[2]}]x)";
        if (part[5].contains("-")) {
          part[5] = "(\\mathord{-}[${abs(part[5])}]x)";
        } else {
          part[5] = "([${part[5]}]x)";
        }
      }

      ss1 = part.join();
      ss1 = "\\small $ss1\\right\\}";
      if (part[3] == "+" && !part[5].contains("-")) {
        var temp = part[2];
        part[2] = part[5];
        part[5] = temp;
        ss2 = part.join();
      } else {
        ss2 = ss1;
      }
    } else if (mainsort == "waseki") {
      int a, b;
      do {
        a = randomint(1, 5);
        b = randomint(1, 5);
      } while (a == b || a + b == 2 || (a - b).abs() == 2);
      String sa = normalize("$a");
      String sb = normalize("$b");
      int p = randomint(1, 4);
      if (p == 1) {
        q1 = "\\sin(${sa}x)+\\sin(${sb}x)";
      } else if (p == 2) {
        q1 = "\\sin(${sa}x)-\\sin(${sb}x)";
      } else if (p == 3) {
        q1 = "\\cos(${sa}x)+\\cos(${sb}x)";
      } else if (p == 4) {
        q1 = "\\cos(${sa}x)-\\cos(${sb}x)";
      }
      List<String> part = [];
      String sum = normalize(lc("($a+$b)/2"));
      String minus = normalize(lc("($a-$b)/2"));

      if (p == 1 || p == 2 || p == 3) {
        part.add("2");
      } else if (p == 4) {
        part.add("-2");
      }
      if (p == 1) {
        part.add("[\\sin]");
        part.add("[\\cos]");
      } else if (p == 2) {
        part.add("[\\cos]");
        part.add("[\\sin]");
      } else if (p == 3) {
        part.add("[\\cos]");
        part.add("[\\cos]");
      } else if (p == 4) {
        part.add("[\\sin]");
        part.add("[\\sin]");
      }
      part.insert(2, sum);
      part.add(minus);
      if (detailsort == "1/2ss") {
        part[0] = "[${part[0]}]";
        part[2] = "\\left(${part[2]}x\\right)";
        if (part[4].contains("-")) {
          part[4] = "\\left(\\mathord{-}${abs(part[4])}x\\right)";
        } else {
          part[4] = "\\left(${part[4]}x\\right)";
        }
      } else if (detailsort == "s1s1") {
        part[2] = "\\left([${part[2]}]x\\right)";
        if (part[4].contains("-")) {
          part[4] = "\\left(\\mathord{-}[${abs(part[4])}]x\\right)";
        } else {
          part[4] = "\\left([${part[4]}]x\\right)";
        }
      }

      ss1 = part.join();
      ss1 = "\\small $ss1";
      if (!part[4].contains("-")) {
        var temp1 = part[2];
        part[2] = part[4];
        part[4] = temp1;
        var temp2 = part[1];
        part[1] = part[3];
        part[3] = temp2;
        ss2 = part.join();
      } else {
        ss2 = ss1;
      }
    } else if (mainsort == "sgousei") {
      List<List<String>> origin = [
        ["\\sqrt{2}", "\\sqrt{2}"],
        ["1", "\\sqrt{3}"],
        ["\\sqrt{3}", "1"]
      ];

      List<String> multiple1 = ["2", "3"];
      List<String> multiple2 = ["\\sqrt{2}", "\\sqrt{3}", "\\frac{1}{3}"];
      List<String> selected1 = origin[0];
      List<String> selected2 = origin[randomint(1, 2)];

      String a, b;

      selected1[0] = random.nextBool() ? selected1[0] : "-${selected1[0]}";
      selected1[1] = random.nextBool() ? selected1[1] : "-${selected1[1]}";
      selected2[0] = random.nextBool() ? selected2[0] : "-${selected2[0]}";
      selected2[1] = random.nextBool() ? selected2[1] : "-${selected2[1]}";

      if (numbersort == "r=1_z=pi/4") {
        a = selected1[0];
        b = selected1[1];
      } else if (numbersort == "r=l2_z=pi/4") {
        String howmult = multiple1[random.nextInt(multiple1.length)];
        a = lc("${selected1[0]}*$howmult");
        b = lc("${selected1[1]}*$howmult");
      } else if (numbersort == "r=l3_z=pi/4") {
        String howmult = multiple2[random.nextInt(multiple1.length)];
        a = lc("${selected1[0]}*$howmult");
        b = lc("${selected1[1]}*$howmult");
      } else if (numbersort == "r=1_z=pi/6") {
        a = selected2[0];
        b = selected2[1];
      } else if (numbersort == "r=l2_z=pi/6") {
        String howmult = multiple1[random.nextInt(multiple1.length)];
        a = lc("${selected2[0]}*$howmult");
        b = lc("${selected2[1]}*$howmult");
      } else {
        String howmult = multiple2[random.nextInt(multiple1.length)];
        a = lc("${selected2[0]}*$howmult");
        b = lc("${selected2[1]}*$howmult");
      }
      String sa = normalize(a);
      String sb = normalize(b);
      q1 =
          "-\\pi\\leqq\\alpha\\leqq\\piのとき;${plusminusreplace("$sa\\sin(x)+$sb\\cos(x)")}";
      String f = normalize("${lc("($a^2+$b^2)^0.5")}");
      String z = "${lc("$a/$f")}";
      String pm = b.contains("-") ? "-" : "+";
      z = acos(z);
      z = normalize(z);
      ss1 = "[$f]\\sin\\left(x[$pm][$z]\\right)";
      ss2 = ss1;
    } else if (mainsort == "cpn") {
      int a = random.nextInt(7);
      int b = a + random.nextInt(7 - a);
      if (detailsort == "c") {
        q1 = "\\huge{}_$b C_$a";
        ss1 = "\\huge[${combination(b, a)}]";
      } else if (detailsort == "p") {
        q1 = "\\huge{}_$b P_$a";
        ss1 = "\\huge[${permutation(b, a)}]";
      } else if (detailsort == "n") {
        q1 = "\\huge{}$a!";
        ss1 = "\\huge[${factorial(a)}]";
      }
      ss2 = ss1;
    } else if (mainsort == "log") {
      List<String> candidates = ["2", "3", "5", "6", "7", "10"];
      String origin = candidates[random.nextInt(candidates.length)];
      List<String> items = [];
      if (["2", "3"].contains(origin)) {
        items = ["2", "3", "4", "5"];
      } else {
        items = ["2", "3"];
      }
      items.shuffle(random);
      String first = items[0];
      String second = items[1];
      String a = "";
      String b = "";
      String c = "";
      String d = "";
      if (detailsort == "1") {
        a = origin;
        c = "1";
      } else if (detailsort == "i") {
        a = "${lc("$origin^$first")}";
        c = first;
      } else if (detailsort == "f") {
        a = "${lc("1/$origin^$first")}";
        c = "-$first";
      } else if (detailsort == "s") {
        a = "${lc("$origin^($first-2)*$origin^0.5")}";
        c = "${lc("$first-\\frac{3}{2}")}";
      }
      if (numbersort == "i") {
        b = "${lc("$origin^$second")}";
        d = second;
      } else if (numbersort == "f") {
        b = "${lc("1/$origin^$second")}";
        d = "-$second";
      } else if (numbersort == "s") {
        b = "${lc("$origin^($second-2)*$origin^0.5")}";
        d = "${lc("$second-\\frac{3}{2}")}";
      }
      q1 = "\\Large\\log_{$a}{$b}";
      ss1 = "\\Large[${lc("$d/$c")}]";
      ss2 = ss1;
    } else if (mainsort == "distance") {
      List<int> numbers = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
      int d = 0;
      int x1 = 0;
      int y1 = 0;
      int x2 = 0;
      int y2 = 0;
      for (int attempt = 0; attempt < 1000; attempt++) {
        numbers.shuffle(random);
        x1 = numbers[0];
        y1 = numbers[1];
        x2 = numbers[2];
        y2 = numbers[3];
        int xdiff = (x1 - x2).abs();
        int ydiff = (y1 - y2).abs();
        d = xdiff * xdiff + ydiff * ydiff;
        if (numbersort == "d<40" && d < 40) {
          break;
        } else if (numbersort == "40<d<100" && 40 <= d && d < 100) {
          break;
        }
      }
      String sd = "${lc("$d^0.5")}";
      if (detailsort == "normal") {
        q1 = "\\small 2点A,Bについて、;\\small A($x1,$y1),B($x2,$y2)のとき";
        ss1 = "AB=[$sd]";
      }
      if (detailsort == "vector") {
        q1 =
            "\\footnotesize 2点A(\\overrightarrow{a}),B(\\overrightarrow{b})について、;\\scriptsize\\overrightarrow{a}=($x1,$y1),\\overrightarrow{b}=($x2,$y2)のとき";
        ss1 = "|\\overrightarrow{AB}|=[$sd]";
      }
      if (detailsort == "imaginary") {
        q1 =
            "\\footnotesize 複素数平面上の2点A(\\alpha),B(\\beta);${plusminusreplace("\\scriptsize\\alpha=$x1+${y1}i,\\beta=$x2+${y2}iのとき")}";
        q1 = q1.replaceAll("1i", "i");
        ss1 = "AB=[$sd]";
      }
      ss2 = ss1;
    } else if (mainsort == "divide") {
      List<List<String>> origin = [];
      if (numbersort == "1:1") {
        origin = [
          ["1", "1"],
        ];
      }
      if (numbersort == "1:q") {
        origin = [
          ["1", "2"],
          ["1", "3"],
          ["1", "4"],
        ];
      }
      if (numbersort == "p:q") {
        origin = [
          ["2", "3"],
          ["3", "4"],
        ];
      }
      List<String> selected = origin[random.nextInt(origin.length)];
      if (random.nextBool()) {
        selected = [selected[1], selected[0]];
      }
      if (detailsort == "g") {
        int indexToNegate = random.nextInt(2);
        selected[indexToNegate] = "-${selected[indexToNegate]}";
      }
      String m = selected[0];
      String n = selected[1];
      List<int> numbers = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
      numbers.shuffle(random);
      int x1 = numbers[0];
      int y1 = numbers[1];
      int x2 = numbers[2];
      int y2 = numbers[3];
      String answer = "";
      q1 = "\\small A($x1,$y1),B($x2,$y2)のとき";
      if (detailsort == "n" && numbersort == "1:1") {
        q1 = "$q1;ABの中点P";
        answer =
            "\\left([${lc("($n*$x1+$m*$x2)/($m+$n)")}],[${lc("($n*$y1+$m*$y2)/($m+$n)")}]\\right)";
      } else if (detailsort == "n") {
        q1 = "$q1;\\small ABを$m:$nに内分する点P";
        answer =
            "\\left([${lc("($n*$x1+$m*$x2)/($m+$n)")}],[${lc("($n*$y1+$m*$y2)/($m+$n)")}]\\right)";
      } else if (detailsort == "g") {
        m = m.replaceAll("-", "");
        n = n.replaceAll("-", "");
        q1 = "$q1;\\small ABを$m:$nに外分する点P";
        answer =
            "\\left([${lc("(-$n*$x1+$m*$x2)/($m-$n)")}],[${lc("(-$n*$y1+$m*$y2)/($m-$n)")}]\\right)";
      }

      ss1 = "P:$answer";
      ss2 = ss1;
    } else if (mainsort == "sct1") {
      List<String> degreeList = [
        "0",
        "30",
        "45",
        "60",
        "90",
        "120",
        "135",
        "150",
        "180",
      ];

      List<String> funcList = ["sin", "cos", "tan"];

      String degree;
      String func;

      do {
        degree = degreeList[random.nextInt(degreeList.length)];
        func = funcList[random.nextInt(funcList.length)];
      } while (func == "tan" &&
          (degree == "90" || degree == "270")); // 追加で270など入れてもOK

      q1 = "\\LARGE\\$func $degree^\\circ";

      switch (func) {
        case "sin":
          s1 = vsin(degree);
          break;
        case "cos":
          s1 = vcos(degree);
          break;
        case "tan":
          s1 = vtan(degree);
          break;
      }
      ss1 = "\\LARGE[$s1]";
      ss2 = "\\LARGE[${returnsqrt(s1)}]";
    } else if (mainsort == "sct2") {
      List<String> angleList;

      switch (numbersort) {
        case "0<z<180":
          // 0〜180 弧度法のみ
          angleList = [
            "30",
            "45",
            "60",
            "90",
            "120",
            "135",
            "150",
            "\\frac{\\pi}{6}",
            "\\frac{\\pi}{4}",
            "\\frac{\\pi}{3}",
            "\\frac{\\pi}{2}",
            "\\frac{2\\pi}{3}",
            "\\frac{3\\pi}{4}",
            "\\frac{5\\pi}{6}",
          ];
          break;

        case "180<p<360":
          // 210〜360 度数法＋弧度法混合
          angleList = [
            "210",
            "225",
            "240",
            "270",
            "300",
            "315",
            "330",
            "\\frac{7\\pi}{6}",
            "\\frac{5\\pi}{4}",
            "\\frac{4\\pi}{3}",
            "\\frac{3\\pi}{2}",
            "\\frac{5\\pi}{3}",
            "\\frac{7\\pi}{4}",
            "\\frac{11\\pi}{6}",
          ];
          break;

        case "-360<p<0":
          // -30〜-360 度数法＋弧度法混合 (注意：角度は負の順番でリストを用意)
          angleList = [
            "-30",
            "-45",
            "-60",
            "-90",
            "-120",
            "-135",
            "-150",
            "-\\frac{\\pi}{6}",
            "-\\frac{\\pi}{4}",
            "-\\frac{\\pi}{3}",
            "-\\frac{\\pi}{2}",
            "-\\frac{2\\pi}{3}",
            "-\\frac{3\\pi}{4}",
            "-\\frac{5\\pi}{6}",
            "-210",
            "-225",
            "-240",
            "-270",
            "-300",
            "-315",
            "-330",
            "-\\frac{7\\pi}{6}",
            "-\\frac{5\\pi}{4}",
            "-\\frac{4\\pi}{3}",
            "-\\frac{3\\pi}{2}",
            "-\\frac{5\\pi}{3}",
            "-\\frac{7\\pi}{4}",
            "-\\frac{11\\pi}{6}",
          ];
          break;

        case "360<p<720":
          // 390〜720 度数法＋弧度法混合
          angleList = [
            "\\frac{13\\pi}{6}",
            "\\frac{7\\pi}{3}",
            "\\frac{15\\pi}{6}",
            "\\frac{8\\pi}{3}",
            "\\frac{19\\pi}{6}",
            "\\frac{11\\pi}{3}",
            "\\frac{23\\pi}{6}",
            "\\frac{13\\pi}{6}",
            "\\frac{9\\pi}{4}",
            "\\frac{7\\pi}{3}",
            "\\frac{5\\pi}{2}",
            "\\frac{8\\pi}{3}",
            "\\frac{11\\pi}{4}",
            "\\frac{17\\pi}{6}",
            "\\frac{19\\pi}{6}",
            "\\frac{13\\pi}{4}",
            "\\frac{10\\pi}{3}",
            "\\frac{7\\pi}{2}",
            "\\frac{11\\pi}{3}",
            "\\frac{15\\pi}{4}",
            "\\frac{23\\pi}{6}",
          ];
          break;

        case "-720<p<-360":
          // -390〜-720 度数法＋弧度法混合 (負の範囲)
          angleList = [
            "-\\frac{13\\pi}{6}",
            "-\\frac{7\\pi}{3}",
            "-\\frac{15\\pi}{6}",
            "-\\frac{8\\pi}{3}",
            "-\\frac{19\\pi}{6}",
            "-\\frac{11\\pi}{3}",
            "-\\frac{23\\pi}{6}",
            "-\\frac{13\\pi}{6}",
            "-\\frac{9\\pi}{4}",
            "-\\frac{7\\pi}{3}",
            "-\\frac{5\\pi}{2}",
            "-\\frac{8\\pi}{3}",
            "-\\frac{11\\pi}{4}",
            "-\\frac{17\\pi}{6}",
            "-\\frac{19\\pi}{6}",
            "-\\frac{13\\pi}{4}",
            "-\\frac{10\\pi}{3}",
            "-\\frac{7\\pi}{2}",
            "-\\frac{11\\pi}{3}",
            "-\\frac{15\\pi}{4}",
            "-\\frac{23\\pi}{6}",
          ];
          break;

        default:
          angleList = [];
      }

      List<String> funcList = ["sin", "cos", "tan"];

      String angle;
      String func;
      bool isUndefinedTanAngle(String angle) {
        const undefinedAngles = {
          "90",
          "270",
          "450",
          "630",
          "-90",
          "-270",
          "-450",
          "-630",
          "\\frac{\\pi}{2}",
          "\\frac{3\\pi}{2}",
          "\\frac{5\\pi}{2}",
          "\\frac{7\\pi}{2}",
          "-\\frac{\\pi}{2}",
          "-\\frac{3\\pi}{2}",
          "-\\frac{5\\pi}{2}",
          "-\\frac{7\\pi}{2}",
        };
        return undefinedAngles.contains(angle);
      }

      do {
        angle = angleList[random.nextInt(angleList.length)];
        func = funcList[random.nextInt(funcList.length)];
      } while (func == "tan" && isUndefinedTanAngle(angle));
      if (angle.contains("\\pi") && angle.contains("-")) {
        q1 =
            "\\LARGE\\$func \\left(\\mathord{-}${angle.replaceAll("-", "")}\\right)";
      } else if (angle.contains("\\pi")) {
        q1 = "\\LARGE\\$func \\left($angle\\right)";
      } else if (angle.contains("-")) {
        q1 = "\\LARGE\\$func (\\mathord{-}${angle.replaceAll("-", "")}^\\circ)";
      } else {
        q1 = "\\LARGE\\$func $angle^\\circ";
      }
      angle = radtodeg(angle);

      String value;
      switch (func) {
        case "sin":
          value = vsin(angle);
          break;
        case "cos":
          value = vcos(angle);
          break;
        case "tan":
          value = vtan(angle);
          break;
        default:
          value = "未知";
      }

      ss1 = "\\LARGE[$value]";
      ss2 = "\\LARGE[${returnsqrt(value)}]";
    } else if (mainsort == "domorebul") {
      List<List<String>> origin = [
        ["\\sqrt{2}", "\\sqrt{2}"],
        ["1", "\\sqrt{3}"],
        ["\\sqrt{3}", "1"]
      ];

      List<String> multiple1 = ["2", "\\sqrt{2}"];
      List<String> selected1 = origin[0];
      List<String> selected2 = origin[randomint(1, 2)];

      String a, b;

      selected1[0] = random.nextBool() ? selected1[0] : "-${selected1[0]}";
      selected1[1] = random.nextBool() ? selected1[1] : "-${selected1[1]}";
      selected2[0] = random.nextBool() ? selected2[0] : "-${selected2[0]}";
      selected2[1] = random.nextBool() ? selected2[1] : "-${selected2[1]}";

      if (numbersort == "r=1_z=pi/4") {
        a = selected1[0];
        b = selected1[1];
      } else if (numbersort == "r=l2_z=pi/4") {
        String howmult = multiple1[random.nextInt(multiple1.length)];
        a = lc("${selected1[0]}*$howmult");
        b = lc("${selected1[1]}*$howmult");
      } else if (numbersort == "r=1_z=pi/6") {
        a = selected2[0];
        b = selected2[1];
      } else {
        String howmult = multiple1[random.nextInt(multiple1.length)];
        a = lc("${selected2[0]}*$howmult");
        b = lc("${selected2[1]}*$howmult");
      }
      String sb = normalize(b);
      int n = 0;
      if (detailsort == "z^3-4") {
        n = random.nextInt(2) + 3;
      } else if (detailsort == "z^5-6") {
        n = random.nextInt(2) + 5;
      }
      q1 =
          "${plusminusreplace("z=$a+${sb}i")};\\small 0\\leqq arg(z^$n)<2\\piとすると";
      String f = "${lc("($a^2+$b^2)^0.5")}";
      String z = "${lc("$a/$f")}";
      String ff = lc("$f^$n");
      String pm = b.contains("-") ? "-" : "";
      z = "$pm${acos(z)}";
      z = radtodeg(z);
      z = lc("$z*$n");
      z = normalizedegree(z);
      z = degtorad(z);
      z = z == "2\\pi" ? "0" : z;
      ss1 = "|z^$n|=[$ff];arg(z^$n)=[$z]";
      ss2 = ss1;
    } else if (mainsort == "naiseki") {
      if (detailsort == "d2") {
        List<int> numbers = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
        numbers.shuffle(random);
        int x1 = numbers[0];
        int y1 = numbers[1];
        int x2 = numbers[2];
        int y2 = numbers[3];
        q1 =
            "\\small\\overrightarrow{a}=($x1,$y1),\\overrightarrow{b}=($x2,$y2)";
        String naiseki = (x1 * x2 + y1 * y2).toString();
        ss1 = "\\overrightarrow{a}\\cdot\\overrightarrow{b}=[$naiseki]";
        ss2 = ss1;
      } else if (detailsort == "d3") {
        List<int> numbers = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
        numbers.shuffle(random);
        int x1 = numbers[0];
        int y1 = numbers[1];
        int z1 = numbers[2];
        int x2 = numbers[3];
        int y2 = numbers[4];
        int z2 = numbers[5];
        q1 =
            "\\overrightarrow{a}=($x1,$y1,$z1);\\overrightarrow{b}=($x2,$y2,$z2)";
        String naiseki = (x1 * x2 + y1 * y2 + z1 * z2).toString();
        ss1 = "\\overrightarrow{a}\\cdot\\overrightarrow{b}=[$naiseki]";
        ss2 = ss1;
      } else if (detailsort == "cos") {
        List<List<int>> numbers = [
          [0, 1],
          [1, 1],
          [1, 2],
          [1, 3],
          [3, 4],
          [2, 3]
        ];

        numbers.shuffle(random);
        int x1 = numbers[0][0];
        int y1 = numbers[0][1];
        int x2 = numbers[1][0];
        int y2 = numbers[1][1];
        if (random.nextBool()) {
          int gg = x1;
          x1 = y1;
          y1 = gg;
        }
        if (random.nextBool()) {
          int gg = x2;
          x2 = y2;
          y2 = gg;
        }
        if (random.nextBool()) {
          x1 = -x1;
        }
        if (random.nextBool()) {
          y1 = -y1;
        }
        if (random.nextBool()) {
          x2 = -x2;
        }
        if (random.nextBool()) {
          y2 = -y2;
        }
        q1 =
            "\\small\\overrightarrow{a}=($x1,$y1),\\overrightarrow{b}=($x2,$y2);\\small\\overrightarrow{a}と\\small\\overrightarrow{b}のなす角を\\thetaとする";
        String naiseki = (x1 * x2 + y1 * y2).toString();
        String za = lc("($x1^2+$y1^2)^0.5");
        String zb = lc("($x2^2+$y2^2)^0.5");
        String cos1 = lc("$naiseki/($za*$zb)");
        String cos2 = returnsqrt(cos1);
        ss1 =
            "\\small |\\overrightarrow{a}|=[$za],|\\overrightarrow{b}|=[$zb];\\footnotesize \\overrightarrow{a}\\cdot\\overrightarrow{b}=[$naiseki],\\cos{\\theta}=[$cos1]";
        ss2 =
            "\\small |\\overrightarrow{a}|=[$za],|\\overrightarrow{b}|=[$zb];\\footnotesize \\overrightarrow{a}\\cdot\\overrightarrow{b}=[$naiseki],\\cos{\\theta}=[$cos2]";
      }
    } else if (mainsort == "dintegral1") {
      int a, b;
      do {
        a = randomint(-3, 2);
        b = randomint(a + 1, 3);
      } while (a.abs() == b.abs() || a == 0 || b == 0);
      String method = "";
      String multiple = "";

      if (detailsort == "x") {
        if (numbersort == "a=n+1") {
          multiple = "2";
        } else if (numbersort == "a=1") {
          multiple = "1";
        }
        method = "${normalize(multiple)}x";
        ss1 = "[${lc("$multiple*\\frac{1}{2}*($b^2-$a^2)")}]";
      } else if (detailsort == "x^2") {
        if (numbersort == "a=n+1") {
          multiple = "3";
        } else if (numbersort == "a=1") {
          multiple = "1";
        }
        method = "${normalize(multiple)}x^2";
        ss1 = "[${lc("$multiple*\\frac{1}{3}*($b^3-$a^3)")}]";
      } else if (detailsort == "x^3") {
        if (numbersort == "a=n+1") {
          multiple = "4";
        } else if (numbersort == "a=1") {
          multiple = "1";
        }
        method = "${normalize(multiple)}x^3";
        ss1 = "[${lc("$multiple*\\frac{1}{4}*($b^4-$a^4)")}]";
      }
      q1 = "\\int_{$a}^{$b} $method dx";
      ss2 = ss1;
    } else if (mainsort == "sequencesum") {
      String method;
      int a;
      if (detailsort == "n") {
        method = "n";
        if (numbersort == "6-10") {
          a = randomint(6, 10);
        } else {
          a = randomint(11, 19);
        }

        ss1 = "S=[${lc("\\frac{1}{2}*($a)*($a+1)")}]";
      } else if (detailsort == "an+b") {
        a = randomint(5, 8);
        int b = randomint(1, 4);
        int c = randomint(1, 4);
        method = "\\left(${normalize("$b")}n+$c\\right)";
        ss1 = "S=[${lc("$b*\\frac{1}{2}*($a)*($a+1)+$a*$c")}]";
      } else if (detailsort == "n^2") {
        a = randomint(8, 20);
        method = "n^2";
        q2 = "=\\frac{1}{6}\\cdot a \\cdot b \\cdot c;(a<b<c)";
        ss1 =
            "S=\\frac{1}{6}\\cdot [$a] \\cdot [${a + 1}] \\cdot [${2 * a + 1}]";
      } else {
        String p;
        int q = randomint(1, 4);
        if (q == 1) {
          p = "2";
          a = randomint(5, 8);
          method = "\\cdot $p^n";
        } else {
          p = "\\frac{1}{2}";
          a = randomint(5, 8);
          method = "\\cdot \\left($p\\right)^n";
        }

        ss1 = "[${lc("($p*(($p)^($a)-1))/(-$p)")}]";
      }

      q1 = "\\sum\\limits_{n=1}^{$a} $method;$q2";

      ss2 = ss1;
    } else if (mainsort == "generalterm") {
      if (detailsort == "arithmetic") {
        int p = randomint(1, 2);
        int a, d, b;
        do {
          a = randomint(-5, 5);
          d = randomint(-5, 5);
          b = a - d;
        } while (a == 0 || d == 0 || b == 0 || d.abs() == 1);
        if (p == 1) {
          q1 = "\\footnotesize a_n：初項$a,公差$dのとき";
        } else if (p == 2) {
          String sd = d < 0 ? "$d" : "+$d";
          q1 = "a_{n+1}=a_n$sd;a_1=$aのとき";
        }

        String pm = b < 0 ? "-" : "+";
        b = b.abs();
        ss1 = "a_n=[$d] n$pm[$b]";
      } else if (detailsort == "auxiliary") {
        int x, y, a, alpha;
        List<int> xList = [-5, -4, -3, -2, 2, 3, 4];
        x = xList[randomint(0, xList.length - 1)];
        List<int> alphaList = [-5, -4, -3, -2, 2, 3, 4];
        alpha = alphaList[randomint(0, alphaList.length - 1)];
        y = alpha * (1 - x);
        List<int> aList = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
        aList
            .removeWhere((v) => v == 0 || v == alpha || (v - alpha).abs() == 1);
        a = aList[randomint(0, aList.length - 1)];
        String sy = y < 0 ? "$y" : "+$y";
        alpha = y ~/ (1 - x);
        String pm = alpha < 0 ? "-" : "+";
        int absalpha = alpha.abs();
        q1 = "a_{n+1}=$x a_n $sy;a_1=$aのとき";
        ss1 =
            "\\footnotesize{特性方程式の解}\\alpha=[$alpha];\\small a_{n+1}=[${a - alpha}]\\cdot [$x]^{n-1}$pm[$absalpha]";
      }
    } else if (mainsort == "kisuuhou") {
      int a = 0;
      int b = 0;
      if (numbersort == "10-50") {
        a = random.nextInt(41) + 10;
      } else if (numbersort == "50-100") {
        a = random.nextInt(51) + 50;
      }
      if (detailsort == "2-3") {
        b = random.nextInt(2) + 2;
      } else if (detailsort == "4-8") {
        b = random.nextInt(5) + 4;
      }

      q1 = "\\LARGE ${toBase(a, b)}_{($b)}";
      ss1 = "\\LARGE [$a]_{(10)}";
      ss2 = ss1;
    } else if (mainsort == "nikoubunpu") {
      if (detailsort == "nikousimple") {
        List<String> nlist = ["5", "10", "20", "30", "50", "80", "100"];
        List<String> plist = [
          "\\frac{1}{2}",
          "\\frac{1}{3}",
          "\\frac{2}{3}",
          "\\frac{1}{4}",
          "\\frac{3}{4}",
        ];
        String n = nlist[random.nextInt(nlist.length)];
        String p = plist[random.nextInt(plist.length)];
        String q = lc("1-$p");
        String E = lc("$n*$p");
        String V = lc("$E*$q");
        String r1 = lc("$V^0.5");
        String r2 = lc("$V^0.6");
        q1 = "\\small二項分布B\\left($n,$p\\right)のとき";
        ss1 = "平均:[$E],分散:[$V];標準偏差:[$r1]";
        ss2 = "平均:[$E],分散:[$V];標準偏差:[$r2]";
      } else {
        List<String> nlist = ["5", "10", "20", "30", "50", "100"];
        List<String> bignlist = ["50", "100", "200", "300", "500"];
        String n = "";
        if (detailsort == "nikoukaku") {
          n = nlist[random.nextInt(nlist.length)];
        } else if (detailsort == "seiki") {
          n = bignlist[random.nextInt(bignlist.length)];
        }
        String p = "";
        int shu = random.nextInt(4) + 1;
        if (shu == 1) {
          q1 = "サイコロを$n回振るとき;${random.nextInt(6) + 1}の目が出る回数をXとする";
          p = "\\frac{1}{6}";
        } else if (shu == 2) {
          String value = "${random.nextInt(4) + 2}";
          q1 = "サイコロを$n回振るとき;$value以上の目が出る回数をXとする";
          p = "${lc("\\frac{1}{6}*(7-$value)")}";
        } else if (shu == 3) {
          String value = "${random.nextInt(4) + 1}";
          q1 = "サイコロを$n回振るとき;$valueより大きい目が出る回数をXとする";
          p = "${lc("\\frac{1}{6}*(6-$value)")}";
        } else if (shu == 4) {
          q1 = "1から10のカードから1枚引いて;カードを戻す作業を$n回繰り返す;2の倍数を引く回数をXとする";
          p = "\\frac{1}{2}";
        } else if (shu == 5) {
          q1 = "1から10のカードから1枚引いて;カードを戻す作業を$n回繰り返す;7以上のカードを引く回数をXとする";
          p = "\\frac{2}{5}";
        } else if (shu == 6) {
          q1 = "1から10のカードから1枚引いて;カードを戻す作業を$n回繰り返す;5の倍数を引く回数をXとする";
          p = "\\frac{1}{5}";
        } else if (shu == 7) {
          q1 = "サイコロを$n回振るとき;偶数の目が出る回数をXとする";
          p = "\\frac{1}{2}";
        } else if (shu == 8) {
          q1 = "サイコロを$n回振るとき;奇数の目が出る回数をXとする";
          p = "\\frac{1}{2}";
        } else if (shu == 9) {
          q1 = "サイコロを$n回振るとき;素数の目が出る回数をXとする";
          p = "\\frac{1}{2}";
        } else if (shu == 10) {
          q1 = "サイコロを$n回振るとき;3の倍数の目が出る回数をXとする";
          p = "\\frac{1}{3}";
        } else if (shu == 11) {
          String value = "${random.nextInt(5) + 1}";
          q1 = "1から10のカードから1枚引いて;カードを戻す作業を$n回繰り返す;$value以下を引く回数をXとする";
          p = "${lc("\\frac{$value}{10}")}";
        } else if (shu == 12) {
          q1 = "コインを$n回投げるとき;表が出る回数をXとする";
          p = "\\frac{1}{2}";
        } else if (shu == 13) {
          q1 = "1から20のカードから1枚引いて;カードを戻す作業を$n回繰り返す;平方数を引く回数をXとする";
          p = "\\frac{1}{5}";
        }
        if (detailsort == "nikoukaku") {
          ss1 = "Xは二項分布B\\left([$n],[$p]\\right)に従う";
        } else if (detailsort == "seiki") {
          String q = lc("1-$p");
          String E = lc("$n*$p");
          String V = lc("$E*$q");
          q1 = "$q1;(n=$nは十分に大きいと仮定)";
          ss1 = "Xは正規分布N\\left([$E],[$V]\\right)に従う";
        }
        q1 = "\\scriptsize $q1";
        q1 = q1.replaceAll(";", ";\\scriptsize ");
        ss1 = "\\scriptsize $ss1";
        ss2 = ss1;
      }
    } else if (mainsort == "cyebamene") {
      List<int> numbers = [1, 2, 3, 4, 5, 6, 7];
      int p = randomint(1, 3);
      int bd, dc, ce, ea, af, fb;
      do {
        numbers.shuffle(random);
        bd = numbers[0];
        dc = numbers[1];
        ce = numbers[2];
        ea = numbers[3];
        af = ea * dc;
        fb = ce * bd;
      } while (bd / dc < 0.25 ||
          bd / dc > 4 ||
          ce / ea < 0.25 ||
          ce / ea > 4 ||
          af / fb < 0.25 ||
          af / fb > 4);
      if (p == 2) {
        int iaf = af;
        int ifb = fb;
        af = ce;
        fb = ea;
        ce = bd;
        ea = dc;
        bd = iaf;
        dc = ifb;
      }
      if (p == 3) {
        int iaf = af;
        int ifb = fb;
        af = bd;
        fb = dc;
        bd = ce;
        dc = ea;
        ce = iaf;
        ea = ifb;
      }
      int cp = ce * (af + fb);
      int pf = ea * fb;
      int ap = ea * (bd + dc);
      int pd = bd * ce;
      int bp = fb * (ce + ea);
      int pe = ce * af;
      int zaf = af ~/ gcd(af, fb);
      int zfb = fb ~/ gcd(af, fb);
      int zap = ap ~/ gcd(ap, pd);
      int zpd = pd ~/ gcd(ap, pd);
      int zbp = bp ~/ gcd(bp, pe);
      int zpe = pe ~/ gcd(bp, pe);
      int zbd = bd ~/ gcd(bd, dc);
      int zdc = dc ~/ gcd(bd, dc);
      int zce = ce ~/ gcd(ce, ea);
      int zea = ea ~/ gcd(ce, ea);
      int zcp = cp ~/ gcd(cp, pf);
      int zpf = pf ~/ gcd(cp, pf);
      result["zbd"] = (bd ~/ gcd(bd, dc));
      result["zdc"] = (dc ~/ gcd(bd, dc));
      result["zce"] = (ce ~/ gcd(ce, ea));
      result["zea"] = (ea ~/ gcd(ce, ea));
      result["zaf"] = (af ~/ gcd(af, fb));
      result["zfb"] = (fb ~/ gcd(af, fb));
      result["zcp"] = (cp ~/ gcd(cp, pf));
      result["zpf"] = (pf ~/ gcd(cp, pf));
      result["zap"] = (ap ~/ gcd(ap, pd));
      result["zpd"] = (pd ~/ gcd(ap, pd));
      result["zbp"] = (bp ~/ gcd(bp, pe));
      result["zpe"] = (pe ~/ gcd(bp, pe));

      if (detailsort == "cyeba") {
        if (p == 1) {
          ss1 = "AF:FB=[$zaf]:[$zfb]";
          result["tf"] = "ab";
        } else if (p == 2) {
          ss1 = "BD:DC=[$zbd]:[$zdc]";
          result["tf"] = "bc";
        } else if (p == 3) {
          ss1 = "CE:EA=[$zce]:[$zea]";
          result["tf"] = "ca";
        }
      } else if (detailsort == "mene") {
        if (p == 1) {
          if (Random().nextBool()) {
            ss1 = "AP:PD=[$zap]:[$zpd]";
            result["tf"] = "ab";
          } else {
            ss1 = "BP:PE=[$zbp]:[$zpe]";
            result["tf"] = "ab";
          }
        } else if (p == 2) {
          if (Random().nextBool()) {
            ss1 = "BP:PE=[$zbp]:[$zpe]";
            result["tf"] = "bc";
          } else {
            ss1 = "CP:PF=[$zcp]:[$zpf]";
            result["tf"] = "bc";
          }
        } else if (p == 3) {
          if (Random().nextBool()) {
            ss1 = "CP:PF=[$zcp]:[$zpf]";
            result["tf"] = "ca";
          } else {
            ss1 = "AP:PD=[$zap]:[$zpd]";
            result["tf"] = "ca";
          }
        }
      }
      ss2 = ss1;
    } else if (mainsort == "kaku") {
      if (detailsort == "1") {
        int a = randomint(1, 8);
        if (a == 1) {
          int n = randomint(3, 6);
          String ou = random.nextBool() ? "表" : "裏";
          q1 = "コインを$n回投げるとき;$ouが$n回出る確率";
          ss1 = "[${lc("(1/2)^$n")}]";
        } else if (a == 2) {
          int n = randomint(3, 6);
          q1 = "コインを$n回投げるとき;$n回とも同じ向きになる確率";
          ss1 = "[${lc("2*(1/2)^$n")}]";
        } else if (a == 3) {
          int n = randomint(3, 6);
          String ou = random.nextBool() ? "表" : "裏";
          q1 = "コインを$n回投げるとき;少なくとも1回$ouが出る確率";
          ss1 = "[${lc("1-(1/2)^$n")}]";
        } else if (a == 4) {
          int n = randomint(3, 6);
          int m = randomint(1, 3);
          String color = random.nextBool() ? "赤玉" : "白玉";
          q1 = "袋に赤玉と白玉が$m個ずつある;玉を$n回引き、引くごとに袋に戻す;$colorが$n回出る確率";
          ss1 = "[${lc("(1/2)^$n")}]";
        } else if (a == 5) {
          int n = randomint(3, 6);
          int m = randomint(1, 3);
          q1 = "袋に赤玉と白玉が$m個ずつある;玉を$n回引き、引くごとに袋に戻す;$n回とも同じ色になる確率";
          ss1 = "[${lc("2*(1/2)^$n")}]";
        } else if (a == 6) {
          int n = randomint(3, 6);
          int m = randomint(1, 3);
          String color = random.nextBool() ? "赤玉" : "白玉";
          q1 = "袋に赤玉と白玉が$m個ずつある;玉を$n回引き、引くごとに袋に戻す;少なくとも1回$colorが出る確率";
          ss1 = "[${lc("1-(1/2)^$n")}]";
        } else if (a == 7 || a == 8) {
          int n = randomint(4, 7);
          int t = randomint(2, n - 2);
          int f = n - t;
          String ab = random.nextBool() ? "A" : "B";
          String tf = (a == 7)
              ? (random.nextBool() ? "あたり" : "はずれ")
              : (random.nextBool() ? "赤玉" : "白玉");
          q1 = (a == 7) ? "あたりが$t本、はずれが$f本ある" : "袋に赤玉が$t個、白玉が$f個ある";
          q2 = "A,Bの順に${a == 7 ? "くじ" : "玉"}を引く(戻さない)";
          q3 = "$abが$tfを引く確率";
          q1 = "$q1;$q2;$q3";
          ss1 =
              "[${lc("${tf.contains("あたり") || tf.contains("赤玉") ? "$t" : "$f"}/$n")}]";
        }
      }
      if (detailsort == "2") {
        int a = randomint(1, 6);
        if (a == 1) {
          int n = randomint(3, 5);
          String card = randomint(1, 3).toString();
          q1 = "1から3が書かれたカードを;$n回引いて戻す;$cardのカードが$n回出る確率";
          ss1 = "[${lc("(1/3)^$n")}]";
        } else if (a == 2) {
          int n = randomint(3, 5);
          q1 = "1から3が書かれたカードを;$n回引いて戻す;$n回とも同じ数字になる確率";
          ss1 = "[${lc("3*(1/3)^$n")}]";
        } else if (a == 3) {
          int n = randomint(3, 5);
          String card = randomint(1, 3).toString();
          q1 = "1から3が書かれたカードを;$n回引いて戻す;少なくとも1回$cardのカードが出る確率";
          ss1 = "[${lc("1-(2/3)^$n")}]";
        } else if (a == 4) {
          int n = randomint(3, 5);
          int m = randomint(1, 3);
          int idx = randomint(1, 3);
          String color = (idx == 1)
              ? "赤玉"
              : (idx == 2)
                  ? "白玉"
                  : "青玉";
          q1 = "袋に赤,白,青玉が$m個ずつ入っている;玉を$n回引き、引くごとに袋に戻す;$colorが$n回出る確率";
          ss1 = "[${lc("(1/3)^$n")}]";
        } else if (a == 5) {
          int n = randomint(3, 5);
          int m = randomint(1, 3);
          q1 = "袋に赤,白,青玉が$m個ずつ入っている;玉を$n回引き、引くごとに袋に戻す;$n回とも同じ色になる確率";
          ss1 = "[${lc("3*(1/3)^$n")}]";
        } else if (a == 6) {
          int n = randomint(3, 5);
          int m = randomint(1, 3);
          int idx = randomint(1, 3);
          String color = (idx == 1)
              ? "赤玉"
              : (idx == 2)
                  ? "白玉"
                  : "青玉";
          q1 = "袋に赤,白,青玉が$m個ずつ入っている;玉を$n回引き、引くごとに袋に戻す;少なくとも1回$colorが出る確率";
          ss1 = "[${lc("1-(2/3)^$n")}]";
        }
      }
      if (detailsort == "3") {
        int a = randomint(1, 3);
        if (a == 1) {
          int n = randomint(3, 6);
          int r = randomint(1, n - 1);
          String ou = random.nextBool() ? "表" : "裏";
          q1 = "コインを$n回投げるとき;$ouが$r回出る確率";
          ss1 = "[${lc("${combination(n, r)}*(1/2)^$n")}]";
        } else if (a == 2) {
          int n = randomint(3, 6);
          int r = randomint(1, n - 1);
          int m = randomint(1, 3);
          String color = random.nextBool() ? "赤玉" : "白玉";
          q1 = "袋に赤玉と白玉が$m個ずつある;玉を$n回引き、引くごとに袋に戻す;$colorが$r回出る確率";
          ss1 = "[${lc("${combination(n, r)}*(1/2)^$n")}]";
        } else if (a == 3) {
          int sum = randomint(2, 12);
          int d = sum <= 7 ? sum - 1 : 13 - sum;
          q1 = "サイコロを2回投げるとき;目の和が$sumになる確率";
          ss1 = "[${lc("(1/36)*$d")}]";
        }
      }
      if (detailsort == "4") {
        int a = randomint(1, 2);
        if (a == 1) {
          int n = randomint(3, 4);
          int r = randomint(1, n - 1);
          String card = randomint(1, 3).toString();
          q1 = "1から3が書かれたカードを;$n回引いて戻す;$cardのカードが$r回出る確率";
          ss1 = "[${lc("${combination(n, r)}*((1/3)^$r)*((2/3)^(${n - r}))")}]";
        } else if (a == 2) {
          int n = randomint(3, 4);
          int m = randomint(1, 3);
          int r = randomint(1, n - 1);
          int idx = randomint(1, 3);
          String color = (idx == 1)
              ? "赤玉"
              : (idx == 2)
                  ? "白玉"
                  : "青玉";
          q1 = "袋に赤,白,青玉が$m個ずつ入っている;玉を$n回引き、引くごとに袋に戻す;$colorが$r回出る確率";
          ss1 = "[${lc("${combination(n, r)}*((1/3)^$r)*((2/3)^(${n - r}))")}]";
        }
      }
      if (detailsort == "5") {
        int a = randomint(6, 11);
        if (a == 6 || a == 9) {
          int n = randomint(4, 7);
          int t = randomint(2, n - 2);
          int f = n - t;
          String tf = (a == 6)
              ? (random.nextBool() ? "あたり" : "はずれ")
              : (random.nextBool() ? "赤玉" : "白玉");
          String obj = a == 6 ? "くじ" : "玉";
          q1 = (a == 6) ? "あたりが$t本、はずれが$f本ある" : "赤玉が$t個、白玉が$f個ある";
          q2 = "A,Bの順に$objを引く(戻さない)";
          q3 = "両方とも$tfを引く確率";
          q1 = "$q1;$q2;$q3";
          if (tf == "あたり" || tf == "赤玉") {
            ss1 = "[${lc("($t/$n)*(($t-1)/($n-1))")}]";
          } else {
            ss1 = "[${lc("($f/$n)*(($f-1)/($n-1))")}]";
          }
        } else if (a == 7 || a == 10) {
          int n = randomint(4, 7);
          int t = randomint(2, n - 2);
          int f = n - t;
          String ab = random.nextBool() ? "A" : "B";
          q1 = (a == 7) ? "あたりが$t本、はずれが$f本ある" : "赤玉が$t個、白玉が$f個ある";
          q2 = "A,Bの順に${a == 7 ? "くじ" : "玉"}を引く(戻さない)";
          q3 = "$abのみ${a == 7 ? "あたり" : "赤玉"}を引く確率";
          q1 = "$q1;$q2;$q3";
          ss1 = "[${lc("($t/$n)*(($f)/($n-1))")}]";
        } else if (a == 8 || a == 11) {
          int n = randomint(4, 7);
          int t = randomint(2, n - 2);
          int f = n - t;
          String tf = (a == 8)
              ? (random.nextBool() ? "あたり" : "はずれ")
              : (random.nextBool() ? "赤玉" : "白玉");
          q1 = (a == 8) ? "あたりが$t本、はずれが$f本ある" : "赤玉が$t個、白玉が$f個ある";
          q2 = "A,Bの順に${a == 8 ? "くじ" : "玉"}を引く(戻さない)";
          q3 = "Aが$tfを引いたとき";
          q4 = "Bが${a == 8 ? "あたり" : "赤玉"}を引く条件つき確率";
          q1 = "$q1;$q2;$q3;$q4";
          if (tf == "あたり" || tf == "赤玉") {
            ss1 = "[${lc("(($t-1)/($n-1))")}]";
          } else {
            ss1 = "[${lc("($t/($n-1))")}]";
          }
        }
      }

      q1 = "\\scriptsize $q1";
      q1 = q1.replaceAll(";", ";\\scriptsize ");
      ss2 = ss1;
    } else if (mainsort == "buy") {
      if (detailsort == "1") {
        if (numbersort == "1") {
          int a = randomint(1, 2);
          if (a == 1) {
            int n = randomint(4, 7);
            int m = randomint(2, n - 2);
            int f = n - m;
            q1 = "男$m人、女$f人を一列に並べる。;場合の数は何通り？";
            ss1 = "[${lc("${factorial(n)}")}]";
          } else if (a == 2) {
            int n = randomint(4, 7);
            int m = randomint(2, n - 2);
            int f = n - m;
            q1 = "男$m人、女$f人を一列に並べる。;個人を区別しないとき、;男女の並び方は何通り？";
            ss1 = "[${lc("${combination(n, m)}")}]";
          }
        }
        if (numbersort == "2") {
          int a = randomint(1, 5);
          if (a == 1) {
            int n = randomint(4, 7);
            int m = randomint(2, n - 2);
            int f = n - m;
            String mf = random.nextBool() ? "男$m人" : "女$f人";
            q1 = "男$m人、女$f人を;$mfが連続するように;一列に並べる。;場合の数は何通り？";
            if (mf == "男$m人") {
              ss1 = "[${lc("${factorial(m)}*${factorial(f + 1)}")}]";
            } else {
              ss1 = "[${lc("${factorial(m + 1)}*${factorial(f)}")}]";
            }
          } else if (a == 2) {
            int m = randomint(2, 4);
            int f = m == 4 ? randomint(2, m - 1) : randomint(2, m);
            q1 = "男$m人、女$f人を;女$f人が連続しないように;一列に並べる。;場合の数は何通り？";
            ss1 = "[${lc("${factorial(m)}*${permutation(m + 1, f)}")}]";
          } else if (a == 3) {
            int n = randomint(4, 7);
            int m = randomint(2, n - 2);
            int f = n - m;
            q1 = "男$m人、女$f人を一列に並べる。;両端が男になる;場合の数は何通り？";
            ss1 = "[${lc("${factorial(n - 2)}*2")}]";
          } else if (a == 4) {
            int m = randomint(2, 4);
            int f = m - 1;
            q1 = "男$m人、女$f人を;男女が交互になるように;一列に並べる。;場合の数は何通り？";
            ss1 = "[${lc("${factorial(m)} * ${factorial(f)}")}]";
          } else if (a == 5) {
            int n = randomint(4, 7);
            int r = randomint(3, n - 1);
            q1 = "$n人から$r人選んで、;その$r人を一列に並べる;組み合わせは何通り？";
            ss1 = "[${lc("${combination(n, r)}*${factorial(r)}")}]";
          }
        }
      }
      if (detailsort == "2") {
        if (numbersort == "1") {
          int a = randomint(1, 4);
          if (a == 1) {
            int n = randomint(4, 7);
            q1 = "$n人を2グループに分ける;組み合わせは何通り？;(0人のグループがあってもよい)";
            ss1 = "[${lc("(1/2)*2^$n")}]";
          }
          if (a == 2) {
            int n = randomint(4, 7);
            q1 = "$n人をグループA,Bに分ける;組み合わせは何通り？;(0人のグループがあってもよい)";
            ss1 = "[${lc("2^$n")}]";
          }
          if (a == 3) {
            int n = randomint(4, 7);
            int s = randomint(1, n - 1);
            int t = n - s;
            q1 = "$n人を$s人と$t人のグループに分ける;組み合わせは何通り？";
            if (t == s) {
              ss1 = "[(${lc("${combination(n, s)}")})/2]";
            } else {
              ss1 = "[${lc("${combination(n, s)}")}]";
            }
          }
          if (a == 4) {
            int n = randomint(4, 7);
            int s = randomint(1, n - 1);
            int t = n - s;
            q1 = "$n人を$s人のグループAと;$t人のグループBに分ける;組み合わせは何通り？";
            ss1 = "[${lc("${combination(n, s)}")}]";
          }
        }
        if (numbersort == "2") {
          int a = randomint(1, 3);
          if (a == 1) {
            int n = randomint(3, 7);
            q1 = "$n人をグループA,B,Cに分ける;個人を区別しないとき;分け方は何通り？;(0人のグループがあってもよい)";
            ss1 = "[${lc("${combination(n + 2, 2)}")}]";
          }
          if (a == 2) {
            int n = randomint(3, 7);
            q1 = "x+y+z=$nをみたす;組み合わせは何通り？;(x,y,zは0以上の整数)";
            ss1 = "[${lc("${combination(n + 2, 2)}")}]";
          }
          if (a == 3) {
            int n = randomint(5, 9);
            q1 = "x+y+z=$nをみたす;組み合わせは何通り？;(x,y,zは自然数)";
            ss1 = "[${lc("${combination(n - 1, 2)}")}]";
          }
        }
        if (numbersort == "3") {
          int a = randomint(1, 3);
          if (a == 1) {
            int n = randomint(3, 7);
            q1 = "$n人をグループA,B,C,Dに分ける;個人を区別しないとき;分け方は何通り？;(0人のグループがあってもよい)";
            ss1 = "[${lc("${combination(n + 3, 3)}")}]";
          }
          if (a == 2) {
            int n = randomint(3, 7);
            q1 = "w+x+y+z=$nをみたす;組み合わせは何通り？;(w,x,y,zは0以上の整数)";
            ss1 = "[${lc("${combination(n + 3, 3)}")}]";
          }
          if (a == 3) {
            int n = randomint(6, 9);
            q1 = "w+x+y+z=$nをみたす;組み合わせは何通り？;(w,x,y,zは自然数)";
            ss1 = "[${lc("${combination(n - 1, 3)}")}]";
          }
        }
      }
      if (detailsort == "3") {
        int m = randomint(3, 4);
        int m2 = randomint(3, 5);
        int h = randomint(2, 4);
        int h2 = randomint(m2, 5);
        String nh = h == 2
            ? "1と2"
            : h == 3
                ? "1,2,3"
                : "1,2,3,4";
        String zh = h == 2
            ? "0と1"
            : h == 3
                ? "0,1,2"
                : "0,1,2,3";
        String nh2 = h2 == 3
            ? "1,2,3"
            : h2 == 4
                ? "1,2,3,4"
                : "1から5";
        String zh2 = h2 == 3
            ? "0,1,2"
            : h2 == 4
                ? "0,1,2,3"
                : "0から4";

        if (numbersort == "1") {
          int a = randomint(1, 2);
          if (a == 1) {
            q1 = "$nhのカードを使って;$m桁の整数を作る;場合の数は何通り？;(同じカードを複数回使用可能)";
            ss1 = "[${lc("$h^$m")}]";
          }
          if (a == 2) {
            q1 = "$nh2のカードを使って;$m2桁の整数を作る;場合の数は何通り？;(同じカードは1回のみ)";
            ss1 = "[${permutation(h2, m2)}]";
          }
        }
        if (numbersort == "2") {
          int a = randomint(1, 4);
          if (a == 1) {
            q1 = "$zhのカードを使って;$m桁の整数を作る;場合の数は何通り？;(同じカードを複数回使用可能)";
            ss1 = "[${lc("($h^($m-1))*($h-1)")}]";
          }
          if (a == 2) {
            q1 = "$zh2のカードを使って;$m2桁の整数を作る;場合の数は何通り？;(同じカードは1回のみ)";
            ss1 = "[${lc("($h2-1)*${permutation(h2 - 1, m2 - 1)}")}]";
          }
          if (a == 3) {
            q1 = "$nh2のカードを使って;$m2桁の偶数を作る;場合の数は何通り？;(同じカードは1回のみ)";
            if (h2 == 4 || h2 == 5) {
              ss1 = "[${lc("2*${permutation(h2 - 1, m2 - 1)}")}]";
            } else {
              ss1 = "[${lc("3*${permutation(h2 - 1, m2 - 1)}")}]";
            }
          }
          if (a == 4) {
            q1 = "$nhのカードを使って;$m桁の偶数を作る;場合の数は何通り？;(同じカードを複数回使用可能)";
            if (h == 2 || h == 3) {
              ss1 = "[${lc("($h^($m-1))")}]";
            } else {
              ss1 = "[${lc("($h^($m-1))*2")}]";
            }
          }
        }
      }
      if (detailsort == "4") {
        int a = randomint(1, 4);
        if (a == 1) {
          int n = randomint(3, 8);
          q1 = "$n人を円状に並べる;組み合わせは何通り？";
          ss1 = "[${lc("${factorial(n - 1)}")}]";
        }
        if (a == 2) {
          int n = randomint(3, 8);
          q1 = "$n人が円状に並んだ椅子に;座る組み合わせは何通り？";
          ss1 = "[${lc("${factorial(n - 1)}")}]";
        }
        if (a == 3) {
          int n = randomint(3, 7);
          String nn = n == 3
              ? "A,B,C"
              : n == 4
                  ? "A,B,C,D"
                  : n == 5
                      ? "A,B,C,D,E"
                      : n == 6
                          ? "A,B,C,D,E,F"
                          : "A,B,C,D,E,F,G";
          q1 = "$n人が円状に並んだ椅子;$nnに座る;組み合わせは何通り？";
          ss1 = "[${lc("${factorial(n)}")}]";
        }
        if (a == 4) {
          int n = randomint(4, 6);
          int r = randomint(3, n - 1);
          q1 = "$n人から$r人選んで、;その$r人を円状に並べる;組み合わせは何通り？";
          ss1 = "[${lc("${combination(n, r)}*${factorial(r - 1)}")}]";
        }
      }

      q1 = "\\scriptsize " "$q1";
      q1 = q1.replaceAll(";", ";\\scriptsize ");
      ss2 = ss1;
    } else if (mainsort == "triangle") {
      int a = 0;
      int b = 0;
      int c = 0;
      String cosA = "", cosB = "", cosC = "";
      String sinA = "", sinB = "", sinC = "";
      String tanA = "", tanB = "", tanC = "";
      final stopwatch = Stopwatch()..start();
      final RegExp badSinPattern =
          RegExp(r'\\frac\{(\d+)?(\\sqrt\{(\d+)\})?\}\{(\d+)\}');

      bool isBadSin(String sin, int value) {
        final match = badSinPattern.firstMatch(sin);
        if (match == null) return false;
        final b = match.group(3) != null ? int.parse(match.group(3)!) : 0;
        final c = int.parse(match.group(4)!);
        return b >= 100 || c >= value;
      }

      bool sinIsBad = false;
      if (detailsort == "sc" || detailsort == "cs" || detailsort == "ta") {
        do {
          do {
            a = randomint(1, 10);
            b = randomint(1, 10);
            c = randomint(1, 10);
          } while ((a >= b + c || b >= a + c || c >= a + b) ||
              (a * a + b * b == c * c ||
                  a * a + c * c == b * b ||
                  b * b + c * c == a * a) ||
              (a == b && b == c));

          cosA = lc("($b^2+$c^2-$a^2)/(2*$b*$c)");
          sinA = lc("(1-($cosA)^2)^0.5");
          if (isBadSin(sinA, 12)) {
            sinIsBad = true;
          } else {
            cosB = lc("($a^2+$c^2-$b^2)/(2*$a*$c)");
            sinB = lc("(1-($cosB)^2)^0.5");
            if (isBadSin(sinB, 200)) {
              sinIsBad = true;
            } else {
              cosC = lc("($b^2+$a^2-$c^2)/(2*$b*$a)");
              sinC = lc("(1-($cosC)^2)^0.5");
              sinIsBad = isBadSin(sinC, 200);
            }
          }
        } while (sinIsBad);
      } else if (detailsort == "seigen" || detailsort == "menseki") {
        do {
          do {
            a = randomint(1, 10);
            b = randomint(1, 10);
            c = randomint(1, 10);
          } while ((a >= b + c || b >= a + c || c >= a + b) ||
              (a * a + b * b == c * c ||
                  a * a + c * c == b * b ||
                  b * b + c * c == a * a) ||
              a == b ||
              b == c ||
              c == a);

          cosA = lc("($b^2+$c^2-$a^2)/(2*$b*$c)");
          sinA = lc("(1-($cosA)^2)^0.5");
          if (isBadSin(sinA, 20)) {
            sinIsBad = true;
          } else {
            cosB = lc("($a^2+$c^2-$b^2)/(2*$a*$c)");
            sinB = lc("(1-($cosB)^2)^0.5");
            if (isBadSin(sinB, 200)) {
              sinIsBad = true;
            } else {
              cosC = lc("($b^2+$a^2-$c^2)/(2*$b*$a)");
              sinC = lc("(1-($cosC)^2)^0.5");
              sinIsBad = isBadSin(sinC, 200);
            }
          }
        } while (sinIsBad);
      } else if (detailsort == "yogen") {
        do {
          do {
            a = randomint(1, 7);
            b = randomint(1, 7);
            c = randomint(1, 7);
          } while ((a >= b + c || b >= a + c || c >= a + b) ||
              (a * a + b * b == c * c ||
                  a * a + c * c == b * b ||
                  b * b + c * c == a * a) ||
              a == b ||
              b == c ||
              c == a);

          cosA = lc("($b^2+$c^2-$a^2)/(2*$b*$c)");
          sinA = lc("(1-($cosA)^2)^0.5");
          if (isBadSin(sinA, 20)) {
            sinIsBad = true;
          } else {
            cosB = lc("($a^2+$c^2-$b^2)/(2*$a*$c)");
            sinB = lc("(1-($cosB)^2)^0.5");
            if (isBadSin(sinB, 200)) {
              sinIsBad = true;
            } else {
              cosC = lc("($b^2+$a^2-$c^2)/(2*$b*$a)");
              sinC = lc("(1-($cosC)^2)^0.5");
              sinIsBad = isBadSin(sinC, 200);
            }
          }
        } while (sinIsBad);
      }
      List<int> abc = [a, b, c];
      List<String> sins = [sinA, sinB, sinC];
      List<String> coss = [cosA, cosB, cosC];
      tanA = lc("$sinA/$cosA");
      tanB = lc("$sinB/$cosB");
      tanC = lc("$sinC/$cosC");
      List<String> tans = [tanA, tanB, tanC];
// インデックスの順序をシャッフル
      List<int> idx = [0, 1, 2]..shuffle();

// シャッフル後の新しい a, b, c および sin, cos
      a = abc[idx[0]];
      b = abc[idx[1]];
      c = abc[idx[2]];

      sinA = sins[idx[0]];
      sinB = sins[idx[1]];
      sinC = sins[idx[2]];

      cosA = coss[idx[0]];
      cosB = coss[idx[1]];
      cosC = coss[idx[2]];
      tanA = tans[idx[0]];
      tanB = tans[idx[1]];
      tanC = tans[idx[2]];
      stopwatch.stop();
      result["a"] = a.toString();
      result["b"] = b.toString();
      result["c"] = c.toString();
      result["sinA"] = sinA;
      result["sinB"] = sinB;
      result["sinC"] = sinC;
      result["cosA"] = cosA;
      result["cosB"] = cosB;
      result["cosC"] = cosC;
      result["tanA"] = tanA;
      result["tanB"] = tanB;
      result["tanC"] = tanC;

      String m = lc("\\frac{1}{2}*$a*$b*$sinC");
      if (detailsort == "sc") {
        if (idx.indexOf(0) == 0) {
          ss1 = "\\cos{A}=[$cosA]";
          result["ff"] = "d";
        }
        if (idx.indexOf(0) == 1) {
          ss1 = "\\cos{B}=[$cosB]";
          result["ff"] = "e";
        }
        if (idx.indexOf(0) == 2) {
          ss1 = "\\cos{C}=[$cosC]";
          result["ff"] = "f";
        }
      } else if (detailsort == "cs") {
        if (idx.indexOf(0) == 0) {
          ss1 = "\\sin{A}=[$sinA]";
          result["ff"] = "a";
        }
        if (idx.indexOf(0) == 1) {
          ss1 = "\\sin{B}=[$sinB]";
          result["ff"] = "b";
        }
        if (idx.indexOf(0) == 2) {
          ss1 = "\\sin{C}=[$sinC]";
          result["ff"] = "c";
        }
      }
      if (detailsort == "ta") {
        if (idx.indexOf(0) == 0) {
          ss1 = "\\tan{A}=[$tanA]";
          result["ff"] = "a";
        }
        if (idx.indexOf(0) == 1) {
          ss1 = "\\tan{B}=[$tanB]";
          result["ff"] = "b";
        }
        if (idx.indexOf(0) == 2) {
          ss1 = "\\tan{C}=[$tanC]";
          result["ff"] = "c";
        }
      } else if (detailsort == "seigen") {
        if (idx.indexOf(0) == 0) {
          ss1 = "\\sin{A}=[$sinA]";
          result["ff"] = "ef";
        }
        if (idx.indexOf(0) == 1) {
          ss1 = "\\sin{B}=[$sinB]";
          result["ff"] = "df";
        }
        if (idx.indexOf(0) == 2) {
          ss1 = "\\sin{C}=[$sinC]";
          result["ff"] = "de";
        }
      } else if (detailsort == "yogen") {
        if (idx.indexOf(0) == 0) {
          ss1 = "\\cos{A}=[$cosA]";
          result["ff"] = "bc";
        }
        if (idx.indexOf(0) == 1) {
          ss1 = "\\cos{B}=[$cosB]";
          result["ff"] = "ac";
        }
        if (idx.indexOf(0) == 2) {
          ss1 = "\\cos{C}=[$cosC]";
          result["ff"] = "ab";
        }
      } else if (detailsort == "menseki") {
        ss1 = "S=[$m]";
        result["ff"] = "def";
      }
      ss2 = ss1;
    } else if (mainsort == "sekibun3") {
      int a, b, c, d;
      do {
        a = randomint(1, 5);
        b = randomint(1, 5);
        c = randomint(1, 5);
        d = randomint(1, 5);
      } while (a == b || c == d || a * d == b * c || a * d == (c + d) * b);
      String p = lc("$a/$b");
      String q = lc("$c/$d");
      p = random.nextBool() ? p : "-$p";
      q = random.nextBool() ? q : "-$q";
      String mq = "-$q".replaceAll("--", "");
      String px = (lc("($p)/($q)"));
      String mx = (lc("(-$p)/($q)"));
      if (detailsort == "sc") {
        if (random.nextBool()) {
          q1 = "$p \\int \\sin{\\left($q x\\right)} dx";
          ss1 = "[$mx]\\cos\\left([$q]x\\right)";
          ss2 = "[$mx]\\cos\\left([$mq]x\\right)";
        } else {
          q1 = "$p \\int \\cos{\\left($q x\\right)} dx";
          ss1 = "[$px]\\sin\\left([$q]x\\right)";
          ss2 = "[$mx]\\sin\\left([$mq]x\\right)";
        }
      } else if (detailsort == "e") {
        q1 = "$p \\int e^{$q x} dx";
        ss1 = "[$px]e^{[$q]x}";
        ss2 = ss1;
      } else if (detailsort == "x") {
        String y = (lc("($p)/($q+1)"));
        String z = (lc("($q)+1"));
        q1 = "$p \\int x^{$q} dx";
        ss1 = "[$y]x^{[$z]}";
        ss2 = ss1;
      }
      ss2 = ss1;
    } else if (mainsort == "bibun3") {
      int a, b, c, d;
      do {
        a = randomint(1, 5);
        b = randomint(1, 5);
        c = randomint(1, 5);
        d = randomint(1, 5);
      } while (a == b || c == d || a * c == b * d || c == 2 * d);
      String p = lc("$a/$b");
      String q = lc("$c/$d");
      p = random.nextBool() ? p : "-$p";
      q = random.nextBool() ? q : "-$q";
      String mq = "-$q".replaceAll("--", "");
      String px = (lc("($p)*($q)"));
      String mx = (lc("(-$p)*($q)"));
      if (detailsort == "sc") {
        if (random.nextBool()) {
          q1 = "\\frac{d}{dx} \\left\\{$p\\sin{\\left($q x\\right)}\\right\\}";
          ss1 = "[$px]\\cos\\left([$q]x\\right)";
          ss2 = "[$px]\\cos\\left([$mq]x\\right)";
        } else {
          q1 = "\\frac{d}{dx} \\left\\{$p\\cos{\\left($q x\\right)}\\right\\}";
          ss1 = "[$mx]\\sin\\left([$q]x\\right)";
          ss2 = "[$px]\\sin\\left([$mq]x\\right)";
        }
      } else if (detailsort == "e") {
        q1 = "\\frac{d}{dx} \\left\\{$p e^{$q x}\\right\\}";
        ss1 = "[$px]e^{[$q]x}";
        ss2 = ss1;
      } else if (detailsort == "x") {
        String z = (lc("($q)-1"));
        q1 = "\\frac{d}{dx} \\left\\{$p x^{$q}\\right\\}";
        ss1 = "[$px]x^{[$z]}";
        ss2 = ss1;
      }
    } else if (mainsort == "kyokugen") {
      int? aGlobal;
      int? bGlobal;
      int? cGlobal;
      int? dGlobal;
      String makingcomplex(int strong, int ch, int n1, int n2, int n3) {
        String value;
        int p = randomint(2, 3);
        cGlobal ??= randomint(2, 6);
        aGlobal ??= randomint(cGlobal! + 1, 7);
        dGlobal ??= randomint(2, 6);
        bGlobal ??= randomint(aGlobal! + 1, 8);
        if (strong == 1) {
          value = ch == 1
              ? "\\log n"
              : ch == 2
                  ? "\\log_${n3 + 1} n+$n1"
                  : "\\log_${n3 + 1} ($n2 n)+$n1";
        } else if (strong == 2) {
          value = ch == 1
              ? "\\{\\log n\\}^2"
              : ch == 2
                  ? "\\{\\log_${n3 + 1} n\\}^2+$n1"
                  : "\\{\\log_${n3 + 1} ($n2 n)\\}^2+$n1";
        } else if (strong == 3) {
          value = ch == 1 ? "\\sqrt{n}" : "\\sqrt{$n1 n+$n3}+$n2";
        } else if (strong == 4) {
          value = ch == 1
              ? "n"
              : ch == 2
                  ? "$n1 n+$n2"
                  : ch == 3
                      ? "$n1 n+\\sqrt{$n3 n^2+$n2}"
                      : "$n1 n+\\sqrt{$n3 n^2+$n2 n}";
        } else if (strong == 5) {
          value = ch == 1
              ? "n^2"
              : ch == 2
                  ? "$n1 n^2+$n2"
                  : ch == 3
                      ? "$n1 n^2+\\sqrt{$n3 n^4+$n2}"
                      : "$n1 n^2+\\sqrt{$n3 n^4+$n2 n^$p}";
        } else if (strong == 6) {
          value = ch == 1 ? "$aGlobal^{n}" : "$aGlobal^{n}+$cGlobal^{n}";
        } else if (strong == 7) {
          value = ch == 1 ? "$bGlobal^{n}" : "$bGlobal^{n}+$dGlobal^{n}";
        } else if (strong == 8) {
          value = ch == 1 ? "n!" : "n!+$n1";
        } else {
          value = ch == 1 ? "n^n" : "n^n+$n1";
        }
        return value;
      }

      if (detailsort == "comparestrong") {
        int a, b, cha, chb;
        String sa = "";
        String sb = "";
        List<String> norxlist = ["n", "x"];
        String norx = norxlist[randomint(0, 1)];
        int na1 = randomint(1, 5);
        int na2 = randomint(1, 5);
        int na3 = randomint(1, 5);
        int nb1 = randomint(1, 5);
        int nb2 = randomint(1, 5);
        int nb3 = randomint(1, 5);
        if (numbersort == "basic") {
          cha = 1;
          chb = 1;
          do {
            a = randomint(1, 9);
            b = randomint(1, 9);
          } while (a == b ||
              a - b == 1 ||
              b - a == 1 ||
              (a == 6 && b == 4) ||
              (a == 4 && b == 6) ||
              (norx == "x" && (a == 8 || b == 8)));
        } else {
          do {
            cha = randomint(1, 4);
            chb = randomint(1, 4);
          } while (cha == chb || (cha == 1 && chb == 1));

          do {
            a = randomint(1, 9);
            int bMin = (a - 2).clamp(1, 9);
            int bMax = (a + 2).clamp(1, 9);
            b = randomint(bMin, bMax);
          } while (a == b || (norx == "x" && (a == 8 || b == 8)));
        }
        sa = makingcomplex(a, cha, na1, na2, na3);
        sb = makingcomplex(b, chb, nb1, nb2, nb3);
        sa = sa.replaceAll("1 n", "n");
        sb = sb.replaceAll("1 n", "n");
        if (norx == "x") {
          sa = sa.replaceAll("n", "x");
          sb = sb.replaceAll("n", "x");
          q1 = "\\lim_{x \\to \\infty}\\frac{$sa}{$sb}";
        } else {
          q1 = "\\lim_{n \\to \\infty}\\frac{$sa}{$sb}";
        }

        if (a > b) {
          ss1 = "[\\infty]";
          ss2 = "[+\\infty]";
        } else {
          ss1 = "[0]";
          ss2 = "[+0]";
        }
      } else if (detailsort == "equalstrong") {
        int a, b, cha, chb;
        String sa = "";
        String sb = "";
        List<String> norxlist = ["n", "x"];
        String norx = norxlist[randomint(0, 1)];
        int na1 = randomint(1, 5);
        int na2 = randomint(1, 5);
        int na3 = randomint(1, 5);
        int nb1 = randomint(1, 5);
        int nb2 = randomint(1, 5);
        int nb3 = randomint(1, 5);
        String r1, r2;
        do {
          na2 = randomint(1, 5);
          nb2 = randomint(1, 5);
        } while (na2 == nb2);
        if (numbersort == "a/b") {
          a = randomint(3, 5);
          b = a;
          int s = randomint(1, 3);
          if (a == 3) {
            if (s == 1) {
              cha = 2;
              chb = 2;
              r1 = lc("(($na1)/($nb1))^0.5");
              r2 = lc("(($na1)/($nb1))^0.6");
            } else if (s == 2) {
              cha = 1;
              chb = 2;
              r1 = lc("(1/($nb1))^0.5");
              r2 = lc("(1/($nb1))^0.6");
            } else {
              cha = 2;
              chb = 1;
              r1 = lc("($na1)^0.5");
              r2 = lc("($na1)^0.6");
            }
          } else {
            if (s == 1) {
              cha = 2;
              chb = 2;
              r1 = lc("($na1)/($nb1)");
            } else if (s == 2) {
              cha = 1;
              chb = 2;
              r1 = lc("1/($nb1)");
            } else {
              cha = 2;
              chb = 1;
              r1 = lc("$na1");
            }
            r2 = r1;
          }
        } else {
          a = randomint(4, 5);
          b = a;
          int s = randomint(1, 3);
          List<int> squarelist = [1, 4, 9];
          na3 = squarelist[randomint(0, 2)];
          nb3 = squarelist[randomint(0, 2)];
          if (s == 1) {
            cha = randomint(3, 4);
            chb = randomint(3, 4);
            r1 = lc("($na1+$na3^0.5)/($nb1+$nb3^0.5)");
          } else if (s == 2) {
            cha = randomint(3, 4);
            chb = 2;
            r1 = lc("($na1+$na3^0.5)/($nb1)");
          } else {
            cha = 2;
            chb = randomint(3, 4);
            r1 = lc("($na1)/($nb1+$nb3^0.5)");
          }
          r2 = r1;
        }

        ss1 = "[$r1]";
        ss2 = "[$r2]";
        sa = makingcomplex(a, cha, na1, na2, na3);
        sb = makingcomplex(b, chb, nb1, nb2, nb3);
        sa = sa.replaceAll("1 n", "n");
        sb = sb.replaceAll("1 n", "n");
        if (norx == "x") {
          sa = sa.replaceAll("n", "x");
          sb = sb.replaceAll("n", "x");
          q1 = "\\lim_{x \\to \\infty}\\frac{$sa}{$sb}";
        } else {
          q1 = "\\lim_{n \\to \\infty}\\frac{$sa}{$sb}";
        }
      } else if (detailsort == "sq-sq") {
        int a, b, c, d, e;
        List<String> norxlist = ["n", "x"];
        String norx = norxlist[randomint(0, 1)];
        b = randomint(1, 5);
        d = randomint(1, 5);
        e = randomint(1, 5);
        String sb = random.nextBool() ? "+$b" : "-$b";
        String sd = random.nextBool() ? "+$d" : "-$d";
        if (numbersort == "infty") {
          int q = randomint(1, 4);
          if (q == 1) {
            int p = randomint(1, 3);
            do {
              a = randomint(1, 5);
              c = randomint(1, 5);
            } while (a == c * c);
            if (p == 1) {
              q1 = "\\sqrt{$a n^2$sb}-$c n";
            } else if (p == 2) {
              q1 = "\\sqrt{$a n^2$sb n}-$c n";
            } else if (p == 3) {
              do {
                a = randomint(1, 5);
                c = randomint(1, 5);
              } while (a == c);
              q1 = "\\sqrt{$a n$sb}-\\sqrt{$c n$sd}";
            }
            if (a > c) {
              ss1 = "[\\infty]";
              ss2 = "[+\\infty]";
            } else {
              ss1 = "[-\\infty]";
              ss2 = "[-\\infty]";
            }
          } else if (q == 2) {
            int p = randomint(1, 2);
            c = randomint(1, 3);
            a = c * c;
            if (p == 1) {
              q1 = "\\sqrt{$a n^2$sb}-$c n";
              if (sb.contains("+")) {
                ss1 = "[0]";
                ss2 = "[+0]";
              } else {
                ss1 = "[0]";
                ss2 = "[-0]";
              }
            } else if (p == 2) {
              a = c;
              q1 = "\\sqrt{$a n$sb}-\\sqrt{$c n$sd}";
              if (int.parse(sb) > int.parse(sd)) {
                ss1 = "[0]";
                ss2 = "[+0]";
              } else {
                ss1 = "[0]";
                ss2 = "[-0]";
              }
            }
          } else if (q == 3) {
            int p = randomint(1, 2);
            c = randomint(1, 3);
            a = c * c;

            if (p == 1) {
              q1 = "\\frac{$e}{\\sqrt{$a n^2$sb}-$c n}";
              if (sb.contains("+")) {
                ss1 = "[\\infty]";
                ss2 = "[+\\infty]";
              } else {
                ss1 = "[-\\infty]";
                ss2 = "[-\\infty]";
              }
            } else if (p == 2) {
              a = c;
              q1 = "\\frac{$e}{\\sqrt{$a n$sb}-\\sqrt{$c n$sd}}";
              if (int.parse(sb) > int.parse(sd)) {
                ss1 = "[\\infty]";
                ss2 = "[+\\infty]";
              } else {
                ss1 = "[-\\infty]";
                ss2 = "[-\\infty]";
              }
            }
          } else if (q == 4) {
            int p = randomint(1, 3);
            do {
              a = randomint(1, 5);
              c = randomint(1, 5);
            } while (a == c * c);
            if (p == 1) {
              q1 = "\\frac{$e}{\\sqrt{$a n^2$sb}-$c n}";
            } else if (p == 2) {
              q1 = "\\frac{$e}{\\sqrt{$a n^2$sb n}-$c n}";
            } else if (p == 3) {
              do {
                a = randomint(1, 5);
                c = randomint(1, 5);
              } while (a == c);
              q1 = "\\frac{$e}{\\sqrt{$a n$sb}-\\sqrt{$c n$sd}}";
            }
            if (a > c) {
              ss1 = "[0]";
              ss2 = "[+0]";
            } else {
              ss1 = "[0]";
              ss2 = "[-0]";
            }
          }
        } else if (numbersort == "const") {
          int q = randomint(1, 2);
          if (q == 1) {
            c = randomint(1, 3);
            a = c * c;
            String ssb = sb.replaceAll("+", "");
            String r1 = lc("$ssb/(($a^0.5)+$c)");
            ssb = ssb.replaceAll("1", "");
            q1 =
                "\\sqrt{$a n^2$sb n}-$c n;\\frac{$ssb n}{\\sqrt{$a n^2$sb n}+$c n}";

            ss1 = "[$r1]";
            ss2 = ss1;
          }
          if (q == 2) {
            c = randomint(1, 3);
            a = c * c;
            q1 = "";
            String ssb = sb.replaceAll("+", "");
            String r1 = lc("($e*(($a^0.5)+$c))/$ssb");
            ssb = ssb.replaceAll("1", "");
            if (e != 1) {
              q1 =
                  "\\frac{$e}{\\sqrt{$a n^2$sb n}-$c n};\\frac{$e(\\sqrt{$a n^2$sb n}+$c n)}{$ssb n}";
            } else {
              q1 =
                  "\\frac{$e}{\\sqrt{$a n^2$sb n}-$c n};\\frac{\\sqrt{$a n^2$sb n}+$c n}{$ssb n}";
            }

            ss1 = "[$r1]";
            ss2 = ss1;
          }
        }
        q1 = q1.replaceAll("1 n", "n");
        if (norx == "x") {
          q1 = q1.replaceAll("n", "x");
          q1 = "\\lim_{x \\to \\infty}$q1";
          q1 = q1.replaceAll(";", ";\\small =\\lim_{x \\to \\infty}");
        } else {
          q1 = "\\lim_{n \\to \\infty}$q1";
          q1 = q1.replaceAll(";", ";\\small =\\lim_{n \\to \\infty}");
        }
      } else if (detailsort == "r^n") {
        String s, r;
        if (numbersort == "infty") {
          int p = randomint(1, 2);
          if (p == 1) {
            do {
              int a = randomint(1, 6);
              int b = randomint(1, 6);
              int d = randomint(1, 5);
              int c = randomint(d + 1, 6);
              s = lc("$a/$b");
              r = lc("$c/$d");
            } while (s == r);
            s = random.nextBool() ? s : "-$s";
            s = (s.contains("frac") || s.contains("-"))
                ? "\\left($s\\right)"
                : s;
            r = r.contains("frac") ? "\\left($r\\right)" : r;
            q1 =
                "\\lim_{n \\to \\infty} \\sum\\limits_{k=1}^n $s \\cdot $r^{k-1}";
            q1 = q1.replaceAll("1 \\cdot", "");
            ss1 = s.contains("-") ? "[-\\infty]" : "[\\infty]";
            ss2 = s.contains("-") ? "[-\\infty]" : "[+\\infty]";
          } else {
            int d = randomint(1, 5);
            int c = randomint(d + 1, 6);
            r = lc("$c/$d");
            ss1 = "[\\infty]";
            ss2 = "[+\\infty]";
            r = r.contains("frac") ? "\\left($r\\right)" : r;
            q1 = "\\lim_{n \\to \\infty} \\sum\\limits_{k=1}^n $r^{k}";
          }
        } else if (numbersort == "const") {
          int p = randomint(1, 2);
          if (p == 1) {
            do {
              int a = randomint(1, 6);
              int b = randomint(1, 6);
              int c = randomint(1, 5);
              int d = randomint(c + 1, 6);
              s = lc("$a/$b");
              r = lc("$c/$d");
            } while (s == r);
            s = random.nextBool() ? s : "-$s";
            ss1 = "[${lc("$s/(1-$r)")}]";
            ss2 = ss1;
            s = (s.contains("frac") || s.contains("-"))
                ? "\\left($s\\right)"
                : s;
            r = r.contains("frac") ? "\\left($r\\right)" : r;
            q1 =
                "\\lim_{n \\to \\infty} \\sum\\limits_{k=1}^n $s \\cdot $r^{k-1}";
            q1 = q1.replaceAll("1 \\cdot", "");
          } else {
            int c = randomint(1, 5);
            int d = randomint(c + 1, 6);
            r = lc("$c/$d");
            ss1 = "[${lc("$r/(1-$r)")}]";
            ss2 = ss1;
            r = r.contains("frac") ? "\\left($r\\right)" : r;
            q1 = "\\lim_{n \\to \\infty} \\sum\\limits_{k=1}^n $r^{k}";
          }
        }
      } else if (detailsort == "r^-n") {
        String r1, r2;
        r1 = makingcomplex(6, 2, 1, 1, 1);
        r2 = makingcomplex(7, 2, 1, 1, 1);
        q1 = "\\lim_{n \\to {-\\infty}} \\frac{$r1}{$r2}";
        if (cGlobal! > dGlobal!) {
          ss1 = "[0]";
          ss2 = "[+0]";
        } else if (cGlobal! < dGlobal!) {
          ss1 = "[\\infty]";
          ss2 = "[+\\infty]";
        } else {
          ss1 = "[1]";
        }
        ss2 = ss1;
      } else if (detailsort == "e") {
        if (numbersort == "(1+nx)^1/x") {
          int p = randomint(1, 2);
          int a, b;
          a = randomint(1, 3);
          b = randomint(1, 3);
          String pm1 = random.nextBool() ? "+" : "-";
          String pm2 = random.nextBool() ? "+" : "-";
          String n1 = "${lc("$a/$b")}x";
          String n2 = n1.contains("}")
              ? n1.replaceAll("}x", "x}")
              : "\\frac{${n1.replaceAll("x", "")}}{x}";

          if (p == 1) {
            if (random.nextBool()) {
              q1 = "\\lim_{x \\to {$pm1\\infty}} \\left(1$pm2$n2\\right)^{x}";
            } else {
              q1 =
                  "\\lim_{x \\to {$pm1 0}} \\left(1$pm2$n1\\right)^{\\frac{1}{x}}";
            }
            q1 = q1.replaceAll("1x", "x");
            String m2 = pm2.replaceAll("+", "");
            String nn = n1.replaceAll("x", "");
            if (nn == "1" && m2 == "") {
              ss1 = "[e]";
            } else {
              ss1 = "[e^{$m2$nn}]";
            }
            if (nn == "\\frac{1}{2}") {
              ss2 = "[\\sqrt{e}]";
            }
          } else if (p == 2) {
            if (random.nextBool()) {
              q1 = "\\lim_{x \\to {+0}} \\left(1+$n2\\right)^{x}";
            } else {
              q1 =
                  "\\lim_{x \\to {+\\infty}} \\left(1+$n1\\right)^{\\frac{1}{x}}";
            }
            q1 = q1.replaceAll("1x", "x");
            ss1 = "[1]";
          }
        } else if (numbersort == "(1+x^n)^1/x") {
          List<String> plist = ["x", "x^2", "x^3"];
          List<String> qlist = [
            "\\frac{1}{x}",
            "\\frac{1}{x^2}",
            "\\frac{1}{x^3}"
          ];
          int a, b;
          do {
            a = randomint(0, 2);
            b = randomint(0, 2);
          } while (a == b);
          String sa = plist[a];
          String sb = qlist[b];
          String pm = random.nextBool() ? "+" : "-";
          int p = randomint(1, 3);
          if (p == 1) {
            q1 = "\\lim_{x \\to {+0}} \\left(1$pm$sa\\right)^{$sb}";
            if (a > b) {
              ss1 = "[1]";
            } else {
              if (pm == "+") {
                ss1 = "[\\infty]";
              } else {
                ss1 = "[0]";
              }
            }
          } else if (p == 2) {
            q1 = "\\lim_{x \\to {+\\infty}} \\left(1$pm$sb\\right)^{$sa}";
            if (a < b) {
              ss1 = "[1]";
            } else {
              if (pm == "+") {
                ss1 = "[\\infty]";
              } else {
                ss1 = "[0]";
              }
            }
          } else if (p == 3) {
            int c = randomint(0, 2);
            String sc = plist[c];
            q1 = "\\lim_{x \\to {+0}} \\frac{\\log{(1$pm$sa})}{$sc}";
            if (a > c) {
              if (pm == "+") {
                ss1 = "[0]";
                ss2 = "[+0]";
              } else {
                ss1 = "[0]";
                ss2 = "[-0]";
              }
            } else if (a == c) {
              if (pm == "+") {
                ss1 = "[1]";
              } else {
                ss1 = "[-1]";
              }
            } else {
              if (pm == "+") {
                ss1 = "[\\infty]";
              } else {
                ss1 = "[-\\infty]";
              }
            }
          }
        }
      }
    } else if (mainsort == "circle") {
      int a, b, c;
      do {
        a = random.nextBool() ? 2 * randomint(1, 5) : -2 * randomint(1, 5);
        b = random.nextBool() ? 2 * randomint(1, 5) : -2 * randomint(1, 5);
        c = random.nextBool() ? randomint(1, 10) : -randomint(1, 10);
      } while (-c + (a * a / 4) + (b * b / 4) <= 0);
      String r = lc("((($a^2)/4)+(($b^2)/4)-$c)^0.5");
      ss1 = "中心：([${-a ~/ 2}],[${-b ~/ 2}]);半径：[$r]";
      q1 = "\\small x^2+y^2+$a x+$b y+$c=0";
      q1 = q1.replaceAll("+-", "-");
    } else if (mainsort == "rotation") {
      if (detailsort == "origin") {
        int a, b;
        do {
          a = randomint(-5, 5);
          b = randomint(-5, 5);
        } while (a.abs() <= 1 || b.abs() <= 1);
        String sb = b < 0 ? "$b" : "+$b";
        int absa = a.abs();
        String pm = a > 0 ? "+" : "-";
        String mp = a > 0 ? "-" : "+";
        int p = randomint(1, 2);
        if (p == 1) {
          String rot = "90^\\circ";
          q1 = "\\footnotesize 複素数平面上で原点を中心に;\\footnotesize $a$sb iを$rot回転させると";
          ss1 = "[${-b}][$pm][$absa]i";
        } else if (p == 2) {
          String rot = "\\mathord{-}90^\\circ";
          q1 = "\\footnotesize 複素数平面上で原点を中心に;\\footnotesize $a$sb iを$rot回転させると";
          ss1 = "[$b][$mp][$absa]i";
        }
      } else if (detailsort == "!origin") {
        int randomPick(List<int> list) {
          return list[Random().nextInt(list.length)];
        }

        List<int> nums = [-5, -4, -3, -2, 2, 3, 4, 5];
        int a, b, c, d;
        while (true) {
          a = randomPick(nums);
          b = randomPick(nums);
          c = randomPick(nums);
          d = randomPick(nums);
          int e1 = a - c + d;
          int e2 = -a + c + d;
          int e3 = -b + c + d;
          int e4 = b + c - d;
          // すべての式の値が -1, 0, 1 以外であること
          if (![e1, e2, e3, e4].any((e) => [-1, 0, 1].contains(e))) {
            break;
          }
        }
        int p = randomint(1, 2);
        String sb = b < 0 ? "$b" : "+$b";
        String sd = d < 0 ? "$d" : "+$d";
        if (p == 1) {
          String rot = "90^\\circ";
          q1 =
              "\\footnotesize 複素数平面上で;\\footnotesize $c$sd iを中心に;\\footnotesize $a$sb iを$rot回転させると";
          ss1 = "[${-b + c + d}][][${a - c + d}]i";
        } else if (p == 2) {
          String rot = "\\mathord{-}90^\\circ";

          q1 =
              "\\footnotesize 複素数平面上で;\\footnotesize $c$sd iを中心に;\\footnotesize $a$sb iを$rot回転させると";
          ss1 = "[${b + c - d}][][${-a + c + d}]i";
        }
      }
      ss1 = ss1.replaceAll("[][-", "[-][");
      ss1 = ss1.replaceAll("[][", "[+][");
    } else if (mainsort == "tenkai") {
      int a, b, c, d;
      do {
        a = randomint(1, 10);
        c = randomint(1, 10);

        b = random.nextBool() ? randomint(1, 10) : -randomint(1, 10);
        d = random.nextBool() ? randomint(1, 10) : -randomint(1, 10);
      } while ((a == 0 && c == 0) ||
          ((a * d + b * c).abs() < 2) ||
          (gcd(a, b) != 1) ||
          (gcd(c, d) != 1));
      String sb = b < 0 ? "$b" : "+$b";
      String sd = d < 0 ? "$d" : "+$d";
      String sa = normalize("$a");
      String sc = normalize("$c");
      int p = a * c;
      String sp = normalize("$p");
      int q = a * d + b * c;
      int r = b * d;
      String mq = q > 0 ? "+" : "-";
      String mr = r > 0 ? "+" : "-";
      q = q.abs();
      r = r.abs();
      q1 = "($sa x$sb)($sc x$sd)";
      if (detailsort == "b") {
        ss1 = "$sp x^2[$mq][$q]x$mr$r ";
      } else if (detailsort == "c") {
        ss1 = "$sp x^2$mq$q x[$mr][$r] ";
      } else if (detailsort == "bc") {
        ss1 = "$sp x^2[$mq][$q]x[$mr][$r] ";
      }
    } else if (mainsort == "junkan") {
      final numbers = List.generate(8, (index) => index + 1);
      numbers.shuffle(random); // ランダムに並べ替え
      final a = numbers[0];
      final b = numbers[1];
      final c = numbers[2];
      final d = numbers[3];
      if (detailsort == "0.x") {
        int p = randomint(1, 3);
        if (p == 1) {
          q1 = "0.\\dot{$a}を分数に直すと";
          ss1 = "\\frac{$a}{9}";
        } else if (p == 2) {
          q1 = "0.\\dot{$a}\\dot{$b}を分数に直すと";
          ss1 = "\\frac{$a$b}{99}";
        } else {
          q1 = "0.\\dot{$a}$b\\dot{$c}を分数に直すと";
          ss1 = "\\frac{$a$b$c}{999}";
        }
      }
      if (detailsort == "a.x") {
        int p = randomint(1, 3);
        int k;
        if (p == 1) {
          k = 10 * d + a - d;
          q1 = "$d.\\dot{$a}を分数に直すと";
          ss1 = "\\frac{$k}{9}";
        } else if (p == 2) {
          k = 100 * d + 10 * a + b - d;
          q1 = "$d.\\dot{$a}\\dot{$b}を分数に直すと";
          ss1 = "\\frac{$k}{99}";
        } else {
          k = 1000 * d + 100 * a + 10 * b + c - d;
          q1 = "$d.\\dot{$a}$b\\dot{$c}を分数に直すと";
          ss1 = "\\frac{$k}{999}";
        }
      }
      if (detailsort == "0.0x") {
        int p = randomint(1, 3);
        if (p == 1) {
          q1 = "0.0\\dot{$a}を分数に直すと";
          ss1 = "\\frac{$a}{90}";
        } else if (p == 2) {
          q1 = "0.0\\dot{$a}\\dot{$b}を分数に直すと";
          ss1 = "\\frac{$a$b}{990}";
        } else {
          q1 = "0.0\\dot{$a}$b\\dot{$c}を分数に直すと";
          ss1 = "\\frac{$a$b$c}{9990}";
        }
      }

      q1 = "$q1;(約分不要)";
      ss2 = lc("$ss1+0");
      ss1 = "[$ss1]";
      ss2 = "[$ss2]";
    } else if (mainsort == "gauss") {
      if (detailsort == "double") {
        int a = randomint(-9, 9);
        int b = randomint(1, 9);
        String c = "$a.$b";
        int n = a < 0 ? a - 1 : a;
        q1 = "[$c]";
        ss1 = "[$n]";
      }
      if (detailsort == "sqrt") {
        int a;
        String c;
        double qa;
        do {
          a = randomint(1, 100);
        } while (hasSquareFactor(a));
        if (random.nextBool()) {
          c = "\\sqrt{$a}";
          qa = sqrt(a);
        } else {
          c = "-\\sqrt{$a}";
          qa = -sqrt(a);
        }
        int n = qa.floor();
        q1 = "[$c]";
        ss1 = "[$n]";
      }
    } else if (mainsort == "insuubunkai") {
      if (detailsort == "(ax+b)(cx+d)") {
        final Map<int, List<int>> divisorCountMap = {
          2: [6, 8, 10, 14, 15],
          3: [16, 22, 26, 27],
          4: [12, 18, 20, 28],
        };
        int number = int.parse(numbersort);
        int chosed = divisorCountMap[number]![
            random.nextInt(divisorCountMap[number]!.length)];
        int a, b, c, d;
        do {
          a = getRandomTrueDivisor(chosed);
          c = chosed ~/ a;
          b = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
          d = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
        } while ((a == 0 && c == 0) ||
            ((a * d + b * c).abs() < 2) ||
            (gcd(a, b) != 1) ||
            (gcd(c, d) != 1) ||
            b == d);
        String sb = b < 0 ? "$b" : "+$b";
        String sd = d < 0 ? "$d" : "+$d";

        int p = a * c;
        String sp = normalize("$p");
        int q = a * d + b * c;
        int r = b * d;
        String mq = q > 0 ? "+" : "-";
        String mr = r > 0 ? "+" : "-";
        q = q.abs();
        r = r.abs();
        ss1 = "([$a] x$sb)([$c] x$sd)";
        q1 = "$sp x^2$mq$q x$mr$r ";
      }
      if (detailsort == "(x+a)(x+b)") {
        int b, d;
        do {
          if (numbersort == "1-5") {
            b = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
            d = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
          } else {
            int p = randomint(1, 3);
            if (p == 1) {
              b = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
              d = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
            } else if (p == 2) {
              b = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
              d = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
            } else {
              b = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
              d = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
            }
          }
        } while (((d + b).abs() < 2) || b.abs() == d.abs());

        String mb = b > 0 ? "+" : "-";
        String md = d > 0 ? "+" : "-";

        int q = d + b;
        int r = b * d;
        String mq = q > 0 ? "+" : "-";
        String mr = r > 0 ? "+" : "-";
        q = q.abs();
        r = r.abs();
        b = b.abs();
        d = d.abs();
        q1 = "x^2$mq$q x$mr$r ";
        ss1 = "(x[$mb][$b])(x[$md][$d])";
        ss2 = "(x[$md][$d])(x[$mb][$b])";
      }
    } else if (mainsort == "equation2") {
      if (detailsort == "(x+a)(x+b)") {
        int b, d;
        do {
          if (numbersort == "1-5") {
            b = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
            d = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
          } else {
            int p = randomint(1, 3);
            if (p == 1) {
              b = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
              d = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
            } else if (p == 2) {
              b = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
              d = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
            } else {
              b = random.nextBool() ? randomint(6, 10) : -randomint(6, 10);
              d = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
            }
          }
        } while (((d + b).abs() < 2) || b.abs() == d.abs());
        int q = d + b;
        int r = b * d;
        String mq = q > 0 ? "+" : "-";
        String mr = r > 0 ? "+" : "-";
        q = q.abs();
        r = r.abs();
        q1 = "x^2$mq$q x$mr$r=0;の解は、";
        ss1 = "x=[${-b}],[${-d}]";
        ss2 = "x=[${-d}],[${-b}]";
      }
      if (detailsort == "b^2-4ac!=0") {
        int a, b, c;
        do {
          if (numbersort == "a=1") {
            a = 1;
          } else {
            a = randomint(2, 5);
          }
          b = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
          c = random.nextBool() ? randomint(1, 5) : -randomint(1, 5);
        } while (b * b - 4 * a * c < 0 ||
            hasSquareFactor(b * b - 4 * a * c) ||
            gcd(b, 2 * a) != 1);

        int p = 2 * a;
        int r = b * b - 4 * a * c;
        String mb = b > 0 ? "+" : "-";
        String mc = c > 0 ? "+" : "-";
        ss1 = "\\frac{[${-b}]\\pm [\\sqrt{$r}]}{$p}";
        b = b.abs();
        c = c.abs();
        String sa = normalize("$a");
        String sb = normalize("$b");
        q1 = "$sa x^2$mb$sb x$mc$c=0;の解は、";
      }
    } else if (mainsort == "eqline") {
      List<int> numbers = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
      double slope = 0;
      int x1 = 0, y1 = 0, x2 = 0, y2 = 0;
      int dy = 0, dx = 0;

      for (int attempt = 0; attempt < 1000; attempt++) {
        numbers.shuffle(random);
        x1 = numbers[0];
        y1 = numbers[1];
        x2 = numbers[2];
        y2 = numbers[3];

        dy = y2 - y1;
        dx = x2 - x1;

        slope = dy / dx;
        if (slope.abs() == 1) continue; // 切片 b = y1 - m*x1
        double b = y1 - slope * x1;

        // 条件に応じて再試行
        if (b == 0) continue; // 切片が 0 は不可

        if ((numbersort == "int" && slope.remainder(1) == 0) ||
            (numbersort == "frac" && slope.remainder(1) != 0)) {
          break;
        }
      }
      if (x1 > x2) {
        final tempX = x1;
        final tempY = y1;
        x1 = x2;
        y1 = y2;
        x2 = tempX;
        y2 = tempY;
      }
      String m = lc("($dy)/($dx)");
      String b = lc("($y1)-(($m)*($x1))");
      String zb = b.replaceAll("-", "");
      String mb = b.startsWith("-") ? "[-][$zb]" : "[+][$zb]";
      q1 = "点($x1,$y1),($x2,$y2)を通る;直線の方程式は？";
      ss1 = "y=[$m]x$mb";
    } else if (mainsort == "jyoyou") {
      int a = randomint(1, 2);
      if (a == 1) {
        int j = randomint(10, 20);
        int n = (0.301 * j).toInt();
        q1 = "\\log_{10} 2=0.301とする。;10^n<2^{$j}\\leqq10^{n+1}より、;2^{$j}の桁数は、";
        ss1 = "n=[$n],\\footnotesize{桁数}\\normalsize:[${n + 1}]";
      } else {
        int j = randomint(-20, -10);
        int n = (0.301 * j).toInt() - 1;
        q1 =
            "\\log_{10} 2=0.301とする。;10^n<2^{$j}\\leqq10^{n+1}より、;2^{$j}は小数第k位で;初めて0出ない数字が表れる";
        ss1 = "n=[$n],\\footnotesize{小数第k位}\\normalsize:[${-n}]";
      }
    } else if (mainsort == "maxmin") {
      int a;
      do {
        a = randomint(-5, 5); // -5〜5
      } while (a == 0); // a=0は除外

      int p = randomint(-5, 5); // -5〜5
      int q = randomint(-10, 10); // -10〜10
      String qq = randomQuadratic(a, p, q);
      int max, min;
      double rm;
      do {
        min = randomint(-7, 6);
        max = randomint(min + 1, 7);
        rm = (min + max) / 2;
      } while (rm == p);
      String range = "$min<x<$max";

      int smax, smin;
      if (a > 0) {
        if (rm < p) {
          smax = min;
        } else {
          smax = max;
        }
        if (max <= p) {
          smin = max;
        } else if (p <= min) {
          smin = min;
        } else {
          smin = p;
        }
      } else {
        if (rm < p) {
          smin = min;
        } else {
          smin = max;
        }
        if (max <= p) {
          smax = max;
        } else if (p <= min) {
          smax = min;
        } else {
          smax = p;
        }
      }
      q1 = "$qqについて、;定義域を$rangeとすると、";
      ss1 = "最小値 : x=[$smin]のとき;最大値 : x=[$smax]のとき";
    } else if (mainsort == "sougo") {
      int b = randomint(2, 5);
      int a = randomint(1, b ^ 2 - 1);
      String pm = random.nextBool() ? "-" : "";
      String cos = lc("($a^0.5)/$b");
      String sin = lc("(1-($cos)^2)^0.5");
      String tan1 = lc("$sin/$cos");
      String tan2 = lc("((1/($cos)^2)-1)^0.6");
      if (detailsort == "cos") {
        if (random.nextBool()) {
          q1 = "0<\\theta<90°とする;\\sin{\\theta}=$sinのとき";
          ss1 = "\\cos{\\theta}=[$cos]";
        } else {
          q1 = "90<\\theta<180°とする;\\sin{\\theta}=$sinのとき";
          ss1 = "\\cos{\\theta}=[-$cos]";
        }
      } else if (detailsort == "sin") {
        q1 = "0<\\theta<180°とする;\\cos{\\theta}=$pm$cosのとき";
        ss1 = "\\sin{\\theta}=[$sin]";
      } else if (detailsort == "tan") {
        q1 = "0<\\theta<180°とする;\\cos{\\theta}=$pm$cosのとき";
        ss1 = "\\tan{\\theta}=[$pm$tan1]";
        ss2 = "\\tan{\\theta}=[$pm$tan2]";
      }
    } else if (mainsort == "prime") {
      int s2 = 0, s3 = 0, s5 = 0, s7 = 0, value = 0;
      if (numbersort == "0-50") {
        do {
          s2 = randomint(0, 5);
          s3 = randomint(0, 2);
          s5 = randomint(0, 2);
          value = pow(2, s2).toInt() * pow(3, s3).toInt() * pow(5, s5).toInt();
        } while ((s2 + s3 + s5) < 3 ||
            [s2, s3, s5].where((x) => x > 0).length < 2 ||
            value > 50);
      }
      if (numbersort == "50-100") {
        do {
          s2 = randomint(0, 5);
          s3 = randomint(0, 3);
          s5 = randomint(0, 2);
          s7 = randomint(0, 2);
          value = pow(2, s2).toInt() *
              pow(3, s3).toInt() *
              pow(5, s5).toInt() *
              pow(7, s7).toInt();
        } while ((s2 + s3 + s5 + s7) < 3 ||
            [s2, s3, s5, s7].where((x) => x > 0).length < 2 ||
            value <= 50 ||
            value > 100);
      }
      if (numbersort == "100-150") {
        do {
          s2 = randomint(0, 6);
          s3 = randomint(0, 3);
          s5 = randomint(0, 2);
          s7 = randomint(0, 2);
          value = pow(2, s2).toInt() *
              pow(3, s3).toInt() *
              pow(5, s5).toInt() *
              pow(7, s7).toInt();
        } while ((s2 + s3 + s5 + s7) < 3 ||
            [s2, s3, s5, s7].where((x) => x > 0).length < 2 ||
            value <= 100 ||
            value > 150);
      }
      if (numbersort == "150-200") {
        do {
          s2 = randomint(0, 6);
          s3 = randomint(0, 4);
          s5 = randomint(0, 2);
          s7 = randomint(0, 2);
          value = pow(2, s2).toInt() *
              pow(3, s3).toInt() *
              pow(5, s5).toInt() *
              pow(7, s7).toInt();
        } while ((s2 + s3 + s5 + s7) < 3 ||
            [s2, s3, s5, s7].where((x) => x > 0).length < 2 ||
            value <= 150 ||
            value > 200);
      }
      q1 = "$valueを素因数分解すると";
      ss1 = "2^[$s2] \\cdot 3^[$s3] \\cdot 5^[$s5] \\cdot 7^[$s7]";
    }
    List<String> parts = q1.split(';');
    result["question1"] = parts.isNotEmpty ? parts[0] : "";
    result["question2"] = parts.length > 1 ? parts[1] : "";
    result["question3"] = parts.length > 2 ? parts[2] : "";
    result["question4"] = parts.length > 3 ? parts[3] : "";
    result["all1"] = ss1;
    if (ss2 != "") {
      result["all2"] = ss2;
    }
    return result;
  }
}

import 'dart:math';

import 'package:math_quiz/math_quiz.dart';

import '../providers/quiz_data_provider.dart';

// --------------------------------------------------
// 選択肢モード専用
// --------------------------------------------------
class OptionMakingData extends MakingData {
  final List<String> optionList;

  OptionMakingData({
    required super.pt,
    required super.questionList,
    required this.optionList,
  }) : super();
}

OptionMakingData makingOptionData(OptionPartData ct) {
  final random = Random();
  String q1 = "";
  String cr = "";
  String p1 = "";
  String p2 = "";
  String p3 = "";
  if (ct.making[0] == "discriminant") {
    final List<int> nonZeroRange = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
    int a, b, c;
    String k0 = "", k1 = "", k2 = "", nn = "";
    List<int> values = List.generate(
        3, (_) => nonZeroRange[random.nextInt(nonZeroRange.length)]);
    a = values[0];
    if (ct.making[2] == "a=1") {
      a = 1;
    }
    b = values[1];
    c = values[2];
    String sa = a.toString();
    String sb = b.toString();
    String sc = c.toString();
    int D = b * b - 4 * a * c;
    int p;
    if (ct.making[1] == "easy") {
      p = randomint(1, 3);
    } else {
      p = randomint(4, 5);
    }
    if (p == 1) {
      q1 = "二次方程式${makingFanction2D(sa, sb, sc)}=0は、";
      k2 = "2つの実数解が存在する";
      k1 = random.nextBool() ? "1つの実数解が存在する" : "重解を持つ";
      k0 = "実数解は存在しない";
    } else if (p == 2) {
      q1 = "二次関数f(x)=${makingFanction2D(sa, sb, sc)}は、";
      k2 = "x軸と2点で交わる";
      k1 = "x軸と1点で接する";
      k0 = "x軸とは交わらない";
    } else if (p == 3) {
      q1 = "二次関数f(x)=${makingFanction2D(sa, sb, sc)}は、";
      k2 = "x軸と2点で交わる";
      k1 = "x軸と1点で接する";
      if (a > 0) {
        k0 = "すべての実数xについてf(x)>0";
        nn = "すべての実数xについてf(x)<0";
      } else {
        k0 = "すべての実数xについてf(x)<0";
        nn = "すべての実数xについてf(x)>0";
      }
    } else if (p == 4) {
      q1 = "二次関数y=${makingFanction2D(sa, sb, "0")}と;直線y=${-c}は、";
      k2 = "2点で交わる";
      k1 = "1点で接する";
      k0 = "交わらない";
    } else if (p == 5) {
      q1 =
          "二次関数y=${makingFanction2D(sa, "0", "0")}と;直線y=${makingFanction1D("-$sb", "-$sc")}は、";
      k2 = "2点で交わる";
      k1 = "1点で接する";
      k0 = "交わらない";
    }
    if (D > 0) {
      cr = k2;
      p1 = k1;
      p2 = k0;
    }
    if (D == 0) {
      cr = k1;
      p1 = k0;
      p2 = k2;
    }
    if (D < 0) {
      cr = k0;
      p1 = k2;
      p2 = k1;
    }
    p3 = nn;
  } else if (ct.making[0] == "symmetry") {
    final List<int> nonZeroRange = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
    int a, b, c;
    String xy, y, x, nn;
    List<int> values = List.generate(
        3, (_) => nonZeroRange[random.nextInt(nonZeroRange.length)]);
    a = values[0];
    if (ct.making[2] == "a=1") {
      a = 1;
    }
    b = values[1];
    c = values[2];
    String sa = a.toString();
    String sb = b.toString();
    String sc = c.toString();
    q1 = "二次関数y=${makingFanction2D(sa, sb, sc)}を;";
    int p = randomint(1, 3);
    x = "y=${makingFanction2D("-$sa", "-$sb", "-$sc")}";
    y = "y=${makingFanction2D(sa, "-$sb", sc)}";
    xy = "y=${makingFanction2D("-$sa", sb, "-$sc")}";
    nn = "y=${makingFanction2D(sa, sb, "-$sc")}";

    if (p == 1) {
      q1 = "${q1}x軸に関して対象移動させると";
    }
    if (p == 2) {
      q1 = "${q1}y軸に関して対象移動させると";
    }
    if (p == 3) {
      q1 = "$q1原点に関して対象移動させると";
    }
    if (p == 1) {
      cr = x;
      p1 = y;
      p2 = xy;
    }
    if (p == 2) {
      cr = y;
      p1 = xy;
      p2 = x;
    }
    if (p == 3) {
      cr = xy;
      p1 = x;
      p2 = y;
    }
    p3 = nn;
  } else if (ct.making[0].contains("inequality_t")) {
    int k = ct.making[0].contains("2") ? 2 : 1;
    String allmax = ct.making[0].contains("2") ? "2\\pi" : "180°";
    String range = ct.making[0].contains("1")
        ? "0<\\theta<180°とする;"
        : "0<\\theta<2\\piとする;";
    if (ct.making[1] != "tan") {
      int q = randomint(1, 2);
      if (q == 1) {
        List<String> crList = [];

        while (crList.length < 4) {
          int a, b, c;
          if (k == 2) {
            do {
              a = randomint(-3, 2);
              b = randomint(a + 1, 3);
              c = randomint(-3, 3);
            } while (a == 0 || b == 0 || c == 0);
          } else {
            a = randomint(1, 2);
            b = randomint(a + 1, 3);
            c = randomint(1, 3);
          }

          String dmin = indexToValueSC(a);
          String dmax = indexToValueSC(b);
          String donly = indexToValueSC(c);
          String gmin1 = "${sinItoA(a)[0]}°";
          String gmin2 = "${sinItoA(a)[1]}°";
          String gmax1 = "${sinItoA(b)[0]}°";
          String gmax2 = "${sinItoA(b)[1]}°";
          String gonly1 = "${sinItoA(c)[0]}°";
          String gonly2 = "${sinItoA(c)[1]}°";

          if (k == 2) {
            gmin1 = degtorad(gmin1.replaceAll("°", ""));
            gmin2 = degtorad(gmin2.replaceAll("°", ""));
            gmax1 = degtorad(gmax1.replaceAll("°", ""));
            gmax2 = degtorad(gmax2.replaceAll("°", ""));
            gonly1 = degtorad(gonly1.replaceAll("°", ""));
            gonly2 = degtorad(gonly2.replaceAll("°", ""));
          }

          int p = crList.isEmpty ? randomint(1, 2) : randomint(3, 5);
          String cr = "";

          if (crList.isEmpty && ct.making[1] == "easy" || p == 4 || p == 5) {
            if (p == 1 || p == 4) {
              if (c > 0) {
                cr = "$gonly1<x<$gonly2";
              }
              if (c < 0) {
                cr = "0<x<$gonly1, $gonly2<x<$allmax";
              }
            }
            if (p == 2 || p == 5) {
              if (c < 0) {
                cr = "$gonly1<x<$gonly2";
              }
              if (c > 0) {
                cr = "0<x<$gonly1, $gonly2<x<$allmax";
              }
            }
          } else if (crList.isEmpty && ct.making[1] == "hard" || p == 3) {
            if (a > 0 && b > 0) {
              cr = "$gmin1<x<$gmax1, $gmax2<x<$gmin2";
            }
            if (a < 0 && b < 0) {
              cr = "$gmax1<x<$gmin1, $gmin2<x<$gmax2";
            }
            if (a < 0 && b > 0) {
              cr = "0<x<$gmax1, $gmax2<x<$gmin1, $gmin2<x<$allmax";
            }
          }
          if (crList.isEmpty) {
            if (ct.making[1] == "easy") {
              q1 = (p == 1) ? "\\sin{\\theta}>$donly" : "\\sin{\\theta}<$donly";
            } else {
              q1 = "$dmin<\\sin{\\theta}<$dmax";
            }
          }

          // 新規ならリストに追加
          if (!crList.contains(cr)) {
            crList.add(cr);
          }
        }

// 最終的に crList に 4 つの重複なし cr が入っている
        cr = crList[0];
        p1 = crList[1];
        p2 = crList[2];
        p3 = crList[3];
      }
      if (q == 2) {
        List<String> crList = [];

        while (crList.length < 4) {
          int a, b, c;

          do {
            a = randomint(-3, 2);
            b = randomint(a + 1, 3);
            c = randomint(-3, 3);
          } while (a == 0 || b == 0 || c == 0);

          String dmin = indexToValueSC(a);
          String dmax = indexToValueSC(b);
          String donly = indexToValueSC(c);
          String gmin1 = "${cosItoA(a)[0]}°";
          String gmin2 = "${cosItoA(a)[1]}°";
          String gmax1 = "${cosItoA(b)[0]}°";
          String gmax2 = "${cosItoA(b)[1]}°";
          String gonly1 = "${cosItoA(c)[0]}°";
          String gonly2 = "${cosItoA(c)[1]}°";

          if (k == 2) {
            gmin1 = degtorad(gmin1.replaceAll("°", ""));
            gmin2 = degtorad(gmin2.replaceAll("°", ""));
            gmax1 = degtorad(gmax1.replaceAll("°", ""));
            gmax2 = degtorad(gmax2.replaceAll("°", ""));
            gonly1 = degtorad(gonly1.replaceAll("°", ""));
            gonly2 = degtorad(gonly2.replaceAll("°", ""));
          }

          int p = crList.isEmpty ? randomint(1, 2) : randomint(3, 5);
          String cr = "";

          if (crList.isEmpty && ct.making[1] == "easy" || p == 4 || p == 5) {
            if (p == 1 || p == 4) {
              if (k == 1) {
                cr = "0<x<$gonly1";
              }
              if (k == 2) {
                cr = "0<x<$gonly1, $gonly2<x<2\\pi";
              }
            }
            if (p == 2 || p == 5) {
              if (k == 1) {
                cr = "$gonly1<x<$allmax";
              }
              if (k == 2) {
                cr = "$gonly1<x<$gonly2";
              }
            }
          } else if (crList.isEmpty && ct.making[1] == "hard" || p == 3) {
            if (k == 1) {
              cr = "$gmax1<x<$gmin1";
            }
            if (k == 2) {
              cr = "$gmax1<x<$gmin1, $gmin2<x<$gmax2";
            }
          }
          if (crList.isEmpty) {
            if (ct.making[1] == "easy") {
              q1 = (p == 1) ? "\\cos{\\theta}>$donly" : "\\cos{\\theta}<$donly";
            } else {
              q1 = "$dmin<\\cos{\\theta}<$dmax";
            }
          }

          // 新規ならリストに追加
          if (!crList.contains(cr)) {
            crList.add(cr);
          }
        }

// 最終的に crList に 4 つの重複なし cr が入っている
        cr = crList[0];
        p1 = crList[1];
        p2 = crList[2];
        p3 = crList[3];
      }
    } else {
      List<String> crList = [];

      while (crList.length < 4) {
        int c;

        do {
          c = randomint(-3, 3);
        } while (c == 0);

        String donly = indexToValueTan(c);
        String gonly1 = "${tanItoA(c)[0]}°";
        String gonly2 = "${tanItoA(c)[1]}°";

        if (k == 2) {
          gonly1 = degtorad(gonly1.replaceAll("°", ""));
          gonly2 = degtorad(gonly2.replaceAll("°", ""));
        }
        String cr = "";
        int p = randomint(1, 2);

        if (p == 1) {
          if (k == 1) {
            if (c > 0) {
              cr = "$gonly1<x<90°";
            }
            if (c < 0) {
              cr = "0<x<90°, $gonly1<x<180°";
            }
          }
          if (k == 2) {
            if (c > 0) {
              cr = "$gonly1<x<\\frac{\\pi}{2}, $gonly2<x<\\frac{3\\pi}{2}";
            }
            if (c < 0) {
              cr =
                  "0<x<\\frac{\\pi}{2}, $gonly1<x<\\frac{3\\pi}{2}, $gonly2<x<2\\pi";
            }
          }
        }
        if (p == 2) {
          if (k == 1) {
            if (c < 0) {
              cr = "90°<x<$gonly1";
            }
            if (c > 0) {
              cr = "0<x<$gonly1, 90°<x<180°";
            }
          }
          if (k == 2) {
            if (c < 0) {
              cr = "\\frac{\\pi}{2}<x<$gonly1, \\frac{3\\pi}{2}<x<$gonly2";
            }
            if (c > 0) {
              cr =
                  "0<x<$gonly1, \\frac{\\pi}{2}<x<$gonly2, \\frac{3\\pi}{2}<x<2\\pi";
            }
          }
        }
        if (crList.isEmpty) {
          q1 = (p == 1) ? "\\tan{\\theta}>$donly" : "\\tan{\\theta}<$donly";
        }
        if (!crList.contains(cr)) {
          crList.add(cr);
        }
      }
// 最終的に crList に 4 つの重複なし cr が入っている
      cr = crList[0];
      p1 = crList[1];
      p2 = crList[2];
      p3 = crList[3];
    }
    q1 = "$range$q1の解は、";
  } else if (ct.making[0].contains("value_t")) {
    int shogen(int input) {
      if (input <= 90) {
        return 1;
      } else if (input <= 180) {
        return 2;
      } else if (input <= 270) {
        return 3;
      } else {
        return 4;
      }
    }

    int k = ct.making[0].contains("2") ? 2 : 1;
    String zmax = "1";
    String zmin = "-1";
    if (ct.making[1] != "tan") {
      int q = randomint(1, 2);
      if (q == 1) {
        List<String> crList = [];
        while (crList.length < 4) {
          int dmin, dmax;
          int valuemin, valuemax, indexmin, indexmax;
          if (k == 2) {
            valuemin = randomint(-3, 2);
            valuemax = randomint(valuemin + 1, 3);
            indexmin = randomint(0, 1);
            indexmax = randomint(0, 1);
          } else {
            valuemin = randomint(0, 2);
            valuemax = randomint(valuemin + 1, 3);
            indexmin = randomint(0, 1);
            indexmax = randomint(0, 1);
          }

          dmin = sinItoA(valuemin)[indexmin];
          dmax = sinItoA(valuemax)[indexmax];

          int pmin = min(dmin, dmax);
          int pmax = max(dmin, dmax);
          int smin = shogen(pmin);
          int smax = shogen(pmax);

          String vmin = indexToValueSC(valuemin);
          String vmax = indexToValueSC(valuemax);
          if (smin == 1 && smax != 1) {
            vmax = zmax;
          }
          if (smin != 4 && smax == 4 && k == 2) {
            vmin = zmin;
          }
          String sdmin = "$pmin°";
          String sdmax = "$pmax°";

          if (k == 2) {
            sdmin = degtorad(sdmin.replaceAll("°", ""));
            sdmax = degtorad(sdmax.replaceAll("°", ""));
          }
          String cr = "";

          cr = "$vmin<\\theta<$vmax";
          if (crList.isEmpty) {
            q1 = "定義域が$sdmin<\\theta<$sdmaxのとき、;\\sin{\\theta}の値域は";
          }

          // 新規ならリストに追加
          if (!crList.contains(cr)) {
            crList.add(cr);
          }
        }

// 最終的に crList に 4 つの重複なし cr が入っている
        cr = crList[0];
        p1 = crList[1];
        p2 = crList[2];
        p3 = crList[3];
      }
      if (q == 2) {
        List<String> crList = [];
        while (crList.length < 4) {
          int dmin, dmax;
          int valuemin, valuemax, indexmin, indexmax;

          valuemin = randomint(-3, 2);
          valuemax = randomint(valuemin + 1, 3);
          if (k == 2) {
            indexmin = randomint(0, 1);
            indexmax = randomint(0, 1);
          } else {
            indexmin = 0;
            indexmax = 0;
          }

          dmin = cosItoA(valuemin)[indexmin];
          dmax = cosItoA(valuemax)[indexmax];

          int pmin = min(dmin, dmax);
          int pmax = max(dmin, dmax);
          int smin = shogen(pmin);
          int smax = shogen(pmax);

          String vmin = indexToValueSC(valuemin);
          String vmax = indexToValueSC(valuemax);
          if ((smin == 1 || smin == 2) && (smax == 3 || smax == 4)) {
            vmin = zmin;
          }
          String sdmin = "$pmin°";
          String sdmax = "$pmax°";

          if (k == 2) {
            sdmin = degtorad(sdmin.replaceAll("°", ""));
            sdmax = degtorad(sdmax.replaceAll("°", ""));
          }
          String cr = "";

          cr = "$vmin<\\theta<$vmax";
          if (crList.isEmpty) {
            q1 = "定義域が$sdmin<\\theta<$sdmaxのとき、;\\cos{\\theta}の値域は";
          }

          // 新規ならリストに追加
          if (!crList.contains(cr)) {
            crList.add(cr);
          }
        }

// 最終的に crList に 4 つの重複なし cr が入っている
        cr = crList[0];
        p1 = crList[1];
        p2 = crList[2];
        p3 = crList[3];
      }
    }
  } else if (ct.making[0].contains("inequality_ex")) {
    int a = randomint(2, 5);
    int b = randomint(2, 3);
    int k = pow(a, b).toInt();
    List<String> crList = [];
    while (crList.length < 4) {
      String ds = random.nextBool() ? ">" : "<";
      String sd = ds == "<" ? ">" : "<";
      List<String> sa = ["$a", "\\left(\\frac{1}{$a}\\right)"];
      List<String> sb = ["$b", "-$b"];
      List<String> sx = ["x", "-x"];
      List<String> sk = ["$k", "\\frac{1}{$k}", "-$k", "-\\frac{1}{$k}"];
      if (crList.isEmpty) {
        if (ct.making[2] == "easy") {
          int p = randomint(1, 2);
          if (p == 1) {
            q1 = "${sa[0]}^{${sx[0]}}$ds${sk[0]}";
            cr = "x$ds${sb[0]}";
          }
          if (p == 2) {
            q1 = "${sa[0]}^${sx[0]}$ds${sk[randomint(2, 3)]}";
            cr = ds == ">" ? "すべての実数" : "存在しない";
          }
        }
        if (ct.making[2] == "hard") {
          int ra = randomint(0, 1);
          int rx = randomint(0, 1);
          int rk = randomint(0, 1);
          q1 = "${sa[ra]}^{${sx[rx]}}$ds${sk[rk]}";
          int rb = (ra + rx + rk) % 2 == 1 ? 1 : 0;
          ds = ra + rx == 1 ? sd : ds;
          cr = "x$ds${sb[rb]}";
        }

        q1 = "$q1の解は、";
        crList.add(cr);
      }

      if (crList.isNotEmpty) {
        List<String> option = [
          "x<${sb[0]}",
          "x<${sb[1]}",
          "x>${sb[0]}",
          "x>${sb[1]}",
          "すべての実数",
          "存在しない"
        ];
        int add = randomint(0, 5);
        if (!crList.contains(option[add])) {
          crList.add(option[add]);
        }
      }

// 最終的に crList に 4 つの重複なし cr が入っている
    }
    cr = crList[0];
    p1 = crList[1];
    p2 = crList[2];
    p3 = crList[3];
  } else if (ct.making[0].contains("inequality_log")) {
    int a = randomint(2, 5);
    int b = randomint(2, 3);
    int k = pow(a, b).toInt();
    List<String> crList = [];
    while (crList.length < 4) {
      String ds = random.nextBool() ? ">" : "<";
      String sd = ds == "<" ? ">" : "<";
      List<String> sa = ["$a", "\\frac{1}{$a}"];
      List<String> sb = ["$b", "-$b"];
      List<String> sk = ["$k", "\\frac{1}{$k}"];
      if (crList.isEmpty) {
        if (ct.making[2] == "easy") {
          q1 = "\\log_{$a}x$ds$b";
          cr = "x$ds${sk[0]}";
        }
        if (ct.making[2] == "hard") {
          int ra = randomint(0, 1);
          int rb = randomint(0, 1);
          q1 = "\\log_{${sa[ra]}}x$ds${sb[rb]}";
          int rk = (ra + rb) % 2 == 1 ? 1 : 0;
          ds = ra == 1 ? sd : ds;
          cr = "x$ds${sk[rk]}";
        }
        cr = cr.replaceAll("x<", "0<x<");
        q1 = "$q1の解は、";
        crList.add(cr);
      }

      if (crList.isNotEmpty) {
        List<String> option = [
          "x<${sk[0]}",
          "x<${sk[1]}",
          "x>${sk[0]}",
          "x>${sk[1]}",
          "0<x<${sk[0]}",
          "0<x<${sk[1]}",
        ];
        int add = randomint(0, 3);
        if (!crList.contains(option[add])) {
          crList.add(option[add]);
        }
      }

// 最終的に crList に 4 つの重複なし cr が入っている
    }
    cr = crList[0];
    p1 = crList[1];
    p2 = crList[2];
    p3 = crList[3];
  }
  List<String> parts = q1.split(';');
  List<String> rawOptions = [cr, p1, p2, p3];
  List<String> optionList = rawOptions.where((s) => s.isNotEmpty).toList();
  OptionMakingData result =
      OptionMakingData(pt: ct, questionList: parts, optionList: optionList);

  return result;
}

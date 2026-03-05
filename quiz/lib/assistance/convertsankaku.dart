import 'latex_to_latex2.dart';
import 'parser.dart';

String vsin(String angle) {
  int? deg = int.tryParse(angle);
  if (deg == null) return angle;

  deg = ((deg % 360) + 360) % 360;

  int base;
  String sign;

  if (deg <= 90) {
    base = deg;
    sign = "";
  } else if (deg <= 180) {
    base = 180 - deg;
    sign = "";
  } else if (deg <= 270) {
    base = deg - 180;
    sign = "-";
  } else {
    base = 360 - deg;
    sign = "-";
  }

  switch (base) {
    case 0:
      return "0";
    case 30:
      return "$sign\\frac{1}{2}";
    case 45:
      return "$sign\\frac{\\sqrt{2}}{2}";
    case 60:
      return "$sign\\frac{\\sqrt{3}}{2}";
    case 90:
      return "${sign}1";
    default:
      return angle; // 定義されていない角度はそのまま返す
  }
}

String vcos(String angle) {
  int? deg = int.tryParse(angle);
  if (deg == null) return angle;

  deg = ((deg % 360) + 360) % 360;

  int base;
  String sign;

  if (deg <= 90) {
    base = deg;
    sign = "";
  } else if (deg <= 180) {
    base = 180 - deg;
    sign = "-";
  } else if (deg <= 270) {
    base = deg - 180;
    sign = "-";
  } else {
    base = 360 - deg;
    sign = "";
  }

  switch (base) {
    case 0:
      return "${sign}1";
    case 30:
      return "$sign\\frac{\\sqrt{3}}{2}";
    case 45:
      return "$sign\\frac{\\sqrt{2}}{2}";
    case 60:
      return "$sign\\frac{1}{2}";
    case 90:
      return "0";
    default:
      return angle;
  }
}

String vtan(String angle) {
  int? deg = int.tryParse(angle);
  if (deg == null) return angle;

  // 180度周期で正規化
  deg = ((deg % 180) + 180) % 180;

  int base;
  String sign;

  if (deg <= 90) {
    base = deg;
    sign = "";
  } else {
    base = 180 - deg;
    sign = "-";
  }

  switch (base) {
    case 0:
      return "0";
    case 30:
      return "$sign\\frac{\\sqrt{3}}{3}";
    case 45:
      return "${sign}1";
    case 60:
      return "$sign\\sqrt{3}";
    case 90:
      return "∞";
    default:
      return angle;
  }
}

String asin(String value) {
  switch (value) {
    case "0":
      return "0";
    case "\\frac{1}{2}":
      return "\\frac{\\pi}{6}";
    case "\\frac{\\sqrt{2}}{2}":
      return "\\frac{\\pi}{4}";
    case "\\frac{\\sqrt{3}}{2}":
      return "\\frac{\\pi}{3}";
    case "1":
      return "\\frac{\\pi}{2}";
    case "-\\frac{1}{2}":
      return "\\frac{7\\pi}{6}";
    case "-\\frac{\\sqrt{2}}{2}":
      return "\\frac{5\\pi}{4}";
    case "-\\frac{\\sqrt{3}}{2}":
      return "\\frac{4\\pi}{3}";
    case "-1":
      return "\\frac{3\\pi}{2}";
    default:
      return "未知";
  }
}

String acos(String value) {
  switch (value) {
    case "1":
      return "0";
    case "\\frac{1}{2}":
      return "\\frac{\\pi}{3}";
    case "\\frac{\\sqrt{2}}{2}":
      return "\\frac{\\pi}{4}";
    case "\\frac{\\sqrt{3}}{2}":
      return "\\frac{\\pi}{6}";
    case "0":
      return "\\frac{\\pi}{2}";
    case "-\\frac{1}{2}":
      return "\\frac{2\\pi}{3}";
    case "-\\frac{\\sqrt{2}}{2}":
      return "\\frac{3\\pi}{4}";
    case "-\\frac{\\sqrt{3}}{2}":
      return "\\frac{5\\pi}{6}";
    case "-1":
      return "\\pi";
    default:
      return "未知";
  }
}

String atan(String value) {
  switch (value) {
    case "0":
      return "0";
    case "\\frac{1}{\\sqrt{3}}":
      return "\\frac{\\pi}{6}";
    case "1":
      return "\\frac{\\pi}{4}";
    case "\\sqrt{3}":
      return "\\frac{\\pi}{3}";
    case "-\\frac{1}{\\sqrt{3}}":
      return "\\frac{5\\pi}{6}";
    case "-1":
      return "\\frac{3\\pi}{4}";
    case "-\\sqrt{3}":
      return "\\frac{2\\pi}{3}";
    case "未定義":
      return "θ=\\frac{\\pi}{2} または \\frac{3\\pi}{2}";
    default:
      return "未知";
  }
}

String radtodeg(String angle) {
  if (angle == "\\pi") {
    return "180";
  }
  if (angle == "-\\pi") {
    return "-180";
  }
  if (angle.contains("\\pi")) {
    String degree = angle.replaceAll("\\pi", "");
    degree = degree.replaceAll("{}", "{1}");
    degree = lc("$degree*180");
    return degree;
  } else {
    return angle;
  }
}

String degtorad(dynamic degree) {
  int? deg = int.tryParse(degree);
  if (deg == null) return degree;

  String angle = lc("$deg/180");
  if (angle == "0") {
    return "0";
  } else if (angle.contains("}")) {
    angle = angle.replaceFirst("}", "\\pi}");
    angle = angle.replaceFirst("{1\\pi}", "{\\pi}");
    return angle;
  } else {
    angle = normalize(angle);
    return "$angle\\pi";
  }
}

String normalizedegree(String degree) {
  int d = int.parse(degree);
  if (d > 360) {
    do {
      d = d - 360;
    } while (d >= 360);
  } else if (d < 0) {
    do {
      d = d + 360;
    } while (d < 0);
  }
  return d.toString();
}

String indexToValueSC(int input) {
  String value = "";
  if (input == 0) {
    value = "0";
  } else if (input.abs() == 1) {
    value = "\\frac{1}{2}";
  } else if (input.abs() == 2) {
    value = "\\frac{\\sqrt{2}}{2}";
  } else if (input.abs() == 3) {
    value = "\\frac{\\sqrt{3}}{2}";
  }
  if (input < 0) {
    value = "-$value";
  }
  return value;
}

String indexToValueTan(int input) {
  String value = "";
  if (input == 0) {
    value = "1";
  } else if (input.abs() == 1) {
    value = "\\frac{1}{\\sqrt{3}}";
  } else if (input.abs() == 2) {
    value = "1";
  } else if (input.abs() == 3) {
    value = "\\sqrt{3}";
  }
  if (input < 0) {
    value = "-$value";
  }
  return value;
}

List<int> tanItoA(int input) {
  List<int> arg = [];
  if (input == 0) {
    arg = [0, 180];
  } else if (input.abs() == 1) {
    arg = [30, 210];
  } else if (input.abs() == 2) {
    arg = [45, 225];
  } else if (input.abs() == 3) {
    arg = [60, 240];
  }
  if (input < 0) {
    arg = [360 - arg[1], 360 - arg[0]];
  }
  return arg;
}

List<int> sinItoA(int input) {
  List<int> arg = [];
  if (input == 0) {
    arg = [0, 180];
  } else if (input.abs() == 1) {
    arg = [30, 150];
  } else if (input.abs() == 2) {
    arg = [45, 135];
  } else if (input.abs() == 3) {
    arg = [60, 120];
  }
  if (input < 0) {
    arg = [arg[0] + 180, arg[1] + 180];
  }
  return arg;
}

List<int> cosItoA(int input) {
  int simplearg = 0;
  List<int> arg = [];
  if (input == 0) {
    simplearg = 90;
  } else if (input.abs() == 1) {
    simplearg = 60;
  } else if (input.abs() == 2) {
    simplearg = 45;
  } else if (input.abs() == 3) {
    simplearg = 30;
  }
  if (input < 0) {
    simplearg = 180 - simplearg;
  }
  arg = [simplearg, 360 - simplearg];
  return arg;
}

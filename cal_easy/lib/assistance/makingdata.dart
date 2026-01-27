import 'dart:math';

class OriginCentral {
  String mainsort;

  OriginCentral({required this.mainsort});

  Map<String, dynamic> makingvariable() {
    Map<String, dynamic> result = {};
    final random = Random();

    String ss1 = "";
    String q1 = "";

    // The 'fi1' is the same as mainsort, used for coloring.
    result["fi1"] = mainsort;

    int ran(int a, int b, {Set<int>? except}) {
      a = min(a, b);
      b = max(a, b);
      except ??= const {};

      final candidates = <int>[];
      for (int i = a; i <= b; i++) {
        if (!except.contains(i)) {
          candidates.add(i);
        }
      }

      if (candidates.isEmpty) {
        throw StateError('No valid numbers after exclusion');
      }

      return candidates[random.nextInt(candidates.length)];
    }

    if (mainsort == "3") {
      // plus
      int a, b;
      a = ran(1, 9);
      b = ran(1, 9);
      ss1 = (a + b).toString();
      q1 = "$a + $b = ？";
    } else if (mainsort == "2") {
      // minus_e
      int a, b;
      b = ran(1, 19);
      a = ran(b, 19);
      ss1 = (a - b).toString();
      q1 = "$a - $b = ？";
    } else if (mainsort == "5") {
      // times
      int a, b;
      a = ran(1, 9);
      b = ran(1, 9);
      ss1 = (a * b).toString();
      q1 = "$a × $b = ？";
    } else if (mainsort == "1") {
      // div
      int a, b;
      b = ran(1, 9);
      a = b * ran(1, 9);
      ss1 = (a ~/ b).toString();
      q1 = "$a ÷ $b = ？";
    } else if (mainsort == "6") {
      // plus2
      int a, b, c, d, x, y, f;
      b = ran(2, 9);
      d = ran(11 - b, 9);
      a = ran(1, 7);
      c = ran(1, 8 - a);
      x = 10 * a + b;
      y = 10 * c + d;
      f = x + y;
      ss1 = f.toString();
      q1 = "$x + $y = ？";
    } else if (mainsort == "8") {
      // plus2
      int a, b, c, d, x, y, f;
      b = ran(1, 8);
      d = ran(1, 9 - b);
      a = ran(1, 8);
      c = ran(1, 9 - a);
      x = 10 * a + b;
      y = 10 * c + d;
      f = x + y;
      ss1 = f.toString();
      q1 = "$x + $y = ？";
    } else if (mainsort == "4") {
      // plus2
      int a, b, c, d, x, y, f;
      b = ran(1, 8);
      d = ran(b + 1, 9);
      a = ran(3, 9);
      c = ran(1, a - 2);
      x = 10 * a + b;
      y = 10 * c + d;
      f = x - y;
      ss1 = f.toString();
      q1 = "$x - $y = ？";
    } else if (mainsort == "7") {
      // plus2
      int a, b, c, d, x, y, f;
      b = ran(2, 9);
      d = ran(1, b - 1);
      a = ran(2, 9);
      c = ran(1, a - 1);
      x = 10 * a + b;
      y = 10 * c + d;
      f = x - y;
      ss1 = f.toString();
      q1 = "$x - $y = ？";
    }

    List<String> parts = q1.split(';');
    result["question1"] = parts.isNotEmpty ? parts[0] : "";
    result["question2"] = parts.length > 1 ? parts[1] : "";
    result["question3"] = parts.length > 2 ? parts[2] : "";
    result["question4"] = parts.length > 3 ? parts[3] : "";
    result["all1"] = ss1;

    return result;
  }
}

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

    if (mainsort == "1") { // plus
      int a, b;
      a = ran(1, 9);
      b = ran(1, 9);
      ss1 = (a + b).toString();
      q1 = "$a + $b = ？";
    } else if (mainsort == "2") { // minus_e
      int a, b;
      b = ran(1, 19);
      a = ran(b, 19);
      ss1 = (a - b).toString();
      q1 = "$a - $b = ？";
    } else if (mainsort == "3") { // times
      int a, b;
      a = ran(1, 9);
      b = ran(1, 9);
      ss1 = (a * b).toString();
      q1 = "$a × $b = ？";
    } else if (mainsort == "4") { // div
      int a, b;
      b = ran(1, 9);
      a = b * ran(1, 9);
      ss1 = (a ~/ b).toString();
      q1 = "$a ÷ $b = ？";
    } else if (mainsort == "5") { // plus2
      int a, b, f;
      f = ran(22, 99);
      do {
        a = ran(11, f - 11);
        b = f - a;
      } while ((a % 10 == 0 || b % 10 == 0));
      ss1 = f.toString();
      q1 = "$a + $b = ？";
    } else if (mainsort == "6") { // minus2
      int a, b, f;
      f = ran(22, 88);
      do {
        a = ran(f, 99);
        b = a - f;
      } while ((a % 10 == 0 || b % 10 == 0));
      ss1 = f.toString();
      q1 = "$a - $b = ？";
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


import 'package:flutter_application_4/assistance/latex_to_latex2.dart';

List<dynamic> parseExpression(String expr) {
  List<dynamic> stack = [];
  List<dynamic> current = [];
  String buffer = "";

  final operators = ['+', '-', '*', '/', '^'];

  void flushBuffer() {
    if (buffer.isNotEmpty) {
      current.add(buffer);
      buffer = "";
    }
  }

  for (int i = 0; i < expr.length; i++) {
    String char = expr[i];

    if (char == '(') {
      flushBuffer();
      stack.add(current);
      current = [];
    } else if (char == ')') {
      flushBuffer();
      List<dynamic> last = stack.removeLast();
      last.add(current);
      current = last;
    } else if (operators.contains(char)) {
      // ここが重要：符号のマイナスかどうか
      if (char == '-' &&
          (i == 0 || operators.contains(expr[i - 1]) || expr[i - 1] == '(')) {
        // 前が演算子か括弧なら符号と判断（例：-6, 3*-2, (-4+5)）
        buffer += char;
      } else {
        flushBuffer();
        current.add(char);
      }
    } else if (char.trim().isEmpty) {
      flushBuffer(); // 空白でトークン確定
    } else {
      buffer += char;
    }
  }

  flushBuffer();
  return current;
}

dynamic replaceDeepestWithComputed(dynamic input) {
  int maxDepth = -1;
  List<List<int>> deepestPaths = [];

  // 深さ探索 + 最も深いリストのパスをすべて記録
  void findAllDeepest(dynamic node, int depth, List<int> path) {
    if (node is List) {
      if (!node.any((e) => e is List)) {
        // 子にリストがない＝最深層候補
        if (depth > maxDepth) {
          maxDepth = depth;
          deepestPaths = [List.from(path)];
        } else if (depth == maxDepth) {
          deepestPaths.add(List.from(path));
        }
      }
      for (int i = 0; i < node.length; i++) {
        findAllDeepest(node[i], depth + 1, [...path, i]);
      }
    }
  }

  // パスからノードを取得する補助関数
  dynamic getNodeAtPath(dynamic node, List<int> path) {
    dynamic current = node;
    for (final idx in path) {
      if (current is List && idx < current.length) {
        current = current[idx];
      } else {
        return null;
      }
    }
    return current;
  }

  // 再帰的にパスに従って置き換える関数
  dynamic replaceAtPath(dynamic node, List<int> path, dynamic newValue) {
    if (path.isEmpty) return newValue;
    final i = path.first;
    if (node is List) {
      return [
        for (int j = 0; j < node.length; j++)
          if (j == i)
            replaceAtPath(node[j], path.sublist(1), newValue)
          else
            node[j]
      ];
    } else {
      return node;
    }
  }

  // 四則演算の計算関数（例として）

  // 計算処理
  dynamic computeNewValue(List<dynamic>? list) {
    if (list == null) return null;
    if (list.length < 3) return list[0];

    // 1. まず ^ を先に計算してリストを縮約
    List<dynamic> temp1 = [];
    temp1.add(list[0]);
    for (int i = 1; i < list.length - 1; i += 2) {
      String op = list[i];
      dynamic next = list[i + 1];

      if (op == '^') {
        dynamic last = temp1.removeLast();
        temp1.add(powkai([last, next])); // ← powkai関数を自作 or 用意してください
      } else {
        temp1.add(op);
        temp1.add(next);
      }
    }

    // 2. 次に * / を計算
    List<dynamic> temp2 = [];
    temp2.add(temp1[0]);
    for (int i = 1; i < temp1.length - 1; i += 2) {
      String op = temp1[i];
      dynamic next = temp1[i + 1];

      if (op == '*') {
        dynamic last = temp2.removeLast();
        temp2.add(timeskai([last, next]));
      } else if (op == '/') {
        dynamic last = temp2.removeLast();
        temp2.add(div([last, next]));
      } else {
        temp2.add(op);
        temp2.add(next);
      }
    }

    // 3. 最後に + - を左から計算
    dynamic result = temp2[0];
    for (int i = 1; i < temp2.length - 1; i += 2) {
      String op = temp2[i];
      dynamic next = temp2[i + 1];

      if (op == '+') {
        result = pluskai([result, next]);
      } else if (op == '-') {
        result = minus([result, next]);
      } else {
        return null;
      }
    }

    return result;
  }

  // 最も深い階層のリストをすべて探す
  findAllDeepest(input, 0, []);

  // 元の構造を壊さずに複数の置換を繰り返す
  dynamic newInput = input;
  for (final path in deepestPaths) {
    final target = getNodeAtPath(newInput, path);
    if (target != null) {
      final newValue = computeNewValue(target);

      newInput = replaceAtPath(newInput, path, newValue);
    }
  }

  return newInput;
}

dynamic lc(String input) {
  if (input.startsWith("--")) {
    input = input.replaceFirst("--", "0--");
  }
  input = input.replaceAll("(--", "(0--");

  dynamic expr = parseExpression(input);

  dynamic current = expr;
  while (true) {
    final next = replaceDeepestWithComputed(current);

    // 置換後に変化がなければ終了（もう計算できる部分がない）
    if (_deepEqual(current, next)) {
      break;
    }
    current = next;
  }

  return current;
}

// シンプルな再帰的等価判定
bool _deepEqual(dynamic a, dynamic b) {
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!_deepEqual(a[i], b[i])) return false;
    }
    return true;
  } else {
    return a == b;
  }
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

// --- 表示部分 ---
class LatexDisplayView extends HookConsumerWidget {
  const LatexDisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    final inputState = ref.watch(latexInputNotifierProvider);
    final question = session.currentQuestion;

    if (question is! LatexMakingData) {
      return const SizedBox.shrink();
    }

    // ◯, ○, □, ☆ のすべてに対応
    final colorMap = {'◯': 'red', '○': 'red', '□': 'blue', '☆': 'orange'};
    final buffer = StringBuffer();
    int outputIdx = 0;

    for (int i = 0; i < question.initialLatexA.length; i++) {
      final char = question.initialLatexA[i];
      if (colorMap.containsKey(char)) {
        if (outputIdx < inputState.latexOutputs.length) {
          final color = colorMap[char]!;
          final content = inputState.latexOutputs[outputIdx];
          buffer.write(outputIdx == inputState.currentBoxIndex
              ? '\\textcolor{$color}{$content}'
              : '{$content}');
        } else {
          // 状態が追いついていない場合は記号自体を表示
          buffer.write(char);
        }
        outputIdx++;
      } else {
        buffer.write(char);
      }
    }

    final parts = buffer.toString().split(';');

    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: getQuizColor2(question.subject, context, 0.6, 0.2, 0.95),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              for (var part in parts)
                if (part.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Math.tex(part,
                        textStyle: TextStyle(
                            fontSize: 30, color: textColor1(context))),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- キーボード部分 ---
class LatexKeyboardView extends HookConsumerWidget {
  const LatexKeyboardView({super.key});

  static const Map<String, String> _buttonLabels = {
    "e": "e",
    "p": "\\pi",
    "7": "7",
    "8": "8",
    "9": "9",
    "r": "\\surd{□}",
    "4": "4",
    "5": "5",
    "6": "6",
    "f": "分数",
    "1": "1",
    "2": "2",
    "3": "3",
    "-": "-",
    "0": "0",
    "+": "+",
    "l": "log",
    "s": "\\sin",
    "c": "\\cos",
    "t": "tan",
    "i": "\\infty",
    "^": "□^□",
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final question =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));

    if (question is! LatexMakingData) return const SizedBox.shrink();

    ref.listen(quizSessionNotifierProvider.select((s) => s.currentQuestion),
        (prev, next) {
      if (next != null) controller.clear();
    });

    // 追加：ボックス（入力箇所）が変わった時もコントローラーをクリアする
    ref.listen(latexInputNotifierProvider.select((s) => s.currentBoxIndex),
        (prev, next) {
      if (next != prev) controller.clear();
    });

    void processInput(String symbol) {
      final notifier = ref.read(latexInputNotifierProvider.notifier);
      final inputState = ref.read(latexInputNotifierProvider);
      final sessionState = ref.read(quizSessionNotifierProvider);
      final config = ref.read(currentDetailConfigProvider);

      if (sessionState.isAnswerChecked || sessionState.isGameOver) return;

      final sound = RegExp(r'\d').hasMatch(symbol) ? '$symbol.mp3' : '0.mp3';
      ref.read(appSoundProvider).requireValue.playSound(sound);

      _updateController(controller, symbol);

      // 入力された値を Provider に通知しつつ、判定も委ねる
      notifier.updateLatexOutput(inputState.currentBoxIndex, controller.text);
      notifier.processSymbol(symbol, config);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          _buildSidePanel(question.firstButton, (s) => processInput(s)),
          Expanded(
              flex: 3,
              child: _buildNumberPad(
                  ref, question.firstButton, (s) => processInput(s))),
        ],
      ),
    );
  }

  void _updateController(TextEditingController controller, String symbol) {
    String textToInsert = symbol;
    int cursorOffset = 0;
    switch (symbol) {
      case "p":
        textToInsert = "\\pi";
        break;
      case "i":
        textToInsert = "\\infty";
        break;
      case "s":
        textToInsert = "\\sin";
        break;
      case "c":
        textToInsert = "\\cos";
        break;
      case "t":
        textToInsert = "\\tan";
        break;
      case "l":
        textToInsert = "\\log";
        break;
      case "r":
        textToInsert = "\\sqrt{}";
        cursorOffset = -1;
        break;
      case "^":
        textToInsert = "^{}";
        cursorOffset = -1;
        break;
      case "f":
        _handleFraction(controller);
        return;
    }

    final text = controller.text;
    final selection = controller.selection;
    final start =
        selection.baseOffset == -1 ? text.length : selection.baseOffset;
    final end =
        selection.extentOffset == -1 ? text.length : selection.extentOffset;

    controller.text = text.replaceRange(start, end, textToInsert);
    controller.selection = TextSelection.collapsed(
        offset: (start + textToInsert.length + cursorOffset)
            .clamp(0, controller.text.length));
  }

  void _handleFraction(TextEditingController controller) {
    String current = controller.text;
    int pos = controller.selection.baseOffset == -1
        ? current.length
        : controller.selection.baseOffset;
    if (pos <= 0) return;

    int start = pos - 1;
    while (start > 0) {
      if (start >= 2 && current.substring(start - 2, start) == '{-') {
        start -= 2;
        break;
      }
      if (current[start - 1] == '{' &&
          (start < 3 || !current.substring(start - 3, start).contains("t{"))) {
        start -= 1;
        break;
      }
      if ("+-".contains(current[start - 1])) {
        start -= 1;
        break;
      }
      start--;
    }

    String extracted = current.substring(start, pos);
    String sign = "";
    String content = extracted;

    if (content.startsWith("{-")) {
      sign = "{-";
      content = content.substring(2);
    } else if (content.startsWith("-")) {
      sign = "-";
      content = content.substring(1);
    } else if (content.startsWith("+")) {
      sign = "+";
      content = content.substring(1);
    } else if (content.startsWith("{")) {
      sign = "{";
      content = content.substring(1);
    }

    String newPart;
    if (content.contains("sqrt") && sign.contains("{")) {
      newPart = "$sign\\frac{}{$content}}}";
    } else if (content.contains("sqrt") || sign.contains("{")) {
      newPart = "$sign\\frac{}{$content}}";
    } else if (content.isNotEmpty) {
      newPart = "$sign\\frac{}{$content}";
    } else {
      return;
    }

    controller.text = current.replaceRange(start, pos, newPart);
    controller.selection =
        TextSelection.collapsed(offset: start + sign.length + 6);
  }

  Widget _buildSidePanel(String type, Function(String) onTap) {
    Widget k(String s) => _Key(symbol: s, onTap: onTap);
    switch (type) {
      case "s":
        return Expanded(
            flex: 2,
            child: Column(children: [
              Expanded(child: k("p")),
              Expanded(child: k("r")),
              Expanded(flex: 2, child: k("f"))
            ]));
      case "lsct":
        return Expanded(
            flex: 2,
            child: Column(children: [
              Expanded(child: k("s")),
              Expanded(child: k("c")),
              Expanded(flex: 2, child: k("f"))
            ]));
      case "m":
        return Expanded(
            flex: 2,
            child: Column(children: [
              Expanded(
                  child: Row(children: [
                Expanded(child: k("e")),
                Expanded(child: k("^"))
              ])),
              Expanded(
                  child: Row(children: [
                Expanded(child: k("p")),
                Expanded(child: k("r"))
              ])),
              Expanded(child: k("f")),
              Expanded(child: k("i")),
            ]));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNumberPad(
      WidgetRef ref, String firstButton, Function(String) onTap) {
    final latexButton = ref.read(appNumberProvider);
    final List<List<String>> rows;
    if (latexButton.value == "mobile") {
      rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["-", "0", "+"]
      ];
    } else {
      rows = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["-", "0", "+"]
      ];
    }

    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((s) {
              // --- 条件判定 ---
              // firstButtonが "a" かつ、現在の記号が "-" または "+" の場合は空白にする
              if (firstButton == "a" && (s == "-" || s == "+")) {
                return const Expanded(child: SizedBox.shrink());
              }
              return Expanded(
                child: _Key(symbol: s, onTap: onTap),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _Key extends HookConsumerWidget {
  final String symbol;
  final Function(String) onTap;
  const _Key({required this.symbol, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(latexInputNotifierProvider
        .select((s) => s.buttonVisibility[symbol] ?? true));
    final label = LatexKeyboardView._buttonLabels[symbol] ?? symbol;
    final isWide = label == "\\cos" || label == "\\sin";

    final question =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));
    final category = question is LatexMakingData ? question.subject : "math";

    final baseColor = getQuizColor2(category, context, 0.6, 0.2, 0.95);
    final color = isVisible ? baseColor : baseColor.withAlpha(30);
    final textColor =
        isVisible ? textColor1(context) : textColor1(context).withAlpha(50);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: isVisible ? () => onTap(symbol) : null,
        borderRadius: BorderRadius.circular(isWide ? 20 : 40),
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(isWide ? 20 : 40)),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Math.tex(label,
                textStyle: TextStyle(fontSize: 30, color: textColor)),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 英単語モード専用 UI
// --------------------------------------------------

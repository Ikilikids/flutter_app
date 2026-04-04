import 'package:common/common.dart';
import "package:quiz/quiz.dart";
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'latex_provider.g.dart';

// --- LatexInputNotifierは変更なし ---
class LatexInputState {
  final List<String> latexOutputs;
  final int currentBoxIndex;
  final int boxSubIndex;
  final List<String> allEnteredSymbols;
  final Map<String, bool> buttonVisibility;

  LatexInputState({
    required this.latexOutputs,
    this.currentBoxIndex = 0,
    this.boxSubIndex = 0,
    this.allEnteredSymbols = const [],
    this.buttonVisibility = const {},
  });

  LatexInputState copyWith({
    List<String>? latexOutputs,
    int? currentBoxIndex,
    int? boxSubIndex,
    List<String>? allEnteredSymbols,
    Map<String, bool>? buttonVisibility,
  }) {
    return LatexInputState(
      latexOutputs: latexOutputs ?? this.latexOutputs,
      currentBoxIndex: currentBoxIndex ?? this.currentBoxIndex,
      boxSubIndex: boxSubIndex ?? this.boxSubIndex,
      allEnteredSymbols: allEnteredSymbols ?? this.allEnteredSymbols,
      buttonVisibility: buttonVisibility ?? this.buttonVisibility,
    );
  }
}

@riverpod
class LatexInputNotifier extends _$LatexInputNotifier {
  @override
  LatexInputState build() {
    final question =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));

    if (question is LatexMakingData) {
      final boxSymbols = RegExp("[◯○□☆]").allMatches(question.initialLatexA);
      final outputs = boxSymbols.map((m) => m.group(0)!).toList();
      final initialConfig =
          question.indexDataA.isNotEmpty ? question.indexDataA[0].button : "";

      return LatexInputState(
        latexOutputs: outputs,
        buttonVisibility: _calculateInitialVisibility(initialConfig),
        allEnteredSymbols: [],
        currentBoxIndex: 0,
        boxSubIndex: 0,
      );
    }
    return LatexInputState(latexOutputs: []);
  }

  Map<String, bool> _calculateInitialVisibility(String config) {
    final visibility = <String, bool>{};
    const labels = [
      "e",
      "p",
      "7",
      "8",
      "9",
      "r",
      "4",
      "5",
      "6",
      "f",
      "1",
      "2",
      "3",
      "-",
      "0",
      "+",
      "l",
      "s",
      "c",
      "t",
      "i",
      "^"
    ];
    for (var k in labels) {
      visibility[k] = false;
    }

    if (config == "a") {
      for (var k in ['s', 'c', 't', 'l']) {
        visibility[k] = true;
      }
    } else if (config == "[+-]") {
      for (var k in ['+', '-']) {
        visibility[k] = true;
      }
    } else {
      final hideChars = config.split('').toSet();
      for (var k in labels) {
        if (!hideChars.contains(k)) {
          visibility[k] = true;
        }
      }
    }
    visibility["f"] = false;
    visibility["^"] = false;
    return visibility;
  }

  void updateVisibility(String lastSymbol, int nextBoxSubIndex) {
    final nextVisibility = Map<String, bool>.from(state.buttonVisibility);
    if (nextBoxSubIndex >= 1) {
      for (var k in ["+", "-", "l", "s", "c", "t"]) {
        nextVisibility[k] = false;
      }
    }

    if ("0123456789p".contains(lastSymbol)) {
      nextVisibility["f"] = true;
      nextVisibility["^"] = true;
      nextVisibility["i"] = false;
    } else if (lastSymbol == "e") {
      nextVisibility["f"] = false;
      nextVisibility["^"] = true;
      nextVisibility["i"] = false;
    } else if (lastSymbol == "f") {
      nextVisibility["f"] = false;
      nextVisibility["^"] = false;
      nextVisibility["r"] = true;
    } else if (lastSymbol == "r" || lastSymbol == "^") {
      nextVisibility["r"] = false;
      nextVisibility["^"] = false;
      if (lastSymbol == "^") {
        nextVisibility["-"] = true;
      }
    }
    state = state.copyWith(buttonVisibility: nextVisibility);
  }

  void moveToNextBox(String nextConfig) {
    state = state.copyWith(
      currentBoxIndex: state.currentBoxIndex + 1,
      boxSubIndex: 0,
      buttonVisibility: _calculateInitialVisibility(nextConfig),
    );
  }

  void updateLatexOutput(int index, String value) {
    if (index >= state.latexOutputs.length) {
      return;
    }
    final newOutputs = List<String>.from(state.latexOutputs);
    newOutputs[index] = value;
    state = state.copyWith(latexOutputs: newOutputs);
  }

  void processSymbol(String symbol, DetailConfig config) {
    final sessionState = ref.read(quizSessionNotifierProvider);
    final sessionNotifier = ref.read(quizSessionNotifierProvider.notifier);
    final question = sessionState.currentQuestion;

    if (question is! LatexMakingData) return;
    if (sessionState.isAnswerChecked || sessionState.isGameOver) return;

    // シンボルを追加
    state = state.copyWith(
      allEnteredSymbols: [...state.allEnteredSymbols, symbol],
      boxSubIndex: state.boxSubIndex + 1,
    );

    final flatA = question.indexDataA.expand((e) => e.tokenList).toList();
    final flatB = question.indexDataB.expand((e) => e.tokenList).toList();

    bool isPrefixMatch(List<String> target) {
      if (target.isEmpty) return false;
      if (state.allEnteredSymbols.length > target.length) return false;
      for (int i = 0; i < state.allEnteredSymbols.length; i++) {
        if (target[i] != state.allEnteredSymbols[i]) return false;
      }
      return true;
    }

    bool matchA = isPrefixMatch(flatA);
    bool matchB = flatB.isNotEmpty && isPrefixMatch(flatB);

    if (matchA || matchB) {
      final currentPath = matchA ? question.indexDataA : question.indexDataB;
      final currentBoxTokens = currentPath[state.currentBoxIndex].tokenList;

      if (state.boxSubIndex == currentBoxTokens.length) {
        if (state.currentBoxIndex >= currentPath.length - 1) {
          sessionNotifier.judge(QuizResult.circle, config);
        } else {
          ref.read(appSoundProvider).playSound('maru.mp3');
          sessionNotifier
              .handlePartPoint(currentPath[state.currentBoxIndex].score * 10);
          moveToNextBox(currentPath[state.currentBoxIndex + 1].button);
        }
      } else {
        updateVisibility(symbol, state.boxSubIndex);
      }
    } else {
      sessionNotifier.judge(QuizResult.cross, config);
    }
  }

  void addSymbol(String symbol) {
    state = state.copyWith(
      allEnteredSymbols: [...state.allEnteredSymbols, symbol],
      boxSubIndex: state.boxSubIndex + 1,
    );
  }
}

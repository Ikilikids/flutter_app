import 'package:common/common.dart';
import "package:quiz/quiz.dart";
import 'package:riverpod_annotation/riverpod_annotation.dart';

// --- EngInputState & EngInputNotifier ---
class EngInputState {
  final String enteredText;
  final List<String> availableButtons;
  final bool isHintUsed;

  EngInputState({
    required this.enteredText,
    required this.availableButtons,
    this.isHintUsed = false,
  });

  EngInputState copyWith({
    String? enteredText,
    List<String>? availableButtons,
    bool? isHintUsed,
  }) {
    return EngInputState(
      enteredText: enteredText ?? this.enteredText,
      availableButtons: availableButtons ?? this.availableButtons,
      isHintUsed: isHintUsed ?? this.isHintUsed,
    );
  }
}

final engInputNotifierProvider =
    NotifierProvider<EngInputNotifier, EngInputState>(EngInputNotifier.new);

class EngInputNotifier extends Notifier<EngInputState> {
  @override
  EngInputState build() {
    final question =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));

    if (question is EngMakingData) {
      return EngInputState(
        enteredText: "",
        availableButtons: List.from(question.buttons),
        isHintUsed: false,
      );
    }
    return EngInputState(
        enteredText: "", availableButtons: [], isHintUsed: false);
  }

  void processLetter(int index, DetailConfig config, {bool isHint = false}) {
    final sessionState = ref.read(quizSessionNotifierProvider);
    final sessionNotifier = ref.read(quizSessionNotifierProvider.notifier);
    final question = sessionState.currentQuestion;

    if (question is! EngMakingData) return;
    if (sessionState.isAnswerChecked || sessionState.isGameOver) return;

    final buttons = List<String>.from(state.availableButtons);
    final char = buttons[index];
    if (char.endsWith('*')) return; // 使用済み

    final nextText = state.enteredText + char;
    buttons[index] = '$char*'; // 使用済みマークを付ける

    state = state.copyWith(
      enteredText: nextText,
      availableButtons: buttons,
    );

    final targetWord = question.word.toLowerCase();

    if (targetWord.startsWith(nextText)) {
      if (nextText.length == targetWord.length) {
        // 完成時は judge でボーナス加算
        sessionNotifier
            .judge(state.isHintUsed ? QuizResult.triangle : QuizResult.circle);
      } else {
        sessionNotifier.handlePartPoint(isHint ? 0 : nextText.length,
            isHintUsed: isHint);
      }
    } else {
      sessionNotifier.judge(QuizResult.cross);
    }
  }

  void giveHint(DetailConfig config) {
    final sessionState = ref.read(quizSessionNotifierProvider);
    final question = sessionState.currentQuestion;
    if (question is! EngMakingData) return;

    final targetWord = question.word.toLowerCase();
    final currentLen = state.enteredText.length;

    // トレーニングモード（!isbattle）なら n-2 文字目までヒント可。
    // バトルモードなら最初の1文字目のみ。
    final maxHintLen = config.modeData.isbattle
        ? 1
        : (targetWord.length - 2).clamp(1, targetWord.length);

    if (currentLen >= maxHintLen) return;

    state = state.copyWith(isHintUsed: true);

    // 次に必要な文字
    final nextChar = targetWord[currentLen];

    // 未使用のボタン（末尾に '*' が付いていない完全一致のもの）から探す
    final index = state.availableButtons.indexWhere((b) => b == nextChar);
    if (index != -1) {
      processLetter(index, config, isHint: true);
    }
  }

  void backspace() {
    if (state.enteredText.isNotEmpty) {
      final lastChar = state.enteredText[state.enteredText.length - 1];
      final nextText =
          state.enteredText.substring(0, state.enteredText.length - 1);

      final buttons = List<String>.from(state.availableButtons);
      // 最後に使用されたその文字のボタン（末尾が*のもの）を探して元に戻す
      final marker = '$lastChar*';
      final index = buttons.lastIndexOf(marker);
      if (index != -1) {
        buttons[index] = lastChar;
      }

      state = state.copyWith(
        enteredText: nextText,
        availableButtons: buttons,
      );
    }
  }
}

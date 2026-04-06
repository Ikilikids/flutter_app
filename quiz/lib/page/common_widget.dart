import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:quiz/quiz.dart";

// --- UI Components (自立型) ---

/// スコア表示用Widget (旧 pointwidget)
class PointWidget extends HookConsumerWidget {
  const PointWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 必要なデータだけをピンポイントでwatch
    final remainingTime = ref.watch(quizRemainingTimerProvider);
    final totalScore =
        ref.watch(quizSessionNotifierProvider.select((s) => s.totalScore));
    final correctCount =
        ref.watch(quizSessionNotifierProvider.select((s) => s.correctCount));
    final timeMode =
        ref.watch(currentDetailConfigProvider.select((s) => s.timeMode));
    final num score = switch (timeMode) {
      TimeMode.timeAttack => correctCount,
      TimeMode.countDown => totalScore,
      TimeMode.learning => totalScore,
    };
    final bool hidden = switch (timeMode) {
      TimeMode.timeAttack => false,
      TimeMode.countDown => remainingTime <= 15,
      TimeMode.learning => false,
    };
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          _StatHeader(
            title: l10n(context, 'pointHeader'),
            isDark: isDark,
          ),
          _StatValueBox(
            value: hidden ? '??' : '$score',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

/// タイマー表示用Widget (旧 timewidget)
class TimeWidget extends HookConsumerWidget {
  const TimeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elapsed = ref.watch(quizElapsedTimerProvider);
    final correctCount =
        ref.watch(quizSessionNotifierProvider.select((s) => s.correctCount));
    final sort =
        ref.watch(currentDetailConfigProvider.select((c) => c.detail.sort));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final int changeCount = sort == "4867" ? 8 : 16;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          _StatHeader(
            title: l10n(context, 'timeHeader'),
            isDark: isDark,
          ),
          _StatValueBox(
            // ロジック：正解数が一定を超えると時間を隠す
            value:
                correctCount < changeCount ? elapsed.toStringAsFixed(2) : "??",
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

/// 問題情報表示Widget (ドメイン、分野、難易度)
class QuizInfoWidget extends HookConsumerWidget {
  const QuizInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question =
        ref.watch(quizSessionNotifierProvider.select((s) => s.currentQuestion));
    if (question == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ドメイン
          Expanded(
            flex: 5,
            child: _LabelBox(
              text: question.domain,
              color: isDark
                  ? getQuizColor2(question.subject, context, 0.6, 0.4, 0.65)
                  : getQuizColor2(question.subject, context, 0.6, 0.4, 0.95),
            ),
          ),
          // 分野
          Expanded(
            flex: 4,
            child: _LabelBox(
              text: question.field,
              color: const Color.fromARGB(99, 111, 111, 111),
            ),
          ),
          // 難易度（星）
          Expanded(
            flex: 4,
            child: _LabelBox(
              text: '★' * question.totalScore,
              color: bgColor1(context).withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}

/// 正誤履歴リストWidget
class MaruPekeListWidget extends HookConsumerWidget {
  const MaruPekeListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marks =
        ref.watch(quizSessionNotifierProvider.select((s) => s.historyMarks));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (marks.isEmpty) return const SizedBox.shrink();

    // 内部パーツ：正誤アイコン
    Widget buildMarkBox(QuizResult mark) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: mark == QuizResult.unknown
            ? null
            : Image.asset(isDark
                ? 'assets/images/${mark.name}_dark.png'
                : 'assets/images/${mark.name}.png'),
      );
    }

    if (marks.length <= 5) {
      return Row(
        children: List.generate(
            marks.length,
            (i) => Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1, child: FittedBox(child: Text("${i + 1}問目"))),
                      Expanded(flex: 3, child: buildMarkBox(marks[i])),
                    ],
                  ),
                )),
      );
    }

    // 2段表示
    final upper = marks.take(5).toList();
    final lower = marks.skip(5).toList();

    return Column(
      children: [
        Expanded(
            child: Row(
                children: upper
                    .map((m) => Expanded(child: buildMarkBox(m)))
                    .toList())),
        Expanded(
            child: Row(
                children: lower
                    .map((m) => Expanded(child: buildMarkBox(m)))
                    .toList())),
      ],
    );
  }
}

/// スコア変動フィードバックWidget
class IncreaseFeedbackWidget extends HookConsumerWidget {
  const IncreaseFeedbackWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f1 =
        ref.watch(quizSessionNotifierProvider.select((s) => s.scoreFeedback1));
    final f2 =
        ref.watch(quizSessionNotifierProvider.select((s) => s.scoreFeedback2));

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
              child: _FeedbackText(text: f2, color: const Color(0xFF0080FF))),
          Expanded(
              child: _FeedbackText(text: f1, color: const Color(0xFFFF0000))),
        ],
      ),
    );
  }
}

// --- Internal Reusable Parts (Private) ---

class _StatHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  const _StatHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFFD77936) : Colors.orangeAccent,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: FittedBox(
                child: Text(title,
                    style: TextStyle(
                        color: textColor1(context),
                        fontWeight: FontWeight.bold))),
          ),
        ),
        const Expanded(child: SizedBox()),
      ]),
    );
  }
}

class _StatValueBox extends StatelessWidget {
  final String value;
  final bool isDark;
  const _StatValueBox({required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? const Color(0xFFD77936) : Colors.orangeAccent,
              width: 2),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6)),
        ),
        child: FittedBox(
            child: Text(value,
                style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: textColor1(context)))),
      ),
    );
  }
}

class _LabelBox extends StatelessWidget {
  final String text;
  final Color color;
  const _LabelBox({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        child: Text(text,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: textColor1(context))),
      ),
    );
  }
}

class _FeedbackText extends StatelessWidget {
  final String text;
  final Color color;
  const _FeedbackText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }
}

// --- Main Question Builder ---

class QuestionDisplayArea extends ConsumerWidget {
  /// 復習モードなどで特定のインデックスを表示したい場合のみ指定。
  /// 指定がない（null）場合は、セッションの「現在の進行中の問題」を表示する。
  final int? index;

  const QuestionDisplayArea({super.key, this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizSessionNotifierProvider);
    print(
        "QuestionDisplayArea build: index=$index, historyLength=${session.historyQuestions.length}");
    // index指定があれば履歴から、なければ現在の進行中の問題を取得
    final P = index != null
        ? (index! < session.historyQuestions.length
            ? session.historyQuestions[index!]
            : null)
        : session.currentQuestion;
    print("Selected Question Data: ${P?.mode}, ${P?.making}");
    if (P == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- 以下、描画ロジック ---
    if (P is SekimenMakingData ||
        P is PointLinedMakingData ||
        P is CyebaMakingData ||
        P is TriangleMakingData) {
      return LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        if (P is SekimenMakingData)
          return Sekimen(origin: P, width: w, height: h);
        if (P is PointLinedMakingData)
          return PointLined(origin: P, width: w, height: h);
        if (P is CyebaMakingData) return Cyeba(origin: P, width: w, height: h);
        if (P is TriangleMakingData)
          return Triangle(origin: P, width: w, height: h);
        return const SizedBox.shrink();
      });
    }

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark
              ? getQuizColor2(P.subject, context, 0.6, 0.4, 0.65)
              : getQuizColor2(P.subject, context, 0.6, 0.4, 0.95),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(P.questionList.length, (i) {
              final text = P.questionList[i];
              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 5),
                child: P is EngMakingData
                    ? _buildEngText(context, text)
                    : Math.tex(text,
                        textStyle: TextStyle(
                            fontSize: 30, color: textColor1(context))),
              );
            }),
          ),
        ),
      ),
    );
  }

  // 英語テキスト装飾用（中身は以前と同じ）
  Widget _buildEngText(BuildContext context, String text) {
    final match = RegExp(r'\((.*?)\)').firstMatch(text);
    if (match == null)
      return Text(text,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor1(context)));
    return Text.rich(TextSpan(
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: textColor1(context)),
      children: [
        TextSpan(text: text.substring(0, match.start)),
        TextSpan(
            text: match.group(0),
            style: TextStyle(
                fontSize: 22, color: textColor1(context).withAlpha(150))),
        TextSpan(text: text.substring(match.end)),
      ],
    ));
  }
}

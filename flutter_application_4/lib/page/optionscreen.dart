import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class QuizOptions extends StatefulWidget {
  final Map<String, dynamic> quizData;
  final Function(String) onCorrect;

  const QuizOptions({
    super.key,
    required this.quizData,
    required this.onCorrect,
  });

  @override
  State<QuizOptions> createState() => _QuizOptionsState();
}

class _QuizOptionsState extends State<QuizOptions> {
  late List<String> options;
  bool _answered = false;
  int? _pressedIndex; // 押されているボタンのインデックス

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  @override
  void didUpdateWidget(covariant QuizOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quizData != widget.quizData) {
      _answered = false;
      _pressedIndex = null;
      _generateOptions();
    }
  }

  void _generateOptions() {
    options = [
      if (widget.quizData['correct'] != null) widget.quizData['correct'],
      if (widget.quizData['option1'] != null) widget.quizData['option1'],
      if (widget.quizData['option2'] != null) widget.quizData['option2'],
      if (widget.quizData['option3'] != null) widget.quizData['option3'],
    ];
    options.shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow.shade700,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(options.length, (index) {
        final option = options[index];
        final color = colors[index % colors.length];
        final isPressed = _pressedIndex == index;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            child: GestureDetector(
              onTap: _answered
                  ? null
                  : () {
                      // 押した瞬間に回答済みにして、押下状態も設定
                      setState(() {
                        _answered = true;
                        _pressedIndex = index;
                      });

                      // アニメーション終了後に押下状態をリセット
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (!mounted) return;
                        setState(() => _pressedIndex = null);
                      });

                      // 正誤判定
                      if (option == widget.quizData['correct']) {
                        widget.onCorrect("maru");
                      } else {
                        widget.onCorrect("peke");
                      }
                    },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isPressed
                        ? bgColor1(context).withAlpha(0)
                        : bgColor1(context),
                    border: Border.all(color: color, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, isPressed ? 1 : 2),
                        blurRadius: isPressed ? 0.5 : 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 30.0,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Math.tex(
                        option,
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: color,
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        );
      }),
    );
  }
}

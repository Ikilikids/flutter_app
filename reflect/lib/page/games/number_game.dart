import 'package:flutter/material.dart';

class NumberGame extends StatelessWidget {
  final bool isWaiting;
  final int targetNumber;
  final ValueChanged<int> onNumberSelected;

  const NumberGame({
    super.key,
    required this.isWaiting,
    required this.targetNumber,
    required this.onNumberSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              isWaiting ? "..." : "$targetNumber",
              style: const TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(builder: (context, constraints) {
              // ボタンのサイズ計算
              double btnHeight = constraints.maxHeight / 4 - 10;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(9, (index) {
                  // 0-9のボタン
                  return SizedBox(
                    width: constraints.maxWidth / 3 - 20,
                    height: btnHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => onNumberSelected(index + 1),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ],
    );
  }
}

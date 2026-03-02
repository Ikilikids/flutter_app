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

  // 再描画時の再生成を防ぐための定数定義
  static const _targetTextStyle = TextStyle(
    fontSize: 120,
    fontWeight: FontWeight.bold,
  );

  static const _buttonTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    // コンテナの装飾を事前に定義
    final buttonDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    );

    return Column(
      children: [
        // 1. ターゲット表示エリア
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              isWaiting ? "..." : "$targetNumber",
              style: _targetTextStyle,
            ),
          ),
        ),

        // 2. 入力ボタンエリア
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(builder: (context, constraints) {
              const double spacing = 10.0;
              final double width = (constraints.maxWidth - (spacing * 2)) / 3;
              final double height = (constraints.maxHeight - (spacing * 2)) / 3;

              return RepaintBoundary(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: width / height,
                  ),
                  itemCount: 9,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // 真ん中（インデックス4）は5を表示せず、空欄にする
                    if (index == 4) {
                      return const SizedBox.shrink();
                    }

                    // index+1 で 1,2,3,4,(空),6,7,8,9 の順に表示
                    final number = index + 1;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (_) => onNumberSelected(number),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: buttonDecoration,
                        child: Text(
                          "$number",
                          style: _buttonTextStyle,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

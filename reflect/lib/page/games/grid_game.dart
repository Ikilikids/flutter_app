import 'package:flutter/material.dart';

class GridGame extends StatelessWidget {
  final bool isWaiting;
  final bool isReadyToAct;
  final int activeGridIndex;
  final ValueChanged<int> onGridSelected;

  const GridGame({
    super.key,
    required this.isWaiting,
    required this.isReadyToAct,
    required this.activeGridIndex,
    required this.onGridSelected,
  });

  // --- 再描画時の再生成を完全に排除するための static const ---

  static const _normalDecoration = BoxDecoration(
    color: Color(0xFFc0c0c0), // Colors.grey[300]
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(BorderSide(color: Colors.black12, width: 2)),
  );

  static const _activeDecoration = BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
        color: Colors.orangeAccent,
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: RepaintBoundary(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              // 固定値 4 を直接指定（動的計算を排除）
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: 16, // 4 * 4
              itemBuilder: (context, index) {
                // インデックスの比較のみ（最速の論理判定）
                final bool isActive = isReadyToAct && index == activeGridIndex;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) => onGridSelected(index),
                  child: Container(
                    decoration:
                        isActive ? _activeDecoration : _normalDecoration,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

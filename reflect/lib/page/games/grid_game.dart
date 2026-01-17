import 'package:flutter/material.dart';

class GridGame extends StatelessWidget {
  final bool isWaiting;
  final bool isReadyToAct;
  final int activeGridIndex;
  final int gridSize;
  final ValueChanged<int> onGridSelected;

  const GridGame({
    super.key,
    required this.isWaiting,
    required this.isReadyToAct,
    required this.activeGridIndex,
    required this.gridSize,
    required this.onGridSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              final bool isActive = isReadyToAct && index == activeGridIndex;
              return GestureDetector(
                onTap: () => onGridSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.orange : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black12,
                      width: isActive ? 0 : 2,
                    ),
                    boxShadow: isActive
                        ? [
                            const BoxShadow(
                              color: Colors.orangeAccent,
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

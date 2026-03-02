import 'package:common/common.dart';
import 'package:flutter/material.dart';

class ColorGame extends StatelessWidget {
  final bool isWaiting;
  final Color currentColor;
  final VoidCallback onTap;

  const ColorGame({
    super.key,
    required this.isWaiting,
    required this.currentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // ← const にできる
        child: Container(
          decoration: BoxDecoration(
            color: currentColor,
            borderRadius: BorderRadius.circular(24), // ← const にできる
          ),
          width: double.infinity,
          height: double.infinity,
          child: isWaiting
              ? Center(
                  child: Text(
                    l10n(context, 'colorReactDesc'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black54,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

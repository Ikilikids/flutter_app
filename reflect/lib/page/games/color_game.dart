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
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: currentColor,
            borderRadius: BorderRadius.circular(24), // ← ここ
          ),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              isWaiting
                  ? l10n(context, 'colorReactDesc')
                  : l10n(context, 'colorGameTapNow'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

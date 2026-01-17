import 'package:flutter/material.dart';

typedef GamePageBuilder = Widget Function(
    BuildContext context, List<dynamic> quizinfo);

class AppConfig {
  final String title;
  final IconData icon;
  final List<String> symbols;
  final bool isRotation;
  final List<Map<String, String>> sortData;
  final GamePageBuilder mainGame;
  final int fix;
  final String unit;

  const AppConfig({
    required this.title,
    required this.icon,
    required this.symbols,
    required this.isRotation,
    required this.sortData,
    required this.mainGame, // ← 追加
    required this.fix,
    required this.unit,
  });
}

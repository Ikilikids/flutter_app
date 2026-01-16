import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/ranking.dart';

class ToggleScreen extends StatefulWidget {
  const ToggleScreen({super.key});

  @override
  State<ToggleScreen> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdScaffold(
      appBar: AppBar(title: const Text("👑ランキング👑")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8), // ←画面全体の左右余白
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ---- 均等幅ボタン二つ ----
            Row(
              children: [
                Expanded(child: _buildButton("実践モード", 0, Colors.red)),
                const SizedBox(width: 8), // ボタン間の隙間
                Expanded(child: _buildButton("練習モード", 1, Colors.blue)),
              ],
            ),

            const SizedBox(height: 16),

            // ---- 下の画面 ----
            Expanded(
              child: selectedIndex == 0 ? const ScreenA() : const ScreenB(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, int index, Color buttoncolor) {
    final bool isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6), // ボタン間の隙間
      child: ElevatedButton(
        onPressed: () => setState(() => selectedIndex = index),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? buttoncolor
              : const Color.fromARGB(255, 224, 224, 224),
          foregroundColor: isSelected
              ? textColor3(context)
              : const Color.fromARGB(59, 0, 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown, // ボタン内に収まるよう縮小
          child: Text(
            text,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RankingScreen(j: true),
    );
  }
}

class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RankingScreen(j: false),
    );
  }
}

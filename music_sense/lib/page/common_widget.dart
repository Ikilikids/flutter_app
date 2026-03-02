import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// Pを受け取ってウィジェットを返す関数
Widget buildChildWidget(BuildContext context, Map<String, dynamic> P) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return Center(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? getQuizColor2(P["fi1"] ?? "1", context, 0.8, 0.4, 0.65)
            : getQuizColor2(P["fi1"] ?? "1", context, 0.6, 0.4, 0.95),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((P["question1"] ?? "").isNotEmpty)
              Text(
                P["question1"]!,
                style: TextStyle(
                  fontSize: 40,
                  color: textColor1(context),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    ),
  );
}

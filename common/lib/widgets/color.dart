import 'package:flutter/material.dart';

Color getColorByIndex(
    double index, double alpha, double saturation, double value) {
  const totalColors = 6;
  final hue = ((360 / totalColors) * index + 80) % 360;
  final hsvColor = HSVColor.fromAHSV(alpha, hue, saturation, value);
  return hsvColor.toColor();
}

Color getQuizColor2(
  String title,
  BuildContext context,
  double alpha,
  double saturation,
  double value,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  value = isDark ? value * 0.8 : value;

  if (title.contains('1') || title.contains('1A')) {
    return getColorByIndex(5.2, alpha, saturation, value);
  } else if (title.contains('2') || title.contains('2B')) {
    return getColorByIndex(2, alpha, saturation, value);
  } else if (title.contains('3') || title.contains('3C')) {
    return getColorByIndex(4.6, alpha, saturation, value);
  } else if (title.contains('6') ||
      title.contains('A') ||
      title.contains('8')) {
    return getColorByIndex(3.8, alpha, saturation, value);
  } else if (title.contains('5') || title.contains('B')) {
    return getColorByIndex(0.7, alpha, saturation * 0.9, value * 0.9);
  } else if (title.contains('4') ||
      title.contains('C') ||
      title.contains('7')) {
    return getColorByIndex(2.9, alpha, saturation, value);
  } else {
    return textColor1(context).withAlpha(230);
  }
}

Color bgColor1(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xff252a31) : Color(0xffffffff);
}

Color bgColor2(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xff141920) : Color(0xfff5f5f5);
}

Color textColor1(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xffe6e6e6) : Color(0xff444444);
}

Color textColor2(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xffc0c0c0) : Color(0xff777777);
}

Color textColor3(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? Color(0xffe6e6e6) : Color(0xfff6f6f6);
}

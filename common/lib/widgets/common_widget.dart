import 'package:flutter/material.dart';

import '../common.dart';

Widget pointwidget(BuildContext context, int totalScore, {int? remainingTime}) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromARGB(255, 215, 121, 54)
                        : Colors.orangeAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                  ),
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n(context, 'pointHeader'),
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: textColor1(context),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container())
            ])),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark
                    ? const Color.fromARGB(255, 215, 121, 54)
                    : Colors.orangeAccent,
                width: 2,
              ),
              color: bgColor1(context),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6)),
            ),
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: Text(
                (remainingTime ?? 21) > 20 ? '$totalScore' : '??',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: textColor1(context),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget timewidget(
    String sort, double remainingTime, num totalScore, BuildContext context) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  int changeCount = sort == "4867" ? 8 : 16;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromARGB(255, 215, 121, 54)
                        : Colors.orangeAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                  ),
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n(context, 'timeHeader'),
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: textColor1(context),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container())
            ])),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark
                    ? const Color.fromARGB(255, 215, 121, 54)
                    : Colors.orangeAccent,
                width: 2,
              ),
              color: bgColor1(context),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6)),
            ),
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: Text(
                totalScore < changeCount
                    ? remainingTime.toStringAsFixed(2)
                    : "??",
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: textColor1(context),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

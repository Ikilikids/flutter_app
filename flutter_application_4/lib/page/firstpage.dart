import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/rankingpage.dart';
import 'package:flutter_application_4/page/setteing.dart';

import 'choose123abc.dart';
import 'datail.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: AdScaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // ← 戻るボタンを非表示にする
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Choose123abc(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Icon(Icons.school,
                                    color: textColor3(context)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Text(
                                  "練習モード",
                                  style: TextStyle(
                                      fontSize: 20, color: textColor3(context)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Text(
                                  "---時間制限なし---",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: const Color.fromARGB(
                                          127, 255, 255, 255)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Text(
                                  "(分野別、5問ずつ)",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: const Color.fromARGB(
                                          127, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DetailCard(title: "jissen"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Icon(Icons.local_fire_department,
                                    color: textColor3(context)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Text(
                                  "実践モード",
                                  style: TextStyle(
                                      fontSize: 20, color: textColor3(context)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Text(
                                  "---時間制限あり---",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: const Color.fromARGB(
                                          127, 255, 255, 255)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Text(
                                  "(得点&ランクで競おう!!)",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: const Color.fromARGB(
                                          127, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: FittedBox(
                                child: Text(
                                  "⚙設定",
                                  style: TextStyle(
                                      fontSize: 80, color: textColor3(context)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ToggleScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: FittedBox(
                                child: Text(
                                  "👑ランキング",
                                  style: TextStyle(
                                      fontSize: 80, color: textColor3(context)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

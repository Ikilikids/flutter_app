import 'package:flutter/material.dart';
import 'package:flutter_application_4/assistance/firebase_score.dart';
import 'package:flutter_application_4/assistance/formula.dart';
import 'package:flutter_application_4/assistance/latex_to_latex2.dart';
import 'package:flutter_application_4/page/datail.dart';

import '../main.dart';
import 'firstpage.dart';

class CardData {
  final String mainText;
  final List<String> subText;

  CardData({required this.mainText, required this.subText});
}

List<CardData> generateCards() {
  final Map<String, Set<String>> grouped = {};
  List<List<String>> subjects2 =
      subjects.where((list) => list[2] != '全合計').toList();
  for (var s in subjects2) {
    final title = s[0];
    final category = s[1];

    if (!grouped.containsKey(title)) {
      grouped[title] = {};
    }
    grouped[title]!.add(category);
  }

  return grouped.entries
      .map((e) => CardData(mainText: e.key, subText: e.value.toList()))
      .toList();
}

// -------------------- メイン画面 --------------------
class Choose123abc extends StatefulWidget {
  const Choose123abc({super.key});

  @override
  State<Choose123abc> createState() => _Choose123abcState();
}

class _Choose123abcState extends State<Choose123abc> {
  int score = 0; // 初期値
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final fetchedScore = await HighScoreManager.getHighScore("全合計", false);
    if (!mounted) return;
    setState(() {
      score = fetchedScore;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = generateCards();

    return PopScope(
        canPop: false,
        child: AdScaffold(
          appBar: AppBar(
            title: Row(children: [
              Icon(
                Icons.school,
              ),
              SizedBox(width: 4),
              Text("練習モード")
            ]),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FirstPage()),
                );
              },
            ),
          ),
          body: loading
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          color: bgColor1(context), // 外枠の基本色
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: bgColor1(context), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40), // 影の色と透明度
                              blurRadius: 4, // 影のぼかし具合
                              offset: const Offset(1, 3), // 影の位置（x, y）
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            children: [
                              // 左1/3部分
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: bgColor1(context),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "★正解数★",
                                      style: TextStyle(
                                          color: textColor1(context),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 100),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              // 右2/3部分
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: bgColor2(context),
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      loading ? "..." : "$score",
                                      style: TextStyle(
                                        color: textColor1(context),
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: List.generate(3, (row) {
                          return Expanded(
                            child: Row(
                              children: List.generate(2, (col) {
                                final index = row * 2 + col;
                                final card = cards[index];
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CardButton(cardData: card),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
        ));
  }
}

// -------------------- カードウィジェット --------------------
class CardButton extends StatelessWidget {
  final CardData cardData;

  const CardButton({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailCard(title: cardData.mainText),
          ),
        );
      },
      child: Card(
        color: bgColor1(context),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // mainText（縦比2）
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    // 円を左寄せ
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown, // scaleDownでもOK
                        child: Container(
                          width: 1000, // 大きめにしてFittedBoxで縮小
                          height: 1000,
                          decoration: BoxDecoration(
                            color: getQuizColor2(
                                cardData.mainText, context, 1, 0.35, 0.95),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                getSubjectFromSymbol(cardData.mainText),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: bgColor1(context),
                                  fontSize: 1000, // できるだけ大きく
                                ),
                                textAlign: TextAlign.left, // 左寄せ
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 1, child: Container()),
              // subText（縦比1）
              Expanded(
                flex: 14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start, // ← Column内も左寄せ
                  children: List.generate(5, (i) {
                    String text =
                        i < cardData.subText.length ? cardData.subText[i] : "";

                    return Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft, // ← 行を左寄せ
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft, // ← FittedBox内も左寄せ
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // 左寄せのため最小幅
                              children: [
                                // アイコン
                                Builder(
                                  builder: (_) {
                                    IconData? icon = i < cardData.subText.length
                                        ? getIconForCategory(text)
                                        : null;
                                    return icon != null
                                        ? Icon(
                                            icon,
                                            size: 100,
                                            color: textColor1(context),
                                          )
                                        : const SizedBox(width: 100);
                                  },
                                ),
                                const SizedBox(width: 4),
                                // テキスト
                                Text(
                                  text,
                                  style: TextStyle(
                                    fontSize: 100,
                                    color: textColor1(context),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

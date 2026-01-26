import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

class LatexInputScreen3 extends StatefulWidget {
  // 引数としてリストを受け取る
  final String marusikaku;
  final String shubetu;
  final List<List<String>> alist;
  final List<List<String>>? blist;

  final List<String> button2;
  final Function(String) pekepeke;
  final Function(int) partpoint;
  final List<int> ctscore;
  final String categoly;
  final String latexButton;
  const LatexInputScreen3({
    super.key,
    required this.marusikaku,
    required this.shubetu,
    required this.alist,
    required this.blist,
    required this.button2,
    required this.ctscore,
    required this.pekepeke,
    required this.partpoint,
    required this.categoly,
    required this.latexButton,
  });

  @override
  LatexInputScreenState createState() => LatexInputScreenState();
}

class LatexInputScreenState extends State<LatexInputScreen3> {
  late SoundManager soundManager;
  String latexInput = "";
  final TextEditingController _controller = TextEditingController();
  List<String> latexOutputs = [];
  int selectedIndex = 0; // 現在編集中のインデックスを保持
  String combinedLatex = "";
  int i = 0;
  int j = 0;
  int p = 1;
  List<String> genzailist = [];
  List<String> falist = [];
  List<String>? fblist;
  int count = 0;
  Map<String, bool> buttonVisibility = {
    "+": true,
    "-": true,
    "l": true,
    "s": true,
    "c": true,
    "t": true,
    "e": true,
    "p": true,
    "7": true,
    "8": true,
    "9": true,
    "r": true,
    "4": true,
    "5": true,
    "6": true,
    "f": false,
    "^": false,
    "1": true,
    "2": true,
    "3": true,
    "0": true,
    "i": true
  };

  @override
  void initState() {
    super.initState();
    resetLatexOutputs(); // 最初の表示時に1回だけ初期化を実
  }

  @override
  void didUpdateWidget(LatexInputScreen3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.marusikaku != widget.marusikaku) {
      resetLatexOutputs(); // marusikakuが変わったら更新処理を実行
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    soundManager = Provider.of<SoundManager>(context, listen: false);
  }

  void resetLatexOutputs() {
    List<String> resetList = [];
    String abcdePart = widget.marusikaku;
    List<String> button2 = widget.button2;

    for (var i = 0; i < abcdePart.length; i++) {
      String char = abcdePart[i];
      if (RegExp("[◯□☆]").hasMatch(char)) {
        resetList.add(char);
      }
    }
    i = 0;
    j = 0;
    p = 1;
    genzailist = [];
    fblist = null;
    count = RegExp("[◯□☆]").allMatches(widget.marusikaku).length - 1;
    falist = widget.alist.expand((p) => p).toList();

    if (widget.blist != null) {
      fblist = widget.blist!.expand((p) => p).toList();
    }

    setState(() {
      resetplusminus(button2[0]);
      latexOutputs = resetList;
      selectedIndex = 0;
      latexInput = "";
      _controller.clear();
    });
  }

  void _onLatexInputChanged(String newText) {
    latexInput = newText;
    latexOutputs[selectedIndex] = latexInput;
    setState(() {});
  }

  // 次のインデックスに移動
  void moveToNextIndex() {
    soundManager.playSound('maru.mp3');
    List<String> button2 = widget.button2;
    List<int> ctscore = widget.ctscore;
    setState(() {
      if (selectedIndex < latexOutputs.length - 1) {
        selectedIndex++;
        latexInput = "";
        _controller.text = latexInput;
      }
      resetplusminus(button2[i]);
      widget.partpoint(ctscore[i - 1]);
    });
  }

  void _addToLatex(String value) {
    int cursorPos = _controller.selection.baseOffset; // カーソル位置を取得
    if (cursorPos == -1) {
      cursorPos = latexInput.length; // カーソルが選択されていない場合、末尾に設定
    }

    // LaTeXの基本式が \frac{}{} の場合、入力を新しい値に置き換え
    if (latexInput == "") {
      latexInput = value;
    } else {
      // カーソル位置に入力値を追加
      latexInput = latexInput.substring(0, cursorPos) +
          value +
          latexInput.substring(cursorPos);
    }

    // 新しいテキスト長さを取得
    int newLength = latexInput.length;

    // もしカーソル位置がテキスト長より大きい場合、テキスト長に設定
    int newCursorPos = cursorPos + value.length;
    if (newCursorPos > newLength) {
      newCursorPos = newLength; // カーソル位置をテキストの末尾に設定
    }

    _controller.text = latexInput; // TextControllerを更新
    _controller.selection =
        TextSelection.collapsed(offset: newCursorPos); // 正しいカーソル位置を設定

    // 入力内容が変わったら、その内容をリアルタイムでlatexOutputsに反映
  }

  void _hidePlusMinusButtons(String value) {
    final Map<String, Set<String>> hideMap = {
      "j1": {"+", "-", "l", "s", "c", "t"},
      "af": {}, // 全非表示の合図
    };

    // j=1のとき、対応するボタンを非表示
    if (j == 1) {
      for (var key in hideMap["j1"]!) {
        buttonVisibility[key] = false;
      }
    }

    // 数字や定数を押したとき、jが1〜3なら f を表示
    if ("0123456789p".contains(value)) {
      buttonVisibility["f"] = true;
      buttonVisibility["^"] = true;
      buttonVisibility["i"] = false;
    }
    if ("e".contains(value)) {
      buttonVisibility["f"] = false;
      buttonVisibility["^"] = true;
      buttonVisibility["i"] = false;
    }
    // f を押したら r を表示、f を非表示
    if (value == "f") {
      buttonVisibility["f"] = false;
      buttonVisibility["^"] = false;
      buttonVisibility["r"] = true;
    }

    // r を押したら r を非表示
    if (value == "r") {
      buttonVisibility["r"] = false;
      buttonVisibility["^"] = false;
    }
    if (value == "^") {
      buttonVisibility["-"] = true;
      buttonVisibility["f"] = false;
      buttonVisibility["^"] = false;
    }
    // af のとき、すべてのボタンを非表示に
    if (value == "af") {
      for (var key in buttonVisibility.keys) {
        buttonVisibility[key] = false;
      }
    }
  }

  void resetplusminus(String ppp) {
    final allKeys = buttonVisibility.keys.toSet();
    if (ppp == "a") {
      for (var key in allKeys) {
        buttonVisibility[key] = ['s', 'c', 't', 'l'].contains(key);
      }
    } else if (ppp == "[+-]") {
      for (var key in allKeys) {
        buttonVisibility[key] = ['+', '-'].contains(key);
      }
    } else {
      final toHide = ppp.split('').toSet();
      for (var key in allKeys) {
        buttonVisibility[key] = !toHide.contains(key);
      }
    }
    buttonVisibility["f"] = false; // 常に非表示
    buttonVisibility["^"] = false;
  }

  void _seigo(String symbol) async {
    bool containsDigit(String symbol) {
      return symbol.contains(RegExp(r'\d'));
    }

    if (!containsDigit(symbol)) {
      soundManager.playSound('0.mp3');
    } else {
      soundManager.playSound('$symbol.mp3');
    }
    if (symbol == "p") {
      _addToLatex("\\pi");
    } else if (symbol == "i") {
      _addToLatex("\\infty");
    } else if (symbol == "s") {
      _addToLatex("\\sin");
    } else if (symbol == "c") {
      _addToLatex("\\cos");
    } else if (symbol == "t") {
      _addToLatex("\\tan");
    } else if (symbol == "l") {
      _addToLatex("\\log");
    } else if (symbol == "r") {
      _sqrtfunction();
    } else if (symbol == "f") {
      _insertFraction();
    } else if (symbol == "^") {
      _squarefunction();
    } else {
      _addToLatex(symbol);
    }

    genzailist.add(symbol);

    if (p <= falist.length &&
        p <= genzailist.length &&
        falist.sublist(0, p).toString() ==
            genzailist.sublist(0, p).toString()) {
      if (j == widget.alist[i].length - 1 && i == count) {
        String ddd = "maru";
        _hidePlusMinusButtons("af");
        _onLatexInputChanged(latexInput);
        widget.pekepeke(ddd);
      } else if (j == widget.alist[i].length - 1) {
        j = 0;
        i = i + 1;
        p = p + 1;
        _onLatexInputChanged(latexInput);
        moveToNextIndex();
      } else {
        j = j + 1;
        p = p + 1;
        _hidePlusMinusButtons(symbol);
        _onLatexInputChanged(latexInput);
      }
    } else if (fblist != null &&
        p <= fblist!.length &&
        p <= genzailist.length &&
        fblist!.sublist(0, p).toString() ==
            genzailist.sublist(0, p).toString()) {
      if (j == widget.blist![i].length - 1 && i == count) {
        String ddd = "maru";
        _hidePlusMinusButtons("af");
        _onLatexInputChanged(latexInput);
        widget.pekepeke(ddd);
      } else if (j == widget.blist![i].length - 1) {
        j = 0;
        i = i + 1;
        p = p + 1;
        _onLatexInputChanged(latexInput);
        moveToNextIndex();
      } else {
        j = j + 1;
        p = p + 1;
        _hidePlusMinusButtons(symbol);
        _onLatexInputChanged(latexInput);
      }
    } else {
      String ddd = "peke";
      _hidePlusMinusButtons("af");
      _onLatexInputChanged(latexInput);
      widget.pekepeke(ddd);
    }
  }

  // 分数挿入
  void _insertFraction() {
    int cursorPos = _controller.selection.baseOffset;
    if (cursorPos == -1) cursorPos = latexInput.length;

    if (cursorPos > 0) {
      int startOfNumber = cursorPos - 1;
      startOfNumber = startOfNumber < 0 ? 0 : startOfNumber;

      while (startOfNumber > 0) {
        // 2文字手前から {- or {+ を見る
        if (startOfNumber >= 2 &&
            (latexInput.substring(startOfNumber - 2, startOfNumber) == '{-')) {
          startOfNumber -= 2;
          break;
        }

        // { の単体も考慮（{-以外の開始）
        if (latexInput[startOfNumber - 1] == '{' &&
            !latexInput
                .substring(startOfNumber - 3, startOfNumber)
                .contains("t{")) {
          startOfNumber -= 1;
          break;
        }

        // + や - の記号
        if (latexInput[startOfNumber - 1] == '+' ||
            latexInput[startOfNumber - 1] == '-') {
          startOfNumber -= 1;
          break;
        }

        startOfNumber--;
      }

      String number = latexInput.substring(startOfNumber, cursorPos);

      String sign = "";
      if (number.startsWith("{-")) {
        sign = "{-";
        number = number.substring(2);
      } else if (number.startsWith("-")) {
        sign = "-";
        number = number.substring(1);
      } else if (number.startsWith("+")) {
        sign = "+";
        number = number.substring(1);
      } else if (number.startsWith("{")) {
        sign = "{";
        number = number.substring(1);
      }

      if (number.contains("sqrt") && sign.contains("{")) {
        // ignore: prefer_interpolation_to_compose_strings
        latexInput =
            "${latexInput.substring(0, startOfNumber)}$sign\\frac{}{$number}}}";
        _controller.text = latexInput;
        _controller.selection =
            TextSelection.collapsed(offset: startOfNumber + 6 + sign.length);
      } else if (number.contains("sqrt") || sign.contains("{")) {
        // ignore: prefer_interpolation_to_compose_strings
        latexInput =
            "${latexInput.substring(0, startOfNumber)}$sign\\frac{}{$number}}";
        _controller.text = latexInput;
        _controller.selection =
            TextSelection.collapsed(offset: startOfNumber + 6 + sign.length);
      } else if (number.isNotEmpty) {
        // ignore: prefer_interpolation_to_compose_strings
        latexInput =
            "${latexInput.substring(0, startOfNumber)}$sign\\frac{}{$number}";

        _controller.text = latexInput;
        _controller.selection =
            TextSelection.collapsed(offset: startOfNumber + 6 + sign.length);
      }
    }

    // 入力が変わったらその内容をリアルタイムでlatexOutputsに反映
  }

  void _sqrtfunction() {
    // LaTeXの平方根記法 \sqrt{} を追加
    _addToLatex("\\sqrt{}");

    // カーソル位置を取得
    int cursorPos = _controller.selection.baseOffset;

    // カーソル位置が -1 の場合、テキストの末尾にカーソルを設定
    if (cursorPos == -1) cursorPos = _controller.text.length;

    // 新しいカーソル位置を \sqrt{} の直後に設定（6は "\sqrt{" の文字数）
    _controller.selection = TextSelection.collapsed(offset: cursorPos - 1);
  }

  void _squarefunction() {
    // LaTeXの平方根記法 \sqrt{} を追加
    _addToLatex("^{}");

    // カーソル位置を取得
    int cursorPos = _controller.selection.baseOffset;

    // カーソル位置が -1 の場合、テキストの末尾にカーソルを設定
    if (cursorPos == -1) cursorPos = _controller.text.length;

    // 新しいカーソル位置を \sqrt{} の直後に設定（6は "\sqrt{" の文字数）
    _controller.selection = TextSelection.collapsed(offset: cursorPos - 1);
  }

  // 数式ボックスのウィジェットを作成
// 編集中のLaTeX式をハイライトする
  Widget _buildLatexBoxWithVariable(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String abcdePart = widget.marusikaku;
    StringBuffer modifiedString = StringBuffer();
    int latexIndex = 0;

    // 記号に対応する色マップ
    Map<String, String> colorMap = isDark
        ? {
            '◯': 'red',
            '□': 'blue',
            '☆': 'orange',
          }
        : {
            '◯': 'red',
            '□': 'blue',
            '☆': 'orange',
          };

    for (int j = 0; j < abcdePart.length; j++) {
      String char = abcdePart[j];
      if (colorMap.containsKey(char) && latexIndex < latexOutputs.length) {
        final color = colorMap[char]!;
        final content = latexOutputs[latexIndex];
        final wrapped = (latexIndex == selectedIndex)
            ? '\\textcolor{$color}{$content}'
            : '{$content}';
        modifiedString.write(wrapped);
        latexIndex++;
      } else {
        modifiedString.write(char);
      }
    }

    combinedLatex = modifiedString.toString();

    List<String> parts = combinedLatex.split(';');

    return GestureDetector(
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: getQuizColor2(widget.categoly, context, 0.6, 0.2, 0.95),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < parts.length; i++) ...[
                  if (parts[i].trim().isNotEmpty)
                    Math.tex(
                      parts[i],
                      textStyle:
                          TextStyle(fontSize: 30, color: textColor1(context)),
                    ),
                  if (i != parts.length - 1) SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Map<String, Map<String, dynamic>> buttonDefinitions = {
    "e": {"label": "e"},
    "p": {"label": "\\pi"},
    "7": {"label": "7"},
    "8": {"label": "8"},
    "9": {"label": "9"},
    "r": {"label": "\\surd{□}"},
    "4": {"label": "4"},
    "5": {"label": "5"},
    "6": {"label": "6"},
    "f": {"label": "分数"},
    "1": {"label": "1"},
    "2": {"label": "2"},
    "3": {"label": "3"},
    "-": {"label": "-"},
    "0": {"label": "0"},
    "+": {"label": "+"},
    "l": {"label": "log"},
    "s": {"label": "\\sin"},
    "c": {"label": "\\cos"},
    "t": {"label": "tan"},
    "i": {"label": "\\infty"},
    "^": {"label": "□^□"}
  };
  Widget _getButtonList(String shubetu) {
    String symbol = shubetu;
    var label = buttonDefinitions[symbol]?["label"] ?? symbol;
    return _buildButton(label, symbol, _seigo, shubetu, context);
  }

  Widget _buildButton(
    String label,
    String symbol,
    Function(String) onPressed1,
    shubetu,
    BuildContext context,
  ) {
    final bool isVisible = buttonVisibility[symbol] ?? true;
    final bool sc = label == "\\cos" || label == "\\sin";
    // 文字色
    Color forecolor =
        isVisible ? textColor1(context) : textColor1(context).withAlpha(50);

    // 背景色
    Color backcolor = isVisible
        ? getQuizColor2(widget.categoly, context, 0.6, 0.2, 0.95)
        : getQuizColor2(widget.categoly, context, 0.6, 0.2, 0.95)
            .withAlpha(30); // 透明にしたい場合

    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: isVisible ? () => onPressed1(symbol) : null,
        borderRadius:
            sc ? BorderRadius.circular(20) : BorderRadius.circular(40),
        child: Container(
          decoration: BoxDecoration(
            color: backcolor,
            borderRadius:
                sc ? BorderRadius.circular(20) : BorderRadius.circular(40),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Math.tex(
              label,
              textStyle: TextStyle(
                fontSize: 30,
                color: forecolor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // boxCountの設定

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: _buildLatexBoxWithVariable(context),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.latexButton == "mobile")
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: _getButtonList("1")),
                                  Expanded(child: _getButtonList("2")),
                                  Expanded(child: _getButtonList("3")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: _getButtonList("4")),
                                  Expanded(child: _getButtonList("5")),
                                  Expanded(child: _getButtonList("6")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: _getButtonList("7")),
                                  Expanded(child: _getButtonList("8")),
                                  Expanded(child: _getButtonList("9")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: SizedBox()),
                                  Expanded(child: _getButtonList("0")),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.latexButton == "calculator")
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: _getButtonList("7")),
                                  Expanded(child: _getButtonList("8")),
                                  Expanded(child: _getButtonList("9")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: _getButtonList("4")),
                                  Expanded(child: _getButtonList("5")),
                                  Expanded(child: _getButtonList("6")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: _getButtonList("1")),
                                  Expanded(child: _getButtonList("2")),
                                  Expanded(child: _getButtonList("3")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: SizedBox()),
                                  Expanded(child: _getButtonList("0")),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

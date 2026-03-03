import 'package:flutter/material.dart';
import 'package:common/common.dart';

/// クイズ画面の共通レイアウトを提供するウィジェット。
/// 数学、英語、その他のクイズ形式に関わらず、共通の「ガワ」を定義します。
class CommonQuizLayout extends StatelessWidget {
  /// 上部のインジケーターエリア（タイマー、スコア、メニューボタンなど）
  final Widget topBar;

  /// 中央の問題表示エリア（問題文、数式、画像、図形など）
  final Widget question;

  /// 下部の回答入力エリア（キーボード、選択肢ボタンなど）
  final Widget answerInput;

  /// 最前面に表示するオーバーレイ（正誤判定の◯×アニメーションなど）
  final Widget? overlay;

  /// 背景色（オプション）
  final Color? backgroundColor;

  /// 全体のパディング（デフォルトは左右20、上40）
  final EdgeInsetsGeometry padding;

  const CommonQuizLayout({
    super.key,
    required this.topBar,
    required this.question,
    required this.answerInput,
    this.overlay,
    this.backgroundColor,
    this.padding = const EdgeInsets.only(left: 20, right: 20, top: 40),
  });

  @override
  Widget build(BuildContext context) {
    return AppAdScaffold(
      body: Container(
        color: backgroundColor,
        padding: padding,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. インジケーター (タイマー/スコア/メニュー)
                Expanded(
                  flex: 2, // math_quiz の flex 1 だと少し狭い場合があるため、調整可能に
                  child: topBar,
                ),
                // 2. クイズコンテンツ (問題文/図形)
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: question,
                  ),
                ),
                // 3. 入力セクション (回答欄/キーボード)
                // answerInput 自体が Expanded を持つ場合や、固定高の場合があるため
                // ここではラップせずにそのまま流し込む
                answerInput,
              ],
            ),
            // 4. 正誤表示などのオーバーレイ
            if (overlay != null) Center(child: overlay!),
          ],
        ),
      ),
    );
  }
}

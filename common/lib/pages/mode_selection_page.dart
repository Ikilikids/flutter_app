import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 新しいプロバイダーをインポート
import '../freezed/user_status.dart';

class CommonModeSelectionPage extends ConsumerWidget {
  const CommonModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ユーザー状態（バッジテキストの反映に必要）
    final statusAsync = ref.watch(userStatusNotifierProvider);

    return PopScope(
      canPop: false,
      child: AppAdScaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // タイトルエリア
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: FittedBox(
                    alignment: const Alignment(0, 0.5),
                    child: Text(
                      l10n(context, allData.appTitle),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textColor1(context),
                      ),
                    ),
                  ),
                ),
              ),

              // 無制限モード (allData.mid[0])
              _buildModeButton(context, ref, statusAsync,
                  index: 0, color: Colors.blue),

              // 1日限定モード (allData.mid[1])
              _buildModeButton(context, ref, statusAsync,
                  index: 1, color: Colors.red),

              // 設定・ランキング
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    _smallButton(
                      context,
                      Colors.grey,
                      l10n(context, 'settingsButton'),
                      () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SettingsPage())),
                    ),
                    _smallButton(
                      context,
                      Colors.orange,
                      l10n(context, 'rankingButton'),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CommonRankingPage())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 各モードボタンのビルド
  Widget _buildModeButton(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<UserStatus> statusAsync, {
    required int index,
    required Color color,
  }) {
    final midData = allData.mid[index];

    // 非同期データからバッジテキストを安全に取得
    final badgeText = statusAsync.maybeWhen(
      data: (s) =>
          s.modes.firstWhere((m) => m.modeType == midData.modeType).badgeText,
      orElse: () => '',
    );

    return BigModeButton(
      color: color,
      icon: midData.modeData.modeIcon ??
          (index == 0 ? Icons.all_inclusive : Icons.timer),
      title: l10n(context, midData.modeData.modeTitle ?? ''),
      sub1: l10n(context, midData.modeData.sub1 ?? ''),
      sub2: l10n(context, midData.modeData.sub2 ?? ''),
      onPressed: () {
        // 1. Notifier に対して「今はこのモードだよ」と通知
        ref
            .read(userStatusNotifierProvider.notifier)
            .selectMode(midData.modeType);

        // 2. そのまま画面遷移（listenを待つ必要はない）
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CommonDetailCard()),
        );
      },
      badge: badgeText.isNotEmpty
          ? LimitedModeBadge(text: l10n(context, badgeText))
          : null,
    );
  }

  static Widget _smallButton(
      BuildContext context, Color color, String text, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox.expand(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: color, width: 3),
            ),
            child: FittedBox(
              child: Text(text, style: TextStyle(color: color, fontSize: 100)),
            ),
          ),
        ),
      ),
    );
  }
}

// --- BigModeButton / LimitedModeBadge 等の UI 部品はそのまま ---

class BigModeButton extends StatelessWidget {
  const BigModeButton({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.sub1,
    required this.sub2,
    required this.onPressed,
    this.badge,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String sub1;
  final String sub2;
  final VoidCallback onPressed;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox.expand(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: color, width: 3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: FittedBox(child: Icon(icon, color: color))),
                      Expanded(
                          flex: 2,
                          child: FittedBox(
                              child:
                                  Text(title, style: TextStyle(color: color)))),
                      Expanded(
                          child: FittedBox(
                              child:
                                  Text(sub1, style: TextStyle(color: color)))),
                      Expanded(
                          child: FittedBox(
                              child:
                                  Text(sub2, style: TextStyle(color: color)))),
                    ],
                  ),
                ),
              ),
            ),
            if (badge != null) Positioned(top: -20, right: -10, child: badge!),
          ],
        ),
      ),
    );
  }
}

class LimitedModeBadge extends StatelessWidget {
  final String text;
  const LimitedModeBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return _AnimatedBadge(text: text);
  }
}

class _AnimatedBadge extends StatefulWidget {
  final String text;
  const _AnimatedBadge({required this.text});

  @override
  State<_AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<_AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _bob;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bob = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _bob,
      child: CustomPaint(
        painter: const BubblePainter(
            color: Colors.white, borderColor: Colors.orange),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: Text(
            widget.text,
            style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  const BubblePainter({
    required this.color,
    required this.borderColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    final w = size.width;
    final h = size.height;
    final tailHeight = 8.0;
    final bodyHeight = h - tailHeight;
    final r = 12.0;
    path.moveTo(r, 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    path.lineTo(w, bodyHeight - r);
    path.arcToPoint(Offset(w - r, bodyHeight), radius: Radius.circular(r));
    path.lineTo(25, bodyHeight);
    path.lineTo(20, h);
    path.lineTo(15, bodyHeight);
    path.lineTo(r, bodyHeight);
    path.arcToPoint(Offset(0, bodyHeight - r), radius: Radius.circular(r));
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

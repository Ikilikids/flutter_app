import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonModeSelectionPage extends ConsumerStatefulWidget {
  const CommonModeSelectionPage({super.key});

  @override
  ConsumerState<CommonModeSelectionPage> createState() =>
      _CommonModeSelectionPageState();
}

class _CommonModeSelectionPageState
    extends ConsumerState<CommonModeSelectionPage> {
  MidData? _navigationRequest;

  @override
  void initState() {
    super.initState();
    // 最初の読み込み
    Future.microtask(() => ref.read(appMidConfigProvider.notifier).loadMid());
  }

  @override
  Widget build(BuildContext context) {
    // 状態を監視（これが更新のトリガー）
    final midState = ref.watch(appMidConfigProvider);

    ref.listen<MidConfig>(appMidConfigProvider, (previous, next) {
      if (_navigationRequest != null &&
          next.mid.modeTitle == _navigationRequest!.modeTitle) {
        _navigationRequest = null;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CommonDetailCard()),
        ).then((_) {
          // 戻ってきたときに再ロードして、バッジを確実に書き換える
          ref.read(appMidConfigProvider.notifier).loadMid();
        });
      }
    });

    return PopScope(
      canPop: false,
      child: AppAdScaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
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
              // 無制限モード
              BigModeButton(
                color: Colors.blue,
                icon: allData.mid[0].modeIcon ?? Icons.all_inclusive,
                title: l10n(context, allData.mid[0].modeTitle!),
                sub1: l10n(context, allData.mid[0].sub1!),
                sub2: l10n(context, allData.mid[0].sub2!),
                onPressed: () => _navigate(0),
                badge: allData.mid[0].modeData.badgeText.isNotEmpty
                    ? LimitedModeBadge(
                        text: l10n(context, allData.mid[0].modeData.badgeText))
                    : null,
              ),
              // 1日限定モード
              BigModeButton(
                color: Colors.red,
                icon: allData.mid[1].modeIcon ?? Icons.timer,
                title: l10n(context, allData.mid[1].modeTitle!),
                sub1: l10n(context, allData.mid[1].sub1!),
                sub2: l10n(context, allData.mid[1].sub2!),
                onPressed: () => _navigate(1),
                // ↓ ここを allData.mid[1] ではなく、最新の状態を反映させる
                badge: allData.mid[1].modeData.badgeText.isNotEmpty
                    ? LimitedModeBadge(
                        text: l10n(context, allData.mid[1].modeData.badgeText))
                    : null,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    _smallButton(
                        context,
                        Colors.grey,
                        l10n(context, 'settingsButton'),
                        () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SettingsPage()))),
                    _smallButton(
                        context,
                        Colors.orange,
                        l10n(context, 'rankingButton'),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CommonRankingPage()))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(int index) {
    _navigationRequest = allData.mid[index];
    ref.read(appMidConfigProvider.notifier).selectMid(allData.mid[index]);
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
              side: BorderSide(
                color: color, // 枠線の色
                width: 3, // 枠線の太さ
              ),
            ),
            child: FittedBox(
                child:
                    Text(text, style: TextStyle(color: color, fontSize: 100))),
          ),
        ),
      ),
    );
  }
}

// ... The rest of the file (BigModeButton, LimitedModeBadge, etc.) remains unchanged ...
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
                  side: BorderSide(
                    color: color, // 枠線の色
                    width: 3, // 枠線の太さ
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Icon(icon, color: color),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Text(
                            title,
                            style: TextStyle(color: color),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            sub1,
                            style: TextStyle(
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            sub2,
                            style: TextStyle(
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (badge != null)
              Positioned(
                top: -20,
                right: -10,
                child: badge!,
              ),
          ],
        ),
      ),
    );
  }
}

class LimitedModeBadge extends StatelessWidget {
  final String text; // 表示するテキストを受け取る

  const LimitedModeBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // アニメーションを使いたい場合は以前のまま StatefulWidget でも良いですが、
    // ロジック（_loadStatus）はすべて削除して、渡された text を出すだけにします。
    return _AnimatedBadge(text: text);
  }
}

// アニメーション部分だけを分離してスッキリさせます
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
            widget.text, // 渡されたテキストを表示
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
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

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Converted to ConsumerStatefulWidget to manage state for navigation
class CommonModeSelectionPage extends ConsumerStatefulWidget {
  const CommonModeSelectionPage({super.key});

  @override
  ConsumerState<CommonModeSelectionPage> createState() =>
      _CommonModeSelectionPageState();
}

class _CommonModeSelectionPageState extends ConsumerState<CommonModeSelectionPage> {
  // 2. State variable to signal navigation intent
  MidData? _navigationRequest;

  @override
  Widget build(BuildContext context) {
    // 3. Listener that reacts to state changes and navigates
    ref.listen<MidConfig>(appMidConfigProvider, (previous, next) {
      if (_navigationRequest != null &&
          next.mid.modeTitle == _navigationRequest!.modeTitle) {
        // Clear the request
        _navigationRequest = null;

        // Navigate only after the state has been updated
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommonDetailCard(),
          ),
        );
      }
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const CommonFirstPage(),
            ),
          );
        }
      },
      child: AppAdScaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// ===== タイトル =====
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
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 2),
                            blurRadius: 4,
                            color: textColor2(context).withAlpha(128),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// ===== 無制限モード =====
              BigModeButton(
                color: Colors.blue,
                icon: allData.mid[0].modeIcon ?? Icons.all_inclusive,
                title: l10n(context, allData.mid[0].modeTitle!),
                sub1: l10n(context, allData.mid[0].sub1!),
                sub2: l10n(context, allData.mid[0].sub2!),
                onPressed: () => _navigate(0), // Pass index only
              ),

              /// ===== 1日限定モード =====
              BigModeButton(
                color: Colors.red,
                icon: allData.mid[1].modeIcon ?? Icons.timer,
                title: l10n(context, allData.mid[1].modeTitle!),
                sub1: l10n(context, allData.mid[1].sub1!),
                sub2: l10n(context, allData.mid[1].sub2!),
                onPressed: () => _navigate(1), // Pass index only
                badge:
                    allData.mid[1].islimited ? const LimitedModeBadge() : null,
              ),

              /// ===== 下段ボタン =====
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    _smallButton(
                      context,
                      Colors.grey,
                      l10n(context, 'settingsButton'),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingsPage()),
                      ),
                    ),
                    _smallButton(
                      context,
                      Colors.orange,
                      l10n(context, 'rankingButton'),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommonRankingPage(),
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
    );
  }

  // 4. _navigate now only updates state and signals intent. No longer navigates.
  void _navigate(int listNumber) {
    final midConfig = allData.mid[listNumber];

    // Set the intent flag
    _navigationRequest = midConfig;

    // Update the provider. The listener will handle the rest.
    ref.read(appMidConfigProvider.notifier).selectMid(midConfig);
  }

  // _smallButton is kept as a static method for simplicity
  static Widget _smallButton(
    BuildContext context,
    Color color,
    String text,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox.expand(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: FittedBox(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 100),
              ),
            ),
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
                  backgroundColor: color,
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
                          child: Icon(icon, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Text(
                            title,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            sub1,
                            style: const TextStyle(
                              color: Color.fromARGB(150, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            sub2,
                            style: const TextStyle(
                              color: Color.fromARGB(150, 255, 255, 255),
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

class LimitedModeBadge extends StatefulWidget {
  const LimitedModeBadge({super.key});

  @override
  State<LimitedModeBadge> createState() => _LimitedModeBadgeState();
}

class _LimitedModeBadgeState extends State<LimitedModeBadge>
    with SingleTickerProviderStateMixin {
  String? _status;
  late final AnimationController _controller;
  late final Animation<Offset> _bob;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bob = Tween(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStatus();
    });
  }

  Future<void> _loadStatus() async {
    final sortData = allData.mid;
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final dateKey =
        DateTime(today.year, today.month, today.day).toIso8601String();

    bool playable = false;
    bool adPlayable = false;

    // 各 GameData の detail をループ
    for (final gameData in sortData) {
      for (final subject in gameData.detail) {
        final title = subject.label;
        final last = prefs.getString('lastPlayDate_$title');

        // 今日まだプレイしていない
        if (last != dateKey) {
          playable = true;
          break;
        }

        final count = prefs.getInt('playCount_$title') ?? 0;
        final reward = prefs.getString('rewardGranted_$title') == dateKey;

        // 1回だけプレイ済みなら広告でプレイ可能
        if (count == 0 || (count == 1 && reward)) {
          playable = true;
          break;
        } else if (count == 1) {
          adPlayable = true;
        }
      }

      if (playable) break; // 1つでも通常プレイ可能なら抜ける
    }

    if (!mounted) return;

    setState(() {
      if (playable) {
        _status = l10n(context, 'playableStatus');
      } else if (adPlayable) {
        _status = l10n(context, 'playableWithAdStatus');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_status == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _bob,
      child: CustomPaint(
        painter: const BubblePainter(
          color: Colors.white,
          borderColor: Colors.orange,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: Text(
            _status!,
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

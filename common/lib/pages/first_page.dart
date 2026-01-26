import 'package:common/assistance/l10n_helper.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonFirstPage extends StatefulWidget {
  const CommonFirstPage({super.key});

  @override
  State<CommonFirstPage> createState() => _CommonFirstPageState();
}

class _CommonFirstPageState extends State<CommonFirstPage>
    with TickerProviderStateMixin {
  bool _isNavigating = false;

  late final AnimationController _controller;
  late final Animation<Offset> _iconAnimation;
  late final Animation<Offset> _titleAnimation;

  // 点滅用
  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();

    // スライドアニメーション
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _iconAnimation = Tween<Offset>(
            begin: const Offset(1.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _titleAnimation = Tween<Offset>(
            begin: const Offset(-1.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // 点滅アニメーション
    _blinkController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _blinkAnimation =
        Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    // 点滅をループ
    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  void _navigateToDestination() {
    if (_isNavigating) return;
    setState(() {
      _isNavigating = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CommonModeSelectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appConfig = Provider.of<AppConfig>(context, listen: false);
    final icon = appConfig.icon;

    return AppAdScaffold(
        advisible: false,
        body: GestureDetector(
          onTap: _navigateToDestination,
          child: Container(
            child: Padding(
              padding: EdgeInsetsGeometry.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // アイコン
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SlideTransition(
                        position: _iconAnimation,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            icon, size: 120, // 初期サイズを指定
                            color: textColor1(context),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // タイトル
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: SlideTransition(
                        position: _titleAnimation,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            l10n(context, appConfig.title),
                            style: TextStyle(
                              fontSize: 120, // 初期サイズを指定
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
                  ),

                  // タップしてスタート
                  Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: FadeTransition(
                            opacity: _blinkAnimation,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                l10n(context, 'tapToStart'),
                                style: TextStyle(
                                  fontSize: 120, // 初期サイズを指定
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Future<void> _checkFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
    // ここで初回起動時にしたい処理があれば書く
    print("初回起動です！");
  }
}

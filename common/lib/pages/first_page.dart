import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/app_sound.dart';

class CommonFirstPage extends ConsumerStatefulWidget {
  const CommonFirstPage({super.key});

  @override
  ConsumerState<CommonFirstPage> createState() => _CommonFirstPageState();
}

class _CommonFirstPageState extends ConsumerState<CommonFirstPage>
    with TickerProviderStateMixin {
  bool _isNavigating = false;

  late final AnimationController _controller;
  late final Animation<Offset> _iconAnimation;
  late final Animation<Offset> _titleAnimation;

  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _iconAnimation = Tween<Offset>(
            begin: const Offset(1.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _titleAnimation = Tween<Offset>(
            begin: const Offset(-1.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _blinkController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _blinkAnimation =
        Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  Future<void> _navigateToDestination() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true; // 判定が始まるのでインジケーターを出す
    });

    try {
      // 1. アップデートチェックが終わっていなければ待つ
      // Bootstrap で呼び出しているはずなので、通常はすぐ終わります
      if (UpdateManager.needsUpdate == null) {
        await UpdateManager.checkUpdate();
      }

      // 2. 強制アップデートが必要な場合はダイアログを出して終了
      if (UpdateManager.needsUpdate == true) {
        if (mounted) {
          UpdateManager.showUpdateDialog(context, allData.appData.URL);
          setState(() => _isNavigating = false); // ダイアログの裏でぐるぐるを消す
        }
        return;
      }

      // 3. UIDとSoundのロード状況を確認
      final uidAsync = ref.read(appUidProvider);
      final soundAsync = ref.read(appSoundProvider);

      if (uidAsync.isLoading || soundAsync.isLoading) {
        // ロード完了を待つ (Future.wait)
        await Future.wait([
          ref.read(appUidProvider.future),
          ref.read(appSoundProvider.future),
        ]);
      }
    } catch (e) {
      debugPrint('Navigation initialization error: $e');
      if (mounted) setState(() => _isNavigating = false);
      return;
    }

    if (!mounted) return;

    // 4. 次の画面へ遷移
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CommonModeSelectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = allData.appIcon;

    return AppAdScaffold(
      advisible: false,
      body: Stack(
        children: [
          // メインコンテンツ
          GestureDetector(
            onTap: _navigateToDestination,
            child: Container(
              color: Colors.transparent, // タップ判定を広げるため
              padding: const EdgeInsets.all(30),
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
                            icon,
                            size: 120,
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
                            l10n(context, allData.appTitle),
                            style: TextStyle(
                              fontSize: 120,
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
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: FadeTransition(
                          opacity: _blinkAnimation,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              l10n(context, 'tapToStart'),
                              style: TextStyle(
                                fontSize: 120,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ★ インジケーター表示 (ロード中のみ)
          if (_isNavigating)
            Container(
              color: Colors.black.withAlpha(50), // 画面を少し暗くして入力を防ぐ
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _checkFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
    debugPrint("初回起動です！");
  }
}

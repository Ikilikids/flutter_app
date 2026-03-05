import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Hookを追加
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonFirstPage extends HookConsumerWidget {
  const CommonFirstPage({super.key});

  // 初回起動チェック
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      debugPrint("初回起動です！");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State & Controllers (Hooks) ---

    final isNavigating = useState(false);

    // メインアニメーション（アイコン・タイトル）
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );

    // 点滅アニメーション
    final blinkController = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );

    // --- Animations ---

    final iconAnimation = useMemoized(() => Tween<Offset>(
            begin: const Offset(1.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)));

    final titleAnimation = useMemoized(() => Tween<Offset>(
            begin: const Offset(-1.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)));

    final blinkAnimation = useMemoized(
        () => Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(
              parent: blinkController,
              curve: Curves.easeInOut,
            )));

    // --- Effects (InitState の代わり) ---

    useEffect(() {
      _checkFirstLaunch();
      controller.forward();
      blinkController.repeat(reverse: true);
      return null; // dispose は Hook が自動で行うため不要
    }, const []);

    // --- Logic ---

    Future<void> navigateToDestination() async {
      if (isNavigating.value) return;

      isNavigating.value = true;

      try {
        if (UpdateManager.needsUpdate == null) {
          await UpdateManager.checkUpdate();
        }

        if (UpdateManager.needsUpdate == true) {
          if (context.mounted) {
            UpdateManager.showUpdateDialog(context, allData.appData.URL);
            isNavigating.value = false;
          }
          return;
        }

        final uidAsync = ref.read(appUidProvider);
        final soundAsync = ref.read(appSoundProvider);

        if (uidAsync.isLoading || soundAsync.isLoading) {
          await Future.wait([
            ref.read(appUidProvider.future),
            ref.read(appSoundProvider.future),
          ]);
        }
      } catch (e) {
        debugPrint('Navigation initialization error: $e');
        isNavigating.value = false;
        return;
      }

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CommonModeSelectionPage(),
        ),
      );
    }

    // --- UI ---

    final icon = allData.appIcon;

    return AppAdScaffold(
      advisible: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: navigateToDestination,
            child: Container(
              color: Colors.transparent,
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
                        position: iconAnimation,
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
                        position: titleAnimation,
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
                          opacity: blinkAnimation,
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

          // インジケーター表示
          if (isNavigating.value)
            Container(
              color: Colors.black.withAlpha(50),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

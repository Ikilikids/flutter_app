import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';
import '../freezed/user_status.dart';

part 'user_status_provider.g.dart';

@Riverpod(keepAlive: true)
class UserStatusNotifier extends _$UserStatusNotifier {
  @override
  FutureOr<UserStatus> build() async {
    return await _init();
  }

  String _getDateKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  // --- ① 初期化 ---
  Future<UserStatus> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    // 1. すべてのクイズのスコア取得処理を「予約（Futureのリスト作成）」する
    // この時点では await しないので、一瞬でループが終わります
    final List<Future<QuizStatus>> quizStatusFutures = [];

    for (var mid in allData.mid) {
      for (var detail in mid.detail) {
        final uniqueId = "${detail.resisterOrigin}_${mid.modeData.modeType}";

        // ScoreManager.getScore の結果を QuizStatus に変換する Future を作る
        final future = ScoreManager.getScore(
          resisterOriginOrSub: detail.resisterOrigin,
          modeType: mid.modeData.modeType,
        ).then((score) {
          final playCount =
              prefs.getInt('playCount_${detail.resisterOrigin}') ?? 0;
          return QuizStatus(
            id: uniqueId,
            highScore: score,
            playCount: playCount,
          );
        });

        quizStatusFutures.add(future);
      }
    }

    // 2. ★ここで一斉に並列実行して待つ
    // 1つずつ待つのとは違い、一番遅い通信1回分の待ち時間で全データが揃います
    final List<QuizStatus> initialQuizzes =
        await Future.wait(quizStatusFutures);

    // 3. モード状態の初期化
    final List<ModeStatus> initialModes = allData.mid.map((m) {
      return ModeStatus(modeType: m.modeData.modeType, badgeText: '');
    }).toList();

    // 初期選択：最初のモードと、そのモードの最初のクイズ
    final firstModeId = allData.mid.first.modeData.modeType;
    final firstDetailId = allData.mid.first.detail.first.resisterOrigin;

    // 4. 計算ロジックへ
    return _calculateAllStatus(
      initialQuizzes,
      initialModes,
      firstModeId,
      firstDetailId,
      prefs,
      dateKey,
    );
  }

  // --- ② 状態計算ロジック（ボタン文字・モードバッジ） ---
  UserStatus _calculateAllStatus(
    List<QuizStatus> quizzes,
    List<ModeStatus> modes,
    String selectedModeId,
    String selectedDetailId,
    SharedPreferences prefs,
    String dateKey,
  ) {
    final updatedQuizzes = quizzes.map((q) {
      final parts = q.id.split('_');
      final quizId = parts[0];
      final modeType = parts[1];

      final masterMode =
          allData.mid.firstWhere((m) => m.modeData.modeType == modeType);

      if (!masterMode.modeData.islimited) {
        return q.copyWith(buttonText: 'playButton');
      } else {
        final isAdWatched = prefs.getString('rewardGranted_$quizId') == dateKey;
        if (q.playCount == 0) {
          return q.copyWith(buttonText: 'playButton');
        } else if (q.playCount == 1 && isAdWatched) {
          return q.copyWith(buttonText: 'playButtonSecondTime');
        } else if (q.playCount == 1 && !isAdWatched) {
          return q.copyWith(buttonText: 'watchAdToPlayButton');
        } else {
          return q.copyWith(buttonText: 'playedTodayButton');
        }
      }
    }).toList();

    final updatedModes = modes.map((m) {
      final masterMode = allData.mid
          .firstWhere((mode) => mode.modeData.modeType == m.modeType);
      if (!masterMode.modeData.islimited) return m.copyWith(badgeText: '');

      final modeQuizzes =
          updatedQuizzes.where((q) => q.id.endsWith('_${m.modeType}'));
      bool hasPlayable =
          modeQuizzes.any((q) => q.buttonText.contains('playButton'));
      bool hasAd =
          modeQuizzes.any((q) => q.buttonText == 'watchAdToPlayButton');

      return m.copyWith(
        badgeText: hasPlayable
            ? 'playableStatus'
            : (hasAd ? 'playableWithAdStatus' : ''),
      );
    }).toList();

    return UserStatus(
      quizzes: updatedQuizzes,
      modes: updatedModes,
      selectedModeId: selectedModeId,
      selectedDetailId: selectedDetailId,
    );
  }

  // --- ③ セレクター更新アクション ---

  void selectMode(String modeType) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedModeId: modeType));
  }

  void selectDetail(String resisterOrigin) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedDetailId: resisterOrigin));
  }

  // --- ④ データ更新アクション ---

  /// 現在選択されているクイズのプレイ回数を記録
  /// 【修正】特定のクイズIDを指定してプレイ回数を記録
  Future<void> recordPlay(String quizId) async {
    final current = state.value;
    if (current == null) return;

    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    // IDをキーにしてプレイ回数を保存・更新
    int nextCount = ((prefs.getInt('playCount_$quizId') ?? 0) + 1);
    print("Recording play for $quizId, next count: $nextCount");
    await prefs.setInt('playCount_$quizId', nextCount);

    // 状態（quizzesリスト）の中の、該当するIDを持つすべてのデータを更新
    // (同じクイズが複数モードにある場合を考慮して startsWith を維持)
    final newQuizzes = current.quizzes
        .map((q) => q.id.startsWith('${quizId}_')
            ? q.copyWith(playCount: nextCount)
            : q)
        .toList();

    state = AsyncData(_calculateAllStatus(
      newQuizzes,
      current.modes,
      current.selectedModeId,
      current.selectedDetailId,
      prefs,
      dateKey,
    ));
  }

  /// 現在選択されているクイズに報酬を付与（広告視聴）
  Future<void> grantReward(String quizId) async {
    final current = state.value;
    if (current == null) return;

    print("granting reward for $quizId"); // ここで正しいIDが出るはず
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    // 特定のIDに対してフラグを立てる
    await prefs.setString('rewardGranted_$quizId', dateKey);

    state = AsyncData(_calculateAllStatus(
      current.quizzes,
      current.modes,
      current.selectedModeId,
      current.selectedDetailId,
      prefs,
      dateKey,
    ));
  }

  /// 【修正】特定のクイズID（resisterOrigin）の問題数を更新
  void updateQcount(String resisterOrigin, String modeType, int qcount) {
    final current = state.value;
    if (current == null) return;

    final targetId = "${resisterOrigin}_$modeType";

    // 現在の state をベースに、特定のクイズだけ copyWith で書き換える
    state = AsyncData(current.copyWith(
      quizzes: current.quizzes
          .map((q) => q.id == targetId ? q.copyWith(qCount: qcount) : q)
          .toList(),
    ));
  }

  /// 【修正】特定のクイズID（resisterOrigin）のスコアを更新
  Future<void> updateScoreLocally(
      String resisterOrigin, String modeType, num newScore) async {
    final current = state.value;
    if (current == null) return;

    final targetId = "${resisterOrigin}_$modeType";

    // 1. まずクイズリストを更新
    final newQuizzes = current.quizzes
        .map((q) => q.id == targetId ? q.copyWith(highScore: newScore) : q)
        .toList();

    // 2. 最新の SharedPreferences を取得
    final prefs = await SharedPreferences.getInstance();

    // 3. 状態を更新（重要：selectedModeId などは current のものをそのまま使い、勝手に上書きしない）
    state = AsyncData(_calculateAllStatus(
      newQuizzes,
      current.modes,
      current.selectedModeId,
      current.selectedDetailId,
      prefs,
      _getDateKey(),
    ));
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

part 'user_status_provider.g.dart';

@Riverpod(keepAlive: true)
class UserStatusNotifier extends _$UserStatusNotifier {
  @override
  UserStatus build() {
    // 最初は空の状態で作成 (Bootstrapで後から上書きされる)
    return _createInitialStatus([], [], '', '');
  }

  String _getDateKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  /// 外部（Bootstrap）から初期データを注入するためのメソッド
  Future<void> initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final allScoresMap = await ScoreManager.getAllScores();

    final List<QuizStatus> initialQuizzes = [];
    for (var mid in allData.mid) {
      for (var detail in mid.detail) {
        final uniqueId = "${detail.resisterOrigin}_${mid.modeData.modeType}";
        final score = allScoresMap[uniqueId] ?? 0.0;
        final playCount =
            prefs.getInt('playCount_${detail.resisterOrigin}') ?? 0;

        initialQuizzes.add(QuizStatus(
          id: uniqueId,
          highScore: score,
          playCount: playCount,
        ));
      }
    }

    final List<ModeStatus> initialModes = allData.mid.map((m) {
      return ModeStatus(modeType: m.modeData.modeType);
    }).toList();

    final firstModeId = allData.mid.first.modeData.modeType;
    final firstDetailId = allData.mid.first.detail.first.resisterOrigin;

    state = _calculateAllStatus(
      initialQuizzes,
      initialModes,
      firstModeId,
      firstDetailId,
      prefs,
      _getDateKey(),
    );
  }

  UserStatus _createInitialStatus(List<QuizStatus> quizzes,
      List<ModeStatus> modes, String selectedModeId, String selectedDetailId) {
    return UserStatus(
      quizzes: quizzes,
      modes: modes,
      selectedModeId: selectedModeId,
      selectedDetailId: selectedDetailId,
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

    return UserStatus(
      quizzes: updatedQuizzes,
      modes: modes,
      selectedModeId: selectedModeId,
      selectedDetailId: selectedDetailId,
    );
  }

  // --- ③ セレクター更新アクション ---

  void selectDetail(String resisterOrigin) {
    state = state.copyWith(selectedDetailId: resisterOrigin);
  }

  // --- ④ データ更新アクション ---

  /// 現在選択されているクイズのプレイ回数を記録
  /// 【修正】特定のクイズIDを指定してプレイ回数を記録
  Future<void> recordPlay(String quizId) async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    // IDをキーにしてプレイ回数を保存・更新
    int nextCount = ((prefs.getInt('playCount_$quizId') ?? 0) + 1);
    print("Recording play for $quizId, next count: $nextCount");
    await prefs.setInt('playCount_$quizId', nextCount);

    // 状態（quizzesリスト）の中の、該当するIDを持つすべてのデータを更新
    final newQuizzes = state.quizzes
        .map((q) => q.id.startsWith('${quizId}_')
            ? q.copyWith(playCount: nextCount)
            : q)
        .toList();

    state = _calculateAllStatus(
      newQuizzes,
      state.modes,
      state.selectedModeId,
      state.selectedDetailId,
      prefs,
      dateKey,
    );
  }

  /// 現在選択されているクイズに報酬を付与（広告視聴）
  Future<void> grantReward(String quizId) async {
    print("granting reward for $quizId");
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    // 特定のIDに対してフラグを立てる
    await prefs.setString('rewardGranted_$quizId', dateKey);

    state = _calculateAllStatus(
      state.quizzes,
      state.modes,
      state.selectedModeId,
      state.selectedDetailId,
      prefs,
      dateKey,
    );
  }

  /// 【修正】特定のクイズID（resisterOrigin）の問題数を更新
  void updateQcount(String resisterOrigin, String modeType, int qcount) {
    final targetId = "${resisterOrigin}_$modeType";

    state = state.copyWith(
      quizzes: state.quizzes
          .map((q) => q.id == targetId ? q.copyWith(qCount: qcount) : q)
          .toList(),
    );
  }

  /// 【修正】特定のクイズID（resisterOrigin）のスコアを更新
  Future<void> updateScoreLocally(
      String resisterOrigin, String modeType, num newScore) async {
    final targetId = "${resisterOrigin}_$modeType";

    // 1. まずクイズリストを更新
    final newQuizzes = state.quizzes
        .map((q) => q.id == targetId ? q.copyWith(highScore: newScore) : q)
        .toList();

    // 2. 最新の SharedPreferences を取得
    final prefs = await SharedPreferences.getInstance();

    // 3. 状態を更新
    state = _calculateAllStatus(
      newQuizzes,
      state.modes,
      state.selectedModeId,
      state.selectedDetailId,
      prefs,
      _getDateKey(),
    );
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

part 'user_status_provider.g.dart';

@Riverpod(keepAlive: true)
class UserStatusNotifier extends _$UserStatusNotifier {
  // ---------------------------------------------------------
  // ① 初期化ロジック (起動時に一回だけ実行される)
  // ---------------------------------------------------------
  @override
  Future<UserStatus> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);

    // 1. 全クイズIDを収集
    final Set<String> targetIdSet = {};
    for (var mid in allData.mid) {
      for (var detail in mid.detail) {
        targetIdSet.add(detail.quizId.toString());
      }
    }

    // 2. スコアを一括取得
    final allScoresMap =
        await ScoreManager.getScoresByIds(targetIdSet.toList());
    final dateKey = _getDateKey();

    final List<MapEntry<QuizId, QuizStatus>> quizEntries = [];
    for (var mid in allData.mid) {
      for (var detail in mid.detail) {
        final quizId = detail.quizId;
        final score = allScoresMap[quizId.toString()] ?? 0.0;
        final playCount =
            prefs.getInt('playCount_${dateKey}_${quizId.toString()}') ?? 0;

        quizEntries.add(MapEntry(
          quizId,
          QuizStatus(
            id: quizId,
            highScore: score,
            playCount: playCount,
            buttonType: _computeButtonType(
              id: quizId,
              playCount: playCount,
              prefs: prefs,
            ),
          ),
        ));
      }
    }

    return UserStatus(
      quizzes: Map.fromEntries(quizEntries),
    );
  }

  // ---------------------------------------------------------
  // ② 更新アクション (state.requireValue を使って同期的に更新)
  // ---------------------------------------------------------

  /// プレイ回数を記録し、ボタン状態を再計算
  Future<void> recordPlay(QuizId id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final dateKey = _getDateKey();
    final String storageKey = 'playCount_${dateKey}_${id.toString()}';

    int nextCount = (prefs.getInt(storageKey) ?? 0) + 1;
    await prefs.setInt(storageKey, nextCount);

    // 現在の状態を取得（ロード済み前提なので requireValue）
    final currentStatus = state.requireValue;
    final updatedQuizzes = Map<QuizId, QuizStatus>.from(currentStatus.quizzes);
    final current = updatedQuizzes[id];

    if (current != null) {
      updatedQuizzes[id] = current.copyWith(
        playCount: nextCount,
        buttonType: _computeButtonType(
          id: id,
          playCount: nextCount,
          prefs: prefs,
        ),
      );
      // stateを直接上書き（UIに即反映）
      state = AsyncData(currentStatus.copyWith(quizzes: updatedQuizzes));
    }
  }

  /// 報酬付与（広告視聴済みフラグを立ててボタン更新）
  Future<void> grantReward(QuizId id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final dateKey = _getDateKey();

    await prefs.setString('rewardGranted_${id.toString()}', dateKey);

    final currentStatus = state.requireValue;
    final updatedQuizzes = Map<QuizId, QuizStatus>.from(currentStatus.quizzes);
    final current = updatedQuizzes[id];

    if (current != null) {
      updatedQuizzes[id] = current.copyWith(
        buttonType: _computeButtonType(
          id: id,
          playCount: current.playCount,
          prefs: prefs,
        ),
      );
      state = AsyncData(currentStatus.copyWith(quizzes: updatedQuizzes));
    }
  }

  /// 問題数のカウントを更新
  void updateQcount(QuizId id, int qcount) {
    final currentStatus = state.requireValue;
    final updatedQuizzes = Map<QuizId, QuizStatus>.from(currentStatus.quizzes);
    final current = updatedQuizzes[id];

    if (current != null) {
      updatedQuizzes[id] = current.copyWith(qCount: qcount);
      state = AsyncData(currentStatus.copyWith(quizzes: updatedQuizzes));
    }
  }

  /// スコアをローカル状態に即時反映
  Future<void> updateScoreLocally(QuizId id, num newScore) async {
    final currentStatus = state.requireValue;
    final updatedQuizzes = Map<QuizId, QuizStatus>.from(currentStatus.quizzes);
    final current = updatedQuizzes[id];

    if (current != null) {
      updatedQuizzes[id] = current.copyWith(highScore: newScore);
      state = AsyncData(currentStatus.copyWith(quizzes: updatedQuizzes));
    }
  }

  // ---------------------------------------------------------
  // ③ 内部ロジック (整理のため private に集約)
  // ---------------------------------------------------------

  static String _getDateKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  static QuizButtonType _computeButtonType({
    required QuizId id,
    required int playCount,
    required SharedPreferences prefs,
  }) {
    final masterMode =
        allData.mid.firstWhere((m) => m.modeData.modeType == id.modeType);

    if (!masterMode.modeData.islimited) {
      return QuizButtonType.play;
    }

    final dateKey = _getDateKey();
    final isAdWatched =
        prefs.getString('rewardGranted_${id.toString()}') == dateKey;

    if (playCount == 0) {
      return QuizButtonType.play;
    } else if (playCount == 1 && isAdWatched) {
      return QuizButtonType.playSecond;
    } else if (playCount == 1 && !isAdWatched) {
      return QuizButtonType.watchAd;
    } else {
      return QuizButtonType.alreadyPlayed;
    }
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

part 'app_mid_config.g.dart';

@riverpod
class AppMidConfig extends _$AppMidConfig {
  @override
  MidConfig build() {
    return MidConfig(
      appData: allData.appData,
      mid: allData.mid.first,
    );
  }

  // 判定に使う日付キーを「YYYY-MM-DD」形式で統一（ズレを防止）
  String _getDateKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  Future<void> loadMid() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    // 移行済みフラグの確認
    bool isMigrated = prefs.getBool('is_migrated_v2') ?? false;

    for (var mid in allData.mid) {
      bool modeHasPlayable = false;
      bool modeHasAdPlayable = false;

      // データの読み込みを並列処理
      final futures = mid.detail.map((detail) async {
        final label = detail.label;
        final quizId = JapaneseTranslator.translateKeyToJapanese(label);
        final rankingId = mid.modeData.ranking;

        // --- スコア移行ロジック ---
        if (!isMigrated) {
          // Firebaseから取得（移行の最初で最後の一回）
          double fireScore =
              await CommonHighScoreManager.getHighScore(quizId, mid.ranking);
          print('Firebaseから取得: $quizId - ${mid.ranking} - $fireScore');
          // ローカルに保存
          await prefs.setDouble('highScore_${rankingId}_$quizId', fireScore);
          detail.highScore = fireScore;
        } else {
          // 移行済みならローカルからのみ取得
          detail.highScore =
              prefs.getDouble('highScore_${rankingId}_$quizId') ?? 0.0;
        }

        // --- プレイ状況・リセット判定 (以前と同様) ---
        final lastPlayDate = prefs.getString('lastPlayDate_$quizId') ?? '';
        int playCount = prefs.getInt('playCount_$quizId') ?? 0;
        final isAdWatched = prefs.getString('rewardGranted_$quizId') == dateKey;

        if (lastPlayDate != dateKey) {
          playCount = 0;
          await prefs.setInt('playCount_$quizId', 0);
          await prefs.remove('rewardGranted_$quizId');
          await prefs.setString('lastPlayDate_$quizId', dateKey);
        }

        // ボタンテキスト判定
        if (!mid.modeData.islimited) {
          detail.buttonText = 'playButton';
        } else {
          if (playCount == 0) {
            detail.buttonText = 'playButton';
            modeHasPlayable = true;
          } else if (playCount == 1 && isAdWatched) {
            detail.buttonText = 'playButtonSecondTime';
            modeHasPlayable = true;
          } else if (playCount == 1 && !isAdWatched) {
            detail.buttonText = 'watchAdToPlayButton';
            modeHasAdPlayable = true;
          } else {
            detail.buttonText = 'playedTodayButton';
          }
        }
      }).toList();

      await Future.wait(futures);

      // バッジ判定ロジック
      if (!mid.modeData.islimited) {
        mid.modeData.badgeText = '';
      } else if (modeHasPlayable) {
        mid.modeData.badgeText = 'playableStatus';
      } else if (modeHasAdPlayable) {
        mid.modeData.badgeText = 'playableWithAdStatus';
      } else {
        mid.modeData.badgeText = '';
      }
    }

    // 全モードの全項目チェックが終わったら移行フラグを立てる
    if (!isMigrated) {
      await prefs.setBool('is_migrated_v2', true);
    }

    state = MidConfig(appData: state.appData, mid: state.mid);
  }

  Future<void> recordPlay(String label) async {
    final quizId = JapaneseTranslator.translateKeyToJapanese(label);
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    int currentCount = prefs.getInt('playCount_$quizId') ?? 0;
    int nextCount = (currentCount + 1).clamp(0, 2);

    await prefs.setInt('playCount_$quizId', nextCount);
    await prefs.setString('lastPlayDate_$quizId', dateKey);

    await loadMid();
  }

  Future<void> grantReward(String label) async {
    final quizId = JapaneseTranslator.translateKeyToJapanese(label);
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();

    // ここで保存するキーを loadMid と完全に一致させる
    await prefs.setString('rewardGranted_$quizId', dateKey);

    // 保存した直後に再計算
    await loadMid();
  }

  void selectMid(MidData mid) {
    state = state.copyWith(mid: mid);
  }
}

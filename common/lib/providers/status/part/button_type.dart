import 'package:common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'button_type.g.dart';

@Riverpod(keepAlive: true)
class PlayCountNotifier extends _$PlayCountNotifier {
  @override
  Future<Map<QuizId, int>> build() async {
    final Map<QuizId, int> result = {};
    final prefs = ref.watch(sharedPreferencesProvider);
    final dateKey = getDateKey();

    // 1. 保存されている全キーを取得
    final allKeys = prefs.getKeys();

    // 2. 「playCount_日付」で始まるキーだけを抜き出す
    final prefix = 'playCount_$dateKey';

    for (String key in allKeys) {
      if (key.startsWith(prefix)) {
        // 1. キーから ID部分の String を抽出 (例: "t_101")
        final idStr = key.replaceFirst('${prefix}_', '');

        // 2. factory を使って QuizId オブジェクトに変換
        final quizId = QuizId.fromString(idStr);

        // 3. Map のキーとして登録
        result[quizId] = prefs.getInt(key) ?? 0;
      }
    }

    return result;
  }

  Future<void> incrementPlayCount(QuizId id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final dateKey = getDateKey();
    final String storageKey = 'playCount_${dateKey}_${id.toString()}';

    int nextCount = (prefs.getInt(storageKey) ?? 0) + 1;
    await prefs.setInt(storageKey, nextCount);

    // ローカルの状態も更新
    final currentCounts = state.requireValue;
    final updatedCounts = Map<QuizId, int>.from(currentCounts);
    updatedCounts[id] = nextCount;
    state = AsyncData(updatedCounts);
  }
}

@Riverpod(keepAlive: true)
class RewardNotifier extends _$RewardNotifier {
  @override
  Future<Map<QuizId, bool>> build() async {
    final Map<QuizId, bool> result = {};
    final prefs = ref.watch(sharedPreferencesProvider);
    final dateKey = getDateKey();

    // 1. 保存されている全キーを取得
    final allKeys = prefs.getKeys();

    // 2. 「playCount_日付」で始まるキーだけを抜き出す
    final prefix = 'reward_$dateKey';

    for (String key in allKeys) {
      if (key.startsWith(prefix)) {
        // 1. キーから ID部分の String を抽出 (例: "t_101")
        final idStr = key.replaceFirst('${prefix}_', '');

        // 2. factory を使って QuizId オブジェクトに変換
        final quizId = QuizId.fromString(idStr);

        // 3. Map のキーとして登録
        result[quizId] = prefs.getBool(key) ?? false;
      }
    }

    return result;
  }

  Future<void> rewardGrant(QuizId id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final dateKey = getDateKey();
    final String storageKey = 'reward_${dateKey}_${id.toString()}';

    await prefs.setBool(storageKey, true);

    // ローカルの状態も更新
    final currentCounts = state.requireValue;
    final updatedCounts = Map<QuizId, bool>.from(currentCounts);
    updatedCounts[id] = true;
    state = AsyncData(updatedCounts);
  }
}

@Riverpod(keepAlive: true)
class ButtonNotifier extends _$ButtonNotifier {
  @override
  Future<Map<QuizId, QuizButtonType>> build() async {
    final Map<QuizId, QuizButtonType> result = {};
    final playCountMap = await ref.watch(playCountNotifierProvider.future);
    final rewardMap = await ref.watch(rewardNotifierProvider.future);
    for (var entry in playCountMap.entries) {
      final quizId = entry.key;
      final playCount = entry.value;
      final isAdWatched = rewardMap[quizId] ?? false;

      QuizButtonType buttonType;
      if (playCount == 0 || quizId.modeType == "t") {
        buttonType = QuizButtonType.play;
      } else if (playCount == 1 && isAdWatched) {
        buttonType = QuizButtonType.playSecond;
      } else if (playCount == 1 && !isAdWatched) {
        buttonType = QuizButtonType.watchAd;
      } else {
        buttonType = QuizButtonType.alreadyPlayed;
      }
      result[quizId] = buttonType;
    }

    return result;
  }
}

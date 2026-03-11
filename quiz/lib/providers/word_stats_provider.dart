import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'word_stats_provider.g.dart';

/// 1単語ごとの統計情報モデル
class WordStats {
  final bool star;
  final bool heart;
  final int correctCount;
  final int incorrectCount;
  final int hintCount;
  final List<String> recentResults;

  const WordStats({
    this.star = false,
    this.heart = false,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.hintCount = 0,
    this.recentResults = const [],
  });

  /// 正解率計算 (△は0.5回分)
  double get accuracyRate {
    final total = correctCount + hintCount + incorrectCount;
    if (total == 0) return 0.0;
    return ((correctCount + hintCount * 0.5) / total) * 100;
  }

  WordStats copyWith({
    bool? star,
    bool? heart,
    int? correctCount,
    int? incorrectCount,
    int? hintCount,
    List<String>? recentResults,
  }) {
    return WordStats(
      star: star ?? this.star,
      heart: heart ?? this.heart,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      hintCount: hintCount ?? this.hintCount,
      recentResults: recentResults ?? this.recentResults,
    );
  }
}

/// 単語の全統計情報を管理するNotifier
@Riverpod(keepAlive: true)
class WordStatsNotifier extends _$WordStatsNotifier {
  late SharedPreferences _prefs;

  @override
  FutureOr<Map<String, WordStats>> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _loadAllStats();
  }

  /// SharedPreferences から全データを一括ロード
  Map<String, WordStats> _loadAllStats() {
    final Map<String, WordStats> statsMap = {};
    final allKeys = _prefs.getKeys();

    // stats_ で始まるキーをスキャンして単語リストを作成
    final wordKeys = allKeys
        .where((k) => k.startsWith('stats_'))
        .map((k) => k.split('_')[1])
        .toSet();

    for (var word in wordKeys) {
      final key = word.toLowerCase();
      statsMap[key] = WordStats(
        star: _prefs.getBool('stats_${key}_star') ?? false,
        heart: _prefs.getBool('stats_${key}_heart') ?? false,
        correctCount: _prefs.getInt('stats_${key}_c') ?? 0,
        incorrectCount: _prefs.getInt('stats_${key}_i') ?? 0,
        hintCount: _prefs.getInt('stats_${key}_h') ?? 0,
        recentResults: (_prefs.getString('stats_${key}_r') ?? "").isEmpty
            ? []
            : (_prefs.getString('stats_${key}_r')!).split(','),
      );
    }
    return statsMap;
  }

  /// 星マークの切り替え
  Future<void> toggleStar(String word) async {
    final key = word.toLowerCase();
    final current = state.value?[key] ?? const WordStats();
    final next = current.copyWith(star: !current.star);

    await _updateAndSave(key, next, 'star', next.star);
  }

  /// ハートマークの切り替え
  Future<void> toggleHeart(String word) async {
    final key = word.toLowerCase();
    final current = state.value?[key] ?? const WordStats();
    final next = current.copyWith(heart: !current.heart);

    await _updateAndSave(key, next, 'heart', next.heart);
  }

  /// クイズ結果の更新
  Future<void> recordResult(String word, String result) async {
    final key = word.toLowerCase();
    final current = state.value?[key] ?? const WordStats();

    int c = current.correctCount;
    int i = current.incorrectCount;
    int h = current.hintCount;

    if (result == "○") c++;
    if (result == "×") i++;
    if (result == "△") h++;

    final newRecent = [result, ...current.recentResults].take(5).toList();

    final next = current.copyWith(
      correctCount: c,
      incorrectCount: i,
      hintCount: h,
      recentResults: newRecent,
    );

    // 1. 先に状態を更新してUIを反応させる
    _updateState(key, next);

    // 2. 裏で保存処理を実行
    _prefs.setInt('stats_${key}_c', next.correctCount);
    await _prefs.setInt('stats_${key}_i', next.incorrectCount);
    await _prefs.setInt('stats_${key}_h', next.hintCount);
    await _prefs.setString('stats_${key}_r', next.recentResults.join(','));
  }

  /// 内部用：状態更新と保存（bool値）
  Future<void> _updateAndSave(
      String key, WordStats next, String type, bool value) async {
    // 1. 先に状態を更新
    _updateState(key, next);

    // 2. 保存
    await _prefs.setBool('stats_${key}_$type', value);
  }

  /// 内部用：メモリ上の状態を更新して通知
  void _updateState(String key, WordStats next) {
    if (state.value != null) {
      final newMap = Map<String, WordStats>.from(state.value!);
      newMap[key] = next;
      state = AsyncData(newMap);
    }
  }
}

/// 登録済みの単語数をカウントするProvider
@riverpod
int registeredCount(Ref ref, String type) {
  final statsMap = ref.watch(wordStatsNotifierProvider).value ?? {};
  if (type == "star") {
    return statsMap.values.where((s) => s.star).length;
  } else if (type == "heart") {
    return statsMap.values.where((s) => s.heart).length;
  }
  return 0;
}

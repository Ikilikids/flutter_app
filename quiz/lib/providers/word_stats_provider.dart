import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../quiz.dart';

part 'word_stats_provider.g.dart';

/// 1単語ごとの統計情報モデル
class WordStats {
  final bool star;
  final bool heart;
  final int correctCount;
  final int incorrectCount;
  final int hintCount;
  final List<QuizResult> recentResults;

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

  /// プレイ回数 (○+△+×)
  int get totalPlayCount => correctCount + hintCount + incorrectCount;

  /// 直近5回の正解数
  int get recentCorrectCount =>
      recentResults.where((r) => r == QuizResult.circle).length;

  /// 直近5回の不正解数
  int get recentIncorrectCount =>
      recentResults.where((r) => r == QuizResult.cross).length;

  WordStats copyWith({
    bool? star,
    bool? heart,
    int? correctCount,
    int? incorrectCount,
    int? hintCount,
    List<QuizResult>? recentResults,
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

@Riverpod(keepAlive: true)
class WordStatsNotifier extends _$WordStatsNotifier {
  late SharedPreferences _prefs;

  @override
  Future<Map<String, WordStats>> build() async {
    _prefs = await SharedPreferences.getInstance();
    final Map<String, WordStats> statsMap = {};
    final allKeys = _prefs.getKeys();

    // 1. SharedPreferencesから単語キーを抽出
    final Set<String> wordKeys = allKeys
        .where((k) => k.startsWith('stats_'))
        .map((k) => k.replaceFirst('stats_', '').split('_').first)
        .toSet();

    // 2. データの復元
    for (var key in wordKeys) {
      statsMap[key] = _loadWordStats(key);
    }

    return statsMap;
  }

  /// 指定した単語の統計情報をSPから読み込む
  WordStats _loadWordStats(String key) {
    final recentStr = _prefs.getString('stats_${key}_r') ?? "";
    return WordStats(
      star: _prefs.getBool('stats_${key}_star') ?? false,
      heart: _prefs.getBool('stats_${key}_heart') ?? false,
      correctCount: _prefs.getInt('stats_${key}_c') ?? 0,
      incorrectCount: _prefs.getInt('stats_${key}_i') ?? 0,
      hintCount: _prefs.getInt('stats_${key}_h') ?? 0,
      recentResults: recentStr.isEmpty
          ? []
          : recentStr
              .split(',')
              .map((s) => QuizResult.values.firstWhere((v) => v.name == s,
                  orElse: () => QuizResult.unknown))
              .toList(),
    );
  }

  /// 星マークの切り替え
  Future<void> toggleStar(String word) async {
    final key = word.toLowerCase();
    final current = state.value?[key] ?? const WordStats();
    final next = current.copyWith(star: !current.star);

    _updateState(key, next);
    await _prefs.setBool('stats_${key}_star', next.star);
  }

  /// ハートマークの切り替え
  Future<void> toggleHeart(String word) async {
    final key = word.toLowerCase();
    final current = state.value?[key] ?? const WordStats();
    final next = current.copyWith(heart: !current.heart);

    _updateState(key, next);
    await _prefs.setBool('stats_${key}_heart', next.heart);
  }

  /// クイズ結果の更新
  Future<void> recordResult(String word, QuizResult result) async {
    final key = word.trim().toLowerCase();
    final current = state.value?[key] ?? const WordStats();

    final next = current.copyWith(
      correctCount:
          current.correctCount + (result == QuizResult.circle ? 1 : 0),
      incorrectCount:
          current.incorrectCount + (result == QuizResult.cross ? 1 : 0),
      hintCount: current.hintCount + (result == QuizResult.triangle ? 1 : 0),
      recentResults: [result, ...current.recentResults].take(5).toList(),
    );

    _updateState(key, next);

    // まとめて永続化
    await Future.wait([
      _prefs.setInt('stats_${key}_c', next.correctCount),
      _prefs.setInt('stats_${key}_i', next.incorrectCount),
      _prefs.setInt('stats_${key}_h', next.hintCount),
      _prefs.setString(
          'stats_${key}_r', next.recentResults.map((r) => r.name).join(',')),
    ]);
  }

  /// 内部用：メモリ上の状態を更新
  void _updateState(String key, WordStats next) {
    final currentMap = state.value ?? {};
    state = AsyncData({...currentMap, key: next});
  }
}

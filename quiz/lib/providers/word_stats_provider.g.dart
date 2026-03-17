// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordStatsInitialHash() => r'85ea427b08a5592ebebcf0d59955a3223a3b85ef';

/// 統計データの初期ロードを行うプロバイダー (CSVと同様に初回のみ実行)
///
/// Copied from [wordStatsInitial].
@ProviderFor(wordStatsInitial)
final wordStatsInitialProvider =
    FutureProvider<Map<String, WordStats>>.internal(
  wordStatsInitial,
  name: r'wordStatsInitialProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordStatsInitialHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WordStatsInitialRef = FutureProviderRef<Map<String, WordStats>>;
String _$wordStatsNotifierHash() => r'd61b70b3c33296d6e928d8a18e688350f64c7adb';

/// 単語の全統計情報を管理するNotifier
///
/// Copied from [WordStatsNotifier].
@ProviderFor(WordStatsNotifier)
final wordStatsNotifierProvider =
    AsyncNotifierProvider<WordStatsNotifier, Map<String, WordStats>>.internal(
  WordStatsNotifier.new,
  name: r'wordStatsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordStatsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WordStatsNotifier = AsyncNotifier<Map<String, WordStats>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

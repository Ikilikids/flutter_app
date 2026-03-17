// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$juniorEngRawCsvHash() => r'420db343699d9d150ab4f7451bd9715acbbb7e00';

/// 1. 固定データ: 英単語CSVのパース結果をキャッシュ
///
/// Copied from [juniorEngRawCsv].
@ProviderFor(juniorEngRawCsv)
final juniorEngRawCsvProvider = FutureProvider<List<List<dynamic>>>.internal(
  juniorEngRawCsv,
  name: r'juniorEngRawCsvProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$juniorEngRawCsvHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JuniorEngRawCsvRef = FutureProviderRef<List<List<dynamic>>>;
String _$integratedEngQuizHash() => r'2a3be8185e53e6c21eb74305f47b7f019dd19220';

/// 3. 統合データ: 固定CSVデータ + 可変統計データをマージ (非同期)
///
/// Copied from [integratedEngQuiz].
@ProviderFor(integratedEngQuiz)
final integratedEngQuizProvider =
    FutureProvider<Map<int, List<EngPartData>>>.internal(
  integratedEngQuiz,
  name: r'integratedEngQuizProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$integratedEngQuizHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IntegratedEngQuizRef = FutureProviderRef<Map<int, List<EngPartData>>>;
String _$activeGameMapHash() => r'edf455c5d453ea51f53617e170cccf8462311bd4';

/// ② 今プレイするゲームのために「フィルタリングされた」マップを保持する器
///
/// Copied from [ActiveGameMap].
@ProviderFor(ActiveGameMap)
final activeGameMapProvider =
    NotifierProvider<ActiveGameMap, Map<int, List<PartData>>>.internal(
  ActiveGameMap.new,
  name: r'activeGameMapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeGameMapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveGameMap = Notifier<Map<int, List<PartData>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeGameMapHash() => r'edf455c5d453ea51f53617e170cccf8462311bd4';

/// ① CSVパース済みの全データを保持する（アプリ起動時に1回だけ実行）
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

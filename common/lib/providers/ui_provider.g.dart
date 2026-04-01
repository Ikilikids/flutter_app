// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMidConfigHash() => r'2653b58829da4ffd6eef2b8e587926b7d0bd1d02';

/// ③ 原本と成績を合体させた「現在のモード」の全データ
///
/// Copied from [currentMidConfig].
@ProviderFor(currentMidConfig)
final currentMidConfigProvider = Provider<MidConfig>.internal(
  currentMidConfig,
  name: r'currentMidConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMidConfigHash,
  dependencies: <ProviderOrFamily>[
    userStatusNotifierProvider,
    selectedModeIndexProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    userStatusNotifierProvider,
    ...?userStatusNotifierProvider.allTransitiveDependencies,
    selectedModeIndexProvider,
    ...?selectedModeIndexProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMidConfigRef = ProviderRef<MidConfig>;
String _$currentDetailConfigHash() =>
    r'd4c19774dbb18e739a9b52a2cbdbc435ebb0873c';

/// ④ 今まさに「選ばれている1件」の DetailConfig
///
/// Copied from [currentDetailConfig].
@ProviderFor(currentDetailConfig)
final currentDetailConfigProvider = Provider<DetailConfig>.internal(
  currentDetailConfig,
  name: r'currentDetailConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentDetailConfigHash,
  dependencies: <ProviderOrFamily>[
    currentMidConfigProvider,
    selectedDetailIndexProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentMidConfigProvider,
    ...?currentMidConfigProvider.allTransitiveDependencies,
    selectedDetailIndexProvider,
    ...?selectedDetailIndexProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentDetailConfigRef = ProviderRef<DetailConfig>;
String _$selectedModeIndexHash() => r'6e2118a35d398b1cde8c186ff1361d0f32ca3bf8';

/// ① 今どのタブ（モード）を選択しているか (0:無制限, 1:1日限定, 2:ランキング, 3:設定)
///
/// Copied from [SelectedModeIndex].
@ProviderFor(SelectedModeIndex)
final selectedModeIndexProvider =
    NotifierProvider<SelectedModeIndex, int>.internal(
  SelectedModeIndex.new,
  name: r'selectedModeIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedModeIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedModeIndex = Notifier<int>;
String _$selectedDetailIndexHash() =>
    r'7ce5b482c96013852b0ef753190ba04fa0f3e092';

/// ② 今どの詳細（詳細カード）を選択しているか
///
/// Copied from [SelectedDetailIndex].
@ProviderFor(SelectedDetailIndex)
final selectedDetailIndexProvider =
    NotifierProvider<SelectedDetailIndex, int>.internal(
  SelectedDetailIndex.new,
  name: r'selectedDetailIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDetailIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDetailIndex = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

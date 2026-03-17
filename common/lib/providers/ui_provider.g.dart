// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMidConfigHash() => r'545138e2f01ebe997c5d28eff3634257497a005b';

/// ② 原本と成績を合体させた「現在のモード」の全データ
///
/// Copied from [currentMidConfig].
@ProviderFor(currentMidConfig)
final currentMidConfigProvider = Provider<MidConfig>.internal(
  currentMidConfig,
  name: r'currentMidConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMidConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMidConfigRef = ProviderRef<MidConfig>;
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
String _$currentDetailConfigHash() =>
    r'4c10caeee3332c6d87c725adf462c14f2350b4ae';

/// ③ 今まさに「選ばれている1件」の DetailConfig
///
/// Copied from [CurrentDetailConfig].
@ProviderFor(CurrentDetailConfig)
final currentDetailConfigProvider =
    NotifierProvider<CurrentDetailConfig, DetailConfig>.internal(
  CurrentDetailConfig.new,
  name: r'currentDetailConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentDetailConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentDetailConfig = Notifier<DetailConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

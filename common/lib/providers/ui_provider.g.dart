// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMidConfigHash() => r'322c9fbaa8de6906f8b26f3d5ed78b35c6879553';

/// ② 原本と成績を合体させた「現在のモード」の全データ
///
/// Copied from [currentMidConfig].
@ProviderFor(currentMidConfig)
final currentMidConfigProvider = AutoDisposeProvider<MidConfig>.internal(
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
typedef CurrentMidConfigRef = AutoDisposeProviderRef<MidConfig>;
String _$currentDetailConfigHash() =>
    r'f57215937caf5e41b63ae822e58808a92c3d4b10';

/// ③ 今まさに「選ばれている1件」の DetailConfig
///
/// Copied from [currentDetailConfig].
@ProviderFor(currentDetailConfig)
final currentDetailConfigProvider = AutoDisposeProvider<DetailConfig>.internal(
  currentDetailConfig,
  name: r'currentDetailConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentDetailConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentDetailConfigRef = AutoDisposeProviderRef<DetailConfig>;
String _$selectedModeIndexHash() => r'c7bd792e5b9c2fba136566ebd20a7ad47726deaa';

/// ① 今どのタブ（モード）を選択しているか (0:無制限, 1:1日限定, 2:ランキング, 3:設定)
///
/// Copied from [SelectedModeIndex].
@ProviderFor(SelectedModeIndex)
final selectedModeIndexProvider =
    AutoDisposeNotifierProvider<SelectedModeIndex, int>.internal(
  SelectedModeIndex.new,
  name: r'selectedModeIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedModeIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedModeIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

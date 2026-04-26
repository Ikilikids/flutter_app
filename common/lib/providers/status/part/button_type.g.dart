// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_type.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playCountNotifierHash() => r'ef12264c1ed710b12e7a7b8a3920bae9d6f3bb5d';

/// See also [PlayCountNotifier].
@ProviderFor(PlayCountNotifier)
final playCountNotifierProvider =
    AsyncNotifierProvider<PlayCountNotifier, Map<QuizId, int>>.internal(
  PlayCountNotifier.new,
  name: r'playCountNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playCountNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlayCountNotifier = AsyncNotifier<Map<QuizId, int>>;
String _$rewardNotifierHash() => r'fe874b8f4f0b7e10a6d6325d89e4be96ea567ee2';

/// See also [RewardNotifier].
@ProviderFor(RewardNotifier)
final rewardNotifierProvider =
    AsyncNotifierProvider<RewardNotifier, Map<QuizId, bool>>.internal(
  RewardNotifier.new,
  name: r'rewardNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rewardNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RewardNotifier = AsyncNotifier<Map<QuizId, bool>>;
String _$buttonNotifierHash() => r'2523ff129f580e32bbc3e801775e963ef5702365';

/// See also [ButtonNotifier].
@ProviderFor(ButtonNotifier)
final buttonNotifierProvider =
    AsyncNotifierProvider<ButtonNotifier, Map<QuizId, QuizButtonType>>.internal(
  ButtonNotifier.new,
  name: r'buttonNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$buttonNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ButtonNotifier = AsyncNotifier<Map<QuizId, QuizButtonType>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

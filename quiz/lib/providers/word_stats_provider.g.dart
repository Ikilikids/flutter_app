// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$registeredCountHash() => r'04d402b2922faed43fe2387163362844e29adde6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 登録済みの単語数をカウントするProvider
///
/// Copied from [registeredCount].
@ProviderFor(registeredCount)
const registeredCountProvider = RegisteredCountFamily();

/// 登録済みの単語数をカウントするProvider
///
/// Copied from [registeredCount].
class RegisteredCountFamily extends Family<int> {
  /// 登録済みの単語数をカウントするProvider
  ///
  /// Copied from [registeredCount].
  const RegisteredCountFamily();

  /// 登録済みの単語数をカウントするProvider
  ///
  /// Copied from [registeredCount].
  RegisteredCountProvider call(
    String type,
  ) {
    return RegisteredCountProvider(
      type,
    );
  }

  @override
  RegisteredCountProvider getProviderOverride(
    covariant RegisteredCountProvider provider,
  ) {
    return call(
      provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'registeredCountProvider';
}

/// 登録済みの単語数をカウントするProvider
///
/// Copied from [registeredCount].
class RegisteredCountProvider extends AutoDisposeProvider<int> {
  /// 登録済みの単語数をカウントするProvider
  ///
  /// Copied from [registeredCount].
  RegisteredCountProvider(
    String type,
  ) : this._internal(
          (ref) => registeredCount(
            ref as RegisteredCountRef,
            type,
          ),
          from: registeredCountProvider,
          name: r'registeredCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$registeredCountHash,
          dependencies: RegisteredCountFamily._dependencies,
          allTransitiveDependencies:
              RegisteredCountFamily._allTransitiveDependencies,
          type: type,
        );

  RegisteredCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  Override overrideWith(
    int Function(RegisteredCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RegisteredCountProvider._internal(
        (ref) => create(ref as RegisteredCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _RegisteredCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RegisteredCountProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RegisteredCountRef on AutoDisposeProviderRef<int> {
  /// The parameter `type` of this provider.
  String get type;
}

class _RegisteredCountProviderElement extends AutoDisposeProviderElement<int>
    with RegisteredCountRef {
  _RegisteredCountProviderElement(super.provider);

  @override
  String get type => (origin as RegisteredCountProvider).type;
}

String _$wordStatsNotifierHash() => r'f8a7ea1427d65b09855495445dca72b2fbb57028';

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

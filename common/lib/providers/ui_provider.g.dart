// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizDetailHash() => r'cdf8df26314c0e587d80227a6f4b1d324368c527';

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

/// ③ 1件合体工場 (Family)
///
/// Copied from [quizDetail].
@ProviderFor(quizDetail)
const quizDetailProvider = QuizDetailFamily();

/// ③ 1件合体工場 (Family)
///
/// Copied from [quizDetail].
class QuizDetailFamily extends Family<DetailConfig> {
  /// ③ 1件合体工場 (Family)
  ///
  /// Copied from [quizDetail].
  const QuizDetailFamily();

  /// ③ 1件合体工場 (Family)
  ///
  /// Copied from [quizDetail].
  QuizDetailProvider call(
    QuizId id,
  ) {
    return QuizDetailProvider(
      id,
    );
  }

  @override
  QuizDetailProvider getProviderOverride(
    covariant QuizDetailProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    quizStatusMapProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    quizStatusMapProvider,
    ...?quizStatusMapProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quizDetailProvider';
}

/// ③ 1件合体工場 (Family)
///
/// Copied from [quizDetail].
class QuizDetailProvider extends Provider<DetailConfig> {
  /// ③ 1件合体工場 (Family)
  ///
  /// Copied from [quizDetail].
  QuizDetailProvider(
    QuizId id,
  ) : this._internal(
          (ref) => quizDetail(
            ref as QuizDetailRef,
            id,
          ),
          from: quizDetailProvider,
          name: r'quizDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quizDetailHash,
          dependencies: QuizDetailFamily._dependencies,
          allTransitiveDependencies:
              QuizDetailFamily._allTransitiveDependencies,
          id: id,
        );

  QuizDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final QuizId id;

  @override
  Override overrideWith(
    DetailConfig Function(QuizDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuizDetailProvider._internal(
        (ref) => create(ref as QuizDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  ProviderElement<DetailConfig> createElement() {
    return _QuizDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuizDetailRef on ProviderRef<DetailConfig> {
  /// The parameter `id` of this provider.
  QuizId get id;
}

class _QuizDetailProviderElement extends ProviderElement<DetailConfig>
    with QuizDetailRef {
  _QuizDetailProviderElement(super.provider);

  @override
  QuizId get id => (origin as QuizDetailProvider).id;
}

String _$currentDetailConfigHash() =>
    r'4a94f1d048cb7f36efcb955983115738596a69bc';

/// ④ 現在選ばれている 1 件 (絶対に DetailConfig を返す)
///
/// Copied from [currentDetailConfig].
@ProviderFor(currentDetailConfig)
final currentDetailConfigProvider = Provider<DetailConfig>.internal(
  currentDetailConfig,
  name: r'currentDetailConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentDetailConfigHash,
  dependencies: <ProviderOrFamily>[selectedQuizIdProvider, quizDetailProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    selectedQuizIdProvider,
    ...?selectedQuizIdProvider.allTransitiveDependencies,
    quizDetailProvider,
    ...?quizDetailProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentDetailConfigRef = ProviderRef<DetailConfig>;
String _$selectedModeIndexHash() => r'6e2118a35d398b1cde8c186ff1361d0f32ca3bf8';

/// ① タブ選択
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
String _$selectedQuizIdHash() => r'ef1a736ce7d4f75d795b19e98a8d6405323e7519';

/// ② 選ばれている QuizId (初期値を設定して Non-nullable に)
///
/// Copied from [SelectedQuizId].
@ProviderFor(SelectedQuizId)
final selectedQuizIdProvider =
    NotifierProvider<SelectedQuizId, QuizId>.internal(
  SelectedQuizId.new,
  name: r'selectedQuizIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedQuizIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedQuizId = Notifier<QuizId>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

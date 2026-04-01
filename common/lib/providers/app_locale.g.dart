// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initialLocaleHash() => r'71936735be1c53a2eaf39648813ca1f48e5bfa09';

/// See also [initialLocale].
@ProviderFor(initialLocale)
final initialLocaleProvider = Provider<Locale>.internal(
  initialLocale,
  name: r'initialLocaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initialLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitialLocaleRef = ProviderRef<Locale>;
String _$appLocaleHash() => r'2faae7dcb48af2abe52d00428bc9ba58b6248bf9';

/// See also [AppLocale].
@ProviderFor(AppLocale)
final appLocaleProvider = NotifierProvider<AppLocale, Locale>.internal(
  AppLocale.new,
  name: r'appLocaleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appLocaleHash,
  dependencies: <ProviderOrFamily>[initialLocaleProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    initialLocaleProvider,
    ...?initialLocaleProvider.allTransitiveDependencies
  },
);

typedef _$AppLocale = Notifier<Locale>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

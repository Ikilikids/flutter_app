// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_number.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initialNumberHash() => r'ca17ead8c8c3574475440f3324026956cc9041fa';

/// See also [initialNumber].
@ProviderFor(initialNumber)
final initialNumberProvider = Provider<String>.internal(
  initialNumber,
  name: r'initialNumberProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initialNumberHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitialNumberRef = ProviderRef<String>;
String _$appNumberHash() => r'dee1cfa2aceb29aa72211527f0a39c808f631122';

/// See also [AppNumber].
@ProviderFor(AppNumber)
final appNumberProvider = NotifierProvider<AppNumber, String>.internal(
  AppNumber.new,
  name: r'appNumberProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appNumberHash,
  dependencies: <ProviderOrFamily>[initialNumberProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    initialNumberProvider,
    ...?initialNumberProvider.allTransitiveDependencies
  },
);

typedef _$AppNumber = Notifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

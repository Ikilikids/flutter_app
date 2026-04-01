// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initialThemeHash() => r'fbd53b5a70105764b0472d254a1e6a2e24dca472';

/// See also [initialTheme].
@ProviderFor(initialTheme)
final initialThemeProvider = Provider<ThemeMode>.internal(
  initialTheme,
  name: r'initialThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$initialThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitialThemeRef = ProviderRef<ThemeMode>;
String _$appThemeHash() => r'9fb536b819ac6f4951d74e04fc11ef9752b4d953';

/// See also [AppTheme].
@ProviderFor(AppTheme)
final appThemeProvider = NotifierProvider<AppTheme, ThemeMode>.internal(
  AppTheme.new,
  name: r'appThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appThemeHash,
  dependencies: <ProviderOrFamily>[initialThemeProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    initialThemeProvider,
    ...?initialThemeProvider.allTransitiveDependencies
  },
);

typedef _$AppTheme = Notifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

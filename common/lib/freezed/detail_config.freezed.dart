// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DetailConfig {
  AppData get appData => throw _privateConstructorUsedError;
  ModeData get modeData => throw _privateConstructorUsedError;
  DetailData get detail => throw _privateConstructorUsedError;

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailConfigCopyWith<DetailConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailConfigCopyWith<$Res> {
  factory $DetailConfigCopyWith(
          DetailConfig value, $Res Function(DetailConfig) then) =
      _$DetailConfigCopyWithImpl<$Res, DetailConfig>;
  @useResult
  $Res call({AppData appData, ModeData modeData, DetailData detail});
}

/// @nodoc
class _$DetailConfigCopyWithImpl<$Res, $Val extends DetailConfig>
    implements $DetailConfigCopyWith<$Res> {
  _$DetailConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appData = null,
    Object? modeData = null,
    Object? detail = null,
  }) {
    return _then(_value.copyWith(
      appData: null == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as AppData,
      modeData: null == modeData
          ? _value.modeData
          : modeData // ignore: cast_nullable_to_non_nullable
              as ModeData,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as DetailData,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DetailConfigImplCopyWith<$Res>
    implements $DetailConfigCopyWith<$Res> {
  factory _$$DetailConfigImplCopyWith(
          _$DetailConfigImpl value, $Res Function(_$DetailConfigImpl) then) =
      __$$DetailConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppData appData, ModeData modeData, DetailData detail});
}

/// @nodoc
class __$$DetailConfigImplCopyWithImpl<$Res>
    extends _$DetailConfigCopyWithImpl<$Res, _$DetailConfigImpl>
    implements _$$DetailConfigImplCopyWith<$Res> {
  __$$DetailConfigImplCopyWithImpl(
      _$DetailConfigImpl _value, $Res Function(_$DetailConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appData = null,
    Object? modeData = null,
    Object? detail = null,
  }) {
    return _then(_$DetailConfigImpl(
      appData: null == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as AppData,
      modeData: null == modeData
          ? _value.modeData
          : modeData // ignore: cast_nullable_to_non_nullable
              as ModeData,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as DetailData,
    ));
  }
}

/// @nodoc

class _$DetailConfigImpl implements _DetailConfig {
  const _$DetailConfigImpl(
      {required this.appData, required this.modeData, required this.detail});

  @override
  final AppData appData;
  @override
  final ModeData modeData;
  @override
  final DetailData detail;

  @override
  String toString() {
    return 'DetailConfig(appData: $appData, modeData: $modeData, detail: $detail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailConfigImpl &&
            (identical(other.appData, appData) || other.appData == appData) &&
            (identical(other.modeData, modeData) ||
                other.modeData == modeData) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appData, modeData, detail);

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailConfigImplCopyWith<_$DetailConfigImpl> get copyWith =>
      __$$DetailConfigImplCopyWithImpl<_$DetailConfigImpl>(this, _$identity);
}

abstract class _DetailConfig implements DetailConfig {
  const factory _DetailConfig(
      {required final AppData appData,
      required final ModeData modeData,
      required final DetailData detail}) = _$DetailConfigImpl;

  @override
  AppData get appData;
  @override
  ModeData get modeData;
  @override
  DetailData get detail;

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailConfigImplCopyWith<_$DetailConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

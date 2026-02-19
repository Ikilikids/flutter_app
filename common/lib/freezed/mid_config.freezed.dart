// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mid_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MidConfig {
  AppData get appData => throw _privateConstructorUsedError;
  MidData get mid => throw _privateConstructorUsedError;

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MidConfigCopyWith<MidConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MidConfigCopyWith<$Res> {
  factory $MidConfigCopyWith(MidConfig value, $Res Function(MidConfig) then) =
      _$MidConfigCopyWithImpl<$Res, MidConfig>;
  @useResult
  $Res call({AppData appData, MidData mid});
}

/// @nodoc
class _$MidConfigCopyWithImpl<$Res, $Val extends MidConfig>
    implements $MidConfigCopyWith<$Res> {
  _$MidConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appData = null,
    Object? mid = null,
  }) {
    return _then(_value.copyWith(
      appData: null == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as AppData,
      mid: null == mid
          ? _value.mid
          : mid // ignore: cast_nullable_to_non_nullable
              as MidData,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MidConfigImplCopyWith<$Res>
    implements $MidConfigCopyWith<$Res> {
  factory _$$MidConfigImplCopyWith(
          _$MidConfigImpl value, $Res Function(_$MidConfigImpl) then) =
      __$$MidConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppData appData, MidData mid});
}

/// @nodoc
class __$$MidConfigImplCopyWithImpl<$Res>
    extends _$MidConfigCopyWithImpl<$Res, _$MidConfigImpl>
    implements _$$MidConfigImplCopyWith<$Res> {
  __$$MidConfigImplCopyWithImpl(
      _$MidConfigImpl _value, $Res Function(_$MidConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appData = null,
    Object? mid = null,
  }) {
    return _then(_$MidConfigImpl(
      appData: null == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as AppData,
      mid: null == mid
          ? _value.mid
          : mid // ignore: cast_nullable_to_non_nullable
              as MidData,
    ));
  }
}

/// @nodoc

class _$MidConfigImpl implements _MidConfig {
  const _$MidConfigImpl({required this.appData, required this.mid});

  @override
  final AppData appData;
  @override
  final MidData mid;

  @override
  String toString() {
    return 'MidConfig(appData: $appData, mid: $mid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MidConfigImpl &&
            (identical(other.appData, appData) || other.appData == appData) &&
            (identical(other.mid, mid) || other.mid == mid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appData, mid);

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MidConfigImplCopyWith<_$MidConfigImpl> get copyWith =>
      __$$MidConfigImplCopyWithImpl<_$MidConfigImpl>(this, _$identity);
}

abstract class _MidConfig implements MidConfig {
  const factory _MidConfig(
      {required final AppData appData,
      required final MidData mid}) = _$MidConfigImpl;

  @override
  AppData get appData;
  @override
  MidData get mid;

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MidConfigImplCopyWith<_$MidConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

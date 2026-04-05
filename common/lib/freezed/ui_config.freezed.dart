// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ui_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MidConfig {
  AppData get appData => throw _privateConstructorUsedError;
  ModeData get modeData => throw _privateConstructorUsedError;
  List<DetailConfig> get details => throw _privateConstructorUsedError;

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
  $Res call({AppData appData, ModeData modeData, List<DetailConfig> details});

  $AppDataCopyWith<$Res> get appData;
  $ModeDataCopyWith<$Res> get modeData;
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
    Object? modeData = null,
    Object? details = null,
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
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<DetailConfig>,
    ) as $Val);
  }

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppDataCopyWith<$Res> get appData {
    return $AppDataCopyWith<$Res>(_value.appData, (value) {
      return _then(_value.copyWith(appData: value) as $Val);
    });
  }

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModeDataCopyWith<$Res> get modeData {
    return $ModeDataCopyWith<$Res>(_value.modeData, (value) {
      return _then(_value.copyWith(modeData: value) as $Val);
    });
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
  $Res call({AppData appData, ModeData modeData, List<DetailConfig> details});

  @override
  $AppDataCopyWith<$Res> get appData;
  @override
  $ModeDataCopyWith<$Res> get modeData;
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
    Object? modeData = null,
    Object? details = null,
  }) {
    return _then(_$MidConfigImpl(
      appData: null == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as AppData,
      modeData: null == modeData
          ? _value.modeData
          : modeData // ignore: cast_nullable_to_non_nullable
              as ModeData,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<DetailConfig>,
    ));
  }
}

/// @nodoc

class _$MidConfigImpl implements _MidConfig {
  const _$MidConfigImpl(
      {required this.appData,
      required this.modeData,
      required final List<DetailConfig> details})
      : _details = details;

  @override
  final AppData appData;
  @override
  final ModeData modeData;
  final List<DetailConfig> _details;
  @override
  List<DetailConfig> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  @override
  String toString() {
    return 'MidConfig(appData: $appData, modeData: $modeData, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MidConfigImpl &&
            (identical(other.appData, appData) || other.appData == appData) &&
            (identical(other.modeData, modeData) ||
                other.modeData == modeData) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appData, modeData,
      const DeepCollectionEquality().hash(_details));

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
      required final ModeData modeData,
      required final List<DetailConfig> details}) = _$MidConfigImpl;

  @override
  AppData get appData;
  @override
  ModeData get modeData;
  @override
  List<DetailConfig> get details;

  /// Create a copy of MidConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MidConfigImplCopyWith<_$MidConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DetailConfig {
  AppData get appData => throw _privateConstructorUsedError;
  ModeData get modeData => throw _privateConstructorUsedError;
  DetailData get detail => throw _privateConstructorUsedError;
  num get highScore => throw _privateConstructorUsedError;
  QuizButtonType get buttonType => throw _privateConstructorUsedError;
  int get qcount => throw _privateConstructorUsedError;

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
  $Res call(
      {AppData appData,
      ModeData modeData,
      DetailData detail,
      num highScore,
      QuizButtonType buttonType,
      int qcount});

  $AppDataCopyWith<$Res> get appData;
  $ModeDataCopyWith<$Res> get modeData;
  $DetailDataCopyWith<$Res> get detail;
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
    Object? highScore = null,
    Object? buttonType = null,
    Object? qcount = null,
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
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonType: null == buttonType
          ? _value.buttonType
          : buttonType // ignore: cast_nullable_to_non_nullable
              as QuizButtonType,
      qcount: null == qcount
          ? _value.qcount
          : qcount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppDataCopyWith<$Res> get appData {
    return $AppDataCopyWith<$Res>(_value.appData, (value) {
      return _then(_value.copyWith(appData: value) as $Val);
    });
  }

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModeDataCopyWith<$Res> get modeData {
    return $ModeDataCopyWith<$Res>(_value.modeData, (value) {
      return _then(_value.copyWith(modeData: value) as $Val);
    });
  }

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailDataCopyWith<$Res> get detail {
    return $DetailDataCopyWith<$Res>(_value.detail, (value) {
      return _then(_value.copyWith(detail: value) as $Val);
    });
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
  $Res call(
      {AppData appData,
      ModeData modeData,
      DetailData detail,
      num highScore,
      QuizButtonType buttonType,
      int qcount});

  @override
  $AppDataCopyWith<$Res> get appData;
  @override
  $ModeDataCopyWith<$Res> get modeData;
  @override
  $DetailDataCopyWith<$Res> get detail;
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
    Object? highScore = null,
    Object? buttonType = null,
    Object? qcount = null,
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
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonType: null == buttonType
          ? _value.buttonType
          : buttonType // ignore: cast_nullable_to_non_nullable
              as QuizButtonType,
      qcount: null == qcount
          ? _value.qcount
          : qcount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DetailConfigImpl extends _DetailConfig {
  const _$DetailConfigImpl(
      {required this.appData,
      required this.modeData,
      required this.detail,
      required this.highScore,
      required this.buttonType,
      required this.qcount})
      : super._();

  @override
  final AppData appData;
  @override
  final ModeData modeData;
  @override
  final DetailData detail;
  @override
  final num highScore;
  @override
  final QuizButtonType buttonType;
  @override
  final int qcount;

  @override
  String toString() {
    return 'DetailConfig(appData: $appData, modeData: $modeData, detail: $detail, highScore: $highScore, buttonType: $buttonType, qcount: $qcount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailConfigImpl &&
            (identical(other.appData, appData) || other.appData == appData) &&
            (identical(other.modeData, modeData) ||
                other.modeData == modeData) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.highScore, highScore) ||
                other.highScore == highScore) &&
            (identical(other.buttonType, buttonType) ||
                other.buttonType == buttonType) &&
            (identical(other.qcount, qcount) || other.qcount == qcount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, appData, modeData, detail, highScore, buttonType, qcount);

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailConfigImplCopyWith<_$DetailConfigImpl> get copyWith =>
      __$$DetailConfigImplCopyWithImpl<_$DetailConfigImpl>(this, _$identity);
}

abstract class _DetailConfig extends DetailConfig {
  const factory _DetailConfig(
      {required final AppData appData,
      required final ModeData modeData,
      required final DetailData detail,
      required final num highScore,
      required final QuizButtonType buttonType,
      required final int qcount}) = _$DetailConfigImpl;
  const _DetailConfig._() : super._();

  @override
  AppData get appData;
  @override
  ModeData get modeData;
  @override
  DetailData get detail;
  @override
  num get highScore;
  @override
  QuizButtonType get buttonType;
  @override
  int get qcount;

  /// Create a copy of DetailConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailConfigImplCopyWith<_$DetailConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

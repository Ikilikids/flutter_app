// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuizId {
  String get resisterOrigin => throw _privateConstructorUsedError;
  String get modeType => throw _privateConstructorUsedError;

  /// Create a copy of QuizId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizIdCopyWith<QuizId> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizIdCopyWith<$Res> {
  factory $QuizIdCopyWith(QuizId value, $Res Function(QuizId) then) =
      _$QuizIdCopyWithImpl<$Res, QuizId>;
  @useResult
  $Res call({String resisterOrigin, String modeType});
}

/// @nodoc
class _$QuizIdCopyWithImpl<$Res, $Val extends QuizId>
    implements $QuizIdCopyWith<$Res> {
  _$QuizIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resisterOrigin = null,
    Object? modeType = null,
  }) {
    return _then(_value.copyWith(
      resisterOrigin: null == resisterOrigin
          ? _value.resisterOrigin
          : resisterOrigin // ignore: cast_nullable_to_non_nullable
              as String,
      modeType: null == modeType
          ? _value.modeType
          : modeType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizIdImplCopyWith<$Res> implements $QuizIdCopyWith<$Res> {
  factory _$$QuizIdImplCopyWith(
          _$QuizIdImpl value, $Res Function(_$QuizIdImpl) then) =
      __$$QuizIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String resisterOrigin, String modeType});
}

/// @nodoc
class __$$QuizIdImplCopyWithImpl<$Res>
    extends _$QuizIdCopyWithImpl<$Res, _$QuizIdImpl>
    implements _$$QuizIdImplCopyWith<$Res> {
  __$$QuizIdImplCopyWithImpl(
      _$QuizIdImpl _value, $Res Function(_$QuizIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resisterOrigin = null,
    Object? modeType = null,
  }) {
    return _then(_$QuizIdImpl(
      resisterOrigin: null == resisterOrigin
          ? _value.resisterOrigin
          : resisterOrigin // ignore: cast_nullable_to_non_nullable
              as String,
      modeType: null == modeType
          ? _value.modeType
          : modeType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$QuizIdImpl extends _QuizId {
  const _$QuizIdImpl({required this.resisterOrigin, required this.modeType})
      : super._();

  @override
  final String resisterOrigin;
  @override
  final String modeType;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizIdImpl &&
            (identical(other.resisterOrigin, resisterOrigin) ||
                other.resisterOrigin == resisterOrigin) &&
            (identical(other.modeType, modeType) ||
                other.modeType == modeType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resisterOrigin, modeType);

  /// Create a copy of QuizId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizIdImplCopyWith<_$QuizIdImpl> get copyWith =>
      __$$QuizIdImplCopyWithImpl<_$QuizIdImpl>(this, _$identity);
}

abstract class _QuizId extends QuizId {
  const factory _QuizId(
      {required final String resisterOrigin,
      required final String modeType}) = _$QuizIdImpl;
  const _QuizId._() : super._();

  @override
  String get resisterOrigin;
  @override
  String get modeType;

  /// Create a copy of QuizId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizIdImplCopyWith<_$QuizIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QuizStatus {
  QuizId get id => throw _privateConstructorUsedError;
  num get highScore => throw _privateConstructorUsedError;
  QuizButtonType get buttonType => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  int get qCount => throw _privateConstructorUsedError;

  /// Create a copy of QuizStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStatusCopyWith<QuizStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStatusCopyWith<$Res> {
  factory $QuizStatusCopyWith(
          QuizStatus value, $Res Function(QuizStatus) then) =
      _$QuizStatusCopyWithImpl<$Res, QuizStatus>;
  @useResult
  $Res call(
      {QuizId id,
      num highScore,
      QuizButtonType buttonType,
      int playCount,
      int qCount});

  $QuizIdCopyWith<$Res> get id;
}

/// @nodoc
class _$QuizStatusCopyWithImpl<$Res, $Val extends QuizStatus>
    implements $QuizStatusCopyWith<$Res> {
  _$QuizStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? highScore = null,
    Object? buttonType = null,
    Object? playCount = null,
    Object? qCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as QuizId,
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonType: null == buttonType
          ? _value.buttonType
          : buttonType // ignore: cast_nullable_to_non_nullable
              as QuizButtonType,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
      qCount: null == qCount
          ? _value.qCount
          : qCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of QuizStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizIdCopyWith<$Res> get id {
    return $QuizIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuizStatusImplCopyWith<$Res>
    implements $QuizStatusCopyWith<$Res> {
  factory _$$QuizStatusImplCopyWith(
          _$QuizStatusImpl value, $Res Function(_$QuizStatusImpl) then) =
      __$$QuizStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {QuizId id,
      num highScore,
      QuizButtonType buttonType,
      int playCount,
      int qCount});

  @override
  $QuizIdCopyWith<$Res> get id;
}

/// @nodoc
class __$$QuizStatusImplCopyWithImpl<$Res>
    extends _$QuizStatusCopyWithImpl<$Res, _$QuizStatusImpl>
    implements _$$QuizStatusImplCopyWith<$Res> {
  __$$QuizStatusImplCopyWithImpl(
      _$QuizStatusImpl _value, $Res Function(_$QuizStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? highScore = null,
    Object? buttonType = null,
    Object? playCount = null,
    Object? qCount = null,
  }) {
    return _then(_$QuizStatusImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as QuizId,
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonType: null == buttonType
          ? _value.buttonType
          : buttonType // ignore: cast_nullable_to_non_nullable
              as QuizButtonType,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
      qCount: null == qCount
          ? _value.qCount
          : qCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$QuizStatusImpl implements _QuizStatus {
  const _$QuizStatusImpl(
      {required this.id,
      this.highScore = 0,
      this.buttonType = QuizButtonType.play,
      this.playCount = 0,
      this.qCount = 5});

  @override
  final QuizId id;
  @override
  @JsonKey()
  final num highScore;
  @override
  @JsonKey()
  final QuizButtonType buttonType;
  @override
  @JsonKey()
  final int playCount;
  @override
  @JsonKey()
  final int qCount;

  @override
  String toString() {
    return 'QuizStatus(id: $id, highScore: $highScore, buttonType: $buttonType, playCount: $playCount, qCount: $qCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.highScore, highScore) ||
                other.highScore == highScore) &&
            (identical(other.buttonType, buttonType) ||
                other.buttonType == buttonType) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.qCount, qCount) || other.qCount == qCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, highScore, buttonType, playCount, qCount);

  /// Create a copy of QuizStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStatusImplCopyWith<_$QuizStatusImpl> get copyWith =>
      __$$QuizStatusImplCopyWithImpl<_$QuizStatusImpl>(this, _$identity);
}

abstract class _QuizStatus implements QuizStatus {
  const factory _QuizStatus(
      {required final QuizId id,
      final num highScore,
      final QuizButtonType buttonType,
      final int playCount,
      final int qCount}) = _$QuizStatusImpl;

  @override
  QuizId get id;
  @override
  num get highScore;
  @override
  QuizButtonType get buttonType;
  @override
  int get playCount;
  @override
  int get qCount;

  /// Create a copy of QuizStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStatusImplCopyWith<_$QuizStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserStatus {
  Map<QuizId, QuizStatus> get quizzes => throw _privateConstructorUsedError;

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatusCopyWith<UserStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatusCopyWith<$Res> {
  factory $UserStatusCopyWith(
          UserStatus value, $Res Function(UserStatus) then) =
      _$UserStatusCopyWithImpl<$Res, UserStatus>;
  @useResult
  $Res call({Map<QuizId, QuizStatus> quizzes});
}

/// @nodoc
class _$UserStatusCopyWithImpl<$Res, $Val extends UserStatus>
    implements $UserStatusCopyWith<$Res> {
  _$UserStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizzes = null,
  }) {
    return _then(_value.copyWith(
      quizzes: null == quizzes
          ? _value.quizzes
          : quizzes // ignore: cast_nullable_to_non_nullable
              as Map<QuizId, QuizStatus>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatusImplCopyWith<$Res>
    implements $UserStatusCopyWith<$Res> {
  factory _$$UserStatusImplCopyWith(
          _$UserStatusImpl value, $Res Function(_$UserStatusImpl) then) =
      __$$UserStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<QuizId, QuizStatus> quizzes});
}

/// @nodoc
class __$$UserStatusImplCopyWithImpl<$Res>
    extends _$UserStatusCopyWithImpl<$Res, _$UserStatusImpl>
    implements _$$UserStatusImplCopyWith<$Res> {
  __$$UserStatusImplCopyWithImpl(
      _$UserStatusImpl _value, $Res Function(_$UserStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizzes = null,
  }) {
    return _then(_$UserStatusImpl(
      quizzes: null == quizzes
          ? _value._quizzes
          : quizzes // ignore: cast_nullable_to_non_nullable
              as Map<QuizId, QuizStatus>,
    ));
  }
}

/// @nodoc

class _$UserStatusImpl implements _UserStatus {
  const _$UserStatusImpl({required final Map<QuizId, QuizStatus> quizzes})
      : _quizzes = quizzes;

  final Map<QuizId, QuizStatus> _quizzes;
  @override
  Map<QuizId, QuizStatus> get quizzes {
    if (_quizzes is EqualUnmodifiableMapView) return _quizzes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_quizzes);
  }

  @override
  String toString() {
    return 'UserStatus(quizzes: $quizzes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatusImpl &&
            const DeepCollectionEquality().equals(other._quizzes, _quizzes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_quizzes));

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatusImplCopyWith<_$UserStatusImpl> get copyWith =>
      __$$UserStatusImplCopyWithImpl<_$UserStatusImpl>(this, _$identity);
}

abstract class _UserStatus implements UserStatus {
  const factory _UserStatus({required final Map<QuizId, QuizStatus> quizzes}) =
      _$UserStatusImpl;

  @override
  Map<QuizId, QuizStatus> get quizzes;

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatusImplCopyWith<_$UserStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

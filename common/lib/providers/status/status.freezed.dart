// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuizStatus {
  num get highScore => throw _privateConstructorUsedError;
  QuizButtonType get buttonType => throw _privateConstructorUsedError;
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
  $Res call({num highScore, QuizButtonType buttonType, int qCount});
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
    Object? highScore = null,
    Object? buttonType = null,
    Object? qCount = null,
  }) {
    return _then(_value.copyWith(
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonType: null == buttonType
          ? _value.buttonType
          : buttonType // ignore: cast_nullable_to_non_nullable
              as QuizButtonType,
      qCount: null == qCount
          ? _value.qCount
          : qCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
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
  $Res call({num highScore, QuizButtonType buttonType, int qCount});
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
    Object? highScore = null,
    Object? buttonType = null,
    Object? qCount = null,
  }) {
    return _then(_$QuizStatusImpl(
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonType: null == buttonType
          ? _value.buttonType
          : buttonType // ignore: cast_nullable_to_non_nullable
              as QuizButtonType,
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
      {this.highScore = 0,
      this.buttonType = QuizButtonType.play,
      this.qCount = 5});

  @override
  @JsonKey()
  final num highScore;
  @override
  @JsonKey()
  final QuizButtonType buttonType;
  @override
  @JsonKey()
  final int qCount;

  @override
  String toString() {
    return 'QuizStatus(highScore: $highScore, buttonType: $buttonType, qCount: $qCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStatusImpl &&
            (identical(other.highScore, highScore) ||
                other.highScore == highScore) &&
            (identical(other.buttonType, buttonType) ||
                other.buttonType == buttonType) &&
            (identical(other.qCount, qCount) || other.qCount == qCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, highScore, buttonType, qCount);

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
      {final num highScore,
      final QuizButtonType buttonType,
      final int qCount}) = _$QuizStatusImpl;

  @override
  num get highScore;
  @override
  QuizButtonType get buttonType;
  @override
  int get qCount;

  /// Create a copy of QuizStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStatusImplCopyWith<_$QuizStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

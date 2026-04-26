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

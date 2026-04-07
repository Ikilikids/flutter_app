// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PeriodData {
  String get label => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;

  /// Create a copy of PeriodData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PeriodDataCopyWith<PeriodData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodDataCopyWith<$Res> {
  factory $PeriodDataCopyWith(
          PeriodData value, $Res Function(PeriodData) then) =
      _$PeriodDataCopyWithImpl<$Res, PeriodData>;
  @useResult
  $Res call({String label, Color color, String value, String unit});
}

/// @nodoc
class _$PeriodDataCopyWithImpl<$Res, $Val extends PeriodData>
    implements $PeriodDataCopyWith<$Res> {
  _$PeriodDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PeriodData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? color = null,
    Object? value = null,
    Object? unit = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PeriodDataImplCopyWith<$Res>
    implements $PeriodDataCopyWith<$Res> {
  factory _$$PeriodDataImplCopyWith(
          _$PeriodDataImpl value, $Res Function(_$PeriodDataImpl) then) =
      __$$PeriodDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, Color color, String value, String unit});
}

/// @nodoc
class __$$PeriodDataImplCopyWithImpl<$Res>
    extends _$PeriodDataCopyWithImpl<$Res, _$PeriodDataImpl>
    implements _$$PeriodDataImplCopyWith<$Res> {
  __$$PeriodDataImplCopyWithImpl(
      _$PeriodDataImpl _value, $Res Function(_$PeriodDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PeriodData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? color = null,
    Object? value = null,
    Object? unit = null,
  }) {
    return _then(_$PeriodDataImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PeriodDataImpl implements _PeriodData {
  const _$PeriodDataImpl(
      {required this.label,
      required this.color,
      this.value = '',
      this.unit = ''});

  @override
  final String label;
  @override
  final Color color;
  @override
  @JsonKey()
  final String value;
  @override
  @JsonKey()
  final String unit;

  @override
  String toString() {
    return 'PeriodData(label: $label, color: $color, value: $value, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeriodDataImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, color, value, unit);

  /// Create a copy of PeriodData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PeriodDataImplCopyWith<_$PeriodDataImpl> get copyWith =>
      __$$PeriodDataImplCopyWithImpl<_$PeriodDataImpl>(this, _$identity);
}

abstract class _PeriodData implements PeriodData {
  const factory _PeriodData(
      {required final String label,
      required final Color color,
      final String value,
      final String unit}) = _$PeriodDataImpl;

  @override
  String get label;
  @override
  Color get color;
  @override
  String get value;
  @override
  String get unit;

  /// Create a copy of PeriodData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PeriodDataImplCopyWith<_$PeriodDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

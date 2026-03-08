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
mixin _$QuizStatus {
  String get id =>
      throw _privateConstructorUsedError; // "${detail.resisterOrigin}_${modeType}"
  num get highScore => throw _privateConstructorUsedError;
  String get buttonText => throw _privateConstructorUsedError;
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
      {String id, num highScore, String buttonText, int playCount, int qCount});
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
    Object? buttonText = null,
    Object? playCount = null,
    Object? qCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonText: null == buttonText
          ? _value.buttonText
          : buttonText // ignore: cast_nullable_to_non_nullable
              as String,
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
      {String id, num highScore, String buttonText, int playCount, int qCount});
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
    Object? buttonText = null,
    Object? playCount = null,
    Object? qCount = null,
  }) {
    return _then(_$QuizStatusImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      highScore: null == highScore
          ? _value.highScore
          : highScore // ignore: cast_nullable_to_non_nullable
              as num,
      buttonText: null == buttonText
          ? _value.buttonText
          : buttonText // ignore: cast_nullable_to_non_nullable
              as String,
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
      this.buttonText = 'playButton',
      this.playCount = 0,
      this.qCount = 5});

  @override
  final String id;
// "${detail.resisterOrigin}_${modeType}"
  @override
  @JsonKey()
  final num highScore;
  @override
  @JsonKey()
  final String buttonText;
  @override
  @JsonKey()
  final int playCount;
  @override
  @JsonKey()
  final int qCount;

  @override
  String toString() {
    return 'QuizStatus(id: $id, highScore: $highScore, buttonText: $buttonText, playCount: $playCount, qCount: $qCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.highScore, highScore) ||
                other.highScore == highScore) &&
            (identical(other.buttonText, buttonText) ||
                other.buttonText == buttonText) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.qCount, qCount) || other.qCount == qCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, highScore, buttonText, playCount, qCount);

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
      {required final String id,
      final num highScore,
      final String buttonText,
      final int playCount,
      final int qCount}) = _$QuizStatusImpl;

  @override
  String get id; // "${detail.resisterOrigin}_${modeType}"
  @override
  num get highScore;
  @override
  String get buttonText;
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
mixin _$ModeStatus {
  String get modeType => throw _privateConstructorUsedError;

  /// Create a copy of ModeStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModeStatusCopyWith<ModeStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModeStatusCopyWith<$Res> {
  factory $ModeStatusCopyWith(
          ModeStatus value, $Res Function(ModeStatus) then) =
      _$ModeStatusCopyWithImpl<$Res, ModeStatus>;
  @useResult
  $Res call({String modeType});
}

/// @nodoc
class _$ModeStatusCopyWithImpl<$Res, $Val extends ModeStatus>
    implements $ModeStatusCopyWith<$Res> {
  _$ModeStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModeStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modeType = null,
  }) {
    return _then(_value.copyWith(
      modeType: null == modeType
          ? _value.modeType
          : modeType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModeStatusImplCopyWith<$Res>
    implements $ModeStatusCopyWith<$Res> {
  factory _$$ModeStatusImplCopyWith(
          _$ModeStatusImpl value, $Res Function(_$ModeStatusImpl) then) =
      __$$ModeStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String modeType});
}

/// @nodoc
class __$$ModeStatusImplCopyWithImpl<$Res>
    extends _$ModeStatusCopyWithImpl<$Res, _$ModeStatusImpl>
    implements _$$ModeStatusImplCopyWith<$Res> {
  __$$ModeStatusImplCopyWithImpl(
      _$ModeStatusImpl _value, $Res Function(_$ModeStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModeStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modeType = null,
  }) {
    return _then(_$ModeStatusImpl(
      modeType: null == modeType
          ? _value.modeType
          : modeType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ModeStatusImpl implements _ModeStatus {
  const _$ModeStatusImpl({required this.modeType});

  @override
  final String modeType;

  @override
  String toString() {
    return 'ModeStatus(modeType: $modeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModeStatusImpl &&
            (identical(other.modeType, modeType) ||
                other.modeType == modeType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, modeType);

  /// Create a copy of ModeStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModeStatusImplCopyWith<_$ModeStatusImpl> get copyWith =>
      __$$ModeStatusImplCopyWithImpl<_$ModeStatusImpl>(this, _$identity);
}

abstract class _ModeStatus implements ModeStatus {
  const factory _ModeStatus({required final String modeType}) =
      _$ModeStatusImpl;

  @override
  String get modeType;

  /// Create a copy of ModeStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModeStatusImplCopyWith<_$ModeStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserStatus {
  List<QuizStatus> get quizzes => throw _privateConstructorUsedError;
  List<ModeStatus> get modes => throw _privateConstructorUsedError;
  String get selectedModeId => throw _privateConstructorUsedError;
  String get selectedDetailId => throw _privateConstructorUsedError;

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
  $Res call(
      {List<QuizStatus> quizzes,
      List<ModeStatus> modes,
      String selectedModeId,
      String selectedDetailId});
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
    Object? modes = null,
    Object? selectedModeId = null,
    Object? selectedDetailId = null,
  }) {
    return _then(_value.copyWith(
      quizzes: null == quizzes
          ? _value.quizzes
          : quizzes // ignore: cast_nullable_to_non_nullable
              as List<QuizStatus>,
      modes: null == modes
          ? _value.modes
          : modes // ignore: cast_nullable_to_non_nullable
              as List<ModeStatus>,
      selectedModeId: null == selectedModeId
          ? _value.selectedModeId
          : selectedModeId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDetailId: null == selectedDetailId
          ? _value.selectedDetailId
          : selectedDetailId // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call(
      {List<QuizStatus> quizzes,
      List<ModeStatus> modes,
      String selectedModeId,
      String selectedDetailId});
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
    Object? modes = null,
    Object? selectedModeId = null,
    Object? selectedDetailId = null,
  }) {
    return _then(_$UserStatusImpl(
      quizzes: null == quizzes
          ? _value._quizzes
          : quizzes // ignore: cast_nullable_to_non_nullable
              as List<QuizStatus>,
      modes: null == modes
          ? _value._modes
          : modes // ignore: cast_nullable_to_non_nullable
              as List<ModeStatus>,
      selectedModeId: null == selectedModeId
          ? _value.selectedModeId
          : selectedModeId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDetailId: null == selectedDetailId
          ? _value.selectedDetailId
          : selectedDetailId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UserStatusImpl implements _UserStatus {
  const _$UserStatusImpl(
      {required final List<QuizStatus> quizzes,
      required final List<ModeStatus> modes,
      this.selectedModeId = '',
      this.selectedDetailId = ''})
      : _quizzes = quizzes,
        _modes = modes;

  final List<QuizStatus> _quizzes;
  @override
  List<QuizStatus> get quizzes {
    if (_quizzes is EqualUnmodifiableListView) return _quizzes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_quizzes);
  }

  final List<ModeStatus> _modes;
  @override
  List<ModeStatus> get modes {
    if (_modes is EqualUnmodifiableListView) return _modes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modes);
  }

  @override
  @JsonKey()
  final String selectedModeId;
  @override
  @JsonKey()
  final String selectedDetailId;

  @override
  String toString() {
    return 'UserStatus(quizzes: $quizzes, modes: $modes, selectedModeId: $selectedModeId, selectedDetailId: $selectedDetailId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatusImpl &&
            const DeepCollectionEquality().equals(other._quizzes, _quizzes) &&
            const DeepCollectionEquality().equals(other._modes, _modes) &&
            (identical(other.selectedModeId, selectedModeId) ||
                other.selectedModeId == selectedModeId) &&
            (identical(other.selectedDetailId, selectedDetailId) ||
                other.selectedDetailId == selectedDetailId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_quizzes),
      const DeepCollectionEquality().hash(_modes),
      selectedModeId,
      selectedDetailId);

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatusImplCopyWith<_$UserStatusImpl> get copyWith =>
      __$$UserStatusImplCopyWithImpl<_$UserStatusImpl>(this, _$identity);
}

abstract class _UserStatus implements UserStatus {
  const factory _UserStatus(
      {required final List<QuizStatus> quizzes,
      required final List<ModeStatus> modes,
      final String selectedModeId,
      final String selectedDetailId}) = _$UserStatusImpl;

  @override
  List<QuizStatus> get quizzes;
  @override
  List<ModeStatus> get modes;
  @override
  String get selectedModeId;
  @override
  String get selectedDetailId;

  /// Create a copy of UserStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatusImplCopyWith<_$UserStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuizSessionState {
  MakingData? get currentQuestion => throw _privateConstructorUsedError;
  DetailConfig? get config => throw _privateConstructorUsedError;
  List<MakingData> get historyQuestions => throw _privateConstructorUsedError;
  Map<String, int> get categortScore =>
      throw _privateConstructorUsedError; // タイポも今のうちに修正！
  int get totalScore => throw _privateConstructorUsedError;
  bool get isGameOver => throw _privateConstructorUsedError;
  QuizSessionStatus get status => throw _privateConstructorUsedError;
  QuizResult get resultMark => throw _privateConstructorUsedError;
  bool get isAnswerChecked => throw _privateConstructorUsedError;
  List<QuizResult> get historyMarks => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  String get scoreFeedback1 => throw _privateConstructorUsedError;
  String get scoreFeedback2 => throw _privateConstructorUsedError;

  /// Create a copy of QuizSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizSessionStateCopyWith<QuizSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizSessionStateCopyWith<$Res> {
  factory $QuizSessionStateCopyWith(
          QuizSessionState value, $Res Function(QuizSessionState) then) =
      _$QuizSessionStateCopyWithImpl<$Res, QuizSessionState>;
  @useResult
  $Res call(
      {MakingData? currentQuestion,
      DetailConfig? config,
      List<MakingData> historyQuestions,
      Map<String, int> categortScore,
      int totalScore,
      bool isGameOver,
      QuizSessionStatus status,
      QuizResult resultMark,
      bool isAnswerChecked,
      List<QuizResult> historyMarks,
      DateTime? startTime,
      int currentIndex,
      String scoreFeedback1,
      String scoreFeedback2});

  $DetailConfigCopyWith<$Res>? get config;
}

/// @nodoc
class _$QuizSessionStateCopyWithImpl<$Res, $Val extends QuizSessionState>
    implements $QuizSessionStateCopyWith<$Res> {
  _$QuizSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentQuestion = freezed,
    Object? config = freezed,
    Object? historyQuestions = null,
    Object? categortScore = null,
    Object? totalScore = null,
    Object? isGameOver = null,
    Object? status = null,
    Object? resultMark = null,
    Object? isAnswerChecked = null,
    Object? historyMarks = null,
    Object? startTime = freezed,
    Object? currentIndex = null,
    Object? scoreFeedback1 = null,
    Object? scoreFeedback2 = null,
  }) {
    return _then(_value.copyWith(
      currentQuestion: freezed == currentQuestion
          ? _value.currentQuestion
          : currentQuestion // ignore: cast_nullable_to_non_nullable
              as MakingData?,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as DetailConfig?,
      historyQuestions: null == historyQuestions
          ? _value.historyQuestions
          : historyQuestions // ignore: cast_nullable_to_non_nullable
              as List<MakingData>,
      categortScore: null == categortScore
          ? _value.categortScore
          : categortScore // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuizSessionStatus,
      resultMark: null == resultMark
          ? _value.resultMark
          : resultMark // ignore: cast_nullable_to_non_nullable
              as QuizResult,
      isAnswerChecked: null == isAnswerChecked
          ? _value.isAnswerChecked
          : isAnswerChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      historyMarks: null == historyMarks
          ? _value.historyMarks
          : historyMarks // ignore: cast_nullable_to_non_nullable
              as List<QuizResult>,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      scoreFeedback1: null == scoreFeedback1
          ? _value.scoreFeedback1
          : scoreFeedback1 // ignore: cast_nullable_to_non_nullable
              as String,
      scoreFeedback2: null == scoreFeedback2
          ? _value.scoreFeedback2
          : scoreFeedback2 // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of QuizSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailConfigCopyWith<$Res>? get config {
    if (_value.config == null) {
      return null;
    }

    return $DetailConfigCopyWith<$Res>(_value.config!, (value) {
      return _then(_value.copyWith(config: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuizSessionStateImplCopyWith<$Res>
    implements $QuizSessionStateCopyWith<$Res> {
  factory _$$QuizSessionStateImplCopyWith(_$QuizSessionStateImpl value,
          $Res Function(_$QuizSessionStateImpl) then) =
      __$$QuizSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MakingData? currentQuestion,
      DetailConfig? config,
      List<MakingData> historyQuestions,
      Map<String, int> categortScore,
      int totalScore,
      bool isGameOver,
      QuizSessionStatus status,
      QuizResult resultMark,
      bool isAnswerChecked,
      List<QuizResult> historyMarks,
      DateTime? startTime,
      int currentIndex,
      String scoreFeedback1,
      String scoreFeedback2});

  @override
  $DetailConfigCopyWith<$Res>? get config;
}

/// @nodoc
class __$$QuizSessionStateImplCopyWithImpl<$Res>
    extends _$QuizSessionStateCopyWithImpl<$Res, _$QuizSessionStateImpl>
    implements _$$QuizSessionStateImplCopyWith<$Res> {
  __$$QuizSessionStateImplCopyWithImpl(_$QuizSessionStateImpl _value,
      $Res Function(_$QuizSessionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentQuestion = freezed,
    Object? config = freezed,
    Object? historyQuestions = null,
    Object? categortScore = null,
    Object? totalScore = null,
    Object? isGameOver = null,
    Object? status = null,
    Object? resultMark = null,
    Object? isAnswerChecked = null,
    Object? historyMarks = null,
    Object? startTime = freezed,
    Object? currentIndex = null,
    Object? scoreFeedback1 = null,
    Object? scoreFeedback2 = null,
  }) {
    return _then(_$QuizSessionStateImpl(
      currentQuestion: freezed == currentQuestion
          ? _value.currentQuestion
          : currentQuestion // ignore: cast_nullable_to_non_nullable
              as MakingData?,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as DetailConfig?,
      historyQuestions: null == historyQuestions
          ? _value._historyQuestions
          : historyQuestions // ignore: cast_nullable_to_non_nullable
              as List<MakingData>,
      categortScore: null == categortScore
          ? _value._categortScore
          : categortScore // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuizSessionStatus,
      resultMark: null == resultMark
          ? _value.resultMark
          : resultMark // ignore: cast_nullable_to_non_nullable
              as QuizResult,
      isAnswerChecked: null == isAnswerChecked
          ? _value.isAnswerChecked
          : isAnswerChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      historyMarks: null == historyMarks
          ? _value._historyMarks
          : historyMarks // ignore: cast_nullable_to_non_nullable
              as List<QuizResult>,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      scoreFeedback1: null == scoreFeedback1
          ? _value.scoreFeedback1
          : scoreFeedback1 // ignore: cast_nullable_to_non_nullable
              as String,
      scoreFeedback2: null == scoreFeedback2
          ? _value.scoreFeedback2
          : scoreFeedback2 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$QuizSessionStateImpl extends _QuizSessionState {
  const _$QuizSessionStateImpl(
      {this.currentQuestion,
      this.config,
      final List<MakingData> historyQuestions = const [],
      final Map<String, int> categortScore = const {},
      this.totalScore = 0,
      this.isGameOver = false,
      this.status = QuizSessionStatus.playing,
      this.resultMark = QuizResult.unknown,
      this.isAnswerChecked = false,
      final List<QuizResult> historyMarks = const [],
      this.startTime,
      this.currentIndex = 0,
      this.scoreFeedback1 = '',
      this.scoreFeedback2 = ''})
      : _historyQuestions = historyQuestions,
        _categortScore = categortScore,
        _historyMarks = historyMarks,
        super._();

  @override
  final MakingData? currentQuestion;
  @override
  final DetailConfig? config;
  final List<MakingData> _historyQuestions;
  @override
  @JsonKey()
  List<MakingData> get historyQuestions {
    if (_historyQuestions is EqualUnmodifiableListView)
      return _historyQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historyQuestions);
  }

  final Map<String, int> _categortScore;
  @override
  @JsonKey()
  Map<String, int> get categortScore {
    if (_categortScore is EqualUnmodifiableMapView) return _categortScore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categortScore);
  }

// タイポも今のうちに修正！
  @override
  @JsonKey()
  final int totalScore;
  @override
  @JsonKey()
  final bool isGameOver;
  @override
  @JsonKey()
  final QuizSessionStatus status;
  @override
  @JsonKey()
  final QuizResult resultMark;
  @override
  @JsonKey()
  final bool isAnswerChecked;
  final List<QuizResult> _historyMarks;
  @override
  @JsonKey()
  List<QuizResult> get historyMarks {
    if (_historyMarks is EqualUnmodifiableListView) return _historyMarks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historyMarks);
  }

  @override
  final DateTime? startTime;
  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final String scoreFeedback1;
  @override
  @JsonKey()
  final String scoreFeedback2;

  @override
  String toString() {
    return 'QuizSessionState(currentQuestion: $currentQuestion, config: $config, historyQuestions: $historyQuestions, categortScore: $categortScore, totalScore: $totalScore, isGameOver: $isGameOver, status: $status, resultMark: $resultMark, isAnswerChecked: $isAnswerChecked, historyMarks: $historyMarks, startTime: $startTime, currentIndex: $currentIndex, scoreFeedback1: $scoreFeedback1, scoreFeedback2: $scoreFeedback2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizSessionStateImpl &&
            (identical(other.currentQuestion, currentQuestion) ||
                other.currentQuestion == currentQuestion) &&
            (identical(other.config, config) || other.config == config) &&
            const DeepCollectionEquality()
                .equals(other._historyQuestions, _historyQuestions) &&
            const DeepCollectionEquality()
                .equals(other._categortScore, _categortScore) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.resultMark, resultMark) ||
                other.resultMark == resultMark) &&
            (identical(other.isAnswerChecked, isAnswerChecked) ||
                other.isAnswerChecked == isAnswerChecked) &&
            const DeepCollectionEquality()
                .equals(other._historyMarks, _historyMarks) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.scoreFeedback1, scoreFeedback1) ||
                other.scoreFeedback1 == scoreFeedback1) &&
            (identical(other.scoreFeedback2, scoreFeedback2) ||
                other.scoreFeedback2 == scoreFeedback2));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentQuestion,
      config,
      const DeepCollectionEquality().hash(_historyQuestions),
      const DeepCollectionEquality().hash(_categortScore),
      totalScore,
      isGameOver,
      status,
      resultMark,
      isAnswerChecked,
      const DeepCollectionEquality().hash(_historyMarks),
      startTime,
      currentIndex,
      scoreFeedback1,
      scoreFeedback2);

  /// Create a copy of QuizSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizSessionStateImplCopyWith<_$QuizSessionStateImpl> get copyWith =>
      __$$QuizSessionStateImplCopyWithImpl<_$QuizSessionStateImpl>(
          this, _$identity);
}

abstract class _QuizSessionState extends QuizSessionState {
  const factory _QuizSessionState(
      {final MakingData? currentQuestion,
      final DetailConfig? config,
      final List<MakingData> historyQuestions,
      final Map<String, int> categortScore,
      final int totalScore,
      final bool isGameOver,
      final QuizSessionStatus status,
      final QuizResult resultMark,
      final bool isAnswerChecked,
      final List<QuizResult> historyMarks,
      final DateTime? startTime,
      final int currentIndex,
      final String scoreFeedback1,
      final String scoreFeedback2}) = _$QuizSessionStateImpl;
  const _QuizSessionState._() : super._();

  @override
  MakingData? get currentQuestion;
  @override
  DetailConfig? get config;
  @override
  List<MakingData> get historyQuestions;
  @override
  Map<String, int> get categortScore; // タイポも今のうちに修正！
  @override
  int get totalScore;
  @override
  bool get isGameOver;
  @override
  QuizSessionStatus get status;
  @override
  QuizResult get resultMark;
  @override
  bool get isAnswerChecked;
  @override
  List<QuizResult> get historyMarks;
  @override
  DateTime? get startTime;
  @override
  int get currentIndex;
  @override
  String get scoreFeedback1;
  @override
  String get scoreFeedback2;

  /// Create a copy of QuizSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizSessionStateImplCopyWith<_$QuizSessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

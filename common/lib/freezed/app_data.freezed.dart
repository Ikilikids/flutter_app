// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PageConfig {
  String get title => throw _privateConstructorUsedError;
  IconData get icon => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;
  String? get modeDescription => throw _privateConstructorUsedError;
  AdditionalPageBuilder get builder => throw _privateConstructorUsedError;

  /// Create a copy of PageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageConfigCopyWith<PageConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageConfigCopyWith<$Res> {
  factory $PageConfigCopyWith(
          PageConfig value, $Res Function(PageConfig) then) =
      _$PageConfigCopyWithImpl<$Res, PageConfig>;
  @useResult
  $Res call(
      {String title,
      IconData icon,
      Color color,
      String? modeDescription,
      AdditionalPageBuilder builder});
}

/// @nodoc
class _$PageConfigCopyWithImpl<$Res, $Val extends PageConfig>
    implements $PageConfigCopyWith<$Res> {
  _$PageConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? icon = null,
    Object? color = null,
    Object? modeDescription = freezed,
    Object? builder = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      modeDescription: freezed == modeDescription
          ? _value.modeDescription
          : modeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as AdditionalPageBuilder,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageConfigImplCopyWith<$Res>
    implements $PageConfigCopyWith<$Res> {
  factory _$$PageConfigImplCopyWith(
          _$PageConfigImpl value, $Res Function(_$PageConfigImpl) then) =
      __$$PageConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      IconData icon,
      Color color,
      String? modeDescription,
      AdditionalPageBuilder builder});
}

/// @nodoc
class __$$PageConfigImplCopyWithImpl<$Res>
    extends _$PageConfigCopyWithImpl<$Res, _$PageConfigImpl>
    implements _$$PageConfigImplCopyWith<$Res> {
  __$$PageConfigImplCopyWithImpl(
      _$PageConfigImpl _value, $Res Function(_$PageConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? icon = null,
    Object? color = null,
    Object? modeDescription = freezed,
    Object? builder = null,
  }) {
    return _then(_$PageConfigImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      modeDescription: freezed == modeDescription
          ? _value.modeDescription
          : modeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as AdditionalPageBuilder,
    ));
  }
}

/// @nodoc

class _$PageConfigImpl implements _PageConfig {
  const _$PageConfigImpl(
      {required this.title,
      required this.icon,
      required this.color,
      this.modeDescription,
      required this.builder});

  @override
  final String title;
  @override
  final IconData icon;
  @override
  final Color color;
  @override
  final String? modeDescription;
  @override
  final AdditionalPageBuilder builder;

  @override
  String toString() {
    return 'PageConfig(title: $title, icon: $icon, color: $color, modeDescription: $modeDescription, builder: $builder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageConfigImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.modeDescription, modeDescription) ||
                other.modeDescription == modeDescription) &&
            (identical(other.builder, builder) || other.builder == builder));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, title, icon, color, modeDescription, builder);

  /// Create a copy of PageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageConfigImplCopyWith<_$PageConfigImpl> get copyWith =>
      __$$PageConfigImplCopyWithImpl<_$PageConfigImpl>(this, _$identity);
}

abstract class _PageConfig implements PageConfig {
  const factory _PageConfig(
      {required final String title,
      required final IconData icon,
      required final Color color,
      final String? modeDescription,
      required final AdditionalPageBuilder builder}) = _$PageConfigImpl;

  @override
  String get title;
  @override
  IconData get icon;
  @override
  Color get color;
  @override
  String? get modeDescription;
  @override
  AdditionalPageBuilder get builder;

  /// Create a copy of PageConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageConfigImplCopyWith<_$PageConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AllData {
  AppData get appData => throw _privateConstructorUsedError;
  List<MidData> get mid => throw _privateConstructorUsedError;

  /// Create a copy of AllData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AllDataCopyWith<AllData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllDataCopyWith<$Res> {
  factory $AllDataCopyWith(AllData value, $Res Function(AllData) then) =
      _$AllDataCopyWithImpl<$Res, AllData>;
  @useResult
  $Res call({AppData appData, List<MidData> mid});

  $AppDataCopyWith<$Res> get appData;
}

/// @nodoc
class _$AllDataCopyWithImpl<$Res, $Val extends AllData>
    implements $AllDataCopyWith<$Res> {
  _$AllDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AllData
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
              as List<MidData>,
    ) as $Val);
  }

  /// Create a copy of AllData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppDataCopyWith<$Res> get appData {
    return $AppDataCopyWith<$Res>(_value.appData, (value) {
      return _then(_value.copyWith(appData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AllDataImplCopyWith<$Res> implements $AllDataCopyWith<$Res> {
  factory _$$AllDataImplCopyWith(
          _$AllDataImpl value, $Res Function(_$AllDataImpl) then) =
      __$$AllDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppData appData, List<MidData> mid});

  @override
  $AppDataCopyWith<$Res> get appData;
}

/// @nodoc
class __$$AllDataImplCopyWithImpl<$Res>
    extends _$AllDataCopyWithImpl<$Res, _$AllDataImpl>
    implements _$$AllDataImplCopyWith<$Res> {
  __$$AllDataImplCopyWithImpl(
      _$AllDataImpl _value, $Res Function(_$AllDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AllData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appData = null,
    Object? mid = null,
  }) {
    return _then(_$AllDataImpl(
      appData: null == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as AppData,
      mid: null == mid
          ? _value._mid
          : mid // ignore: cast_nullable_to_non_nullable
              as List<MidData>,
    ));
  }
}

/// @nodoc

class _$AllDataImpl extends _AllData {
  const _$AllDataImpl({required this.appData, required final List<MidData> mid})
      : _mid = mid,
        super._();

  @override
  final AppData appData;
  final List<MidData> _mid;
  @override
  List<MidData> get mid {
    if (_mid is EqualUnmodifiableListView) return _mid;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mid);
  }

  @override
  String toString() {
    return 'AllData(appData: $appData, mid: $mid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllDataImpl &&
            (identical(other.appData, appData) || other.appData == appData) &&
            const DeepCollectionEquality().equals(other._mid, _mid));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, appData, const DeepCollectionEquality().hash(_mid));

  /// Create a copy of AllData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AllDataImplCopyWith<_$AllDataImpl> get copyWith =>
      __$$AllDataImplCopyWithImpl<_$AllDataImpl>(this, _$identity);
}

abstract class _AllData extends AllData {
  const factory _AllData(
      {required final AppData appData,
      required final List<MidData> mid}) = _$AllDataImpl;
  const _AllData._() : super._();

  @override
  AppData get appData;
  @override
  List<MidData> get mid;

  /// Create a copy of AllData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AllDataImplCopyWith<_$AllDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppData {
  String get appTitle => throw _privateConstructorUsedError;
  IconData get appIcon => throw _privateConstructorUsedError;
  List<String> get symbols => throw _privateConstructorUsedError;
  bool get isRotation => throw _privateConstructorUsedError;
  String get URL => throw _privateConstructorUsedError;
  GamePageBuilder get mainGame => throw _privateConstructorUsedError;
  LoadBuilder? get loadGame => throw _privateConstructorUsedError;
  SettingWidgetsBuilder? get settingWidgets =>
      throw _privateConstructorUsedError;
  PageConfig? get additionalPage1 => throw _privateConstructorUsedError;
  PageConfig? get additionalPage2 => throw _privateConstructorUsedError;
  String? get bannerId => throw _privateConstructorUsedError;
  String? get interId => throw _privateConstructorUsedError;
  String? get rewardId => throw _privateConstructorUsedError;

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppDataCopyWith<AppData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDataCopyWith<$Res> {
  factory $AppDataCopyWith(AppData value, $Res Function(AppData) then) =
      _$AppDataCopyWithImpl<$Res, AppData>;
  @useResult
  $Res call(
      {String appTitle,
      IconData appIcon,
      List<String> symbols,
      bool isRotation,
      String URL,
      GamePageBuilder mainGame,
      LoadBuilder? loadGame,
      SettingWidgetsBuilder? settingWidgets,
      PageConfig? additionalPage1,
      PageConfig? additionalPage2,
      String? bannerId,
      String? interId,
      String? rewardId});

  $PageConfigCopyWith<$Res>? get additionalPage1;
  $PageConfigCopyWith<$Res>? get additionalPage2;
}

/// @nodoc
class _$AppDataCopyWithImpl<$Res, $Val extends AppData>
    implements $AppDataCopyWith<$Res> {
  _$AppDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appTitle = null,
    Object? appIcon = null,
    Object? symbols = null,
    Object? isRotation = null,
    Object? URL = null,
    Object? mainGame = null,
    Object? loadGame = freezed,
    Object? settingWidgets = freezed,
    Object? additionalPage1 = freezed,
    Object? additionalPage2 = freezed,
    Object? bannerId = freezed,
    Object? interId = freezed,
    Object? rewardId = freezed,
  }) {
    return _then(_value.copyWith(
      appTitle: null == appTitle
          ? _value.appTitle
          : appTitle // ignore: cast_nullable_to_non_nullable
              as String,
      appIcon: null == appIcon
          ? _value.appIcon
          : appIcon // ignore: cast_nullable_to_non_nullable
              as IconData,
      symbols: null == symbols
          ? _value.symbols
          : symbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRotation: null == isRotation
          ? _value.isRotation
          : isRotation // ignore: cast_nullable_to_non_nullable
              as bool,
      URL: null == URL
          ? _value.URL
          : URL // ignore: cast_nullable_to_non_nullable
              as String,
      mainGame: null == mainGame
          ? _value.mainGame
          : mainGame // ignore: cast_nullable_to_non_nullable
              as GamePageBuilder,
      loadGame: freezed == loadGame
          ? _value.loadGame
          : loadGame // ignore: cast_nullable_to_non_nullable
              as LoadBuilder?,
      settingWidgets: freezed == settingWidgets
          ? _value.settingWidgets
          : settingWidgets // ignore: cast_nullable_to_non_nullable
              as SettingWidgetsBuilder?,
      additionalPage1: freezed == additionalPage1
          ? _value.additionalPage1
          : additionalPage1 // ignore: cast_nullable_to_non_nullable
              as PageConfig?,
      additionalPage2: freezed == additionalPage2
          ? _value.additionalPage2
          : additionalPage2 // ignore: cast_nullable_to_non_nullable
              as PageConfig?,
      bannerId: freezed == bannerId
          ? _value.bannerId
          : bannerId // ignore: cast_nullable_to_non_nullable
              as String?,
      interId: freezed == interId
          ? _value.interId
          : interId // ignore: cast_nullable_to_non_nullable
              as String?,
      rewardId: freezed == rewardId
          ? _value.rewardId
          : rewardId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageConfigCopyWith<$Res>? get additionalPage1 {
    if (_value.additionalPage1 == null) {
      return null;
    }

    return $PageConfigCopyWith<$Res>(_value.additionalPage1!, (value) {
      return _then(_value.copyWith(additionalPage1: value) as $Val);
    });
  }

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageConfigCopyWith<$Res>? get additionalPage2 {
    if (_value.additionalPage2 == null) {
      return null;
    }

    return $PageConfigCopyWith<$Res>(_value.additionalPage2!, (value) {
      return _then(_value.copyWith(additionalPage2: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppDataImplCopyWith<$Res> implements $AppDataCopyWith<$Res> {
  factory _$$AppDataImplCopyWith(
          _$AppDataImpl value, $Res Function(_$AppDataImpl) then) =
      __$$AppDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String appTitle,
      IconData appIcon,
      List<String> symbols,
      bool isRotation,
      String URL,
      GamePageBuilder mainGame,
      LoadBuilder? loadGame,
      SettingWidgetsBuilder? settingWidgets,
      PageConfig? additionalPage1,
      PageConfig? additionalPage2,
      String? bannerId,
      String? interId,
      String? rewardId});

  @override
  $PageConfigCopyWith<$Res>? get additionalPage1;
  @override
  $PageConfigCopyWith<$Res>? get additionalPage2;
}

/// @nodoc
class __$$AppDataImplCopyWithImpl<$Res>
    extends _$AppDataCopyWithImpl<$Res, _$AppDataImpl>
    implements _$$AppDataImplCopyWith<$Res> {
  __$$AppDataImplCopyWithImpl(
      _$AppDataImpl _value, $Res Function(_$AppDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appTitle = null,
    Object? appIcon = null,
    Object? symbols = null,
    Object? isRotation = null,
    Object? URL = null,
    Object? mainGame = null,
    Object? loadGame = freezed,
    Object? settingWidgets = freezed,
    Object? additionalPage1 = freezed,
    Object? additionalPage2 = freezed,
    Object? bannerId = freezed,
    Object? interId = freezed,
    Object? rewardId = freezed,
  }) {
    return _then(_$AppDataImpl(
      appTitle: null == appTitle
          ? _value.appTitle
          : appTitle // ignore: cast_nullable_to_non_nullable
              as String,
      appIcon: null == appIcon
          ? _value.appIcon
          : appIcon // ignore: cast_nullable_to_non_nullable
              as IconData,
      symbols: null == symbols
          ? _value._symbols
          : symbols // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isRotation: null == isRotation
          ? _value.isRotation
          : isRotation // ignore: cast_nullable_to_non_nullable
              as bool,
      URL: null == URL
          ? _value.URL
          : URL // ignore: cast_nullable_to_non_nullable
              as String,
      mainGame: null == mainGame
          ? _value.mainGame
          : mainGame // ignore: cast_nullable_to_non_nullable
              as GamePageBuilder,
      loadGame: freezed == loadGame
          ? _value.loadGame
          : loadGame // ignore: cast_nullable_to_non_nullable
              as LoadBuilder?,
      settingWidgets: freezed == settingWidgets
          ? _value.settingWidgets
          : settingWidgets // ignore: cast_nullable_to_non_nullable
              as SettingWidgetsBuilder?,
      additionalPage1: freezed == additionalPage1
          ? _value.additionalPage1
          : additionalPage1 // ignore: cast_nullable_to_non_nullable
              as PageConfig?,
      additionalPage2: freezed == additionalPage2
          ? _value.additionalPage2
          : additionalPage2 // ignore: cast_nullable_to_non_nullable
              as PageConfig?,
      bannerId: freezed == bannerId
          ? _value.bannerId
          : bannerId // ignore: cast_nullable_to_non_nullable
              as String?,
      interId: freezed == interId
          ? _value.interId
          : interId // ignore: cast_nullable_to_non_nullable
              as String?,
      rewardId: freezed == rewardId
          ? _value.rewardId
          : rewardId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AppDataImpl implements _AppData {
  const _$AppDataImpl(
      {required this.appTitle,
      required this.appIcon,
      required final List<String> symbols,
      required this.isRotation,
      required this.URL,
      required this.mainGame,
      this.loadGame,
      this.settingWidgets,
      this.additionalPage1,
      this.additionalPage2,
      this.bannerId,
      this.interId,
      this.rewardId})
      : _symbols = symbols;

  @override
  final String appTitle;
  @override
  final IconData appIcon;
  final List<String> _symbols;
  @override
  List<String> get symbols {
    if (_symbols is EqualUnmodifiableListView) return _symbols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symbols);
  }

  @override
  final bool isRotation;
  @override
  final String URL;
  @override
  final GamePageBuilder mainGame;
  @override
  final LoadBuilder? loadGame;
  @override
  final SettingWidgetsBuilder? settingWidgets;
  @override
  final PageConfig? additionalPage1;
  @override
  final PageConfig? additionalPage2;
  @override
  final String? bannerId;
  @override
  final String? interId;
  @override
  final String? rewardId;

  @override
  String toString() {
    return 'AppData(appTitle: $appTitle, appIcon: $appIcon, symbols: $symbols, isRotation: $isRotation, URL: $URL, mainGame: $mainGame, loadGame: $loadGame, settingWidgets: $settingWidgets, additionalPage1: $additionalPage1, additionalPage2: $additionalPage2, bannerId: $bannerId, interId: $interId, rewardId: $rewardId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDataImpl &&
            (identical(other.appTitle, appTitle) ||
                other.appTitle == appTitle) &&
            (identical(other.appIcon, appIcon) || other.appIcon == appIcon) &&
            const DeepCollectionEquality().equals(other._symbols, _symbols) &&
            (identical(other.isRotation, isRotation) ||
                other.isRotation == isRotation) &&
            (identical(other.URL, URL) || other.URL == URL) &&
            (identical(other.mainGame, mainGame) ||
                other.mainGame == mainGame) &&
            (identical(other.loadGame, loadGame) ||
                other.loadGame == loadGame) &&
            (identical(other.settingWidgets, settingWidgets) ||
                other.settingWidgets == settingWidgets) &&
            (identical(other.additionalPage1, additionalPage1) ||
                other.additionalPage1 == additionalPage1) &&
            (identical(other.additionalPage2, additionalPage2) ||
                other.additionalPage2 == additionalPage2) &&
            (identical(other.bannerId, bannerId) ||
                other.bannerId == bannerId) &&
            (identical(other.interId, interId) || other.interId == interId) &&
            (identical(other.rewardId, rewardId) ||
                other.rewardId == rewardId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      appTitle,
      appIcon,
      const DeepCollectionEquality().hash(_symbols),
      isRotation,
      URL,
      mainGame,
      loadGame,
      settingWidgets,
      additionalPage1,
      additionalPage2,
      bannerId,
      interId,
      rewardId);

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDataImplCopyWith<_$AppDataImpl> get copyWith =>
      __$$AppDataImplCopyWithImpl<_$AppDataImpl>(this, _$identity);
}

abstract class _AppData implements AppData {
  const factory _AppData(
      {required final String appTitle,
      required final IconData appIcon,
      required final List<String> symbols,
      required final bool isRotation,
      required final String URL,
      required final GamePageBuilder mainGame,
      final LoadBuilder? loadGame,
      final SettingWidgetsBuilder? settingWidgets,
      final PageConfig? additionalPage1,
      final PageConfig? additionalPage2,
      final String? bannerId,
      final String? interId,
      final String? rewardId}) = _$AppDataImpl;

  @override
  String get appTitle;
  @override
  IconData get appIcon;
  @override
  List<String> get symbols;
  @override
  bool get isRotation;
  @override
  String get URL;
  @override
  GamePageBuilder get mainGame;
  @override
  LoadBuilder? get loadGame;
  @override
  SettingWidgetsBuilder? get settingWidgets;
  @override
  PageConfig? get additionalPage1;
  @override
  PageConfig? get additionalPage2;
  @override
  String? get bannerId;
  @override
  String? get interId;
  @override
  String? get rewardId;

  /// Create a copy of AppData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppDataImplCopyWith<_$AppDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MidData {
  ModeData get modeData => throw _privateConstructorUsedError;
  List<DetailData> get detail => throw _privateConstructorUsedError;

  /// Create a copy of MidData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MidDataCopyWith<MidData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MidDataCopyWith<$Res> {
  factory $MidDataCopyWith(MidData value, $Res Function(MidData) then) =
      _$MidDataCopyWithImpl<$Res, MidData>;
  @useResult
  $Res call({ModeData modeData, List<DetailData> detail});

  $ModeDataCopyWith<$Res> get modeData;
}

/// @nodoc
class _$MidDataCopyWithImpl<$Res, $Val extends MidData>
    implements $MidDataCopyWith<$Res> {
  _$MidDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MidData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modeData = null,
    Object? detail = null,
  }) {
    return _then(_value.copyWith(
      modeData: null == modeData
          ? _value.modeData
          : modeData // ignore: cast_nullable_to_non_nullable
              as ModeData,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as List<DetailData>,
    ) as $Val);
  }

  /// Create a copy of MidData
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
abstract class _$$MidDataImplCopyWith<$Res> implements $MidDataCopyWith<$Res> {
  factory _$$MidDataImplCopyWith(
          _$MidDataImpl value, $Res Function(_$MidDataImpl) then) =
      __$$MidDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ModeData modeData, List<DetailData> detail});

  @override
  $ModeDataCopyWith<$Res> get modeData;
}

/// @nodoc
class __$$MidDataImplCopyWithImpl<$Res>
    extends _$MidDataCopyWithImpl<$Res, _$MidDataImpl>
    implements _$$MidDataImplCopyWith<$Res> {
  __$$MidDataImplCopyWithImpl(
      _$MidDataImpl _value, $Res Function(_$MidDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MidData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modeData = null,
    Object? detail = null,
  }) {
    return _then(_$MidDataImpl(
      modeData: null == modeData
          ? _value.modeData
          : modeData // ignore: cast_nullable_to_non_nullable
              as ModeData,
      detail: null == detail
          ? _value._detail
          : detail // ignore: cast_nullable_to_non_nullable
              as List<DetailData>,
    ));
  }
}

/// @nodoc

class _$MidDataImpl extends _MidData {
  const _$MidDataImpl(
      {required this.modeData, required final List<DetailData> detail})
      : _detail = detail,
        super._();

  @override
  final ModeData modeData;
  final List<DetailData> _detail;
  @override
  List<DetailData> get detail {
    if (_detail is EqualUnmodifiableListView) return _detail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detail);
  }

  @override
  String toString() {
    return 'MidData(modeData: $modeData, detail: $detail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MidDataImpl &&
            (identical(other.modeData, modeData) ||
                other.modeData == modeData) &&
            const DeepCollectionEquality().equals(other._detail, _detail));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, modeData, const DeepCollectionEquality().hash(_detail));

  /// Create a copy of MidData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MidDataImplCopyWith<_$MidDataImpl> get copyWith =>
      __$$MidDataImplCopyWithImpl<_$MidDataImpl>(this, _$identity);
}

abstract class _MidData extends MidData {
  const factory _MidData(
      {required final ModeData modeData,
      required final List<DetailData> detail}) = _$MidDataImpl;
  const _MidData._() : super._();

  @override
  ModeData get modeData;
  @override
  List<DetailData> get detail;

  /// Create a copy of MidData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MidDataImplCopyWith<_$MidDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ModeData {
  String get unit => throw _privateConstructorUsedError;
  int get fix => throw _privateConstructorUsedError;
  bool get islimited => throw _privateConstructorUsedError;
  bool get isbattle => throw _privateConstructorUsedError;
  bool get isSmallerBetter => throw _privateConstructorUsedError;
  String get modeType => throw _privateConstructorUsedError;
  IconData get modeIcon => throw _privateConstructorUsedError;
  String get modeTitle => throw _privateConstructorUsedError;
  String? get modeDescription => throw _privateConstructorUsedError;
  List<QuizTabInfo>? get rankingList => throw _privateConstructorUsedError;

  /// Create a copy of ModeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModeDataCopyWith<ModeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModeDataCopyWith<$Res> {
  factory $ModeDataCopyWith(ModeData value, $Res Function(ModeData) then) =
      _$ModeDataCopyWithImpl<$Res, ModeData>;
  @useResult
  $Res call(
      {String unit,
      int fix,
      bool islimited,
      bool isbattle,
      bool isSmallerBetter,
      String modeType,
      IconData modeIcon,
      String modeTitle,
      String? modeDescription,
      List<QuizTabInfo>? rankingList});
}

/// @nodoc
class _$ModeDataCopyWithImpl<$Res, $Val extends ModeData>
    implements $ModeDataCopyWith<$Res> {
  _$ModeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unit = null,
    Object? fix = null,
    Object? islimited = null,
    Object? isbattle = null,
    Object? isSmallerBetter = null,
    Object? modeType = null,
    Object? modeIcon = null,
    Object? modeTitle = null,
    Object? modeDescription = freezed,
    Object? rankingList = freezed,
  }) {
    return _then(_value.copyWith(
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      fix: null == fix
          ? _value.fix
          : fix // ignore: cast_nullable_to_non_nullable
              as int,
      islimited: null == islimited
          ? _value.islimited
          : islimited // ignore: cast_nullable_to_non_nullable
              as bool,
      isbattle: null == isbattle
          ? _value.isbattle
          : isbattle // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmallerBetter: null == isSmallerBetter
          ? _value.isSmallerBetter
          : isSmallerBetter // ignore: cast_nullable_to_non_nullable
              as bool,
      modeType: null == modeType
          ? _value.modeType
          : modeType // ignore: cast_nullable_to_non_nullable
              as String,
      modeIcon: null == modeIcon
          ? _value.modeIcon
          : modeIcon // ignore: cast_nullable_to_non_nullable
              as IconData,
      modeTitle: null == modeTitle
          ? _value.modeTitle
          : modeTitle // ignore: cast_nullable_to_non_nullable
              as String,
      modeDescription: freezed == modeDescription
          ? _value.modeDescription
          : modeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      rankingList: freezed == rankingList
          ? _value.rankingList
          : rankingList // ignore: cast_nullable_to_non_nullable
              as List<QuizTabInfo>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModeDataImplCopyWith<$Res>
    implements $ModeDataCopyWith<$Res> {
  factory _$$ModeDataImplCopyWith(
          _$ModeDataImpl value, $Res Function(_$ModeDataImpl) then) =
      __$$ModeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String unit,
      int fix,
      bool islimited,
      bool isbattle,
      bool isSmallerBetter,
      String modeType,
      IconData modeIcon,
      String modeTitle,
      String? modeDescription,
      List<QuizTabInfo>? rankingList});
}

/// @nodoc
class __$$ModeDataImplCopyWithImpl<$Res>
    extends _$ModeDataCopyWithImpl<$Res, _$ModeDataImpl>
    implements _$$ModeDataImplCopyWith<$Res> {
  __$$ModeDataImplCopyWithImpl(
      _$ModeDataImpl _value, $Res Function(_$ModeDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unit = null,
    Object? fix = null,
    Object? islimited = null,
    Object? isbattle = null,
    Object? isSmallerBetter = null,
    Object? modeType = null,
    Object? modeIcon = null,
    Object? modeTitle = null,
    Object? modeDescription = freezed,
    Object? rankingList = freezed,
  }) {
    return _then(_$ModeDataImpl(
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      fix: null == fix
          ? _value.fix
          : fix // ignore: cast_nullable_to_non_nullable
              as int,
      islimited: null == islimited
          ? _value.islimited
          : islimited // ignore: cast_nullable_to_non_nullable
              as bool,
      isbattle: null == isbattle
          ? _value.isbattle
          : isbattle // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmallerBetter: null == isSmallerBetter
          ? _value.isSmallerBetter
          : isSmallerBetter // ignore: cast_nullable_to_non_nullable
              as bool,
      modeType: null == modeType
          ? _value.modeType
          : modeType // ignore: cast_nullable_to_non_nullable
              as String,
      modeIcon: null == modeIcon
          ? _value.modeIcon
          : modeIcon // ignore: cast_nullable_to_non_nullable
              as IconData,
      modeTitle: null == modeTitle
          ? _value.modeTitle
          : modeTitle // ignore: cast_nullable_to_non_nullable
              as String,
      modeDescription: freezed == modeDescription
          ? _value.modeDescription
          : modeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      rankingList: freezed == rankingList
          ? _value._rankingList
          : rankingList // ignore: cast_nullable_to_non_nullable
              as List<QuizTabInfo>?,
    ));
  }
}

/// @nodoc

class _$ModeDataImpl implements _ModeData {
  const _$ModeDataImpl(
      {required this.unit,
      required this.fix,
      required this.islimited,
      required this.isbattle,
      required this.isSmallerBetter,
      required this.modeType,
      required this.modeIcon,
      required this.modeTitle,
      this.modeDescription,
      final List<QuizTabInfo>? rankingList})
      : _rankingList = rankingList;

  @override
  final String unit;
  @override
  final int fix;
  @override
  final bool islimited;
  @override
  final bool isbattle;
  @override
  final bool isSmallerBetter;
  @override
  final String modeType;
  @override
  final IconData modeIcon;
  @override
  final String modeTitle;
  @override
  final String? modeDescription;
  final List<QuizTabInfo>? _rankingList;
  @override
  List<QuizTabInfo>? get rankingList {
    final value = _rankingList;
    if (value == null) return null;
    if (_rankingList is EqualUnmodifiableListView) return _rankingList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ModeData(unit: $unit, fix: $fix, islimited: $islimited, isbattle: $isbattle, isSmallerBetter: $isSmallerBetter, modeType: $modeType, modeIcon: $modeIcon, modeTitle: $modeTitle, modeDescription: $modeDescription, rankingList: $rankingList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModeDataImpl &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.fix, fix) || other.fix == fix) &&
            (identical(other.islimited, islimited) ||
                other.islimited == islimited) &&
            (identical(other.isbattle, isbattle) ||
                other.isbattle == isbattle) &&
            (identical(other.isSmallerBetter, isSmallerBetter) ||
                other.isSmallerBetter == isSmallerBetter) &&
            (identical(other.modeType, modeType) ||
                other.modeType == modeType) &&
            (identical(other.modeIcon, modeIcon) ||
                other.modeIcon == modeIcon) &&
            (identical(other.modeTitle, modeTitle) ||
                other.modeTitle == modeTitle) &&
            (identical(other.modeDescription, modeDescription) ||
                other.modeDescription == modeDescription) &&
            const DeepCollectionEquality()
                .equals(other._rankingList, _rankingList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      unit,
      fix,
      islimited,
      isbattle,
      isSmallerBetter,
      modeType,
      modeIcon,
      modeTitle,
      modeDescription,
      const DeepCollectionEquality().hash(_rankingList));

  /// Create a copy of ModeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModeDataImplCopyWith<_$ModeDataImpl> get copyWith =>
      __$$ModeDataImplCopyWithImpl<_$ModeDataImpl>(this, _$identity);
}

abstract class _ModeData implements ModeData {
  const factory _ModeData(
      {required final String unit,
      required final int fix,
      required final bool islimited,
      required final bool isbattle,
      required final bool isSmallerBetter,
      required final String modeType,
      required final IconData modeIcon,
      required final String modeTitle,
      final String? modeDescription,
      final List<QuizTabInfo>? rankingList}) = _$ModeDataImpl;

  @override
  String get unit;
  @override
  int get fix;
  @override
  bool get islimited;
  @override
  bool get isbattle;
  @override
  bool get isSmallerBetter;
  @override
  String get modeType;
  @override
  IconData get modeIcon;
  @override
  String get modeTitle;
  @override
  String? get modeDescription;
  @override
  List<QuizTabInfo>? get rankingList;

  /// Create a copy of ModeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModeDataImplCopyWith<_$ModeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DetailData {
  QuizId get quizId => throw _privateConstructorUsedError; // ← 追加
  String get sort => throw _privateConstructorUsedError;
  String get displayLabel => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get circleColor => throw _privateConstructorUsedError;
  IconData? get detailIcon => throw _privateConstructorUsedError;

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailDataCopyWith<DetailData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailDataCopyWith<$Res> {
  factory $DetailDataCopyWith(
          DetailData value, $Res Function(DetailData) then) =
      _$DetailDataCopyWithImpl<$Res, DetailData>;
  @useResult
  $Res call(
      {QuizId quizId,
      String sort,
      String displayLabel,
      String method,
      String description,
      String color,
      String circleColor,
      IconData? detailIcon});

  $QuizIdCopyWith<$Res> get quizId;
}

/// @nodoc
class _$DetailDataCopyWithImpl<$Res, $Val extends DetailData>
    implements $DetailDataCopyWith<$Res> {
  _$DetailDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? sort = null,
    Object? displayLabel = null,
    Object? method = null,
    Object? description = null,
    Object? color = null,
    Object? circleColor = null,
    Object? detailIcon = freezed,
  }) {
    return _then(_value.copyWith(
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as QuizId,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      displayLabel: null == displayLabel
          ? _value.displayLabel
          : displayLabel // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      circleColor: null == circleColor
          ? _value.circleColor
          : circleColor // ignore: cast_nullable_to_non_nullable
              as String,
      detailIcon: freezed == detailIcon
          ? _value.detailIcon
          : detailIcon // ignore: cast_nullable_to_non_nullable
              as IconData?,
    ) as $Val);
  }

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizIdCopyWith<$Res> get quizId {
    return $QuizIdCopyWith<$Res>(_value.quizId, (value) {
      return _then(_value.copyWith(quizId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DetailDataImplCopyWith<$Res>
    implements $DetailDataCopyWith<$Res> {
  factory _$$DetailDataImplCopyWith(
          _$DetailDataImpl value, $Res Function(_$DetailDataImpl) then) =
      __$$DetailDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {QuizId quizId,
      String sort,
      String displayLabel,
      String method,
      String description,
      String color,
      String circleColor,
      IconData? detailIcon});

  @override
  $QuizIdCopyWith<$Res> get quizId;
}

/// @nodoc
class __$$DetailDataImplCopyWithImpl<$Res>
    extends _$DetailDataCopyWithImpl<$Res, _$DetailDataImpl>
    implements _$$DetailDataImplCopyWith<$Res> {
  __$$DetailDataImplCopyWithImpl(
      _$DetailDataImpl _value, $Res Function(_$DetailDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? sort = null,
    Object? displayLabel = null,
    Object? method = null,
    Object? description = null,
    Object? color = null,
    Object? circleColor = null,
    Object? detailIcon = freezed,
  }) {
    return _then(_$DetailDataImpl(
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as QuizId,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      displayLabel: null == displayLabel
          ? _value.displayLabel
          : displayLabel // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      circleColor: null == circleColor
          ? _value.circleColor
          : circleColor // ignore: cast_nullable_to_non_nullable
              as String,
      detailIcon: freezed == detailIcon
          ? _value.detailIcon
          : detailIcon // ignore: cast_nullable_to_non_nullable
              as IconData?,
    ));
  }
}

/// @nodoc

class _$DetailDataImpl extends _DetailData {
  const _$DetailDataImpl(
      {required this.quizId,
      required this.sort,
      required this.displayLabel,
      required this.method,
      required this.description,
      required this.color,
      required this.circleColor,
      this.detailIcon})
      : super._();

  @override
  final QuizId quizId;
// ← 追加
  @override
  final String sort;
  @override
  final String displayLabel;
  @override
  final String method;
  @override
  final String description;
  @override
  final String color;
  @override
  final String circleColor;
  @override
  final IconData? detailIcon;

  @override
  String toString() {
    return 'DetailData(quizId: $quizId, sort: $sort, displayLabel: $displayLabel, method: $method, description: $description, color: $color, circleColor: $circleColor, detailIcon: $detailIcon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailDataImpl &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.displayLabel, displayLabel) ||
                other.displayLabel == displayLabel) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.circleColor, circleColor) ||
                other.circleColor == circleColor) &&
            (identical(other.detailIcon, detailIcon) ||
                other.detailIcon == detailIcon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, quizId, sort, displayLabel,
      method, description, color, circleColor, detailIcon);

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailDataImplCopyWith<_$DetailDataImpl> get copyWith =>
      __$$DetailDataImplCopyWithImpl<_$DetailDataImpl>(this, _$identity);
}

abstract class _DetailData extends DetailData {
  const factory _DetailData(
      {required final QuizId quizId,
      required final String sort,
      required final String displayLabel,
      required final String method,
      required final String description,
      required final String color,
      required final String circleColor,
      final IconData? detailIcon}) = _$DetailDataImpl;
  const _DetailData._() : super._();

  @override
  QuizId get quizId; // ← 追加
  @override
  String get sort;
  @override
  String get displayLabel;
  @override
  String get method;
  @override
  String get description;
  @override
  String get color;
  @override
  String get circleColor;
  @override
  IconData? get detailIcon;

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailDataImplCopyWith<_$DetailDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

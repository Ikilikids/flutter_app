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
mixin _$AdditionalPageConfig {
  String get title => throw _privateConstructorUsedError;
  IconData get icon => throw _privateConstructorUsedError;
  AdditionalPageBuilder get builder => throw _privateConstructorUsedError;

  /// Create a copy of AdditionalPageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdditionalPageConfigCopyWith<AdditionalPageConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdditionalPageConfigCopyWith<$Res> {
  factory $AdditionalPageConfigCopyWith(AdditionalPageConfig value,
          $Res Function(AdditionalPageConfig) then) =
      _$AdditionalPageConfigCopyWithImpl<$Res, AdditionalPageConfig>;
  @useResult
  $Res call({String title, IconData icon, AdditionalPageBuilder builder});
}

/// @nodoc
class _$AdditionalPageConfigCopyWithImpl<$Res,
        $Val extends AdditionalPageConfig>
    implements $AdditionalPageConfigCopyWith<$Res> {
  _$AdditionalPageConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdditionalPageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? icon = null,
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
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as AdditionalPageBuilder,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdditionalPageConfigImplCopyWith<$Res>
    implements $AdditionalPageConfigCopyWith<$Res> {
  factory _$$AdditionalPageConfigImplCopyWith(_$AdditionalPageConfigImpl value,
          $Res Function(_$AdditionalPageConfigImpl) then) =
      __$$AdditionalPageConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, IconData icon, AdditionalPageBuilder builder});
}

/// @nodoc
class __$$AdditionalPageConfigImplCopyWithImpl<$Res>
    extends _$AdditionalPageConfigCopyWithImpl<$Res, _$AdditionalPageConfigImpl>
    implements _$$AdditionalPageConfigImplCopyWith<$Res> {
  __$$AdditionalPageConfigImplCopyWithImpl(_$AdditionalPageConfigImpl _value,
      $Res Function(_$AdditionalPageConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdditionalPageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? icon = null,
    Object? builder = null,
  }) {
    return _then(_$AdditionalPageConfigImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      builder: null == builder
          ? _value.builder
          : builder // ignore: cast_nullable_to_non_nullable
              as AdditionalPageBuilder,
    ));
  }
}

/// @nodoc

class _$AdditionalPageConfigImpl implements _AdditionalPageConfig {
  const _$AdditionalPageConfigImpl(
      {required this.title, required this.icon, required this.builder});

  @override
  final String title;
  @override
  final IconData icon;
  @override
  final AdditionalPageBuilder builder;

  @override
  String toString() {
    return 'AdditionalPageConfig(title: $title, icon: $icon, builder: $builder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdditionalPageConfigImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.builder, builder) || other.builder == builder));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, icon, builder);

  /// Create a copy of AdditionalPageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdditionalPageConfigImplCopyWith<_$AdditionalPageConfigImpl>
      get copyWith =>
          __$$AdditionalPageConfigImplCopyWithImpl<_$AdditionalPageConfigImpl>(
              this, _$identity);
}

abstract class _AdditionalPageConfig implements AdditionalPageConfig {
  const factory _AdditionalPageConfig(
          {required final String title,
          required final IconData icon,
          required final AdditionalPageBuilder builder}) =
      _$AdditionalPageConfigImpl;

  @override
  String get title;
  @override
  IconData get icon;
  @override
  AdditionalPageBuilder get builder;

  /// Create a copy of AdditionalPageConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdditionalPageConfigImplCopyWith<_$AdditionalPageConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
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
  EndBuilder? get endBuilder => throw _privateConstructorUsedError;
  SettingWidgetsBuilder? get settingWidgets =>
      throw _privateConstructorUsedError;
  AdditionalPageConfig? get additionalPage =>
      throw _privateConstructorUsedError;
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
      EndBuilder? endBuilder,
      SettingWidgetsBuilder? settingWidgets,
      AdditionalPageConfig? additionalPage,
      String? bannerId,
      String? interId,
      String? rewardId});

  $AdditionalPageConfigCopyWith<$Res>? get additionalPage;
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
    Object? endBuilder = freezed,
    Object? settingWidgets = freezed,
    Object? additionalPage = freezed,
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
      endBuilder: freezed == endBuilder
          ? _value.endBuilder
          : endBuilder // ignore: cast_nullable_to_non_nullable
              as EndBuilder?,
      settingWidgets: freezed == settingWidgets
          ? _value.settingWidgets
          : settingWidgets // ignore: cast_nullable_to_non_nullable
              as SettingWidgetsBuilder?,
      additionalPage: freezed == additionalPage
          ? _value.additionalPage
          : additionalPage // ignore: cast_nullable_to_non_nullable
              as AdditionalPageConfig?,
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
  $AdditionalPageConfigCopyWith<$Res>? get additionalPage {
    if (_value.additionalPage == null) {
      return null;
    }

    return $AdditionalPageConfigCopyWith<$Res>(_value.additionalPage!, (value) {
      return _then(_value.copyWith(additionalPage: value) as $Val);
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
      EndBuilder? endBuilder,
      SettingWidgetsBuilder? settingWidgets,
      AdditionalPageConfig? additionalPage,
      String? bannerId,
      String? interId,
      String? rewardId});

  @override
  $AdditionalPageConfigCopyWith<$Res>? get additionalPage;
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
    Object? endBuilder = freezed,
    Object? settingWidgets = freezed,
    Object? additionalPage = freezed,
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
      endBuilder: freezed == endBuilder
          ? _value.endBuilder
          : endBuilder // ignore: cast_nullable_to_non_nullable
              as EndBuilder?,
      settingWidgets: freezed == settingWidgets
          ? _value.settingWidgets
          : settingWidgets // ignore: cast_nullable_to_non_nullable
              as SettingWidgetsBuilder?,
      additionalPage: freezed == additionalPage
          ? _value.additionalPage
          : additionalPage // ignore: cast_nullable_to_non_nullable
              as AdditionalPageConfig?,
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
      this.endBuilder,
      this.settingWidgets,
      this.additionalPage,
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
  final EndBuilder? endBuilder;
  @override
  final SettingWidgetsBuilder? settingWidgets;
  @override
  final AdditionalPageConfig? additionalPage;
  @override
  final String? bannerId;
  @override
  final String? interId;
  @override
  final String? rewardId;

  @override
  String toString() {
    return 'AppData(appTitle: $appTitle, appIcon: $appIcon, symbols: $symbols, isRotation: $isRotation, URL: $URL, mainGame: $mainGame, loadGame: $loadGame, endBuilder: $endBuilder, settingWidgets: $settingWidgets, additionalPage: $additionalPage, bannerId: $bannerId, interId: $interId, rewardId: $rewardId)';
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
            (identical(other.endBuilder, endBuilder) ||
                other.endBuilder == endBuilder) &&
            (identical(other.settingWidgets, settingWidgets) ||
                other.settingWidgets == settingWidgets) &&
            (identical(other.additionalPage, additionalPage) ||
                other.additionalPage == additionalPage) &&
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
      endBuilder,
      settingWidgets,
      additionalPage,
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
      final EndBuilder? endBuilder,
      final SettingWidgetsBuilder? settingWidgets,
      final AdditionalPageConfig? additionalPage,
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
  EndBuilder? get endBuilder;
  @override
  SettingWidgetsBuilder? get settingWidgets;
  @override
  AdditionalPageConfig? get additionalPage;
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
  IconData? get modeIcon => throw _privateConstructorUsedError;
  String? get modeTitle => throw _privateConstructorUsedError;
  String? get sub1 => throw _privateConstructorUsedError;
  String? get sub2 => throw _privateConstructorUsedError;

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
      IconData? modeIcon,
      String? modeTitle,
      String? sub1,
      String? sub2});
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
    Object? modeIcon = freezed,
    Object? modeTitle = freezed,
    Object? sub1 = freezed,
    Object? sub2 = freezed,
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
      modeIcon: freezed == modeIcon
          ? _value.modeIcon
          : modeIcon // ignore: cast_nullable_to_non_nullable
              as IconData?,
      modeTitle: freezed == modeTitle
          ? _value.modeTitle
          : modeTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      sub1: freezed == sub1
          ? _value.sub1
          : sub1 // ignore: cast_nullable_to_non_nullable
              as String?,
      sub2: freezed == sub2
          ? _value.sub2
          : sub2 // ignore: cast_nullable_to_non_nullable
              as String?,
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
      IconData? modeIcon,
      String? modeTitle,
      String? sub1,
      String? sub2});
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
    Object? modeIcon = freezed,
    Object? modeTitle = freezed,
    Object? sub1 = freezed,
    Object? sub2 = freezed,
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
      modeIcon: freezed == modeIcon
          ? _value.modeIcon
          : modeIcon // ignore: cast_nullable_to_non_nullable
              as IconData?,
      modeTitle: freezed == modeTitle
          ? _value.modeTitle
          : modeTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      sub1: freezed == sub1
          ? _value.sub1
          : sub1 // ignore: cast_nullable_to_non_nullable
              as String?,
      sub2: freezed == sub2
          ? _value.sub2
          : sub2 // ignore: cast_nullable_to_non_nullable
              as String?,
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
      this.modeIcon,
      this.modeTitle,
      this.sub1,
      this.sub2});

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
  final IconData? modeIcon;
  @override
  final String? modeTitle;
  @override
  final String? sub1;
  @override
  final String? sub2;

  @override
  String toString() {
    return 'ModeData(unit: $unit, fix: $fix, islimited: $islimited, isbattle: $isbattle, isSmallerBetter: $isSmallerBetter, modeType: $modeType, modeIcon: $modeIcon, modeTitle: $modeTitle, sub1: $sub1, sub2: $sub2)';
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
            (identical(other.sub1, sub1) || other.sub1 == sub1) &&
            (identical(other.sub2, sub2) || other.sub2 == sub2));
  }

  @override
  int get hashCode => Object.hash(runtimeType, unit, fix, islimited, isbattle,
      isSmallerBetter, modeType, modeIcon, modeTitle, sub1, sub2);

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
      final IconData? modeIcon,
      final String? modeTitle,
      final String? sub1,
      final String? sub2}) = _$ModeDataImpl;

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
  IconData? get modeIcon;
  @override
  String? get modeTitle;
  @override
  String? get sub1;
  @override
  String? get sub2;

  /// Create a copy of ModeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModeDataImplCopyWith<_$ModeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DetailData {
  String get sort => throw _privateConstructorUsedError;
  String get displayLabel => throw _privateConstructorUsedError;
  String get displayRank => throw _privateConstructorUsedError;
  String get resisterSub => throw _privateConstructorUsedError;
  String get resisterOrigin => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get circleColor => throw _privateConstructorUsedError;

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
      {String sort,
      String displayLabel,
      String displayRank,
      String resisterSub,
      String resisterOrigin,
      String method,
      String description,
      String color,
      String circleColor});
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
    Object? sort = null,
    Object? displayLabel = null,
    Object? displayRank = null,
    Object? resisterSub = null,
    Object? resisterOrigin = null,
    Object? method = null,
    Object? description = null,
    Object? color = null,
    Object? circleColor = null,
  }) {
    return _then(_value.copyWith(
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      displayLabel: null == displayLabel
          ? _value.displayLabel
          : displayLabel // ignore: cast_nullable_to_non_nullable
              as String,
      displayRank: null == displayRank
          ? _value.displayRank
          : displayRank // ignore: cast_nullable_to_non_nullable
              as String,
      resisterSub: null == resisterSub
          ? _value.resisterSub
          : resisterSub // ignore: cast_nullable_to_non_nullable
              as String,
      resisterOrigin: null == resisterOrigin
          ? _value.resisterOrigin
          : resisterOrigin // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
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
      {String sort,
      String displayLabel,
      String displayRank,
      String resisterSub,
      String resisterOrigin,
      String method,
      String description,
      String color,
      String circleColor});
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
    Object? sort = null,
    Object? displayLabel = null,
    Object? displayRank = null,
    Object? resisterSub = null,
    Object? resisterOrigin = null,
    Object? method = null,
    Object? description = null,
    Object? color = null,
    Object? circleColor = null,
  }) {
    return _then(_$DetailDataImpl(
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      displayLabel: null == displayLabel
          ? _value.displayLabel
          : displayLabel // ignore: cast_nullable_to_non_nullable
              as String,
      displayRank: null == displayRank
          ? _value.displayRank
          : displayRank // ignore: cast_nullable_to_non_nullable
              as String,
      resisterSub: null == resisterSub
          ? _value.resisterSub
          : resisterSub // ignore: cast_nullable_to_non_nullable
              as String,
      resisterOrigin: null == resisterOrigin
          ? _value.resisterOrigin
          : resisterOrigin // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc

class _$DetailDataImpl implements _DetailData {
  const _$DetailDataImpl(
      {required this.sort,
      required this.displayLabel,
      required this.displayRank,
      required this.resisterSub,
      required this.resisterOrigin,
      required this.method,
      required this.description,
      required this.color,
      required this.circleColor});

  @override
  final String sort;
  @override
  final String displayLabel;
  @override
  final String displayRank;
  @override
  final String resisterSub;
  @override
  final String resisterOrigin;
  @override
  final String method;
  @override
  final String description;
  @override
  final String color;
  @override
  final String circleColor;

  @override
  String toString() {
    return 'DetailData(sort: $sort, displayLabel: $displayLabel, displayRank: $displayRank, resisterSub: $resisterSub, resisterOrigin: $resisterOrigin, method: $method, description: $description, color: $color, circleColor: $circleColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailDataImpl &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.displayLabel, displayLabel) ||
                other.displayLabel == displayLabel) &&
            (identical(other.displayRank, displayRank) ||
                other.displayRank == displayRank) &&
            (identical(other.resisterSub, resisterSub) ||
                other.resisterSub == resisterSub) &&
            (identical(other.resisterOrigin, resisterOrigin) ||
                other.resisterOrigin == resisterOrigin) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.circleColor, circleColor) ||
                other.circleColor == circleColor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sort, displayLabel, displayRank,
      resisterSub, resisterOrigin, method, description, color, circleColor);

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailDataImplCopyWith<_$DetailDataImpl> get copyWith =>
      __$$DetailDataImplCopyWithImpl<_$DetailDataImpl>(this, _$identity);
}

abstract class _DetailData implements DetailData {
  const factory _DetailData(
      {required final String sort,
      required final String displayLabel,
      required final String displayRank,
      required final String resisterSub,
      required final String resisterOrigin,
      required final String method,
      required final String description,
      required final String color,
      required final String circleColor}) = _$DetailDataImpl;

  @override
  String get sort;
  @override
  String get displayLabel;
  @override
  String get displayRank;
  @override
  String get resisterSub;
  @override
  String get resisterOrigin;
  @override
  String get method;
  @override
  String get description;
  @override
  String get color;
  @override
  String get circleColor;

  /// Create a copy of DetailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailDataImplCopyWith<_$DetailDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'creator_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatorProfile {

 String get id; String get name;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'creator_level') CreatorLevel get creatorLevel;@JsonKey(name: 'reputation_points') int get reputationPoints;@JsonKey(name: 'stories_published') int get storiesPublished; List<String> get badges;@JsonKey(name: 'accuracy_rate') double get accuracyRate;@JsonKey(name: 'joined_at') DateTime? get joinedAt;
/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatorProfileCopyWith<CreatorProfile> get copyWith => _$CreatorProfileCopyWithImpl<CreatorProfile>(this as CreatorProfile, _$identity);

  /// Serializes this CreatorProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.reputationPoints, reputationPoints) || other.reputationPoints == reputationPoints)&&(identical(other.storiesPublished, storiesPublished) || other.storiesPublished == storiesPublished)&&const DeepCollectionEquality().equals(other.badges, badges)&&(identical(other.accuracyRate, accuracyRate) || other.accuracyRate == accuracyRate)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,creatorLevel,reputationPoints,storiesPublished,const DeepCollectionEquality().hash(badges),accuracyRate,joinedAt);

@override
String toString() {
  return 'CreatorProfile(id: $id, name: $name, avatarUrl: $avatarUrl, creatorLevel: $creatorLevel, reputationPoints: $reputationPoints, storiesPublished: $storiesPublished, badges: $badges, accuracyRate: $accuracyRate, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $CreatorProfileCopyWith<$Res>  {
  factory $CreatorProfileCopyWith(CreatorProfile value, $Res Function(CreatorProfile) _then) = _$CreatorProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'creator_level') CreatorLevel creatorLevel,@JsonKey(name: 'reputation_points') int reputationPoints,@JsonKey(name: 'stories_published') int storiesPublished, List<String> badges,@JsonKey(name: 'accuracy_rate') double accuracyRate,@JsonKey(name: 'joined_at') DateTime? joinedAt
});




}
/// @nodoc
class _$CreatorProfileCopyWithImpl<$Res>
    implements $CreatorProfileCopyWith<$Res> {
  _$CreatorProfileCopyWithImpl(this._self, this._then);

  final CreatorProfile _self;
  final $Res Function(CreatorProfile) _then;

/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? creatorLevel = null,Object? reputationPoints = null,Object? storiesPublished = null,Object? badges = null,Object? accuracyRate = null,Object? joinedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: null == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as CreatorLevel,reputationPoints: null == reputationPoints ? _self.reputationPoints : reputationPoints // ignore: cast_nullable_to_non_nullable
as int,storiesPublished: null == storiesPublished ? _self.storiesPublished : storiesPublished // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,accuracyRate: null == accuracyRate ? _self.accuracyRate : accuracyRate // ignore: cast_nullable_to_non_nullable
as double,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatorProfile].
extension CreatorProfilePatterns on CreatorProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatorProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatorProfile value)  $default,){
final _that = this;
switch (_that) {
case _CreatorProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatorProfile value)?  $default,){
final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'creator_level')  CreatorLevel creatorLevel, @JsonKey(name: 'reputation_points')  int reputationPoints, @JsonKey(name: 'stories_published')  int storiesPublished,  List<String> badges, @JsonKey(name: 'accuracy_rate')  double accuracyRate, @JsonKey(name: 'joined_at')  DateTime? joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.creatorLevel,_that.reputationPoints,_that.storiesPublished,_that.badges,_that.accuracyRate,_that.joinedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'creator_level')  CreatorLevel creatorLevel, @JsonKey(name: 'reputation_points')  int reputationPoints, @JsonKey(name: 'stories_published')  int storiesPublished,  List<String> badges, @JsonKey(name: 'accuracy_rate')  double accuracyRate, @JsonKey(name: 'joined_at')  DateTime? joinedAt)  $default,) {final _that = this;
switch (_that) {
case _CreatorProfile():
return $default(_that.id,_that.name,_that.avatarUrl,_that.creatorLevel,_that.reputationPoints,_that.storiesPublished,_that.badges,_that.accuracyRate,_that.joinedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'creator_level')  CreatorLevel creatorLevel, @JsonKey(name: 'reputation_points')  int reputationPoints, @JsonKey(name: 'stories_published')  int storiesPublished,  List<String> badges, @JsonKey(name: 'accuracy_rate')  double accuracyRate, @JsonKey(name: 'joined_at')  DateTime? joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _CreatorProfile() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.creatorLevel,_that.reputationPoints,_that.storiesPublished,_that.badges,_that.accuracyRate,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatorProfile implements CreatorProfile {
  const _CreatorProfile({required this.id, required this.name, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'creator_level') this.creatorLevel = CreatorLevel.basicCreator, @JsonKey(name: 'reputation_points') this.reputationPoints = 0, @JsonKey(name: 'stories_published') this.storiesPublished = 0, final  List<String> badges = const [], @JsonKey(name: 'accuracy_rate') this.accuracyRate = 0.0, @JsonKey(name: 'joined_at') this.joinedAt}): _badges = badges;
  factory _CreatorProfile.fromJson(Map<String, dynamic> json) => _$CreatorProfileFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'creator_level') final  CreatorLevel creatorLevel;
@override@JsonKey(name: 'reputation_points') final  int reputationPoints;
@override@JsonKey(name: 'stories_published') final  int storiesPublished;
 final  List<String> _badges;
@override@JsonKey() List<String> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override@JsonKey(name: 'accuracy_rate') final  double accuracyRate;
@override@JsonKey(name: 'joined_at') final  DateTime? joinedAt;

/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatorProfileCopyWith<_CreatorProfile> get copyWith => __$CreatorProfileCopyWithImpl<_CreatorProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatorProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatorProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.reputationPoints, reputationPoints) || other.reputationPoints == reputationPoints)&&(identical(other.storiesPublished, storiesPublished) || other.storiesPublished == storiesPublished)&&const DeepCollectionEquality().equals(other._badges, _badges)&&(identical(other.accuracyRate, accuracyRate) || other.accuracyRate == accuracyRate)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,creatorLevel,reputationPoints,storiesPublished,const DeepCollectionEquality().hash(_badges),accuracyRate,joinedAt);

@override
String toString() {
  return 'CreatorProfile(id: $id, name: $name, avatarUrl: $avatarUrl, creatorLevel: $creatorLevel, reputationPoints: $reputationPoints, storiesPublished: $storiesPublished, badges: $badges, accuracyRate: $accuracyRate, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$CreatorProfileCopyWith<$Res> implements $CreatorProfileCopyWith<$Res> {
  factory _$CreatorProfileCopyWith(_CreatorProfile value, $Res Function(_CreatorProfile) _then) = __$CreatorProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'creator_level') CreatorLevel creatorLevel,@JsonKey(name: 'reputation_points') int reputationPoints,@JsonKey(name: 'stories_published') int storiesPublished, List<String> badges,@JsonKey(name: 'accuracy_rate') double accuracyRate,@JsonKey(name: 'joined_at') DateTime? joinedAt
});




}
/// @nodoc
class __$CreatorProfileCopyWithImpl<$Res>
    implements _$CreatorProfileCopyWith<$Res> {
  __$CreatorProfileCopyWithImpl(this._self, this._then);

  final _CreatorProfile _self;
  final $Res Function(_CreatorProfile) _then;

/// Create a copy of CreatorProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? creatorLevel = null,Object? reputationPoints = null,Object? storiesPublished = null,Object? badges = null,Object? accuracyRate = null,Object? joinedAt = freezed,}) {
  return _then(_CreatorProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: null == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as CreatorLevel,reputationPoints: null == reputationPoints ? _self.reputationPoints : reputationPoints // ignore: cast_nullable_to_non_nullable
as int,storiesPublished: null == storiesPublished ? _self.storiesPublished : storiesPublished // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,accuracyRate: null == accuracyRate ? _self.accuracyRate : accuracyRate // ignore: cast_nullable_to_non_nullable
as double,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

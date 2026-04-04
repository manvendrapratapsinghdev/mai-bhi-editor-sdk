// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String get name; String get email;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'creator_level') CreatorLevel get creatorLevel;@JsonKey(name: 'reputation_points') int get reputationPoints; String? get city;@JsonKey(name: 'stories_published') int get storiesPublished; List<String> get badges;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.reputationPoints, reputationPoints) || other.reputationPoints == reputationPoints)&&(identical(other.city, city) || other.city == city)&&(identical(other.storiesPublished, storiesPublished) || other.storiesPublished == storiesPublished)&&const DeepCollectionEquality().equals(other.badges, badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,creatorLevel,reputationPoints,city,storiesPublished,const DeepCollectionEquality().hash(badges));

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, creatorLevel: $creatorLevel, reputationPoints: $reputationPoints, city: $city, storiesPublished: $storiesPublished, badges: $badges)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'creator_level') CreatorLevel creatorLevel,@JsonKey(name: 'reputation_points') int reputationPoints, String? city,@JsonKey(name: 'stories_published') int storiesPublished, List<String> badges
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? avatarUrl = freezed,Object? creatorLevel = null,Object? reputationPoints = null,Object? city = freezed,Object? storiesPublished = null,Object? badges = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: null == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as CreatorLevel,reputationPoints: null == reputationPoints ? _self.reputationPoints : reputationPoints // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,storiesPublished: null == storiesPublished ? _self.storiesPublished : storiesPublished // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'creator_level')  CreatorLevel creatorLevel, @JsonKey(name: 'reputation_points')  int reputationPoints,  String? city, @JsonKey(name: 'stories_published')  int storiesPublished,  List<String> badges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.creatorLevel,_that.reputationPoints,_that.city,_that.storiesPublished,_that.badges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'creator_level')  CreatorLevel creatorLevel, @JsonKey(name: 'reputation_points')  int reputationPoints,  String? city, @JsonKey(name: 'stories_published')  int storiesPublished,  List<String> badges)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.creatorLevel,_that.reputationPoints,_that.city,_that.storiesPublished,_that.badges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'creator_level')  CreatorLevel creatorLevel, @JsonKey(name: 'reputation_points')  int reputationPoints,  String? city, @JsonKey(name: 'stories_published')  int storiesPublished,  List<String> badges)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.creatorLevel,_that.reputationPoints,_that.city,_that.storiesPublished,_that.badges);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, required this.name, required this.email, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'creator_level') this.creatorLevel = CreatorLevel.basicCreator, @JsonKey(name: 'reputation_points') this.reputationPoints = 0, this.city, @JsonKey(name: 'stories_published') this.storiesPublished = 0, final  List<String> badges = const []}): _badges = badges;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'creator_level') final  CreatorLevel creatorLevel;
@override@JsonKey(name: 'reputation_points') final  int reputationPoints;
@override final  String? city;
@override@JsonKey(name: 'stories_published') final  int storiesPublished;
 final  List<String> _badges;
@override@JsonKey() List<String> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}


/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.reputationPoints, reputationPoints) || other.reputationPoints == reputationPoints)&&(identical(other.city, city) || other.city == city)&&(identical(other.storiesPublished, storiesPublished) || other.storiesPublished == storiesPublished)&&const DeepCollectionEquality().equals(other._badges, _badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,creatorLevel,reputationPoints,city,storiesPublished,const DeepCollectionEquality().hash(_badges));

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, creatorLevel: $creatorLevel, reputationPoints: $reputationPoints, city: $city, storiesPublished: $storiesPublished, badges: $badges)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'creator_level') CreatorLevel creatorLevel,@JsonKey(name: 'reputation_points') int reputationPoints, String? city,@JsonKey(name: 'stories_published') int storiesPublished, List<String> badges
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? avatarUrl = freezed,Object? creatorLevel = null,Object? reputationPoints = null,Object? city = freezed,Object? storiesPublished = null,Object? badges = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: null == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as CreatorLevel,reputationPoints: null == reputationPoints ? _self.reputationPoints : reputationPoints // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,storiesPublished: null == storiesPublished ? _self.storiesPublished : storiesPublished // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

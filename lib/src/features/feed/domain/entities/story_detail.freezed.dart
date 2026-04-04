// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryDetail {

 String get id; String get title; String get description; List<String> get images; CreatorProfile? get creator;@JsonKey(name: 'editor_verified') bool get editorVerified;@JsonKey(name: 'ai_verified') bool get aiVerified;@JsonKey(name: 'editor_name') String? get editorName; int get likes; int get confirmations; String? get city;@JsonKey(name: 'published_at') DateTime? get publishedAt;@JsonKey(name: 'user_has_confirmed') bool get userHasConfirmed;@JsonKey(name: 'user_has_liked') bool get userHasLiked;
/// Create a copy of StoryDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryDetailCopyWith<StoryDetail> get copyWith => _$StoryDetailCopyWithImpl<StoryDetail>(this as StoryDetail, _$identity);

  /// Serializes this StoryDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.editorVerified, editorVerified) || other.editorVerified == editorVerified)&&(identical(other.aiVerified, aiVerified) || other.aiVerified == aiVerified)&&(identical(other.editorName, editorName) || other.editorName == editorName)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.confirmations, confirmations) || other.confirmations == confirmations)&&(identical(other.city, city) || other.city == city)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.userHasConfirmed, userHasConfirmed) || other.userHasConfirmed == userHasConfirmed)&&(identical(other.userHasLiked, userHasLiked) || other.userHasLiked == userHasLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(images),creator,editorVerified,aiVerified,editorName,likes,confirmations,city,publishedAt,userHasConfirmed,userHasLiked);

@override
String toString() {
  return 'StoryDetail(id: $id, title: $title, description: $description, images: $images, creator: $creator, editorVerified: $editorVerified, aiVerified: $aiVerified, editorName: $editorName, likes: $likes, confirmations: $confirmations, city: $city, publishedAt: $publishedAt, userHasConfirmed: $userHasConfirmed, userHasLiked: $userHasLiked)';
}


}

/// @nodoc
abstract mixin class $StoryDetailCopyWith<$Res>  {
  factory $StoryDetailCopyWith(StoryDetail value, $Res Function(StoryDetail) _then) = _$StoryDetailCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, List<String> images, CreatorProfile? creator,@JsonKey(name: 'editor_verified') bool editorVerified,@JsonKey(name: 'ai_verified') bool aiVerified,@JsonKey(name: 'editor_name') String? editorName, int likes, int confirmations, String? city,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'user_has_confirmed') bool userHasConfirmed,@JsonKey(name: 'user_has_liked') bool userHasLiked
});


$CreatorProfileCopyWith<$Res>? get creator;

}
/// @nodoc
class _$StoryDetailCopyWithImpl<$Res>
    implements $StoryDetailCopyWith<$Res> {
  _$StoryDetailCopyWithImpl(this._self, this._then);

  final StoryDetail _self;
  final $Res Function(StoryDetail) _then;

/// Create a copy of StoryDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? images = null,Object? creator = freezed,Object? editorVerified = null,Object? aiVerified = null,Object? editorName = freezed,Object? likes = null,Object? confirmations = null,Object? city = freezed,Object? publishedAt = freezed,Object? userHasConfirmed = null,Object? userHasLiked = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as CreatorProfile?,editorVerified: null == editorVerified ? _self.editorVerified : editorVerified // ignore: cast_nullable_to_non_nullable
as bool,aiVerified: null == aiVerified ? _self.aiVerified : aiVerified // ignore: cast_nullable_to_non_nullable
as bool,editorName: freezed == editorName ? _self.editorName : editorName // ignore: cast_nullable_to_non_nullable
as String?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,confirmations: null == confirmations ? _self.confirmations : confirmations // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userHasConfirmed: null == userHasConfirmed ? _self.userHasConfirmed : userHasConfirmed // ignore: cast_nullable_to_non_nullable
as bool,userHasLiked: null == userHasLiked ? _self.userHasLiked : userHasLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of StoryDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatorProfileCopyWith<$Res>? get creator {
    if (_self.creator == null) {
    return null;
  }

  return $CreatorProfileCopyWith<$Res>(_self.creator!, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoryDetail].
extension StoryDetailPatterns on StoryDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryDetail value)  $default,){
final _that = this;
switch (_that) {
case _StoryDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryDetail value)?  $default,){
final _that = this;
switch (_that) {
case _StoryDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> images,  CreatorProfile? creator, @JsonKey(name: 'editor_verified')  bool editorVerified, @JsonKey(name: 'ai_verified')  bool aiVerified, @JsonKey(name: 'editor_name')  String? editorName,  int likes,  int confirmations,  String? city, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'user_has_confirmed')  bool userHasConfirmed, @JsonKey(name: 'user_has_liked')  bool userHasLiked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.images,_that.creator,_that.editorVerified,_that.aiVerified,_that.editorName,_that.likes,_that.confirmations,_that.city,_that.publishedAt,_that.userHasConfirmed,_that.userHasLiked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> images,  CreatorProfile? creator, @JsonKey(name: 'editor_verified')  bool editorVerified, @JsonKey(name: 'ai_verified')  bool aiVerified, @JsonKey(name: 'editor_name')  String? editorName,  int likes,  int confirmations,  String? city, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'user_has_confirmed')  bool userHasConfirmed, @JsonKey(name: 'user_has_liked')  bool userHasLiked)  $default,) {final _that = this;
switch (_that) {
case _StoryDetail():
return $default(_that.id,_that.title,_that.description,_that.images,_that.creator,_that.editorVerified,_that.aiVerified,_that.editorName,_that.likes,_that.confirmations,_that.city,_that.publishedAt,_that.userHasConfirmed,_that.userHasLiked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  List<String> images,  CreatorProfile? creator, @JsonKey(name: 'editor_verified')  bool editorVerified, @JsonKey(name: 'ai_verified')  bool aiVerified, @JsonKey(name: 'editor_name')  String? editorName,  int likes,  int confirmations,  String? city, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'user_has_confirmed')  bool userHasConfirmed, @JsonKey(name: 'user_has_liked')  bool userHasLiked)?  $default,) {final _that = this;
switch (_that) {
case _StoryDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.images,_that.creator,_that.editorVerified,_that.aiVerified,_that.editorName,_that.likes,_that.confirmations,_that.city,_that.publishedAt,_that.userHasConfirmed,_that.userHasLiked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoryDetail implements StoryDetail {
  const _StoryDetail({required this.id, required this.title, required this.description, final  List<String> images = const [], this.creator, @JsonKey(name: 'editor_verified') this.editorVerified = false, @JsonKey(name: 'ai_verified') this.aiVerified = false, @JsonKey(name: 'editor_name') this.editorName, this.likes = 0, this.confirmations = 0, this.city, @JsonKey(name: 'published_at') this.publishedAt, @JsonKey(name: 'user_has_confirmed') this.userHasConfirmed = false, @JsonKey(name: 'user_has_liked') this.userHasLiked = false}): _images = images;
  factory _StoryDetail.fromJson(Map<String, dynamic> json) => _$StoryDetailFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  CreatorProfile? creator;
@override@JsonKey(name: 'editor_verified') final  bool editorVerified;
@override@JsonKey(name: 'ai_verified') final  bool aiVerified;
@override@JsonKey(name: 'editor_name') final  String? editorName;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int confirmations;
@override final  String? city;
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;
@override@JsonKey(name: 'user_has_confirmed') final  bool userHasConfirmed;
@override@JsonKey(name: 'user_has_liked') final  bool userHasLiked;

/// Create a copy of StoryDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryDetailCopyWith<_StoryDetail> get copyWith => __$StoryDetailCopyWithImpl<_StoryDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.editorVerified, editorVerified) || other.editorVerified == editorVerified)&&(identical(other.aiVerified, aiVerified) || other.aiVerified == aiVerified)&&(identical(other.editorName, editorName) || other.editorName == editorName)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.confirmations, confirmations) || other.confirmations == confirmations)&&(identical(other.city, city) || other.city == city)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.userHasConfirmed, userHasConfirmed) || other.userHasConfirmed == userHasConfirmed)&&(identical(other.userHasLiked, userHasLiked) || other.userHasLiked == userHasLiked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_images),creator,editorVerified,aiVerified,editorName,likes,confirmations,city,publishedAt,userHasConfirmed,userHasLiked);

@override
String toString() {
  return 'StoryDetail(id: $id, title: $title, description: $description, images: $images, creator: $creator, editorVerified: $editorVerified, aiVerified: $aiVerified, editorName: $editorName, likes: $likes, confirmations: $confirmations, city: $city, publishedAt: $publishedAt, userHasConfirmed: $userHasConfirmed, userHasLiked: $userHasLiked)';
}


}

/// @nodoc
abstract mixin class _$StoryDetailCopyWith<$Res> implements $StoryDetailCopyWith<$Res> {
  factory _$StoryDetailCopyWith(_StoryDetail value, $Res Function(_StoryDetail) _then) = __$StoryDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, List<String> images, CreatorProfile? creator,@JsonKey(name: 'editor_verified') bool editorVerified,@JsonKey(name: 'ai_verified') bool aiVerified,@JsonKey(name: 'editor_name') String? editorName, int likes, int confirmations, String? city,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'user_has_confirmed') bool userHasConfirmed,@JsonKey(name: 'user_has_liked') bool userHasLiked
});


@override $CreatorProfileCopyWith<$Res>? get creator;

}
/// @nodoc
class __$StoryDetailCopyWithImpl<$Res>
    implements _$StoryDetailCopyWith<$Res> {
  __$StoryDetailCopyWithImpl(this._self, this._then);

  final _StoryDetail _self;
  final $Res Function(_StoryDetail) _then;

/// Create a copy of StoryDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? images = null,Object? creator = freezed,Object? editorVerified = null,Object? aiVerified = null,Object? editorName = freezed,Object? likes = null,Object? confirmations = null,Object? city = freezed,Object? publishedAt = freezed,Object? userHasConfirmed = null,Object? userHasLiked = null,}) {
  return _then(_StoryDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as CreatorProfile?,editorVerified: null == editorVerified ? _self.editorVerified : editorVerified // ignore: cast_nullable_to_non_nullable
as bool,aiVerified: null == aiVerified ? _self.aiVerified : aiVerified // ignore: cast_nullable_to_non_nullable
as bool,editorName: freezed == editorName ? _self.editorName : editorName // ignore: cast_nullable_to_non_nullable
as String?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,confirmations: null == confirmations ? _self.confirmations : confirmations // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userHasConfirmed: null == userHasConfirmed ? _self.userHasConfirmed : userHasConfirmed // ignore: cast_nullable_to_non_nullable
as bool,userHasLiked: null == userHasLiked ? _self.userHasLiked : userHasLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of StoryDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatorProfileCopyWith<$Res>? get creator {
    if (_self.creator == null) {
    return null;
  }

  return $CreatorProfileCopyWith<$Res>(_self.creator!, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}

// dart format on

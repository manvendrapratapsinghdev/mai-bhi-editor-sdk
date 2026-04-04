// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedItem {

 String get id; String get title;@JsonKey(name: 'cover_image_url') String? get coverImageUrl;@JsonKey(name: 'creator_name') String? get creatorName;@JsonKey(name: 'creator_level') String? get creatorLevel; int get likes; int get confirmations; String? get city;@JsonKey(name: 'published_at') DateTime? get publishedAt;
/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedItemCopyWith<FeedItem> get copyWith => _$FeedItemCopyWithImpl<FeedItem>(this as FeedItem, _$identity);

  /// Serializes this FeedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.confirmations, confirmations) || other.confirmations == confirmations)&&(identical(other.city, city) || other.city == city)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,coverImageUrl,creatorName,creatorLevel,likes,confirmations,city,publishedAt);

@override
String toString() {
  return 'FeedItem(id: $id, title: $title, coverImageUrl: $coverImageUrl, creatorName: $creatorName, creatorLevel: $creatorLevel, likes: $likes, confirmations: $confirmations, city: $city, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $FeedItemCopyWith<$Res>  {
  factory $FeedItemCopyWith(FeedItem value, $Res Function(FeedItem) _then) = _$FeedItemCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'creator_name') String? creatorName,@JsonKey(name: 'creator_level') String? creatorLevel, int likes, int confirmations, String? city,@JsonKey(name: 'published_at') DateTime? publishedAt
});




}
/// @nodoc
class _$FeedItemCopyWithImpl<$Res>
    implements $FeedItemCopyWith<$Res> {
  _$FeedItemCopyWithImpl(this._self, this._then);

  final FeedItem _self;
  final $Res Function(FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? coverImageUrl = freezed,Object? creatorName = freezed,Object? creatorLevel = freezed,Object? likes = null,Object? confirmations = null,Object? city = freezed,Object? publishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: freezed == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as String?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,confirmations: null == confirmations ? _self.confirmations : confirmations // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedItem].
extension FeedItemPatterns on FeedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedItem value)  $default,){
final _that = this;
switch (_that) {
case _FeedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedItem value)?  $default,){
final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'creator_name')  String? creatorName, @JsonKey(name: 'creator_level')  String? creatorLevel,  int likes,  int confirmations,  String? city, @JsonKey(name: 'published_at')  DateTime? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.id,_that.title,_that.coverImageUrl,_that.creatorName,_that.creatorLevel,_that.likes,_that.confirmations,_that.city,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'creator_name')  String? creatorName, @JsonKey(name: 'creator_level')  String? creatorLevel,  int likes,  int confirmations,  String? city, @JsonKey(name: 'published_at')  DateTime? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _FeedItem():
return $default(_that.id,_that.title,_that.coverImageUrl,_that.creatorName,_that.creatorLevel,_that.likes,_that.confirmations,_that.city,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'creator_name')  String? creatorName, @JsonKey(name: 'creator_level')  String? creatorLevel,  int likes,  int confirmations,  String? city, @JsonKey(name: 'published_at')  DateTime? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _FeedItem() when $default != null:
return $default(_that.id,_that.title,_that.coverImageUrl,_that.creatorName,_that.creatorLevel,_that.likes,_that.confirmations,_that.city,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedItem implements FeedItem {
  const _FeedItem({required this.id, required this.title, @JsonKey(name: 'cover_image_url') this.coverImageUrl, @JsonKey(name: 'creator_name') this.creatorName, @JsonKey(name: 'creator_level') this.creatorLevel, this.likes = 0, this.confirmations = 0, this.city, @JsonKey(name: 'published_at') this.publishedAt});
  factory _FeedItem.fromJson(Map<String, dynamic> json) => _$FeedItemFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'cover_image_url') final  String? coverImageUrl;
@override@JsonKey(name: 'creator_name') final  String? creatorName;
@override@JsonKey(name: 'creator_level') final  String? creatorLevel;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int confirmations;
@override final  String? city;
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedItemCopyWith<_FeedItem> get copyWith => __$FeedItemCopyWithImpl<_FeedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.creatorLevel, creatorLevel) || other.creatorLevel == creatorLevel)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.confirmations, confirmations) || other.confirmations == confirmations)&&(identical(other.city, city) || other.city == city)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,coverImageUrl,creatorName,creatorLevel,likes,confirmations,city,publishedAt);

@override
String toString() {
  return 'FeedItem(id: $id, title: $title, coverImageUrl: $coverImageUrl, creatorName: $creatorName, creatorLevel: $creatorLevel, likes: $likes, confirmations: $confirmations, city: $city, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$FeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory _$FeedItemCopyWith(_FeedItem value, $Res Function(_FeedItem) _then) = __$FeedItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'creator_name') String? creatorName,@JsonKey(name: 'creator_level') String? creatorLevel, int likes, int confirmations, String? city,@JsonKey(name: 'published_at') DateTime? publishedAt
});




}
/// @nodoc
class __$FeedItemCopyWithImpl<$Res>
    implements _$FeedItemCopyWith<$Res> {
  __$FeedItemCopyWithImpl(this._self, this._then);

  final _FeedItem _self;
  final $Res Function(_FeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? coverImageUrl = freezed,Object? creatorName = freezed,Object? creatorLevel = freezed,Object? likes = null,Object? confirmations = null,Object? city = freezed,Object? publishedAt = freezed,}) {
  return _then(_FeedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,creatorLevel: freezed == creatorLevel ? _self.creatorLevel : creatorLevel // ignore: cast_nullable_to_non_nullable
as String?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,confirmations: null == confirmations ? _self.confirmations : confirmations // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Submission {

 String get id; String get title; String get description; String get city; SubmissionStatus get status;@JsonKey(name: 'cover_image_url') String? get coverImageUrl;@JsonKey(name: 'created_at') DateTime? get createdAt; UserProfile? get creator;
/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionCopyWith<Submission> get copyWith => _$SubmissionCopyWithImpl<Submission>(this as Submission, _$identity);

  /// Serializes this Submission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submission&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.creator, creator) || other.creator == creator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,city,status,coverImageUrl,createdAt,creator);

@override
String toString() {
  return 'Submission(id: $id, title: $title, description: $description, city: $city, status: $status, coverImageUrl: $coverImageUrl, createdAt: $createdAt, creator: $creator)';
}


}

/// @nodoc
abstract mixin class $SubmissionCopyWith<$Res>  {
  factory $SubmissionCopyWith(Submission value, $Res Function(Submission) _then) = _$SubmissionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String city, SubmissionStatus status,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'created_at') DateTime? createdAt, UserProfile? creator
});


$UserProfileCopyWith<$Res>? get creator;

}
/// @nodoc
class _$SubmissionCopyWithImpl<$Res>
    implements $SubmissionCopyWith<$Res> {
  _$SubmissionCopyWithImpl(this._self, this._then);

  final Submission _self;
  final $Res Function(Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? city = null,Object? status = null,Object? coverImageUrl = freezed,Object? createdAt = freezed,Object? creator = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubmissionStatus,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as UserProfile?,
  ));
}
/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get creator {
    if (_self.creator == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.creator!, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// Adds pattern-matching-related methods to [Submission].
extension SubmissionPatterns on Submission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Submission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Submission value)  $default,){
final _that = this;
switch (_that) {
case _Submission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Submission value)?  $default,){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String city,  SubmissionStatus status, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserProfile? creator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.city,_that.status,_that.coverImageUrl,_that.createdAt,_that.creator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String city,  SubmissionStatus status, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserProfile? creator)  $default,) {final _that = this;
switch (_that) {
case _Submission():
return $default(_that.id,_that.title,_that.description,_that.city,_that.status,_that.coverImageUrl,_that.createdAt,_that.creator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String city,  SubmissionStatus status, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserProfile? creator)?  $default,) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.city,_that.status,_that.coverImageUrl,_that.createdAt,_that.creator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Submission implements Submission {
  const _Submission({required this.id, required this.title, required this.description, required this.city, this.status = SubmissionStatus.inProgress, @JsonKey(name: 'cover_image_url') this.coverImageUrl, @JsonKey(name: 'created_at') this.createdAt, this.creator});
  factory _Submission.fromJson(Map<String, dynamic> json) => _$SubmissionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String city;
@override@JsonKey() final  SubmissionStatus status;
@override@JsonKey(name: 'cover_image_url') final  String? coverImageUrl;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override final  UserProfile? creator;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionCopyWith<_Submission> get copyWith => __$SubmissionCopyWithImpl<_Submission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submission&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.creator, creator) || other.creator == creator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,city,status,coverImageUrl,createdAt,creator);

@override
String toString() {
  return 'Submission(id: $id, title: $title, description: $description, city: $city, status: $status, coverImageUrl: $coverImageUrl, createdAt: $createdAt, creator: $creator)';
}


}

/// @nodoc
abstract mixin class _$SubmissionCopyWith<$Res> implements $SubmissionCopyWith<$Res> {
  factory _$SubmissionCopyWith(_Submission value, $Res Function(_Submission) _then) = __$SubmissionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String city, SubmissionStatus status,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'created_at') DateTime? createdAt, UserProfile? creator
});


@override $UserProfileCopyWith<$Res>? get creator;

}
/// @nodoc
class __$SubmissionCopyWithImpl<$Res>
    implements _$SubmissionCopyWith<$Res> {
  __$SubmissionCopyWithImpl(this._self, this._then);

  final _Submission _self;
  final $Res Function(_Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? city = null,Object? status = null,Object? coverImageUrl = freezed,Object? createdAt = freezed,Object? creator = freezed,}) {
  return _then(_Submission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubmissionStatus,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as UserProfile?,
  ));
}

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get creator {
    if (_self.creator == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.creator!, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}

// dart format on

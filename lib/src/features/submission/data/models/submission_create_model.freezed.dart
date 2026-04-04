// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_create_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmissionCreate {

 String get title; String get description; String get city; List<String> get tags;
/// Create a copy of SubmissionCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionCreateCopyWith<SubmissionCreate> get copyWith => _$SubmissionCreateCopyWithImpl<SubmissionCreate>(this as SubmissionCreate, _$identity);

  /// Serializes this SubmissionCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,city,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'SubmissionCreate(title: $title, description: $description, city: $city, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $SubmissionCreateCopyWith<$Res>  {
  factory $SubmissionCreateCopyWith(SubmissionCreate value, $Res Function(SubmissionCreate) _then) = _$SubmissionCreateCopyWithImpl;
@useResult
$Res call({
 String title, String description, String city, List<String> tags
});




}
/// @nodoc
class _$SubmissionCreateCopyWithImpl<$Res>
    implements $SubmissionCreateCopyWith<$Res> {
  _$SubmissionCreateCopyWithImpl(this._self, this._then);

  final SubmissionCreate _self;
  final $Res Function(SubmissionCreate) _then;

/// Create a copy of SubmissionCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? city = null,Object? tags = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmissionCreate].
extension SubmissionCreatePatterns on SubmissionCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionCreate value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionCreate value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  String city,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionCreate() when $default != null:
return $default(_that.title,_that.description,_that.city,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  String city,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _SubmissionCreate():
return $default(_that.title,_that.description,_that.city,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  String city,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionCreate() when $default != null:
return $default(_that.title,_that.description,_that.city,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmissionCreate implements SubmissionCreate {
  const _SubmissionCreate({required this.title, required this.description, required this.city, final  List<String> tags = const []}): _tags = tags;
  factory _SubmissionCreate.fromJson(Map<String, dynamic> json) => _$SubmissionCreateFromJson(json);

@override final  String title;
@override final  String description;
@override final  String city;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of SubmissionCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionCreateCopyWith<_SubmissionCreate> get copyWith => __$SubmissionCreateCopyWithImpl<_SubmissionCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,city,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'SubmissionCreate(title: $title, description: $description, city: $city, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$SubmissionCreateCopyWith<$Res> implements $SubmissionCreateCopyWith<$Res> {
  factory _$SubmissionCreateCopyWith(_SubmissionCreate value, $Res Function(_SubmissionCreate) _then) = __$SubmissionCreateCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String city, List<String> tags
});




}
/// @nodoc
class __$SubmissionCreateCopyWithImpl<$Res>
    implements _$SubmissionCreateCopyWith<$Res> {
  __$SubmissionCreateCopyWithImpl(this._self, this._then);

  final _SubmissionCreate _self;
  final $Res Function(_SubmissionCreate) _then;

/// Create a copy of SubmissionCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? city = null,Object? tags = null,}) {
  return _then(_SubmissionCreate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

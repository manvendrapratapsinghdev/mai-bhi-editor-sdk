// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confirmation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfirmationResult {

@JsonKey(name: 'story_id') String get storyId;@JsonKey(name: 'total_confirmations') int get totalConfirmations; bool get confirmed;
/// Create a copy of ConfirmationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmationResultCopyWith<ConfirmationResult> get copyWith => _$ConfirmationResultCopyWithImpl<ConfirmationResult>(this as ConfirmationResult, _$identity);

  /// Serializes this ConfirmationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmationResult&&(identical(other.storyId, storyId) || other.storyId == storyId)&&(identical(other.totalConfirmations, totalConfirmations) || other.totalConfirmations == totalConfirmations)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storyId,totalConfirmations,confirmed);

@override
String toString() {
  return 'ConfirmationResult(storyId: $storyId, totalConfirmations: $totalConfirmations, confirmed: $confirmed)';
}


}

/// @nodoc
abstract mixin class $ConfirmationResultCopyWith<$Res>  {
  factory $ConfirmationResultCopyWith(ConfirmationResult value, $Res Function(ConfirmationResult) _then) = _$ConfirmationResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'story_id') String storyId,@JsonKey(name: 'total_confirmations') int totalConfirmations, bool confirmed
});




}
/// @nodoc
class _$ConfirmationResultCopyWithImpl<$Res>
    implements $ConfirmationResultCopyWith<$Res> {
  _$ConfirmationResultCopyWithImpl(this._self, this._then);

  final ConfirmationResult _self;
  final $Res Function(ConfirmationResult) _then;

/// Create a copy of ConfirmationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storyId = null,Object? totalConfirmations = null,Object? confirmed = null,}) {
  return _then(_self.copyWith(
storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,totalConfirmations: null == totalConfirmations ? _self.totalConfirmations : totalConfirmations // ignore: cast_nullable_to_non_nullable
as int,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfirmationResult].
extension ConfirmationResultPatterns on ConfirmationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfirmationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfirmationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfirmationResult value)  $default,){
final _that = this;
switch (_that) {
case _ConfirmationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfirmationResult value)?  $default,){
final _that = this;
switch (_that) {
case _ConfirmationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'story_id')  String storyId, @JsonKey(name: 'total_confirmations')  int totalConfirmations,  bool confirmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfirmationResult() when $default != null:
return $default(_that.storyId,_that.totalConfirmations,_that.confirmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'story_id')  String storyId, @JsonKey(name: 'total_confirmations')  int totalConfirmations,  bool confirmed)  $default,) {final _that = this;
switch (_that) {
case _ConfirmationResult():
return $default(_that.storyId,_that.totalConfirmations,_that.confirmed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'story_id')  String storyId, @JsonKey(name: 'total_confirmations')  int totalConfirmations,  bool confirmed)?  $default,) {final _that = this;
switch (_that) {
case _ConfirmationResult() when $default != null:
return $default(_that.storyId,_that.totalConfirmations,_that.confirmed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfirmationResult implements ConfirmationResult {
  const _ConfirmationResult({@JsonKey(name: 'story_id') required this.storyId, @JsonKey(name: 'total_confirmations') this.totalConfirmations = 0, this.confirmed = false});
  factory _ConfirmationResult.fromJson(Map<String, dynamic> json) => _$ConfirmationResultFromJson(json);

@override@JsonKey(name: 'story_id') final  String storyId;
@override@JsonKey(name: 'total_confirmations') final  int totalConfirmations;
@override@JsonKey() final  bool confirmed;

/// Create a copy of ConfirmationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmationResultCopyWith<_ConfirmationResult> get copyWith => __$ConfirmationResultCopyWithImpl<_ConfirmationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfirmationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmationResult&&(identical(other.storyId, storyId) || other.storyId == storyId)&&(identical(other.totalConfirmations, totalConfirmations) || other.totalConfirmations == totalConfirmations)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storyId,totalConfirmations,confirmed);

@override
String toString() {
  return 'ConfirmationResult(storyId: $storyId, totalConfirmations: $totalConfirmations, confirmed: $confirmed)';
}


}

/// @nodoc
abstract mixin class _$ConfirmationResultCopyWith<$Res> implements $ConfirmationResultCopyWith<$Res> {
  factory _$ConfirmationResultCopyWith(_ConfirmationResult value, $Res Function(_ConfirmationResult) _then) = __$ConfirmationResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'story_id') String storyId,@JsonKey(name: 'total_confirmations') int totalConfirmations, bool confirmed
});




}
/// @nodoc
class __$ConfirmationResultCopyWithImpl<$Res>
    implements _$ConfirmationResultCopyWith<$Res> {
  __$ConfirmationResultCopyWithImpl(this._self, this._then);

  final _ConfirmationResult _self;
  final $Res Function(_ConfirmationResult) _then;

/// Create a copy of ConfirmationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storyId = null,Object? totalConfirmations = null,Object? confirmed = null,}) {
  return _then(_ConfirmationResult(
storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,totalConfirmations: null == totalConfirmations ? _self.totalConfirmations : totalConfirmations // ignore: cast_nullable_to_non_nullable
as int,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

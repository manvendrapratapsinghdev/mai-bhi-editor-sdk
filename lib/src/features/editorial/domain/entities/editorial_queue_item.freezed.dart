// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editorial_queue_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditorialQueueItem {

 SubmissionDetail get submission;@JsonKey(name: 'ai_confidence') double get aiConfidence;@JsonKey(name: 'community_confirmations') int get communityConfirmations;@JsonKey(name: 'priority_rank') int get priorityRank;
/// Create a copy of EditorialQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorialQueueItemCopyWith<EditorialQueueItem> get copyWith => _$EditorialQueueItemCopyWithImpl<EditorialQueueItem>(this as EditorialQueueItem, _$identity);

  /// Serializes this EditorialQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorialQueueItem&&(identical(other.submission, submission) || other.submission == submission)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.communityConfirmations, communityConfirmations) || other.communityConfirmations == communityConfirmations)&&(identical(other.priorityRank, priorityRank) || other.priorityRank == priorityRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,submission,aiConfidence,communityConfirmations,priorityRank);

@override
String toString() {
  return 'EditorialQueueItem(submission: $submission, aiConfidence: $aiConfidence, communityConfirmations: $communityConfirmations, priorityRank: $priorityRank)';
}


}

/// @nodoc
abstract mixin class $EditorialQueueItemCopyWith<$Res>  {
  factory $EditorialQueueItemCopyWith(EditorialQueueItem value, $Res Function(EditorialQueueItem) _then) = _$EditorialQueueItemCopyWithImpl;
@useResult
$Res call({
 SubmissionDetail submission,@JsonKey(name: 'ai_confidence') double aiConfidence,@JsonKey(name: 'community_confirmations') int communityConfirmations,@JsonKey(name: 'priority_rank') int priorityRank
});


$SubmissionDetailCopyWith<$Res> get submission;

}
/// @nodoc
class _$EditorialQueueItemCopyWithImpl<$Res>
    implements $EditorialQueueItemCopyWith<$Res> {
  _$EditorialQueueItemCopyWithImpl(this._self, this._then);

  final EditorialQueueItem _self;
  final $Res Function(EditorialQueueItem) _then;

/// Create a copy of EditorialQueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submission = null,Object? aiConfidence = null,Object? communityConfirmations = null,Object? priorityRank = null,}) {
  return _then(_self.copyWith(
submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as SubmissionDetail,aiConfidence: null == aiConfidence ? _self.aiConfidence : aiConfidence // ignore: cast_nullable_to_non_nullable
as double,communityConfirmations: null == communityConfirmations ? _self.communityConfirmations : communityConfirmations // ignore: cast_nullable_to_non_nullable
as int,priorityRank: null == priorityRank ? _self.priorityRank : priorityRank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of EditorialQueueItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionDetailCopyWith<$Res> get submission {
  
  return $SubmissionDetailCopyWith<$Res>(_self.submission, (value) {
    return _then(_self.copyWith(submission: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorialQueueItem].
extension EditorialQueueItemPatterns on EditorialQueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorialQueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorialQueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorialQueueItem value)  $default,){
final _that = this;
switch (_that) {
case _EditorialQueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorialQueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _EditorialQueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SubmissionDetail submission, @JsonKey(name: 'ai_confidence')  double aiConfidence, @JsonKey(name: 'community_confirmations')  int communityConfirmations, @JsonKey(name: 'priority_rank')  int priorityRank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorialQueueItem() when $default != null:
return $default(_that.submission,_that.aiConfidence,_that.communityConfirmations,_that.priorityRank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SubmissionDetail submission, @JsonKey(name: 'ai_confidence')  double aiConfidence, @JsonKey(name: 'community_confirmations')  int communityConfirmations, @JsonKey(name: 'priority_rank')  int priorityRank)  $default,) {final _that = this;
switch (_that) {
case _EditorialQueueItem():
return $default(_that.submission,_that.aiConfidence,_that.communityConfirmations,_that.priorityRank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SubmissionDetail submission, @JsonKey(name: 'ai_confidence')  double aiConfidence, @JsonKey(name: 'community_confirmations')  int communityConfirmations, @JsonKey(name: 'priority_rank')  int priorityRank)?  $default,) {final _that = this;
switch (_that) {
case _EditorialQueueItem() when $default != null:
return $default(_that.submission,_that.aiConfidence,_that.communityConfirmations,_that.priorityRank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditorialQueueItem implements EditorialQueueItem {
  const _EditorialQueueItem({required this.submission, @JsonKey(name: 'ai_confidence') this.aiConfidence = 0.0, @JsonKey(name: 'community_confirmations') this.communityConfirmations = 0, @JsonKey(name: 'priority_rank') this.priorityRank = 0});
  factory _EditorialQueueItem.fromJson(Map<String, dynamic> json) => _$EditorialQueueItemFromJson(json);

@override final  SubmissionDetail submission;
@override@JsonKey(name: 'ai_confidence') final  double aiConfidence;
@override@JsonKey(name: 'community_confirmations') final  int communityConfirmations;
@override@JsonKey(name: 'priority_rank') final  int priorityRank;

/// Create a copy of EditorialQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorialQueueItemCopyWith<_EditorialQueueItem> get copyWith => __$EditorialQueueItemCopyWithImpl<_EditorialQueueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditorialQueueItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorialQueueItem&&(identical(other.submission, submission) || other.submission == submission)&&(identical(other.aiConfidence, aiConfidence) || other.aiConfidence == aiConfidence)&&(identical(other.communityConfirmations, communityConfirmations) || other.communityConfirmations == communityConfirmations)&&(identical(other.priorityRank, priorityRank) || other.priorityRank == priorityRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,submission,aiConfidence,communityConfirmations,priorityRank);

@override
String toString() {
  return 'EditorialQueueItem(submission: $submission, aiConfidence: $aiConfidence, communityConfirmations: $communityConfirmations, priorityRank: $priorityRank)';
}


}

/// @nodoc
abstract mixin class _$EditorialQueueItemCopyWith<$Res> implements $EditorialQueueItemCopyWith<$Res> {
  factory _$EditorialQueueItemCopyWith(_EditorialQueueItem value, $Res Function(_EditorialQueueItem) _then) = __$EditorialQueueItemCopyWithImpl;
@override @useResult
$Res call({
 SubmissionDetail submission,@JsonKey(name: 'ai_confidence') double aiConfidence,@JsonKey(name: 'community_confirmations') int communityConfirmations,@JsonKey(name: 'priority_rank') int priorityRank
});


@override $SubmissionDetailCopyWith<$Res> get submission;

}
/// @nodoc
class __$EditorialQueueItemCopyWithImpl<$Res>
    implements _$EditorialQueueItemCopyWith<$Res> {
  __$EditorialQueueItemCopyWithImpl(this._self, this._then);

  final _EditorialQueueItem _self;
  final $Res Function(_EditorialQueueItem) _then;

/// Create a copy of EditorialQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submission = null,Object? aiConfidence = null,Object? communityConfirmations = null,Object? priorityRank = null,}) {
  return _then(_EditorialQueueItem(
submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as SubmissionDetail,aiConfidence: null == aiConfidence ? _self.aiConfidence : aiConfidence // ignore: cast_nullable_to_non_nullable
as double,communityConfirmations: null == communityConfirmations ? _self.communityConfirmations : communityConfirmations // ignore: cast_nullable_to_non_nullable
as int,priorityRank: null == priorityRank ? _self.priorityRank : priorityRank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of EditorialQueueItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionDetailCopyWith<$Res> get submission {
  
  return $SubmissionDetailCopyWith<$Res>(_self.submission, (value) {
    return _then(_self.copyWith(submission: value));
  });
}
}

// dart format on

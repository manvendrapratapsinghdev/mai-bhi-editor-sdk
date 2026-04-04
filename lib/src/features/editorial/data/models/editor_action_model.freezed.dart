// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_action_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditorAction {

 EditorActionType get action;@JsonKey(name: 'edited_title') String? get editedTitle;@JsonKey(name: 'edited_description') String? get editedDescription;@JsonKey(name: 'rejection_reason') String? get rejectionReason;@JsonKey(name: 'correction_notes') String? get correctionNotes;
/// Create a copy of EditorAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorActionCopyWith<EditorAction> get copyWith => _$EditorActionCopyWithImpl<EditorAction>(this as EditorAction, _$identity);

  /// Serializes this EditorAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorAction&&(identical(other.action, action) || other.action == action)&&(identical(other.editedTitle, editedTitle) || other.editedTitle == editedTitle)&&(identical(other.editedDescription, editedDescription) || other.editedDescription == editedDescription)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.correctionNotes, correctionNotes) || other.correctionNotes == correctionNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,editedTitle,editedDescription,rejectionReason,correctionNotes);

@override
String toString() {
  return 'EditorAction(action: $action, editedTitle: $editedTitle, editedDescription: $editedDescription, rejectionReason: $rejectionReason, correctionNotes: $correctionNotes)';
}


}

/// @nodoc
abstract mixin class $EditorActionCopyWith<$Res>  {
  factory $EditorActionCopyWith(EditorAction value, $Res Function(EditorAction) _then) = _$EditorActionCopyWithImpl;
@useResult
$Res call({
 EditorActionType action,@JsonKey(name: 'edited_title') String? editedTitle,@JsonKey(name: 'edited_description') String? editedDescription,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'correction_notes') String? correctionNotes
});




}
/// @nodoc
class _$EditorActionCopyWithImpl<$Res>
    implements $EditorActionCopyWith<$Res> {
  _$EditorActionCopyWithImpl(this._self, this._then);

  final EditorAction _self;
  final $Res Function(EditorAction) _then;

/// Create a copy of EditorAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? editedTitle = freezed,Object? editedDescription = freezed,Object? rejectionReason = freezed,Object? correctionNotes = freezed,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as EditorActionType,editedTitle: freezed == editedTitle ? _self.editedTitle : editedTitle // ignore: cast_nullable_to_non_nullable
as String?,editedDescription: freezed == editedDescription ? _self.editedDescription : editedDescription // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,correctionNotes: freezed == correctionNotes ? _self.correctionNotes : correctionNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditorAction].
extension EditorActionPatterns on EditorAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorAction value)  $default,){
final _that = this;
switch (_that) {
case _EditorAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorAction value)?  $default,){
final _that = this;
switch (_that) {
case _EditorAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EditorActionType action, @JsonKey(name: 'edited_title')  String? editedTitle, @JsonKey(name: 'edited_description')  String? editedDescription, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'correction_notes')  String? correctionNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorAction() when $default != null:
return $default(_that.action,_that.editedTitle,_that.editedDescription,_that.rejectionReason,_that.correctionNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EditorActionType action, @JsonKey(name: 'edited_title')  String? editedTitle, @JsonKey(name: 'edited_description')  String? editedDescription, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'correction_notes')  String? correctionNotes)  $default,) {final _that = this;
switch (_that) {
case _EditorAction():
return $default(_that.action,_that.editedTitle,_that.editedDescription,_that.rejectionReason,_that.correctionNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EditorActionType action, @JsonKey(name: 'edited_title')  String? editedTitle, @JsonKey(name: 'edited_description')  String? editedDescription, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'correction_notes')  String? correctionNotes)?  $default,) {final _that = this;
switch (_that) {
case _EditorAction() when $default != null:
return $default(_that.action,_that.editedTitle,_that.editedDescription,_that.rejectionReason,_that.correctionNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditorAction implements EditorAction {
  const _EditorAction({required this.action, @JsonKey(name: 'edited_title') this.editedTitle, @JsonKey(name: 'edited_description') this.editedDescription, @JsonKey(name: 'rejection_reason') this.rejectionReason, @JsonKey(name: 'correction_notes') this.correctionNotes});
  factory _EditorAction.fromJson(Map<String, dynamic> json) => _$EditorActionFromJson(json);

@override final  EditorActionType action;
@override@JsonKey(name: 'edited_title') final  String? editedTitle;
@override@JsonKey(name: 'edited_description') final  String? editedDescription;
@override@JsonKey(name: 'rejection_reason') final  String? rejectionReason;
@override@JsonKey(name: 'correction_notes') final  String? correctionNotes;

/// Create a copy of EditorAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorActionCopyWith<_EditorAction> get copyWith => __$EditorActionCopyWithImpl<_EditorAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditorActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorAction&&(identical(other.action, action) || other.action == action)&&(identical(other.editedTitle, editedTitle) || other.editedTitle == editedTitle)&&(identical(other.editedDescription, editedDescription) || other.editedDescription == editedDescription)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.correctionNotes, correctionNotes) || other.correctionNotes == correctionNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,editedTitle,editedDescription,rejectionReason,correctionNotes);

@override
String toString() {
  return 'EditorAction(action: $action, editedTitle: $editedTitle, editedDescription: $editedDescription, rejectionReason: $rejectionReason, correctionNotes: $correctionNotes)';
}


}

/// @nodoc
abstract mixin class _$EditorActionCopyWith<$Res> implements $EditorActionCopyWith<$Res> {
  factory _$EditorActionCopyWith(_EditorAction value, $Res Function(_EditorAction) _then) = __$EditorActionCopyWithImpl;
@override @useResult
$Res call({
 EditorActionType action,@JsonKey(name: 'edited_title') String? editedTitle,@JsonKey(name: 'edited_description') String? editedDescription,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'correction_notes') String? correctionNotes
});




}
/// @nodoc
class __$EditorActionCopyWithImpl<$Res>
    implements _$EditorActionCopyWith<$Res> {
  __$EditorActionCopyWithImpl(this._self, this._then);

  final _EditorAction _self;
  final $Res Function(_EditorAction) _then;

/// Create a copy of EditorAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? editedTitle = freezed,Object? editedDescription = freezed,Object? rejectionReason = freezed,Object? correctionNotes = freezed,}) {
  return _then(_EditorAction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as EditorActionType,editedTitle: freezed == editedTitle ? _self.editedTitle : editedTitle // ignore: cast_nullable_to_non_nullable
as String?,editedDescription: freezed == editedDescription ? _self.editedDescription : editedDescription // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,correctionNotes: freezed == correctionNotes ? _self.correctionNotes : correctionNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

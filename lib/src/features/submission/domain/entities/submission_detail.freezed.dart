// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmissionDetail {

 String get id; String get title; String get description; String get city; SubmissionStatus get status;@JsonKey(name: 'cover_image_url') String? get coverImageUrl;@JsonKey(name: 'created_at') DateTime? get createdAt; UserProfile? get creator;@JsonKey(name: 'original_text') String? get originalText;@JsonKey(name: 'ai_rewritten_text') String? get aiRewrittenText;@JsonKey(name: 'ai_review') AIReviewResult? get aiReview;@JsonKey(name: 'additional_images') List<String> get additionalImages;@JsonKey(name: 'editor_notes') String? get editorNotes;
/// Create a copy of SubmissionDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionDetailCopyWith<SubmissionDetail> get copyWith => _$SubmissionDetailCopyWithImpl<SubmissionDetail>(this as SubmissionDetail, _$identity);

  /// Serializes this SubmissionDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.aiRewrittenText, aiRewrittenText) || other.aiRewrittenText == aiRewrittenText)&&(identical(other.aiReview, aiReview) || other.aiReview == aiReview)&&const DeepCollectionEquality().equals(other.additionalImages, additionalImages)&&(identical(other.editorNotes, editorNotes) || other.editorNotes == editorNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,city,status,coverImageUrl,createdAt,creator,originalText,aiRewrittenText,aiReview,const DeepCollectionEquality().hash(additionalImages),editorNotes);

@override
String toString() {
  return 'SubmissionDetail(id: $id, title: $title, description: $description, city: $city, status: $status, coverImageUrl: $coverImageUrl, createdAt: $createdAt, creator: $creator, originalText: $originalText, aiRewrittenText: $aiRewrittenText, aiReview: $aiReview, additionalImages: $additionalImages, editorNotes: $editorNotes)';
}


}

/// @nodoc
abstract mixin class $SubmissionDetailCopyWith<$Res>  {
  factory $SubmissionDetailCopyWith(SubmissionDetail value, $Res Function(SubmissionDetail) _then) = _$SubmissionDetailCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String city, SubmissionStatus status,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'created_at') DateTime? createdAt, UserProfile? creator,@JsonKey(name: 'original_text') String? originalText,@JsonKey(name: 'ai_rewritten_text') String? aiRewrittenText,@JsonKey(name: 'ai_review') AIReviewResult? aiReview,@JsonKey(name: 'additional_images') List<String> additionalImages,@JsonKey(name: 'editor_notes') String? editorNotes
});


$UserProfileCopyWith<$Res>? get creator;$AIReviewResultCopyWith<$Res>? get aiReview;

}
/// @nodoc
class _$SubmissionDetailCopyWithImpl<$Res>
    implements $SubmissionDetailCopyWith<$Res> {
  _$SubmissionDetailCopyWithImpl(this._self, this._then);

  final SubmissionDetail _self;
  final $Res Function(SubmissionDetail) _then;

/// Create a copy of SubmissionDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? city = null,Object? status = null,Object? coverImageUrl = freezed,Object? createdAt = freezed,Object? creator = freezed,Object? originalText = freezed,Object? aiRewrittenText = freezed,Object? aiReview = freezed,Object? additionalImages = null,Object? editorNotes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubmissionStatus,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as UserProfile?,originalText: freezed == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String?,aiRewrittenText: freezed == aiRewrittenText ? _self.aiRewrittenText : aiRewrittenText // ignore: cast_nullable_to_non_nullable
as String?,aiReview: freezed == aiReview ? _self.aiReview : aiReview // ignore: cast_nullable_to_non_nullable
as AIReviewResult?,additionalImages: null == additionalImages ? _self.additionalImages : additionalImages // ignore: cast_nullable_to_non_nullable
as List<String>,editorNotes: freezed == editorNotes ? _self.editorNotes : editorNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SubmissionDetail
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
}/// Create a copy of SubmissionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AIReviewResultCopyWith<$Res>? get aiReview {
    if (_self.aiReview == null) {
    return null;
  }

  return $AIReviewResultCopyWith<$Res>(_self.aiReview!, (value) {
    return _then(_self.copyWith(aiReview: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubmissionDetail].
extension SubmissionDetailPatterns on SubmissionDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionDetail value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String city,  SubmissionStatus status, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserProfile? creator, @JsonKey(name: 'original_text')  String? originalText, @JsonKey(name: 'ai_rewritten_text')  String? aiRewrittenText, @JsonKey(name: 'ai_review')  AIReviewResult? aiReview, @JsonKey(name: 'additional_images')  List<String> additionalImages, @JsonKey(name: 'editor_notes')  String? editorNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.city,_that.status,_that.coverImageUrl,_that.createdAt,_that.creator,_that.originalText,_that.aiRewrittenText,_that.aiReview,_that.additionalImages,_that.editorNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String city,  SubmissionStatus status, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserProfile? creator, @JsonKey(name: 'original_text')  String? originalText, @JsonKey(name: 'ai_rewritten_text')  String? aiRewrittenText, @JsonKey(name: 'ai_review')  AIReviewResult? aiReview, @JsonKey(name: 'additional_images')  List<String> additionalImages, @JsonKey(name: 'editor_notes')  String? editorNotes)  $default,) {final _that = this;
switch (_that) {
case _SubmissionDetail():
return $default(_that.id,_that.title,_that.description,_that.city,_that.status,_that.coverImageUrl,_that.createdAt,_that.creator,_that.originalText,_that.aiRewrittenText,_that.aiReview,_that.additionalImages,_that.editorNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String city,  SubmissionStatus status, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'created_at')  DateTime? createdAt,  UserProfile? creator, @JsonKey(name: 'original_text')  String? originalText, @JsonKey(name: 'ai_rewritten_text')  String? aiRewrittenText, @JsonKey(name: 'ai_review')  AIReviewResult? aiReview, @JsonKey(name: 'additional_images')  List<String> additionalImages, @JsonKey(name: 'editor_notes')  String? editorNotes)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.city,_that.status,_that.coverImageUrl,_that.createdAt,_that.creator,_that.originalText,_that.aiRewrittenText,_that.aiReview,_that.additionalImages,_that.editorNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmissionDetail implements SubmissionDetail {
  const _SubmissionDetail({required this.id, required this.title, required this.description, required this.city, this.status = SubmissionStatus.inProgress, @JsonKey(name: 'cover_image_url') this.coverImageUrl, @JsonKey(name: 'created_at') this.createdAt, this.creator, @JsonKey(name: 'original_text') this.originalText, @JsonKey(name: 'ai_rewritten_text') this.aiRewrittenText, @JsonKey(name: 'ai_review') this.aiReview, @JsonKey(name: 'additional_images') final  List<String> additionalImages = const [], @JsonKey(name: 'editor_notes') this.editorNotes}): _additionalImages = additionalImages;
  factory _SubmissionDetail.fromJson(Map<String, dynamic> json) => _$SubmissionDetailFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String city;
@override@JsonKey() final  SubmissionStatus status;
@override@JsonKey(name: 'cover_image_url') final  String? coverImageUrl;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override final  UserProfile? creator;
@override@JsonKey(name: 'original_text') final  String? originalText;
@override@JsonKey(name: 'ai_rewritten_text') final  String? aiRewrittenText;
@override@JsonKey(name: 'ai_review') final  AIReviewResult? aiReview;
 final  List<String> _additionalImages;
@override@JsonKey(name: 'additional_images') List<String> get additionalImages {
  if (_additionalImages is EqualUnmodifiableListView) return _additionalImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_additionalImages);
}

@override@JsonKey(name: 'editor_notes') final  String? editorNotes;

/// Create a copy of SubmissionDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionDetailCopyWith<_SubmissionDetail> get copyWith => __$SubmissionDetailCopyWithImpl<_SubmissionDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.aiRewrittenText, aiRewrittenText) || other.aiRewrittenText == aiRewrittenText)&&(identical(other.aiReview, aiReview) || other.aiReview == aiReview)&&const DeepCollectionEquality().equals(other._additionalImages, _additionalImages)&&(identical(other.editorNotes, editorNotes) || other.editorNotes == editorNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,city,status,coverImageUrl,createdAt,creator,originalText,aiRewrittenText,aiReview,const DeepCollectionEquality().hash(_additionalImages),editorNotes);

@override
String toString() {
  return 'SubmissionDetail(id: $id, title: $title, description: $description, city: $city, status: $status, coverImageUrl: $coverImageUrl, createdAt: $createdAt, creator: $creator, originalText: $originalText, aiRewrittenText: $aiRewrittenText, aiReview: $aiReview, additionalImages: $additionalImages, editorNotes: $editorNotes)';
}


}

/// @nodoc
abstract mixin class _$SubmissionDetailCopyWith<$Res> implements $SubmissionDetailCopyWith<$Res> {
  factory _$SubmissionDetailCopyWith(_SubmissionDetail value, $Res Function(_SubmissionDetail) _then) = __$SubmissionDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String city, SubmissionStatus status,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'created_at') DateTime? createdAt, UserProfile? creator,@JsonKey(name: 'original_text') String? originalText,@JsonKey(name: 'ai_rewritten_text') String? aiRewrittenText,@JsonKey(name: 'ai_review') AIReviewResult? aiReview,@JsonKey(name: 'additional_images') List<String> additionalImages,@JsonKey(name: 'editor_notes') String? editorNotes
});


@override $UserProfileCopyWith<$Res>? get creator;@override $AIReviewResultCopyWith<$Res>? get aiReview;

}
/// @nodoc
class __$SubmissionDetailCopyWithImpl<$Res>
    implements _$SubmissionDetailCopyWith<$Res> {
  __$SubmissionDetailCopyWithImpl(this._self, this._then);

  final _SubmissionDetail _self;
  final $Res Function(_SubmissionDetail) _then;

/// Create a copy of SubmissionDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? city = null,Object? status = null,Object? coverImageUrl = freezed,Object? createdAt = freezed,Object? creator = freezed,Object? originalText = freezed,Object? aiRewrittenText = freezed,Object? aiReview = freezed,Object? additionalImages = null,Object? editorNotes = freezed,}) {
  return _then(_SubmissionDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubmissionStatus,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as UserProfile?,originalText: freezed == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String?,aiRewrittenText: freezed == aiRewrittenText ? _self.aiRewrittenText : aiRewrittenText // ignore: cast_nullable_to_non_nullable
as String?,aiReview: freezed == aiReview ? _self.aiReview : aiReview // ignore: cast_nullable_to_non_nullable
as AIReviewResult?,additionalImages: null == additionalImages ? _self._additionalImages : additionalImages // ignore: cast_nullable_to_non_nullable
as List<String>,editorNotes: freezed == editorNotes ? _self.editorNotes : editorNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SubmissionDetail
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
}/// Create a copy of SubmissionDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AIReviewResultCopyWith<$Res>? get aiReview {
    if (_self.aiReview == null) {
    return null;
  }

  return $AIReviewResultCopyWith<$Res>(_self.aiReview!, (value) {
    return _then(_self.copyWith(aiReview: value));
  });
}
}

// dart format on

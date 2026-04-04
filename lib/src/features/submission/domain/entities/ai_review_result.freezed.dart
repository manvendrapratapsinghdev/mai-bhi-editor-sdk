// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_review_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIReviewResult {

@JsonKey(name: 'submission_id') String get submissionId;@JsonKey(name: 'rewritten_text') String? get rewrittenText;@JsonKey(name: 'safety_score') double get safetyScore;@JsonKey(name: 'confidence_score') double get confidenceScore;@JsonKey(name: 'suggested_tags') List<String> get suggestedTags;@JsonKey(name: 'suggested_category') String? get suggestedCategory;@JsonKey(name: 'hate_speech_detected') bool get hateSpeechDetected;@JsonKey(name: 'toxicity_detected') bool get toxicityDetected;@JsonKey(name: 'spam_detected') bool get spamDetected;@JsonKey(name: 'duplicate_of') String? get duplicateOf;@JsonKey(name: 'language_detected') String? get languageDetected;
/// Create a copy of AIReviewResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIReviewResultCopyWith<AIReviewResult> get copyWith => _$AIReviewResultCopyWithImpl<AIReviewResult>(this as AIReviewResult, _$identity);

  /// Serializes this AIReviewResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIReviewResult&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.rewrittenText, rewrittenText) || other.rewrittenText == rewrittenText)&&(identical(other.safetyScore, safetyScore) || other.safetyScore == safetyScore)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&const DeepCollectionEquality().equals(other.suggestedTags, suggestedTags)&&(identical(other.suggestedCategory, suggestedCategory) || other.suggestedCategory == suggestedCategory)&&(identical(other.hateSpeechDetected, hateSpeechDetected) || other.hateSpeechDetected == hateSpeechDetected)&&(identical(other.toxicityDetected, toxicityDetected) || other.toxicityDetected == toxicityDetected)&&(identical(other.spamDetected, spamDetected) || other.spamDetected == spamDetected)&&(identical(other.duplicateOf, duplicateOf) || other.duplicateOf == duplicateOf)&&(identical(other.languageDetected, languageDetected) || other.languageDetected == languageDetected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,submissionId,rewrittenText,safetyScore,confidenceScore,const DeepCollectionEquality().hash(suggestedTags),suggestedCategory,hateSpeechDetected,toxicityDetected,spamDetected,duplicateOf,languageDetected);

@override
String toString() {
  return 'AIReviewResult(submissionId: $submissionId, rewrittenText: $rewrittenText, safetyScore: $safetyScore, confidenceScore: $confidenceScore, suggestedTags: $suggestedTags, suggestedCategory: $suggestedCategory, hateSpeechDetected: $hateSpeechDetected, toxicityDetected: $toxicityDetected, spamDetected: $spamDetected, duplicateOf: $duplicateOf, languageDetected: $languageDetected)';
}


}

/// @nodoc
abstract mixin class $AIReviewResultCopyWith<$Res>  {
  factory $AIReviewResultCopyWith(AIReviewResult value, $Res Function(AIReviewResult) _then) = _$AIReviewResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'submission_id') String submissionId,@JsonKey(name: 'rewritten_text') String? rewrittenText,@JsonKey(name: 'safety_score') double safetyScore,@JsonKey(name: 'confidence_score') double confidenceScore,@JsonKey(name: 'suggested_tags') List<String> suggestedTags,@JsonKey(name: 'suggested_category') String? suggestedCategory,@JsonKey(name: 'hate_speech_detected') bool hateSpeechDetected,@JsonKey(name: 'toxicity_detected') bool toxicityDetected,@JsonKey(name: 'spam_detected') bool spamDetected,@JsonKey(name: 'duplicate_of') String? duplicateOf,@JsonKey(name: 'language_detected') String? languageDetected
});




}
/// @nodoc
class _$AIReviewResultCopyWithImpl<$Res>
    implements $AIReviewResultCopyWith<$Res> {
  _$AIReviewResultCopyWithImpl(this._self, this._then);

  final AIReviewResult _self;
  final $Res Function(AIReviewResult) _then;

/// Create a copy of AIReviewResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submissionId = null,Object? rewrittenText = freezed,Object? safetyScore = null,Object? confidenceScore = null,Object? suggestedTags = null,Object? suggestedCategory = freezed,Object? hateSpeechDetected = null,Object? toxicityDetected = null,Object? spamDetected = null,Object? duplicateOf = freezed,Object? languageDetected = freezed,}) {
  return _then(_self.copyWith(
submissionId: null == submissionId ? _self.submissionId : submissionId // ignore: cast_nullable_to_non_nullable
as String,rewrittenText: freezed == rewrittenText ? _self.rewrittenText : rewrittenText // ignore: cast_nullable_to_non_nullable
as String?,safetyScore: null == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as double,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,suggestedTags: null == suggestedTags ? _self.suggestedTags : suggestedTags // ignore: cast_nullable_to_non_nullable
as List<String>,suggestedCategory: freezed == suggestedCategory ? _self.suggestedCategory : suggestedCategory // ignore: cast_nullable_to_non_nullable
as String?,hateSpeechDetected: null == hateSpeechDetected ? _self.hateSpeechDetected : hateSpeechDetected // ignore: cast_nullable_to_non_nullable
as bool,toxicityDetected: null == toxicityDetected ? _self.toxicityDetected : toxicityDetected // ignore: cast_nullable_to_non_nullable
as bool,spamDetected: null == spamDetected ? _self.spamDetected : spamDetected // ignore: cast_nullable_to_non_nullable
as bool,duplicateOf: freezed == duplicateOf ? _self.duplicateOf : duplicateOf // ignore: cast_nullable_to_non_nullable
as String?,languageDetected: freezed == languageDetected ? _self.languageDetected : languageDetected // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIReviewResult].
extension AIReviewResultPatterns on AIReviewResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIReviewResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIReviewResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIReviewResult value)  $default,){
final _that = this;
switch (_that) {
case _AIReviewResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIReviewResult value)?  $default,){
final _that = this;
switch (_that) {
case _AIReviewResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'submission_id')  String submissionId, @JsonKey(name: 'rewritten_text')  String? rewrittenText, @JsonKey(name: 'safety_score')  double safetyScore, @JsonKey(name: 'confidence_score')  double confidenceScore, @JsonKey(name: 'suggested_tags')  List<String> suggestedTags, @JsonKey(name: 'suggested_category')  String? suggestedCategory, @JsonKey(name: 'hate_speech_detected')  bool hateSpeechDetected, @JsonKey(name: 'toxicity_detected')  bool toxicityDetected, @JsonKey(name: 'spam_detected')  bool spamDetected, @JsonKey(name: 'duplicate_of')  String? duplicateOf, @JsonKey(name: 'language_detected')  String? languageDetected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIReviewResult() when $default != null:
return $default(_that.submissionId,_that.rewrittenText,_that.safetyScore,_that.confidenceScore,_that.suggestedTags,_that.suggestedCategory,_that.hateSpeechDetected,_that.toxicityDetected,_that.spamDetected,_that.duplicateOf,_that.languageDetected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'submission_id')  String submissionId, @JsonKey(name: 'rewritten_text')  String? rewrittenText, @JsonKey(name: 'safety_score')  double safetyScore, @JsonKey(name: 'confidence_score')  double confidenceScore, @JsonKey(name: 'suggested_tags')  List<String> suggestedTags, @JsonKey(name: 'suggested_category')  String? suggestedCategory, @JsonKey(name: 'hate_speech_detected')  bool hateSpeechDetected, @JsonKey(name: 'toxicity_detected')  bool toxicityDetected, @JsonKey(name: 'spam_detected')  bool spamDetected, @JsonKey(name: 'duplicate_of')  String? duplicateOf, @JsonKey(name: 'language_detected')  String? languageDetected)  $default,) {final _that = this;
switch (_that) {
case _AIReviewResult():
return $default(_that.submissionId,_that.rewrittenText,_that.safetyScore,_that.confidenceScore,_that.suggestedTags,_that.suggestedCategory,_that.hateSpeechDetected,_that.toxicityDetected,_that.spamDetected,_that.duplicateOf,_that.languageDetected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'submission_id')  String submissionId, @JsonKey(name: 'rewritten_text')  String? rewrittenText, @JsonKey(name: 'safety_score')  double safetyScore, @JsonKey(name: 'confidence_score')  double confidenceScore, @JsonKey(name: 'suggested_tags')  List<String> suggestedTags, @JsonKey(name: 'suggested_category')  String? suggestedCategory, @JsonKey(name: 'hate_speech_detected')  bool hateSpeechDetected, @JsonKey(name: 'toxicity_detected')  bool toxicityDetected, @JsonKey(name: 'spam_detected')  bool spamDetected, @JsonKey(name: 'duplicate_of')  String? duplicateOf, @JsonKey(name: 'language_detected')  String? languageDetected)?  $default,) {final _that = this;
switch (_that) {
case _AIReviewResult() when $default != null:
return $default(_that.submissionId,_that.rewrittenText,_that.safetyScore,_that.confidenceScore,_that.suggestedTags,_that.suggestedCategory,_that.hateSpeechDetected,_that.toxicityDetected,_that.spamDetected,_that.duplicateOf,_that.languageDetected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIReviewResult implements AIReviewResult {
  const _AIReviewResult({@JsonKey(name: 'submission_id') required this.submissionId, @JsonKey(name: 'rewritten_text') this.rewrittenText, @JsonKey(name: 'safety_score') this.safetyScore = 0.0, @JsonKey(name: 'confidence_score') this.confidenceScore = 0.0, @JsonKey(name: 'suggested_tags') final  List<String> suggestedTags = const [], @JsonKey(name: 'suggested_category') this.suggestedCategory, @JsonKey(name: 'hate_speech_detected') this.hateSpeechDetected = false, @JsonKey(name: 'toxicity_detected') this.toxicityDetected = false, @JsonKey(name: 'spam_detected') this.spamDetected = false, @JsonKey(name: 'duplicate_of') this.duplicateOf, @JsonKey(name: 'language_detected') this.languageDetected}): _suggestedTags = suggestedTags;
  factory _AIReviewResult.fromJson(Map<String, dynamic> json) => _$AIReviewResultFromJson(json);

@override@JsonKey(name: 'submission_id') final  String submissionId;
@override@JsonKey(name: 'rewritten_text') final  String? rewrittenText;
@override@JsonKey(name: 'safety_score') final  double safetyScore;
@override@JsonKey(name: 'confidence_score') final  double confidenceScore;
 final  List<String> _suggestedTags;
@override@JsonKey(name: 'suggested_tags') List<String> get suggestedTags {
  if (_suggestedTags is EqualUnmodifiableListView) return _suggestedTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestedTags);
}

@override@JsonKey(name: 'suggested_category') final  String? suggestedCategory;
@override@JsonKey(name: 'hate_speech_detected') final  bool hateSpeechDetected;
@override@JsonKey(name: 'toxicity_detected') final  bool toxicityDetected;
@override@JsonKey(name: 'spam_detected') final  bool spamDetected;
@override@JsonKey(name: 'duplicate_of') final  String? duplicateOf;
@override@JsonKey(name: 'language_detected') final  String? languageDetected;

/// Create a copy of AIReviewResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIReviewResultCopyWith<_AIReviewResult> get copyWith => __$AIReviewResultCopyWithImpl<_AIReviewResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIReviewResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIReviewResult&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.rewrittenText, rewrittenText) || other.rewrittenText == rewrittenText)&&(identical(other.safetyScore, safetyScore) || other.safetyScore == safetyScore)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&const DeepCollectionEquality().equals(other._suggestedTags, _suggestedTags)&&(identical(other.suggestedCategory, suggestedCategory) || other.suggestedCategory == suggestedCategory)&&(identical(other.hateSpeechDetected, hateSpeechDetected) || other.hateSpeechDetected == hateSpeechDetected)&&(identical(other.toxicityDetected, toxicityDetected) || other.toxicityDetected == toxicityDetected)&&(identical(other.spamDetected, spamDetected) || other.spamDetected == spamDetected)&&(identical(other.duplicateOf, duplicateOf) || other.duplicateOf == duplicateOf)&&(identical(other.languageDetected, languageDetected) || other.languageDetected == languageDetected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,submissionId,rewrittenText,safetyScore,confidenceScore,const DeepCollectionEquality().hash(_suggestedTags),suggestedCategory,hateSpeechDetected,toxicityDetected,spamDetected,duplicateOf,languageDetected);

@override
String toString() {
  return 'AIReviewResult(submissionId: $submissionId, rewrittenText: $rewrittenText, safetyScore: $safetyScore, confidenceScore: $confidenceScore, suggestedTags: $suggestedTags, suggestedCategory: $suggestedCategory, hateSpeechDetected: $hateSpeechDetected, toxicityDetected: $toxicityDetected, spamDetected: $spamDetected, duplicateOf: $duplicateOf, languageDetected: $languageDetected)';
}


}

/// @nodoc
abstract mixin class _$AIReviewResultCopyWith<$Res> implements $AIReviewResultCopyWith<$Res> {
  factory _$AIReviewResultCopyWith(_AIReviewResult value, $Res Function(_AIReviewResult) _then) = __$AIReviewResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'submission_id') String submissionId,@JsonKey(name: 'rewritten_text') String? rewrittenText,@JsonKey(name: 'safety_score') double safetyScore,@JsonKey(name: 'confidence_score') double confidenceScore,@JsonKey(name: 'suggested_tags') List<String> suggestedTags,@JsonKey(name: 'suggested_category') String? suggestedCategory,@JsonKey(name: 'hate_speech_detected') bool hateSpeechDetected,@JsonKey(name: 'toxicity_detected') bool toxicityDetected,@JsonKey(name: 'spam_detected') bool spamDetected,@JsonKey(name: 'duplicate_of') String? duplicateOf,@JsonKey(name: 'language_detected') String? languageDetected
});




}
/// @nodoc
class __$AIReviewResultCopyWithImpl<$Res>
    implements _$AIReviewResultCopyWith<$Res> {
  __$AIReviewResultCopyWithImpl(this._self, this._then);

  final _AIReviewResult _self;
  final $Res Function(_AIReviewResult) _then;

/// Create a copy of AIReviewResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submissionId = null,Object? rewrittenText = freezed,Object? safetyScore = null,Object? confidenceScore = null,Object? suggestedTags = null,Object? suggestedCategory = freezed,Object? hateSpeechDetected = null,Object? toxicityDetected = null,Object? spamDetected = null,Object? duplicateOf = freezed,Object? languageDetected = freezed,}) {
  return _then(_AIReviewResult(
submissionId: null == submissionId ? _self.submissionId : submissionId // ignore: cast_nullable_to_non_nullable
as String,rewrittenText: freezed == rewrittenText ? _self.rewrittenText : rewrittenText // ignore: cast_nullable_to_non_nullable
as String?,safetyScore: null == safetyScore ? _self.safetyScore : safetyScore // ignore: cast_nullable_to_non_nullable
as double,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,suggestedTags: null == suggestedTags ? _self._suggestedTags : suggestedTags // ignore: cast_nullable_to_non_nullable
as List<String>,suggestedCategory: freezed == suggestedCategory ? _self.suggestedCategory : suggestedCategory // ignore: cast_nullable_to_non_nullable
as String?,hateSpeechDetected: null == hateSpeechDetected ? _self.hateSpeechDetected : hateSpeechDetected // ignore: cast_nullable_to_non_nullable
as bool,toxicityDetected: null == toxicityDetected ? _self.toxicityDetected : toxicityDetected // ignore: cast_nullable_to_non_nullable
as bool,spamDetected: null == spamDetected ? _self.spamDetected : spamDetected // ignore: cast_nullable_to_non_nullable
as bool,duplicateOf: freezed == duplicateOf ? _self.duplicateOf : duplicateOf // ignore: cast_nullable_to_non_nullable
as String?,languageDetected: freezed == languageDetected ? _self.languageDetected : languageDetected // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

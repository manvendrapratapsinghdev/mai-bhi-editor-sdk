import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_review_result.freezed.dart';
part 'ai_review_result.g.dart';

/// AI processing result for a submission.
@freezed
abstract class AIReviewResult with _$AIReviewResult {
  const factory AIReviewResult({
    @JsonKey(name: 'submission_id') required String submissionId,
    @JsonKey(name: 'rewritten_text') String? rewrittenText,
    @JsonKey(name: 'safety_score') @Default(0.0) double safetyScore,
    @JsonKey(name: 'confidence_score') @Default(0.0) double confidenceScore,
    @JsonKey(name: 'suggested_tags') @Default([]) List<String> suggestedTags,
    @JsonKey(name: 'suggested_category') String? suggestedCategory,
    @JsonKey(name: 'hate_speech_detected') @Default(false) bool hateSpeechDetected,
    @JsonKey(name: 'toxicity_detected') @Default(false) bool toxicityDetected,
    @JsonKey(name: 'spam_detected') @Default(false) bool spamDetected,
    @JsonKey(name: 'duplicate_of') String? duplicateOf,
    @JsonKey(name: 'language_detected') String? languageDetected,
  }) = _AIReviewResult;

  factory AIReviewResult.fromJson(Map<String, dynamic> json) =>
      _$AIReviewResultFromJson(json);
}

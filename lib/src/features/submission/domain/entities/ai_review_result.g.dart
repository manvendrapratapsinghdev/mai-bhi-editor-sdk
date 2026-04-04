// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_review_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AIReviewResult _$AIReviewResultFromJson(Map<String, dynamic> json) =>
    _AIReviewResult(
      submissionId: json['submission_id'] as String,
      rewrittenText: json['rewritten_text'] as String?,
      safetyScore: (json['safety_score'] as num?)?.toDouble() ?? 0.0,
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
      suggestedTags:
          (json['suggested_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      suggestedCategory: json['suggested_category'] as String?,
      hateSpeechDetected: json['hate_speech_detected'] as bool? ?? false,
      toxicityDetected: json['toxicity_detected'] as bool? ?? false,
      spamDetected: json['spam_detected'] as bool? ?? false,
      duplicateOf: json['duplicate_of'] as String?,
      languageDetected: json['language_detected'] as String?,
    );

Map<String, dynamic> _$AIReviewResultToJson(_AIReviewResult instance) =>
    <String, dynamic>{
      'submission_id': instance.submissionId,
      'rewritten_text': instance.rewrittenText,
      'safety_score': instance.safetyScore,
      'confidence_score': instance.confidenceScore,
      'suggested_tags': instance.suggestedTags,
      'suggested_category': instance.suggestedCategory,
      'hate_speech_detected': instance.hateSpeechDetected,
      'toxicity_detected': instance.toxicityDetected,
      'spam_detected': instance.spamDetected,
      'duplicate_of': instance.duplicateOf,
      'language_detected': instance.languageDetected,
    };

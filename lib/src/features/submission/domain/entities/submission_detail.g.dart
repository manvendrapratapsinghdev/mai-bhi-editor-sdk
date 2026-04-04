// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmissionDetail _$SubmissionDetailFromJson(Map<String, dynamic> json) =>
    _SubmissionDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      city: json['city'] as String,
      status:
          $enumDecodeNullable(_$SubmissionStatusEnumMap, json['status']) ??
          SubmissionStatus.inProgress,
      coverImageUrl: json['cover_image_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      creator: json['creator'] == null
          ? null
          : UserProfile.fromJson(json['creator'] as Map<String, dynamic>),
      originalText: json['original_text'] as String?,
      aiRewrittenText: json['ai_rewritten_text'] as String?,
      aiReview: json['ai_review'] == null
          ? null
          : AIReviewResult.fromJson(json['ai_review'] as Map<String, dynamic>),
      additionalImages:
          (json['additional_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      editorNotes: json['editor_notes'] as String?,
    );

Map<String, dynamic> _$SubmissionDetailToJson(_SubmissionDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'city': instance.city,
      'status': _$SubmissionStatusEnumMap[instance.status]!,
      'cover_image_url': instance.coverImageUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'creator': instance.creator,
      'original_text': instance.originalText,
      'ai_rewritten_text': instance.aiRewrittenText,
      'ai_review': instance.aiReview,
      'additional_images': instance.additionalImages,
      'editor_notes': instance.editorNotes,
    };

const _$SubmissionStatusEnumMap = {
  SubmissionStatus.inProgress: 'in_progress',
  SubmissionStatus.underReview: 'under_review',
  SubmissionStatus.published: 'published',
  SubmissionStatus.rejected: 'rejected',
};

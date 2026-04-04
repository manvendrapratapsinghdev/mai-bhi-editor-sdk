// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Submission _$SubmissionFromJson(Map<String, dynamic> json) => _Submission(
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
);

Map<String, dynamic> _$SubmissionToJson(_Submission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'city': instance.city,
      'status': _$SubmissionStatusEnumMap[instance.status]!,
      'cover_image_url': instance.coverImageUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'creator': instance.creator,
    };

const _$SubmissionStatusEnumMap = {
  SubmissionStatus.inProgress: 'in_progress',
  SubmissionStatus.underReview: 'under_review',
  SubmissionStatus.published: 'published',
  SubmissionStatus.rejected: 'rejected',
};

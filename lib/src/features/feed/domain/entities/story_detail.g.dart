// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryDetail _$StoryDetailFromJson(Map<String, dynamic> json) => _StoryDetail(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  creator: json['creator'] == null
      ? null
      : CreatorProfile.fromJson(json['creator'] as Map<String, dynamic>),
  editorVerified: json['editor_verified'] as bool? ?? false,
  aiVerified: json['ai_verified'] as bool? ?? false,
  editorName: json['editor_name'] as String?,
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  confirmations: (json['confirmations'] as num?)?.toInt() ?? 0,
  city: json['city'] as String?,
  publishedAt: json['published_at'] == null
      ? null
      : DateTime.parse(json['published_at'] as String),
  userHasConfirmed: json['user_has_confirmed'] as bool? ?? false,
  userHasLiked: json['user_has_liked'] as bool? ?? false,
);

Map<String, dynamic> _$StoryDetailToJson(_StoryDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'creator': instance.creator,
      'editor_verified': instance.editorVerified,
      'ai_verified': instance.aiVerified,
      'editor_name': instance.editorName,
      'likes': instance.likes,
      'confirmations': instance.confirmations,
      'city': instance.city,
      'published_at': instance.publishedAt?.toIso8601String(),
      'user_has_confirmed': instance.userHasConfirmed,
      'user_has_liked': instance.userHasLiked,
    };

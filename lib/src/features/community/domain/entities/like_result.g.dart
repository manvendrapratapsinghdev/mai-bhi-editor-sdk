// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LikeResult _$LikeResultFromJson(Map<String, dynamic> json) => _LikeResult(
  storyId: json['story_id'] as String,
  totalLikes: (json['total_likes'] as num?)?.toInt() ?? 0,
  liked: json['liked'] as bool? ?? false,
);

Map<String, dynamic> _$LikeResultToJson(_LikeResult instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'total_likes': instance.totalLikes,
      'liked': instance.liked,
    };

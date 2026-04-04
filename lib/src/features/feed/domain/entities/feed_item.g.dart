// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedItem _$FeedItemFromJson(Map<String, dynamic> json) => _FeedItem(
  id: json['id'] as String,
  title: json['title'] as String,
  coverImageUrl: json['cover_image_url'] as String?,
  creatorName: json['creator_name'] as String?,
  creatorLevel: json['creator_level'] as String?,
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  confirmations: (json['confirmations'] as num?)?.toInt() ?? 0,
  city: json['city'] as String?,
  publishedAt: json['published_at'] == null
      ? null
      : DateTime.parse(json['published_at'] as String),
);

Map<String, dynamic> _$FeedItemToJson(_FeedItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'cover_image_url': instance.coverImageUrl,
  'creator_name': instance.creatorName,
  'creator_level': instance.creatorLevel,
  'likes': instance.likes,
  'confirmations': instance.confirmations,
  'city': instance.city,
  'published_at': instance.publishedAt?.toIso8601String(),
};

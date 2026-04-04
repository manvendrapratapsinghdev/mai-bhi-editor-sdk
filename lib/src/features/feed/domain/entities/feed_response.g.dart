// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) =>
    _FeedResponse(
      stories:
          (json['stories'] as List<dynamic>?)
              ?.map((e) => FeedItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$FeedResponseToJson(_FeedResponse instance) =>
    <String, dynamic>{
      'stories': instance.stories,
      'next_cursor': instance.nextCursor,
    };

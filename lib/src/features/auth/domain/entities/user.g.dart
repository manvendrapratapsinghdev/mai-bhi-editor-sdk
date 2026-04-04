// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatar_url'] as String?,
  creatorLevel:
      $enumDecodeNullable(_$CreatorLevelEnumMap, json['creator_level']) ??
      CreatorLevel.basicCreator,
  reputationPoints: (json['reputation_points'] as num?)?.toInt() ?? 0,
  city: json['city'] as String?,
  storiesPublished: (json['stories_published'] as num?)?.toInt() ?? 0,
  badges:
      (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'creator_level': _$CreatorLevelEnumMap[instance.creatorLevel]!,
      'reputation_points': instance.reputationPoints,
      'city': instance.city,
      'stories_published': instance.storiesPublished,
      'badges': instance.badges,
    };

const _$CreatorLevelEnumMap = {
  CreatorLevel.basicCreator: 'basic_creator',
  CreatorLevel.htApprovedCreator: 'ht_approved_creator',
  CreatorLevel.trustedReporter: 'trusted_reporter',
};

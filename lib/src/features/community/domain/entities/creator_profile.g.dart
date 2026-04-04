// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatorProfile _$CreatorProfileFromJson(Map<String, dynamic> json) =>
    _CreatorProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      creatorLevel:
          $enumDecodeNullable(_$CreatorLevelEnumMap, json['creator_level']) ??
          CreatorLevel.basicCreator,
      reputationPoints: (json['reputation_points'] as num?)?.toInt() ?? 0,
      storiesPublished: (json['stories_published'] as num?)?.toInt() ?? 0,
      badges:
          (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      accuracyRate: (json['accuracy_rate'] as num?)?.toDouble() ?? 0.0,
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
    );

Map<String, dynamic> _$CreatorProfileToJson(_CreatorProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'creator_level': _$CreatorLevelEnumMap[instance.creatorLevel]!,
      'reputation_points': instance.reputationPoints,
      'stories_published': instance.storiesPublished,
      'badges': instance.badges,
      'accuracy_rate': instance.accuracyRate,
      'joined_at': instance.joinedAt?.toIso8601String(),
    };

const _$CreatorLevelEnumMap = {
  CreatorLevel.basicCreator: 'basic_creator',
  CreatorLevel.htApprovedCreator: 'ht_approved_creator',
  CreatorLevel.trustedReporter: 'trusted_reporter',
};

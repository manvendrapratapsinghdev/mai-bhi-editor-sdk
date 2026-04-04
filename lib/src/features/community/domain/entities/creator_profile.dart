import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/user.dart';

part 'creator_profile.freezed.dart';
part 'creator_profile.g.dart';

/// Public profile for a content creator.
@freezed
abstract class CreatorProfile with _$CreatorProfile {
  const factory CreatorProfile({
    required String id,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'creator_level') @Default(CreatorLevel.basicCreator) CreatorLevel creatorLevel,
    @JsonKey(name: 'reputation_points') @Default(0) int reputationPoints,
    @JsonKey(name: 'stories_published') @Default(0) int storiesPublished,
    @Default([]) List<String> badges,
    @JsonKey(name: 'accuracy_rate') @Default(0.0) double accuracyRate,
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
  }) = _CreatorProfile;

  factory CreatorProfile.fromJson(Map<String, dynamic> json) =>
      _$CreatorProfileFromJson(json);
}

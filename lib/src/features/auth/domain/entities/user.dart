import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Creator level enum matching the API contract.
enum CreatorLevel {
  @JsonValue('basic_creator')
  basicCreator,
  @JsonValue('ht_approved_creator')
  htApprovedCreator,
  @JsonValue('trusted_reporter')
  trustedReporter,
}

/// Domain entity for a user profile.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'creator_level') @Default(CreatorLevel.basicCreator) CreatorLevel creatorLevel,
    @JsonKey(name: 'reputation_points') @Default(0) int reputationPoints,
    String? city,
    @JsonKey(name: 'stories_published') @Default(0) int storiesPublished,
    @Default([]) List<String> badges,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

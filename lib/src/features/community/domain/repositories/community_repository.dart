import '../entities/confirmation_result.dart';
import '../entities/creator_profile.dart';
import '../entities/like_result.dart';

/// Abstract contract for community interaction operations.
abstract class CommunityRepository {
  /// Confirm/validate a citizen news story.
  Future<ConfirmationResult> confirmStory(String storyId);

  /// Like a story.
  Future<LikeResult> likeStory(String storyId);

  /// Fetch a creator's public profile.
  Future<CreatorProfile> getCreatorProfile(String creatorId);

  /// Fetch the list of stories published by a creator.
  Future<List<String>> getCreatorStoryIds(String creatorId);

  /// Block or unblock a creator. Returns `true` if now blocked.
  Future<bool> blockCreator(String creatorId);

  /// Submit a report for a creator or story.
  Future<void> report({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  });

  /// Fetch the list of creators the current user has blocked.
  Future<List<CreatorProfile>> getBlockedCreators();
}

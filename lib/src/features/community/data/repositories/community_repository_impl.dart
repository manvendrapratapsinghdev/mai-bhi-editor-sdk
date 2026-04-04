import '../../domain/entities/confirmation_result.dart';
import '../../domain/entities/creator_profile.dart';
import '../../domain/entities/like_result.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_remote_datasource.dart';

/// Concrete implementation of [CommunityRepository].
///
/// Delegates all calls to [CommunityRemoteDataSource].
class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource _remoteDataSource;

  const CommunityRepositoryImpl({
    required CommunityRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ConfirmationResult> confirmStory(String storyId) {
    return _remoteDataSource.confirmStory(storyId);
  }

  @override
  Future<LikeResult> likeStory(String storyId) {
    return _remoteDataSource.likeStory(storyId);
  }

  @override
  Future<CreatorProfile> getCreatorProfile(String creatorId) {
    return _remoteDataSource.getCreatorProfile(creatorId);
  }

  @override
  Future<List<String>> getCreatorStoryIds(String creatorId) {
    // The stories are fetched via the feed endpoint; this is a placeholder
    // for future dedicated endpoint.
    return Future.value([]);
  }

  @override
  Future<bool> blockCreator(String creatorId) {
    return _remoteDataSource.blockCreator(creatorId);
  }

  @override
  Future<void> report({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) {
    return _remoteDataSource.report(
      targetType: targetType,
      targetId: targetId,
      reason: reason,
      details: details,
    );
  }

  @override
  Future<List<CreatorProfile>> getBlockedCreators() {
    return _remoteDataSource.getBlockedCreators();
  }
}

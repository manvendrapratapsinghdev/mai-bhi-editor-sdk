import '../entities/like_result.dart';
import '../repositories/community_repository.dart';

/// Use case: like or unlike a story.
class LikeStoryUseCase {
  final CommunityRepository _repository;

  const LikeStoryUseCase(this._repository);

  Future<LikeResult> call(String storyId) {
    return _repository.likeStory(storyId);
  }
}

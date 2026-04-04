import '../entities/confirmation_result.dart';
import '../repositories/community_repository.dart';

/// Use case: confirm/validate a citizen news story.
class ConfirmStoryUseCase {
  final CommunityRepository _repository;

  const ConfirmStoryUseCase(this._repository);

  Future<ConfirmationResult> call(String storyId) {
    return _repository.confirmStory(storyId);
  }
}

import '../entities/story_detail.dart';
import '../repositories/feed_repository.dart';

/// Use case: Fetch full story detail by ID.
class GetStoryDetailUseCase {
  final FeedRepository _repository;

  const GetStoryDetailUseCase(this._repository);

  Future<StoryDetail> call(String id) {
    return _repository.getStoryDetail(id);
  }
}

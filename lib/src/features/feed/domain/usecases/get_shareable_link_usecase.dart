import '../repositories/feed_repository.dart';

/// Use case: Get a shareable deep-link URL for a story.
class GetShareableLinkUseCase {
  final FeedRepository _repository;

  const GetShareableLinkUseCase(this._repository);

  Future<String> call(String id) {
    return _repository.getShareableLink(id);
  }
}

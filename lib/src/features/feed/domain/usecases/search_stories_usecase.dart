import '../entities/feed_response.dart';
import '../repositories/feed_repository.dart';

/// Use case: Search stories by query string.
class SearchStoriesUseCase {
  final FeedRepository _repository;

  const SearchStoriesUseCase(this._repository);

  Future<FeedResponse> call({
    required String query,
    String? cursor,
    int limit = 20,
  }) {
    return _repository.searchStories(
      query: query,
      cursor: cursor,
      limit: limit,
    );
  }
}

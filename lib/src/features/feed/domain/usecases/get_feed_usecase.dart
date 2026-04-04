import '../entities/feed_response.dart';
import '../repositories/feed_repository.dart';

/// Use case: Fetch the news feed with optional city filter and pagination.
class GetFeedUseCase {
  final FeedRepository _repository;

  const GetFeedUseCase(this._repository);

  Future<FeedResponse> call({
    String? city,
    bool? trending,
    String? cursor,
    int limit = 20,
  }) {
    return _repository.getFeed(
      city: city,
      trending: trending,
      cursor: cursor,
      limit: limit,
    );
  }
}

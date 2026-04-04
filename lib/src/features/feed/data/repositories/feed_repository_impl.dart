import '../../domain/entities/feed_response.dart';
import '../../domain/entities/story_detail.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';

/// Concrete implementation of [FeedRepository].
///
/// Delegates all calls to [FeedRemoteDataSource].
class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _remoteDataSource;

  const FeedRepositoryImpl({
    required FeedRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<FeedResponse> getFeed({
    String? city,
    bool? trending,
    String? cursor,
    int limit = 20,
  }) {
    return _remoteDataSource.getFeed(
      city: city,
      trending: trending,
      cursor: cursor,
      limit: limit,
    );
  }

  @override
  Future<StoryDetail> getStoryDetail(String id) {
    return _remoteDataSource.getStoryDetail(id);
  }

  @override
  Future<FeedResponse> searchStories({
    required String query,
    String? cursor,
    int limit = 20,
  }) {
    return _remoteDataSource.searchStories(
      query: query,
      cursor: cursor,
      limit: limit,
    );
  }

  @override
  Future<String> getShareableLink(String id) {
    return _remoteDataSource.getShareableLink(id);
  }
}

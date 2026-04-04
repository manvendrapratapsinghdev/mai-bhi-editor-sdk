import '../entities/feed_response.dart';
import '../entities/story_detail.dart';

/// Abstract contract for news feed operations.
abstract class FeedRepository {
  /// Fetch the published news feed with cursor-based pagination.
  Future<FeedResponse> getFeed({
    String? city,
    bool? trending,
    String? cursor,
    int limit,
  });

  /// Fetch full story detail by ID.
  Future<StoryDetail> getStoryDetail(String id);

  /// Search stories by query string with cursor-based pagination.
  Future<FeedResponse> searchStories({
    required String query,
    String? cursor,
    int limit,
  });

  /// Get a shareable deep-link URL for a story.
  Future<String> getShareableLink(String id);
}

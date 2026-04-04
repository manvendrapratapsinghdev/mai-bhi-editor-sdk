import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/feed_response.dart';
import '../../domain/entities/story_detail.dart';

/// Remote data source for feed endpoints.
abstract class FeedRemoteDataSource {
  /// GET /feed — paginated feed with optional city and trending filters.
  Future<FeedResponse> getFeed({
    String? city,
    bool? trending,
    String? cursor,
    int limit = 20,
  });

  /// GET /feed/{id} — full story detail.
  Future<StoryDetail> getStoryDetail(String id);

  /// GET /feed/search — search stories by query.
  Future<FeedResponse> searchStories({
    required String query,
    String? cursor,
    int limit = 20,
  });

  /// GET /feed/{id}/share — get shareable link for a story.
  Future<String> getShareableLink(String id);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio _dio;

  const FeedRemoteDataSourceImpl(this._dio);

  @override
  Future<FeedResponse> getFeed({
    String? city,
    bool? trending,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
      };
      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }
      if (trending == true) {
        queryParams['trending'] = true;
      }
      if (cursor != null && cursor.isNotEmpty) {
        queryParams['cursor'] = cursor;
      }

      final response = await _dio.get(
        ApiConstants.feed,
        queryParameters: queryParams,
      );

      return FeedResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch feed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<StoryDetail> getStoryDetail(String id) async {
    try {
      final response = await _dio.get(ApiConstants.storyDetail(id));
      return StoryDetail.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch story detail',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<FeedResponse> searchStories({
    required String query,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'limit': limit,
      };
      if (cursor != null && cursor.isNotEmpty) {
        queryParams['cursor'] = cursor;
      }

      final response = await _dio.get(
        ApiConstants.feedSearch,
        queryParameters: queryParams,
      );

      return FeedResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to search stories',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> getShareableLink(String id) async {
    try {
      final response = await _dio.get(ApiConstants.storyShare(id));
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['url'] as String? ??
            data['share_url'] as String? ??
            '${ApiConstants.prodBaseUrl}/stories/$id';
      }
      return '${ApiConstants.prodBaseUrl}/stories/$id';
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to get shareable link',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

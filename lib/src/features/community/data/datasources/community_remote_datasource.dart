import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/confirmation_result.dart';
import '../../domain/entities/creator_profile.dart';
import '../../domain/entities/like_result.dart';

/// Remote data source for community interaction endpoints.
abstract class CommunityRemoteDataSource {
  /// POST /stories/{id}/confirm
  Future<ConfirmationResult> confirmStory(String storyId);

  /// POST /stories/{id}/like
  Future<LikeResult> likeStory(String storyId);

  /// GET /creators/{id}/profile
  Future<CreatorProfile> getCreatorProfile(String creatorId);

  /// POST /users/{id}/block — toggles block status.
  /// Returns `true` if the creator is now blocked.
  Future<bool> blockCreator(String creatorId);

  /// POST /reports — submit a report.
  Future<void> report({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  });

  /// GET /users/blocked — list of blocked creators.
  Future<List<CreatorProfile>> getBlockedCreators();
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final Dio _dio;

  const CommunityRemoteDataSourceImpl(this._dio);

  @override
  Future<ConfirmationResult> confirmStory(String storyId) async {
    try {
      final response = await _dio.post(ApiConstants.confirmStory(storyId));
      return ConfirmationResult.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to confirm story',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<LikeResult> likeStory(String storyId) async {
    try {
      final response = await _dio.post(ApiConstants.likeStory(storyId));
      return LikeResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to like story',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<CreatorProfile> getCreatorProfile(String creatorId) async {
    try {
      final response =
          await _dio.get(ApiConstants.creatorProfile(creatorId));
      return CreatorProfile.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch creator profile',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> blockCreator(String creatorId) async {
    try {
      final response =
          await _dio.post(ApiConstants.blockCreator(creatorId));
      final data = response.data as Map<String, dynamic>;
      return data['blocked'] as bool? ?? true;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to block creator',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> report({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) async {
    try {
      await _dio.post(ApiConstants.reports, data: {
        'target_type': targetType,
        'target_id': targetId,
        'reason': reason,
        if (details != null && details.isNotEmpty) 'details': details,
      });
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to submit report',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<CreatorProfile>> getBlockedCreators() async {
    try {
      final response = await _dio.get(ApiConstants.blockedCreators);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => CreatorProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch blocked creators',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

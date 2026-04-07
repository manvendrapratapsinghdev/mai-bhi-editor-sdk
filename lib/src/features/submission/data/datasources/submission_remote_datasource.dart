import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/ai_review_result.dart';
import '../../domain/entities/submission.dart';
import '../../domain/entities/submission_detail.dart';
import '../models/submission_create_model.dart';

/// Paginated result from a cursor-based list endpoint.
class PaginatedResult<T> {
  final List<T> items;
  final String? nextCursor;
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
  });
}

/// Remote data source for submission endpoints.
abstract class SubmissionRemoteDataSource {
  /// POST /submissions — create submission with cover image.
  Future<Submission> createSubmission({
    required SubmissionCreate data,
    required String coverImagePath,
    void Function(double progress)? onProgress,
  });

  /// GET /submissions/my — list current user's submissions.
  Future<PaginatedResult<Submission>> getMySubmissions({
    String? status,
    String? cursor,
    int limit = 20,
  });

  /// GET /submissions/{id} — full submission detail.
  Future<SubmissionDetail> getSubmissionDetail(String id);

  /// POST /submissions/{id}/images — upload additional images.
  Future<void> uploadAdditionalImages({
    required String submissionId,
    required List<String> imagePaths,
    void Function(double progress)? onProgress,
  });

  /// POST /submissions/{id}/process-ai — trigger AI processing.
  Future<AIReviewResult> triggerAiProcessing(String submissionId);
}

class SubmissionRemoteDataSourceImpl implements SubmissionRemoteDataSource {
  final Dio _dio;

  const SubmissionRemoteDataSourceImpl(this._dio);

  @override
  Future<Submission> createSubmission({
    required SubmissionCreate data,
    required String coverImagePath,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final formMap = <String, dynamic>{
        'title': data.title,
        'description': data.description,
        'city': data.city,
        'cover_image': await MultipartFile.fromFile(
          coverImagePath,
          filename: 'cover_image.jpg',
        ),
      };
      if (data.tags.isNotEmpty) {
        formMap['tags'] = jsonEncode(data.tags);
      }
      final formData = FormData.fromMap(formMap);

      final response = await _dio.post(
        ApiConstants.submissions,
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0 && onProgress != null) {
            onProgress(sent / total);
          }
        },
      );

      return Submission.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to create submission',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PaginatedResult<Submission>> getMySubmissions({
    String? status,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
      };
      if (status != null) {
        queryParams['status'] = status;
      }
      if (cursor != null) {
        queryParams['cursor'] = cursor;
      }

      final response = await _dio.get(
        ApiConstants.mySubmissions,
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('items')) {
        final items = (data['items'] as List)
            .map((e) => Submission.fromJson(e as Map<String, dynamic>))
            .toList();
        return PaginatedResult(
          items: items,
          nextCursor: data['next_cursor'] as String?,
          hasMore: data['has_more'] as bool? ?? false,
        );
      }
      if (data is List) {
        final items = data
            .map((e) => Submission.fromJson(e as Map<String, dynamic>))
            .toList();
        return PaginatedResult(items: items);
      }
      return const PaginatedResult(items: []);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch submissions',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SubmissionDetail> getSubmissionDetail(String id) async {
    try {
      final response = await _dio.get(
        ApiConstants.submissionDetail(id),
      );
      return SubmissionDetail.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch submission detail',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> uploadAdditionalImages({
    required String submissionId,
    required List<String> imagePaths,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final files = <MapEntry<String, MultipartFile>>[];
      for (final path in imagePaths) {
        files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }

      final formData = FormData();
      for (final entry in files) {
        formData.files.add(entry);
      }

      await _dio.post(
        ApiConstants.submissionImages(submissionId),
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0 && onProgress != null) {
            onProgress(sent / total);
          }
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to upload images',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AIReviewResult> triggerAiProcessing(String submissionId) async {
    try {
      final response = await _dio.post(
        ApiConstants.processAi(submissionId),
      );
      return AIReviewResult.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to trigger AI processing',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

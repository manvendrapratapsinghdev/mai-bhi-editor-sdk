import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/ai_review_result.dart';
import '../../domain/entities/submission.dart';
import '../../domain/entities/submission_detail.dart';
import '../models/submission_create_model.dart';

/// Remote data source for submission endpoints.
abstract class SubmissionRemoteDataSource {
  /// POST /submissions — create submission with cover image.
  Future<Submission> createSubmission({
    required SubmissionCreate data,
    required String coverImagePath,
    void Function(double progress)? onProgress,
  });

  /// GET /submissions/my — list current user's submissions.
  Future<List<Submission>> getMySubmissions({
    String? status,
    int page = 1,
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
      final formData = FormData.fromMap({
        'title': data.title,
        'description': data.description,
        'city': data.city,
        'tags': data.tags.join(','),
        'cover_image': await MultipartFile.fromFile(
          coverImagePath,
          filename: 'cover_image.jpg',
        ),
      });

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
  Future<List<Submission>> getMySubmissions({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _dio.get(
        ApiConstants.mySubmissions,
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => Submission.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      // Handle paginated response shape: { "items": [...], ... }
      if (data is Map<String, dynamic> && data.containsKey('items')) {
        final items = data['items'] as List;
        return items
            .map((e) => Submission.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
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

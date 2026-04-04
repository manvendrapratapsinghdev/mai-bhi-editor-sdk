import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../submission/domain/entities/submission.dart';
import '../../../submission/domain/entities/submission_detail.dart';
import '../../domain/entities/appeal.dart';
import '../../domain/entities/editorial_queue_item.dart';
import '../models/editor_action_model.dart';

/// Remote data source for editorial endpoints.
abstract class EditorialRemoteDataSource {
  /// GET /editorial/queue
  Future<List<EditorialQueueItem>> getQueue({
    String? city,
    String? sortBy,
    int page = 1,
  });

  /// GET /submissions/{id} — reuse submission detail endpoint.
  Future<SubmissionDetail> getSubmissionDetail(String submissionId);

  /// POST /editorial/{id}/action
  Future<Submission> performAction({
    required String submissionId,
    required EditorAction action,
  });

  /// POST /editorial/{id}/flag-false
  Future<void> flagFalseNews(String submissionId);

  /// GET /editorial/appeals
  Future<List<Appeal>> getAppeals();

  /// POST /editorial/appeals/{id}/review
  Future<Appeal> reviewAppeal({
    required String appealId,
    required bool approve,
    String? notes,
  });

  /// POST /submissions/{submissionId}/appeal
  Future<Appeal> submitAppeal({
    required String submissionId,
    required String justification,
  });

  /// GET /submissions/{submissionId}/appeal
  Future<Appeal?> getAppealForSubmission(String submissionId);
}

class EditorialRemoteDataSourceImpl implements EditorialRemoteDataSource {
  final Dio _dio;

  const EditorialRemoteDataSourceImpl(this._dio);

  @override
  Future<List<EditorialQueueItem>> getQueue({
    String? city,
    String? sortBy,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
      };
      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sort_by'] = sortBy;
      }

      final response = await _dio.get(
        ApiConstants.editorialQueue,
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((e) =>
                EditorialQueueItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      // Handle paginated response shape: { "items": [...], ... }
      if (data is Map<String, dynamic> && data.containsKey('items')) {
        final items = data['items'] as List;
        return items
            .map((e) =>
                EditorialQueueItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch editorial queue',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SubmissionDetail> getSubmissionDetail(String submissionId) async {
    try {
      final response = await _dio.get(
        ApiConstants.submissionDetail(submissionId),
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
  Future<Submission> performAction({
    required String submissionId,
    required EditorAction action,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.editorAction(submissionId),
        data: action.toJson(),
      );
      return Submission.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to perform editor action',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> flagFalseNews(String submissionId) async {
    try {
      await _dio.post(ApiConstants.flagFalseNews(submissionId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to flag story as false',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<Appeal>> getAppeals() async {
    try {
      final response = await _dio.get(ApiConstants.editorialAppeals);
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => Appeal.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (data is Map<String, dynamic> && data.containsKey('items')) {
        final items = data['items'] as List;
        return items
            .map((e) => Appeal.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch appeals',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Appeal> reviewAppeal({
    required String appealId,
    required bool approve,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.reviewAppeal(appealId),
        data: <String, dynamic>{
          'approve': approve,
          'notes': ?notes,
        },
      );
      return Appeal.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to review appeal',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Appeal> submitAppeal({
    required String submissionId,
    required String justification,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.submitAppeal(submissionId),
        data: {'justification': justification},
      );
      return Appeal.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to submit appeal',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Appeal?> getAppealForSubmission(String submissionId) async {
    try {
      final response = await _dio.get(
        ApiConstants.submitAppeal(submissionId),
      );
      if (response.data == null) return null;
      return Appeal.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // 404 means no appeal exists — return null.
      if (e.response?.statusCode == 404) return null;
      throw ServerException(
        message: e.message ?? 'Failed to fetch appeal',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

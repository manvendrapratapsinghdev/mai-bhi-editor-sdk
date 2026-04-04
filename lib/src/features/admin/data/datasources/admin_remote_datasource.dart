import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/admin_report.dart';
import '../../domain/entities/admin_stats.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/editor_analytics.dart';

/// Remote data source for admin endpoints.
abstract class AdminRemoteDataSource {
  Future<AdminStats> getDashboardStats();
  Future<List<AdminReport>> getReports({String? status});
  Future<void> actionReport({
    required String reportId,
    required String action,
  });
  Future<List<AdminUser>> getUsers({String? filter});
  Future<void> actionUser({
    required String userId,
    required String action,
    int? suspendDays,
  });
  Future<EditorAnalytics> getEditorAnalytics({String? city});
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio _dio;

  const AdminRemoteDataSourceImpl(this._dio);

  @override
  Future<AdminStats> getDashboardStats() async {
    try {
      final response = await _dio.get(ApiConstants.adminStats);
      return AdminStats.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch admin stats',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<AdminReport>> getReports({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        ApiConstants.adminReports,
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>;
      final items = data['reports'] as List<dynamic>? ?? [];
      return items
          .map((e) => AdminReport.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch reports',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> actionReport({
    required String reportId,
    required String action,
  }) async {
    try {
      await _dio.post(
        ApiConstants.adminReportAction(reportId),
        data: {'action': action},
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to action report',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<AdminUser>> getUsers({String? filter}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (filter != null && filter != 'all') queryParams['status'] = filter;

      final response = await _dio.get(
        ApiConstants.adminUsers,
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>;
      final items = data['users'] as List<dynamic>? ?? [];
      return items
          .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch users',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> actionUser({
    required String userId,
    required String action,
    int? suspendDays,
  }) async {
    try {
      final data = <String, dynamic>{'action': action};
      if (suspendDays != null) data['suspend_days'] = suspendDays;

      await _dio.post(
        ApiConstants.adminUserAction(userId),
        data: data,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to action user',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<EditorAnalytics> getEditorAnalytics({String? city}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (city != null) queryParams['city'] = city;

      final response = await _dio.get(
        ApiConstants.editorAnalytics,
        queryParameters: queryParams,
      );

      return EditorAnalytics.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch editor analytics',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

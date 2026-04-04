import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/notification_entity.dart';

/// Remote data source for notification endpoints.
abstract class NotificationRemoteDataSource {
  /// GET /notifications
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  /// POST /notifications/{id}/read
  Future<void> markAsRead(String notificationId);

  /// POST /notifications/read-all
  Future<void> markAllAsRead();

  /// POST /devices/register
  Future<void> registerDevice({
    required String token,
    required String platform,
  });

  /// GET /notifications/preferences
  Future<NotificationPreferences> getPreferences();

  /// PUT /notifications/preferences
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  );
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  const NotificationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.notifications,
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>? ?? [];
      return items
          .map((e) =>
              NotificationEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch notifications',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.post(ApiConstants.notificationRead(notificationId));
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to mark notification as read',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dio.post(ApiConstants.notificationsReadAll);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to mark all notifications as read',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> registerDevice({
    required String token,
    required String platform,
  }) async {
    try {
      await _dio.post(
        ApiConstants.devicesRegister,
        data: {'token': token, 'platform': platform},
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to register device',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<NotificationPreferences> getPreferences() async {
    try {
      final response = await _dio.get(ApiConstants.notificationPreferences);
      return NotificationPreferences.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch notification preferences',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  ) async {
    try {
      final response = await _dio.put(
        ApiConstants.notificationPreferences,
        data: preferences.toJson(),
      );
      return NotificationPreferences.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to update notification preferences',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

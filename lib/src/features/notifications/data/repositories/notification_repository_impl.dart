import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

/// Concrete implementation of [NotificationRepository].
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  const NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  }) {
    return _remoteDataSource.getNotifications(page: page, limit: limit);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() {
    return _remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> registerDevice({
    required String token,
    required String platform,
  }) {
    return _remoteDataSource.registerDevice(
      token: token,
      platform: platform,
    );
  }

  @override
  Future<NotificationPreferences> getPreferences() {
    return _remoteDataSource.getPreferences();
  }

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  ) {
    return _remoteDataSource.updatePreferences(preferences);
  }
}

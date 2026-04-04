import '../entities/notification_entity.dart';

/// Abstract contract for notification operations.
///
/// Implemented in the data layer by [NotificationRepositoryImpl].
abstract class NotificationRepository {
  /// Fetch paginated notifications for the current user.
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read.
  Future<void> markAllAsRead();

  /// Register a device token for push notifications.
  Future<void> registerDevice({
    required String token,
    required String platform,
  });

  /// Get notification preferences.
  Future<NotificationPreferences> getPreferences();

  /// Update notification preferences.
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  );
}

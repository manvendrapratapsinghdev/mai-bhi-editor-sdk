part of 'notification_bloc.dart';

/// Events for the notification BLoC.
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Load the initial page of notifications.
class LoadNotifications extends NotificationEvent {
  const LoadNotifications();
}

/// Mark a specific notification as read.
class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Mark all notifications as read.
class MarkAllNotificationsAsRead extends NotificationEvent {
  const MarkAllNotificationsAsRead();
}

/// Load the next page of notifications (pagination).
class LoadMoreNotifications extends NotificationEvent {
  const LoadMoreNotifications();
}

/// Register the device token for push notifications.
class RegisterDeviceToken extends NotificationEvent {
  final String token;
  final String platform;

  const RegisterDeviceToken({
    required this.token,
    required this.platform,
  });

  @override
  List<Object?> get props => [token, platform];
}

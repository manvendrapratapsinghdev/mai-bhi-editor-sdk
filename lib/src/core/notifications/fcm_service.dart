import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Callback type for when a notification is tapped.
typedef OnNotificationTap = void Function(Map<String, dynamic> data);

/// Callback type for foreground notification display.
typedef OnForegroundNotification = void Function({
  required String title,
  required String body,
  Map<String, dynamic>? data,
});

/// Abstract interface for push notification services.
///
/// Allows swapping between real Firebase Cloud Messaging and a mock
/// implementation for development/testing.
abstract class PushNotificationService {
  /// Initialise the push notification service.
  Future<void> initialize();

  /// Get the current device token for push notifications.
  Future<String?> getToken();

  /// Set handler for notification taps (from background/terminated state).
  void setOnNotificationTap(OnNotificationTap handler);

  /// Set handler for foreground notification display.
  void setOnForegroundNotification(OnForegroundNotification handler);

  /// Request permission for notifications (iOS).
  Future<bool> requestPermission();

  /// Dispose resources.
  void dispose();
}

/// Mock implementation of [PushNotificationService] that logs all
/// operations instead of communicating with Firebase.
///
/// This is used during development and can be swapped for the real
/// Firebase implementation once the firebase_messaging dependency
/// is added to the project.
class MockFcmService implements PushNotificationService {
  OnNotificationTap? _onNotificationTap;
  OnForegroundNotification? _onForegroundNotification;

  static const String _tag = 'MockFcmService';

  @override
  Future<void> initialize() async {
    developer.log('FCM initialized (mock)', name: _tag);
    if (kDebugMode) {
      debugPrint('[$_tag] Push notification service initialized (mock mode)');
    }
  }

  @override
  Future<String?> getToken() async {
    const mockToken = 'mock-fcm-device-token-for-development';
    developer.log('FCM token requested: $mockToken', name: _tag);
    return mockToken;
  }

  @override
  void setOnNotificationTap(OnNotificationTap handler) {
    _onNotificationTap = handler;
    developer.log('Notification tap handler registered', name: _tag);
  }

  @override
  void setOnForegroundNotification(OnForegroundNotification handler) {
    _onForegroundNotification = handler;
    developer.log('Foreground notification handler registered', name: _tag);
  }

  @override
  Future<bool> requestPermission() async {
    developer.log('Notification permission requested (mock: granted)',
        name: _tag);
    return true;
  }

  @override
  void dispose() {
    _onNotificationTap = null;
    _onForegroundNotification = null;
    developer.log('FCM service disposed', name: _tag);
  }

  /// Simulate receiving a foreground notification (for testing).
  void simulateForegroundNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    developer.log(
      'Simulating foreground notification: $title - $body',
      name: _tag,
    );
    _onForegroundNotification?.call(
      title: title,
      body: body,
      data: data,
    );
  }

  /// Simulate a notification tap (for testing).
  void simulateNotificationTap(Map<String, dynamic> data) {
    developer.log('Simulating notification tap with data: $data', name: _tag);
    _onNotificationTap?.call(data);
  }
}

/// Handles routing when a notification is tapped.
///
/// Parses the notification data payload and returns the route path
/// to navigate to.
class NotificationRouter {
  NotificationRouter._();

  /// Determine the navigation route from notification data.
  ///
  /// Returns a route path string, or null if no navigation is needed.
  static String? routeFromData(Map<String, dynamic> data) {
    final targetType = data['target_type'] as String?;
    final targetId = data['target_id'] as String?;

    if (targetType == null || targetId == null) return null;

    switch (targetType) {
      case 'story':
        return '/feed/$targetId';
      case 'submission':
        return '/submissions/$targetId/ai-preview';
      case 'profile':
        return '/profile';
      case 'editorial':
        return '/editorial/$targetId';
      default:
        return '/notifications';
    }
  }
}

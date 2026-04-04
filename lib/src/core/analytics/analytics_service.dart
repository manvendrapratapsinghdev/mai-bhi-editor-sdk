import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';

/// Lightweight analytics service that batches events locally and flushes
/// them to POST /analytics/events periodically.
///
/// Events are buffered in memory and sent every [_flushInterval] seconds.
/// On app background ([onAppPaused]), any buffered events are flushed
/// immediately.
///
/// This service is designed to be non-blocking: flush failures are silently
/// ignored so they never disrupt the user experience.
class AnalyticsService {
  final Dio _dio;

  /// Buffer of events waiting to be sent.
  final List<Map<String, dynamic>> _eventBuffer = [];

  /// Periodic flush timer.
  Timer? _flushTimer;

  /// Flush interval in seconds.
  static const int _flushIntervalSeconds = 30;

  /// Maximum buffer size before forced flush.
  static const int _maxBufferSize = 100;

  AnalyticsService(this._dio);

  // ── Event names ─────────────────────────────────────────────────────────

  static const String submissionStarted = 'submission_started';
  static const String submissionCompleted = 'submission_completed';
  static const String aiReviewViewed = 'ai_review_viewed';
  static const String storyViewed = 'story_viewed';
  static const String storyConfirmed = 'story_confirmed';
  static const String storyLiked = 'story_liked';
  static const String storyShared = 'story_shared';
  static const String searchPerformed = 'search_performed';
  static const String feedScrolled = 'feed_scrolled';
  static const String trendingToggled = 'trending_toggled';
  static const String deleteAccountRequested = 'delete_account_requested';

  // ── Lifecycle ───────────────────────────────────────────────────────────

  /// Start the periodic flush timer. Call once during app startup.
  void initialize() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(
      const Duration(seconds: _flushIntervalSeconds),
      (_) => flush(),
    );
  }

  /// Flush remaining events and cancel the timer. Call on app dispose.
  Future<void> dispose() async {
    _flushTimer?.cancel();
    _flushTimer = null;
    await flush();
  }

  /// Call when the app is paused (e.g. from [AppLifecycleListener]).
  Future<void> onAppPaused() async {
    await flush();
  }

  // ── Tracking ────────────────────────────────────────────────────────────

  /// Track an analytics event with optional properties.
  ///
  /// This is non-blocking: the event is added to the buffer and will be
  /// flushed on the next timer tick or when the buffer is full.
  void track(String eventName, {Map<String, dynamic>? properties}) {
    final event = <String, dynamic>{
      'event_type': eventName,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      if (properties != null && properties.isNotEmpty)
        'metadata': properties,
    };

    _eventBuffer.add(event);

    // Force flush if buffer is getting large.
    if (_eventBuffer.length >= _maxBufferSize) {
      flush();
    }
  }

  // ── Flush ───────────────────────────────────────────────────────────────

  /// Send all buffered events to the server.
  ///
  /// On failure, events are silently discarded to avoid blocking the UI.
  /// In a production app you might persist to local storage for retry.
  Future<void> flush() async {
    if (_eventBuffer.isEmpty) return;

    // Take a snapshot and clear the buffer so new events can accumulate
    // while we send.
    final batch = List<Map<String, dynamic>>.from(_eventBuffer);
    _eventBuffer.clear();

    try {
      await _dio.post(
        ApiConstants.analyticsEvents,
        data: {'events': batch},
      );
    } catch (e) {
      // Silently discard. In debug mode, log to console.
      debugPrint('[AnalyticsService] Flush failed: $e');
    }
  }
}

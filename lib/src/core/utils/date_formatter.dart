import 'package:intl/intl.dart';

/// Utility helpers for formatting [DateTime] values throughout the app.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _fullDate = DateFormat('dd MMM yyyy');
  static final DateFormat _fullDateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _timeOnly = DateFormat('hh:mm a');

  /// e.g. "27 Mar 2026"
  static String formatDate(DateTime date) => _fullDate.format(date);

  /// e.g. "27 Mar 2026, 02:30 PM"
  static String formatDateTime(DateTime date) => _fullDateTime.format(date);

  /// e.g. "02:30 PM"
  static String formatTime(DateTime date) => _timeOnly.format(date);

  /// Returns a human-readable relative time string.
  ///
  /// Examples: "just now", "5m ago", "2h ago", "3d ago", "27 Mar 2026".
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDate(date);
  }

  /// Parse an ISO-8601 string, returning `null` on failure.
  static DateTime? tryParseIso(String? iso) {
    if (iso == null) return null;
    return DateTime.tryParse(iso);
  }
}

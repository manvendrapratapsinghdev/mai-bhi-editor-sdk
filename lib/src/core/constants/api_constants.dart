// Backwards-compatible shim for feature files that import ApiConstants.
// Delegates to MbeApiConstants for endpoint paths.
export '../../network/api_constants.dart' show MbeApiConstants;

import '../../config/mai_bhi_editor_initializer.dart';
import '../../network/api_constants.dart';

class ApiConstants {
  ApiConstants._();

  /// Resolved from [MaiBhiEditor.baseUrl].
  static String get baseUrl => MaiBhiEditor.baseUrl;

  static String get serverRoot {
    final uri = Uri.parse(baseUrl);
    return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  }

  static String resolveImageUrl(String? url) =>
      MbeApiConstants.resolveImageUrl(MaiBhiEditor.baseUrl, url);

  // ── Auth ──────────────────────────────────────────────────────────────
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String profile = '/auth/profile';

  // ── Submissions ───────────────────────────────────────────────────────
  static const String submissions = '/submissions';
  static const String mySubmissions = '/submissions/my';
  static String submissionDetail(String id) => '/submissions/$id';
  static String aiReview(String id) => '/submissions/$id/ai-review';
  static String processAi(String id) => '/submissions/$id/process-ai';
  static String submissionImages(String id) => '/submissions/$id/images';

  // ── Editorial ─────────────────────────────────────────────────────────
  static const String editorialQueue = '/editorial/queue';
  static String editorAction(String id) => '/editorial/$id/action';
  static String flagFalseNews(String id) => '/editorial/$id/flag-false';
  static const String editorialAppeals = '/editorial/appeals';
  static String reviewAppeal(String id) => '/editorial/appeals/$id/review';

  // ── Appeals ───────────────────────────────────────────────────────────
  static String submitAppeal(String submissionId) =>
      '/submissions/$submissionId/appeal';

  // ── Feed ──────────────────────────────────────────────────────────────
  static const String feed = '/feed';
  static String storyDetail(String id) => '/feed/$id';
  static const String feedSearch = '/feed/search';
  static String storyShare(String id) => '/feed/$id/share';

  // ── Community ─────────────────────────────────────────────────────────
  static String confirmStory(String id) => '/stories/$id/confirm';
  static String likeStory(String id) => '/stories/$id/like';
  static String creatorProfile(String id) => '/creators/$id/profile';
  static String blockCreator(String id) => '/users/$id/block';
  static const String reports = '/reports';
  static const String blockedCreators = '/users/blocked';

  // ── Notifications ─────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';
  static const String devicesRegister = '/devices/register';
  static const String notificationPreferences = '/notifications/preferences';

  // ── Users ─────────────────────────────────────────────────────────────
  static const String deleteAccount = '/users/me';

  // ── Analytics ─────────────────────────────────────────────────────────
  static const String analyticsEvents = '/analytics/events';

  // ── Admin ─────────────────────────────────────────────────────────────
  static const String adminStats = '/admin/stats';
  static const String adminReports = '/admin/reports';
  static String adminReportAction(String id) => '/admin/reports/$id/action';
  static const String adminUsers = '/admin/users';
  static String adminUserAction(String id) => '/admin/users/$id/action';

  // ── Editor Analytics ──────────────────────────────────────────────────
  static const String editorAnalytics = '/editorial/analytics';

  /// Production base URL (used for shareable links).
  static String get prodBaseUrl => baseUrl;

  /// Dev base URL (alias for current baseUrl in SDK context).
  static String get devBaseUrl => baseUrl;

  // ── Timeouts ──────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 30);
}

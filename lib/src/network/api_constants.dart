/// API endpoint paths for Mai Bhi Editor.
///
/// Contains only relative paths — the base URL is provided by the host app
/// at initialization via [MaiBhiEditor.initialize].
class MbeApiConstants {
  MbeApiConstants._();

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

  // ── Appeals (creator-facing) ──────────────────────────────────────────
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

  /// Resolve an image URL. Relative paths (starting with /media/) get the
  /// server root prepended. Absolute URLs are returned as-is.
  static String resolveImageUrl(String baseUrl, String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final uri = Uri.parse(baseUrl);
    final serverRoot =
        '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    return '$serverRoot$url';
  }
}

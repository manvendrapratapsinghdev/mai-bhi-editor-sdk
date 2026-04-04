/// Named route constants for the Mai Bhi Editor SDK.
///
/// Use these constants for type-safe navigation within the SDK.
class MbeRoutes {
  MbeRoutes._();

  static const String feed = '/feed';
  static const String storyDetail = '/feed/:id';
  static const String submit = '/submit';
  static const String mySubmissions = '/my-submissions';
  static const String editorialQueue = '/editorial';
  static const String editorialReview = '/editorial/:id';
  static const String profile = '/profile';
  static const String creatorProfile = '/creators/:id';
  static const String blockedCreators = '/blocked-creators';
  static const String kycUpload = '/kyc';
  static const String aiPreview = '/submissions/:id/ai-preview';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
  static const String adminDashboard = '/admin';
  static const String adminReports = '/admin/reports';
  static const String adminUsers = '/admin/users';
  static const String editorAnalytics = '/editorial/analytics';
  static const String storyDeepLink = '/stories/:id';
}

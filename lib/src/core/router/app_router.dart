// Backwards-compatible shim for features that import AppRoutes.
// Route constants are preserved. The actual router is in src/router/.

/// Named route constants for type-safe navigation.
class AppRoutes {
  AppRoutes._();

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

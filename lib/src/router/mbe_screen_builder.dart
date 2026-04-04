import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/widgets/mbe_error_boundary.dart';
import '../di/injection.dart';
import '../features/admin/presentation/bloc/admin_bloc.dart';
import '../features/admin/presentation/bloc/editor_analytics_bloc.dart';
import '../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../features/admin/presentation/screens/admin_reports_screen.dart';
import '../features/admin/presentation/screens/admin_users_screen.dart';
import '../features/admin/presentation/screens/editor_analytics_screen.dart';
import '../features/community/presentation/bloc/creator_profile_bloc.dart';
import '../features/community/presentation/screens/blocked_creators_screen.dart';
import '../features/community/presentation/screens/creator_profile_screen.dart';
import '../features/editorial/presentation/bloc/editor_review_bloc.dart';
import '../features/editorial/presentation/bloc/editorial_queue_bloc.dart';
import '../features/editorial/presentation/screens/editorial_queue_screen.dart';
import '../features/editorial/presentation/screens/editorial_review_screen.dart';
import '../features/feed/presentation/bloc/feed_bloc.dart';
import '../features/feed/presentation/bloc/story_detail_bloc.dart';
import '../features/feed/presentation/screens/feed_screen.dart';
import '../features/feed/presentation/screens/story_detail_screen.dart';
import '../features/kyc/presentation/screens/kyc_upload_screen.dart';
import '../features/notifications/presentation/bloc/notification_bloc.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/settings/presentation/bloc/settings_bloc.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/submission/presentation/bloc/ai_preview_bloc.dart';
import '../features/submission/presentation/bloc/my_submissions_bloc.dart';
import '../features/submission/presentation/bloc/submission_form_bloc.dart';
import '../features/submission/presentation/screens/ai_preview_screen.dart';
import '../features/submission/presentation/screens/my_submissions_screen.dart';
import '../features/submission/presentation/screens/submission_form_screen.dart';

/// Provides pre-built screen widgets for Mode B navigation.
///
/// Host apps that manage their own routing can use these static methods
/// to get individual SDK screens with their required BLoC providers
/// already wired up.
///
/// ## Example
///
/// ```dart
/// GoRoute(
///   path: '/feed',
///   builder: (_, __) => MbeScreens.feed(),
/// ),
/// ```
class MbeScreens {
  MbeScreens._();

  /// Wraps a screen widget with the SDK error boundary.
  static Widget _guarded(Widget child) => MbeErrorBoundary(child: child);

  // ── Feed ────────────────────────────────────────────────────────────

  static Widget feed() => _guarded(BlocProvider(
        create: (_) => sl<FeedBloc>()..add(const LoadFeed()),
        child: const FeedScreen(),
      ));

  static Widget storyDetail(String id) => _guarded(BlocProvider(
        create: (_) => sl<StoryDetailBloc>(),
        child: StoryDetailScreen(storyId: id),
      ));

  // ── Submission ──────────────────────────────────────────────────────

  static Widget submissionForm({String? draftId}) => _guarded(BlocProvider(
        create: (_) => sl<SubmissionFormBloc>(),
        child: SubmissionFormScreen(draftId: draftId),
      ));

  static Widget mySubmissions() => _guarded(BlocProvider(
        create: (_) => sl<MySubmissionsBloc>()..add(const LoadMySubmissions()),
        child: const MySubmissionsScreen(),
      ));

  static Widget aiPreview(String submissionId) => _guarded(BlocProvider(
        create: (_) =>
            sl<AiPreviewBloc>()..add(LoadAiPreview(submissionId)),
        child: AiPreviewScreen(submissionId: submissionId),
      ));

  // ── Editorial ───────────────────────────────────────────────────────

  static Widget editorialQueue() => _guarded(BlocProvider(
        create: (_) =>
            sl<EditorialQueueBloc>()..add(const LoadQueue()),
        child: const EditorialQueueScreen(),
      ));

  static Widget editorialReview(String submissionId) => _guarded(BlocProvider(
        create: (_) =>
            sl<EditorReviewBloc>()..add(LoadReview(submissionId)),
        child: EditorialReviewScreen(submissionId: submissionId),
      ));

  // ── Editor Analytics ────────────────────────────────────────────────

  static Widget editorAnalytics() => _guarded(BlocProvider(
        create: (_) =>
            sl<EditorAnalyticsBloc>()..add(const LoadEditorAnalytics()),
        child: const EditorAnalyticsScreen(),
      ));

  // ── Profile ─────────────────────────────────────────────────────────

  static Widget profile() => _guarded(const ProfileScreen());

  // ── KYC ─────────────────────────────────────────────────────────────

  static Widget kycUpload() => _guarded(const KycUploadScreen());

  // ── Creator Profile ────────────────────────────────────────────────

  static Widget creatorProfile(String creatorId) => _guarded(BlocProvider(
        create: (_) => sl<CreatorProfileBloc>(),
        child: CreatorProfileScreen(creatorId: creatorId),
      ));

  static Widget blockedCreators() => _guarded(const BlockedCreatorsScreen());

  // ── Notifications ──────────────────────────────────────────────────

  static Widget notifications() => _guarded(BlocProvider(
        create: (_) => sl<NotificationBloc>()..add(const LoadNotifications()),
        child: const NotificationsScreen(),
      ));

  // ── Settings ───────────────────────────────────────────────────────

  static Widget settings() => _guarded(BlocProvider(
        create: (_) => sl<SettingsBloc>()..add(const LoadSettings()),
        child: const SettingsScreen(),
      ));

  // ── Onboarding ─────────────────────────────────────────────────────

  static Widget onboarding() => _guarded(const OnboardingScreen());

  // ── Admin ──────────────────────────────────────────────────────────

  static Widget adminDashboard() => _guarded(BlocProvider(
        create: (_) => sl<AdminBloc>()..add(const LoadDashboardStats()),
        child: const AdminDashboardScreen(),
      ));

  static Widget adminReports() => _guarded(BlocProvider(
        create: (_) => sl<AdminBloc>()..add(const LoadReports()),
        child: const AdminReportsScreen(),
      ));

  static Widget adminUsers() => _guarded(BlocProvider(
        create: (_) => sl<AdminBloc>()..add(const LoadUsers()),
        child: const AdminUsersScreen(),
      ));
}

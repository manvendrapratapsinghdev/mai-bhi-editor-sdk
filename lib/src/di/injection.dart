import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/analytics/analytics_service.dart';
import '../network/api_client.dart';

// ── Feed ────────────────────────────────────────────────────────────────
import '../features/feed/data/datasources/city_preference_datasource.dart';
import '../features/feed/data/datasources/feed_remote_datasource.dart';
import '../features/feed/data/repositories/feed_repository_impl.dart';
import '../features/feed/domain/repositories/feed_repository.dart';
import '../features/feed/domain/usecases/get_feed_usecase.dart';
import '../features/feed/domain/usecases/get_shareable_link_usecase.dart';
import '../features/feed/domain/usecases/get_story_detail_usecase.dart';
import '../features/feed/domain/usecases/search_stories_usecase.dart';
import '../features/feed/presentation/bloc/feed_bloc.dart';
import '../features/feed/presentation/bloc/story_detail_bloc.dart';

// ── Submission ──────────────────────────────────────────────────────────
import '../features/submission/data/datasources/submission_remote_datasource.dart';
import '../features/submission/data/local/draft_local_datasource.dart';
import '../features/submission/data/repositories/submission_repository_impl.dart';
import '../features/submission/domain/repositories/submission_repository.dart';
import '../features/submission/domain/usecases/create_submission_usecase.dart';
import '../features/submission/domain/usecases/get_my_submissions_usecase.dart';
import '../features/submission/domain/usecases/get_submission_detail_usecase.dart';
import '../features/submission/domain/usecases/trigger_ai_processing_usecase.dart';
import '../features/submission/presentation/bloc/ai_preview_bloc.dart';
import '../features/submission/presentation/bloc/my_submissions_bloc.dart';
import '../features/submission/presentation/bloc/submission_form_bloc.dart';

// ── Editorial ───────────────────────────────────────────────────────────
import '../features/editorial/data/datasources/editorial_remote_datasource.dart';
import '../features/editorial/data/repositories/editorial_repository_impl.dart';
import '../features/editorial/domain/repositories/editorial_repository.dart';
import '../features/editorial/domain/usecases/flag_false_news_usecase.dart';
import '../features/editorial/domain/usecases/get_appeal_usecase.dart';
import '../features/editorial/domain/usecases/get_editorial_queue_usecase.dart';
import '../features/editorial/domain/usecases/perform_editor_action_usecase.dart';
import '../features/editorial/domain/usecases/submit_appeal_usecase.dart';
import '../features/editorial/presentation/bloc/appeal_bloc.dart';
import '../features/editorial/presentation/bloc/editor_review_bloc.dart';
import '../features/editorial/presentation/bloc/editorial_queue_bloc.dart';

// ── Community ───────────────────────────────────────────────────────────
import '../features/community/data/datasources/community_remote_datasource.dart';
import '../features/community/data/repositories/community_repository_impl.dart';
import '../features/community/domain/repositories/community_repository.dart';
import '../features/community/domain/usecases/block_creator_usecase.dart';
import '../features/community/domain/usecases/confirm_story_usecase.dart';
import '../features/community/domain/usecases/get_blocked_creators_usecase.dart';
import '../features/community/domain/usecases/get_creator_profile_usecase.dart';
import '../features/community/domain/usecases/like_story_usecase.dart';
import '../features/community/domain/usecases/report_usecase.dart';
import '../features/community/presentation/bloc/creator_profile_bloc.dart';

// ── Notifications ───────────────────────────────────────────────────────
import '../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/domain/repositories/notification_repository.dart';
import '../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../features/notifications/domain/usecases/register_device_usecase.dart';
import '../features/notifications/presentation/bloc/notification_bloc.dart';

// ── Settings ────────────────────────────────────────────────────────────
import '../features/settings/presentation/bloc/settings_bloc.dart';


// ── Admin ───────────────────────────────────────────────────────────────
import '../features/admin/data/datasources/admin_remote_datasource.dart';
import '../features/admin/data/repositories/admin_repository_impl.dart';
import '../features/admin/domain/repositories/admin_repository.dart';
import '../features/admin/presentation/bloc/admin_bloc.dart';
import '../features/admin/presentation/bloc/editor_analytics_bloc.dart';

// ── KYC ─────────────────────────────────────────────────────────────────
import '../features/kyc/data/datasources/kyc_remote_datasource.dart';
import '../features/kyc/data/repositories/kyc_repository_impl.dart';
import '../features/kyc/domain/repositories/kyc_repository.dart';
import '../features/kyc/presentation/bloc/kyc_bloc.dart';

// ── Onboarding ──────────────────────────────────────────────────────────
import '../features/onboarding/data/onboarding_preferences.dart';

/// Package-scoped service locator.
///
/// Uses [GetIt.asNewInstance] to avoid collisions with the host app's DI.
final GetIt sl = GetIt.asNewInstance();

/// Register all SDK-internal dependencies.
///
/// Called once by [MaiBhiEditor.initialize]. Auth-related registrations are
/// intentionally absent — auth is delegated to the host via [AuthProvider].
Future<void> registerSdkDependencies() async {
  // ── External / Core ──────────────────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => MbeApiClient.instance);

  // ── Analytics ────────────────────────────────────────────────────────
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService(sl()));

  // ── Onboarding ───────────────────────────────────────────────────────
  sl.registerLazySingleton<OnboardingPreferences>(
      () => OnboardingPreferences());

  // ── Feed Feature ─────────────────────────────────────────────────────
  _registerFeedFeature();

  // ── Submission Feature ───────────────────────────────────────────────
  _registerSubmissionFeature();

  // ── Editorial Feature ────────────────────────────────────────────────
  _registerEditorialFeature();

  // ── Community Feature ────────────────────────────────────────────────
  _registerCommunityFeature();

  // ── Notification Feature ─────────────────────────────────────────────
  _registerNotificationFeature();

  // ── Settings Feature ─────────────────────────────────────────────────
  _registerSettingsFeature();

  // ── Admin Feature ────────────────────────────────────────────────────
  _registerAdminFeature();

  // ── KYC Feature ──────────────────────────────────────────────────────
  _registerKycFeature();
}

// ── Feature Registration Functions ───────────────────────────────────────

void _registerFeedFeature() {
  // DataSources
  sl.registerLazySingleton<FeedRemoteDataSource>(
      () => FeedRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CityPreferenceDataSource>(
      () => CityPreferenceDataSourceImpl());

  // Repository
  sl.registerLazySingleton<FeedRepository>(
      () => FeedRepositoryImpl(remoteDataSource: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetFeedUseCase(sl()));
  sl.registerLazySingleton(() => SearchStoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetStoryDetailUseCase(sl()));
  sl.registerLazySingleton(() => GetShareableLinkUseCase(sl()));

  // BLoCs (factory — new instance per screen)
  sl.registerFactory(() => FeedBloc(
        getFeedUseCase: sl(),
        searchStoriesUseCase: sl(),
      ));
  sl.registerFactory(() => StoryDetailBloc(
        getStoryDetailUseCase: sl(),
        getShareableLinkUseCase: sl(),
        communityRepository: sl(),
      ));
}

void _registerSubmissionFeature() {
  // DataSources
  sl.registerLazySingleton<SubmissionRemoteDataSource>(
      () => SubmissionRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<DraftLocalDataSource>(
      () => DraftLocalDataSourceImpl());

  // Repository
  sl.registerLazySingleton<SubmissionRepository>(() =>
      SubmissionRepositoryImpl(
          remoteDataSource: sl(), draftLocalDataSource: sl()));

  // UseCases
  sl.registerLazySingleton(() => CreateSubmissionUseCase(sl()));
  sl.registerLazySingleton(() => GetMySubmissionsUseCase(sl()));
  sl.registerLazySingleton(
      () => GetSubmissionDetailUseCase(sl()));
  sl.registerLazySingleton(
      () => TriggerAiProcessingUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => SubmissionFormBloc(
        createSubmissionUseCase: sl(),
        draftLocalDataSource: sl(),
      ));
  sl.registerFactory(() => MySubmissionsBloc(
        getMySubmissionsUseCase: sl(),
        draftLocalDataSource: sl(),
      ));
  sl.registerFactory(() => AiPreviewBloc(
        getSubmissionDetailUseCase: sl(),
        triggerAiProcessingUseCase: sl(),
      ));
}

void _registerEditorialFeature() {
  // DataSources
  sl.registerLazySingleton<EditorialRemoteDataSource>(
      () => EditorialRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<EditorialRepository>(
      () => EditorialRepositoryImpl(remoteDataSource: sl()));

  // UseCases
  sl.registerLazySingleton(
      () => GetEditorialQueueUseCase(sl()));
  sl.registerLazySingleton(
      () => PerformEditorActionUseCase(sl()));
  sl.registerLazySingleton(() => FlagFalseNewsUseCase(sl()));
  sl.registerLazySingleton(() => GetAppealUseCase(sl()));
  sl.registerLazySingleton(() => SubmitAppealUseCase(sl()));

  // BLoCs
  sl.registerFactory(
      () => EditorialQueueBloc(getEditorialQueueUseCase: sl()));
  sl.registerFactory(() => EditorReviewBloc(
        repository: sl(),
        performEditorActionUseCase: sl(),
        flagFalseNewsUseCase: sl(),
      ));
  sl.registerFactory(() => AppealBloc(
        getAppealUseCase: sl(),
        submitAppealUseCase: sl(),
      ));
}

void _registerCommunityFeature() {
  // DataSources
  sl.registerLazySingleton<CommunityRemoteDataSource>(
      () => CommunityRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<CommunityRepository>(
      () => CommunityRepositoryImpl(remoteDataSource: sl()));

  // UseCases
  sl.registerLazySingleton(
      () => GetCreatorProfileUseCase(sl()));
  sl.registerLazySingleton(() => LikeStoryUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmStoryUseCase(sl()));
  sl.registerLazySingleton(() => BlockCreatorUseCase(sl()));
  sl.registerLazySingleton(() => ReportUseCase(sl()));
  sl.registerLazySingleton(
      () => GetBlockedCreatorsUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => CreatorProfileBloc(
        communityRepository: sl(),
        feedRepository: sl(),
      ));
}

void _registerNotificationFeature() {
  // DataSources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(remoteDataSource: sl()));

  // UseCases
  sl.registerLazySingleton(
      () => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => RegisterDeviceUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => NotificationBloc(
        getNotificationsUseCase: sl(),
        registerDeviceUseCase: sl(),
        repository: sl(),
      ));
}

void _registerSettingsFeature() {
  // BLoCs (depends on NotificationRepository registered above)
  sl.registerFactory(
      () => SettingsBloc(notificationRepository: sl()));
}

void _registerAdminFeature() {
  // DataSources
  sl.registerLazySingleton<AdminRemoteDataSource>(
      () => AdminRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(remoteDataSource: sl()));

  // BLoCs
  sl.registerFactory(() => AdminBloc(repository: sl()));
  sl.registerFactory(() => EditorAnalyticsBloc(repository: sl()));
}

void _registerKycFeature() {
  // DataSources
  sl.registerLazySingleton<KycRemoteDataSource>(
      () => KycRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<KycRepository>(
      () => KycRepositoryImpl(remoteDataSource: sl()));

  // BLoCs
  sl.registerFactory(() => KycBloc(kycRepository: sl()));
}

/// Reset all registrations (for testing).
Future<void> resetSdkDependencies() async {
  await sl.reset();
}

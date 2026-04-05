import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';
import 'package:mai_bhi_editor_sdk/src/core/analytics/analytics_service.dart';
import 'package:mai_bhi_editor_sdk/src/di/injection.dart';
import 'package:mai_bhi_editor_sdk/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:mai_bhi_editor_sdk/src/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/data/datasources/community_remote_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/domain/repositories/community_repository.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/domain/usecases/block_creator_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/domain/usecases/confirm_story_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/domain/usecases/get_blocked_creators_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/domain/usecases/get_creator_profile_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/domain/usecases/like_story_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/community/domain/usecases/report_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/editorial/data/datasources/editorial_remote_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/editorial/domain/repositories/editorial_repository.dart';
import 'package:mai_bhi_editor_sdk/src/features/editorial/domain/usecases/flag_false_news_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/editorial/domain/usecases/get_appeal_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/editorial/domain/usecases/get_editorial_queue_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/editorial/domain/usecases/perform_editor_action_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/editorial/domain/usecases/submit_appeal_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/data/datasources/city_preference_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/domain/repositories/feed_repository.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/domain/usecases/get_feed_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/domain/usecases/get_shareable_link_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/domain/usecases/get_story_detail_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/domain/usecases/search_stories_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:mai_bhi_editor_sdk/src/features/kyc/data/datasources/kyc_remote_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:mai_bhi_editor_sdk/src/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mai_bhi_editor_sdk/src/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/notifications/domain/usecases/register_device_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/onboarding/data/onboarding_preferences.dart';
import 'package:mai_bhi_editor_sdk/src/features/submission/data/datasources/submission_remote_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/submission/data/local/draft_local_datasource.dart';
import 'package:mai_bhi_editor_sdk/src/features/submission/domain/repositories/submission_repository.dart';
import 'package:mai_bhi_editor_sdk/src/features/submission/domain/usecases/create_submission_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/submission/domain/usecases/get_my_submissions_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/submission/domain/usecases/get_submission_detail_usecase.dart';
import 'package:mai_bhi_editor_sdk/src/features/submission/domain/usecases/trigger_ai_processing_usecase.dart';

// ── Minimal fake AuthProvider for testing ────────────────────────────────

class _FakeAuthProvider implements AuthProvider {
  @override
  AuthStatus get authStatus => AuthStatus.unauthenticated;

  @override
  MbeUser? get currentUser => null;

  @override
  Stream<AuthStatus> get authStatusStream => const Stream.empty();

  @override
  Future<Map<String, String>> getAuthHeaders() async => const {};

  @override
  Future<bool> requestLogin() async => false;

  @override
  Future<void> logout() async {}
}

void main() {
  group('SDK DI smoke test', () {
    setUp(() async {
      await MaiBhiEditor.reset();
      await MaiBhiEditor.initialize(
        authProvider: _FakeAuthProvider(),
        baseUrl: 'https://test.example.com/v1',
        enableAnalytics: false,
      );
    });

    tearDown(() async {
      await MaiBhiEditor.reset();
    });

    test('all singleton services resolve without throwing', () {
      // Core services
      expect(() => sl<AnalyticsService>(), returnsNormally);
      expect(() => sl<OnboardingPreferences>(), returnsNormally);

      // Feed
      expect(() => sl<FeedRepository>(), returnsNormally);
      expect(() => sl<FeedRemoteDataSource>(), returnsNormally);
      expect(() => sl<CityPreferenceDataSource>(), returnsNormally);
      expect(() => sl<GetFeedUseCase>(), returnsNormally);
      expect(() => sl<SearchStoriesUseCase>(), returnsNormally);
      expect(() => sl<GetStoryDetailUseCase>(), returnsNormally);
      expect(() => sl<GetShareableLinkUseCase>(), returnsNormally);

      // Submission
      expect(() => sl<SubmissionRepository>(), returnsNormally);
      expect(() => sl<SubmissionRemoteDataSource>(), returnsNormally);
      expect(() => sl<DraftLocalDataSource>(), returnsNormally);
      expect(() => sl<CreateSubmissionUseCase>(), returnsNormally);
      expect(() => sl<GetMySubmissionsUseCase>(), returnsNormally);
      expect(() => sl<GetSubmissionDetailUseCase>(), returnsNormally);
      expect(() => sl<TriggerAiProcessingUseCase>(), returnsNormally);

      // Editorial
      expect(() => sl<EditorialRepository>(), returnsNormally);
      expect(() => sl<EditorialRemoteDataSource>(), returnsNormally);
      expect(() => sl<GetEditorialQueueUseCase>(), returnsNormally);
      expect(() => sl<PerformEditorActionUseCase>(), returnsNormally);
      expect(() => sl<FlagFalseNewsUseCase>(), returnsNormally);
      expect(() => sl<GetAppealUseCase>(), returnsNormally);
      expect(() => sl<SubmitAppealUseCase>(), returnsNormally);

      // Community
      expect(() => sl<CommunityRepository>(), returnsNormally);
      expect(() => sl<CommunityRemoteDataSource>(), returnsNormally);
      expect(() => sl<GetCreatorProfileUseCase>(), returnsNormally);
      expect(() => sl<LikeStoryUseCase>(), returnsNormally);
      expect(() => sl<ConfirmStoryUseCase>(), returnsNormally);
      expect(() => sl<BlockCreatorUseCase>(), returnsNormally);
      expect(() => sl<ReportUseCase>(), returnsNormally);
      expect(() => sl<GetBlockedCreatorsUseCase>(), returnsNormally);

      // Notifications
      expect(() => sl<NotificationRepository>(), returnsNormally);
      expect(() => sl<NotificationRemoteDataSource>(), returnsNormally);
      expect(() => sl<GetNotificationsUseCase>(), returnsNormally);
      expect(() => sl<RegisterDeviceUseCase>(), returnsNormally);

      // Admin
      expect(() => sl<AdminRepository>(), returnsNormally);
      expect(() => sl<AdminRemoteDataSource>(), returnsNormally);

      // KYC
      expect(() => sl<KycRepository>(), returnsNormally);
      expect(() => sl<KycRemoteDataSource>(), returnsNormally);
    });

    test('BLoC factories create new instances each call', () {
      final feed1 = sl<FeedBloc>();
      final feed2 = sl<FeedBloc>();
      expect(identical(feed1, feed2), isFalse);
      feed1.close();
      feed2.close();

      final admin1 = sl<AdminBloc>();
      final admin2 = sl<AdminBloc>();
      expect(identical(admin1, admin2), isFalse);
      admin1.close();
      admin2.close();
    });

    test('reset and re-initialize works without error', () async {
      await MaiBhiEditor.reset();

      await MaiBhiEditor.initialize(
        authProvider: _FakeAuthProvider(),
        baseUrl: 'https://test2.example.com/v1',
        enableAnalytics: false,
      );

      expect(MaiBhiEditor.isInitialized, isTrue);
      expect(MaiBhiEditor.baseUrl, 'https://test2.example.com/v1');

      final bloc = sl<FeedBloc>();
      expect(bloc, isNotNull);
      bloc.close();
    });
  });
}

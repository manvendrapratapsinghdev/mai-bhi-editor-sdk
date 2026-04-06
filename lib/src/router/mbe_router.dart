import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_status.dart';
import '../config/mai_bhi_editor_initializer.dart';
import 'mbe_routes.dart';
import 'mbe_page_transitions.dart';
import 'mbe_screen_builder.dart';

/// SDK-internal GoRouter with auth guards using [AuthProvider].
///
/// Use [MaiBhiEditor.router] to access this. The host app can use it
/// as its primary router (Mode A) or use [MbeScreens] for Mode B.
class MbeRouter {
  MbeRouter._();

  /// Root navigator key. Host apps can use this to push modal screens
  /// (e.g. login) on top of the SDK's router.
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'mbe_root');

  /// Routes that require hard redirect when unauthenticated.
  ///
  /// Editorial routes require an editor role; admin routes require admin.
  /// All other routes either work without auth (feed, stories, creators)
  /// or handle auth at the screen level via [AuthGateWidget] so the user
  /// is never silently bounced away.
  static const _editorRoutes = <String>{
    '/editorial',
  };

  static const _editorPrefixes = <String>{'/editorial/'};

  /// Routes that require admin role.
  static const _adminRoutes = <String>{
    '/admin',
    '/admin/reports',
    '/admin/users',
  };

  static GoRouter get router => _router ??= _createRouter();

  static GoRouter? _router;

  /// Reset the router so it is recreated on next access.
  /// Called by [MaiBhiEditor.reset] to ensure a fresh auth provider is used.
  static void reset() {
    _router?.dispose();
    _router = null;
  }

  static GoRouter _createRouter() => GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: MbeRoutes.feed,
    debugLogDiagnostics: true,
    routes: [
      // ── Feed ────────────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.feed,
        name: 'feed',
        builder: (context, state) => MbeScreens.feed(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'storyDetail',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return slideTransitionPage(
                state: state,
                child: MbeScreens.storyDetail(id),
              );
            },
          ),
        ],
      ),

      // ── Deep link: /stories/:id -> redirects to /feed/:id ──────────
      GoRoute(
        path: MbeRoutes.storyDeepLink,
        name: 'storyDeepLink',
        redirect: (context, state) {
          final id = state.pathParameters['id'];
          return '/feed/$id';
        },
      ),

      // ── Submission ──────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.submit,
        name: 'submit',
        pageBuilder: (context, state) {
          final draftId = state.uri.queryParameters['draftId'];
          return slideTransitionPage(
            state: state,
            child: MbeScreens.submissionForm(draftId: draftId),
          );
        },
      ),
      GoRoute(
        path: MbeRoutes.mySubmissions,
        name: 'mySubmissions',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.mySubmissions(),
        ),
      ),

      // ── AI Preview ────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.aiPreview,
        name: 'aiPreview',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return slideTransitionPage(
            state: state,
            child: MbeScreens.aiPreview(id),
          );
        },
      ),

      // ── Editorial ───────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.editorialQueue,
        name: 'editorialQueue',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.editorialQueue(),
        ),
        routes: [
          GoRoute(
            path: ':id',
            name: 'editorialReview',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return slideTransitionPage(
                state: state,
                child: MbeScreens.editorialReview(id),
              );
            },
          ),
        ],
      ),

      // ── Editor Analytics ────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.editorAnalytics,
        name: 'editorAnalytics',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.editorAnalytics(),
        ),
      ),

      // ── Profile ─────────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.profile(),
        ),
      ),

      // ── KYC ─────────────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.kycUpload,
        name: 'kycUpload',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.kycUpload(),
        ),
      ),

      // ── Creator public profile ──────────────────────────────────────
      GoRoute(
        path: MbeRoutes.creatorProfile,
        name: 'creatorProfile',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return slideTransitionPage(
            state: state,
            child: MbeScreens.creatorProfile(id),
          );
        },
      ),

      // ── Blocked creators list ────────────────────────────────────
      GoRoute(
        path: MbeRoutes.blockedCreators,
        name: 'blockedCreators',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.blockedCreators(),
        ),
      ),

      // ── Notifications ──────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.notifications(),
        ),
      ),

      // ── Settings ───────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.settings(),
        ),
      ),

      // ── Onboarding ─────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.onboarding(),
        ),
      ),

      // ── Admin Dashboard ────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.adminDashboard,
        name: 'adminDashboard',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.adminDashboard(),
        ),
      ),

      // ── Admin Reports ──────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.adminReports,
        name: 'adminReports',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.adminReports(),
        ),
      ),

      // ── Admin Users ────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.adminUsers,
        name: 'adminUsers',
        pageBuilder: (context, state) => slideTransitionPage(
          state: state,
          child: MbeScreens.adminUsers(),
        ),
      ),
    ],

    // ── Auth redirect ─────────────────────────────────────────────────
    //
    // Lazy auth: most routes are allowed through for unauthenticated
    // users. Screens that need auth show an inline login prompt via
    // AuthGateWidget instead of bouncing to /feed. Only editorial
    // (editor-role) and admin routes hard-redirect.
    redirect: (context, state) {
      final authStatus = MaiBhiEditor.authProvider.authStatus;
      final isAuthenticated = authStatus == AuthStatus.authenticated;
      final currentPath = state.uri.path;

      // If still loading auth state, don't redirect yet.
      if (authStatus == AuthStatus.unknown) {
        return null;
      }

      // Editorial routes require editor role — hard redirect.
      final isEditorRoute = _editorRoutes.contains(currentPath) ||
          _editorPrefixes.any(currentPath.startsWith);
      if (isEditorRoute && !isAuthenticated) {
        return MbeRoutes.feed;
      }

      // Admin route guard.
      if (_adminRoutes.contains(currentPath)) {
        if (!isAuthenticated) return MbeRoutes.feed;
        final user = MaiBhiEditor.authProvider.currentUser;
        if (user == null || !user.isAdmin) {
          return MbeRoutes.feed;
        }
      }

      // All other routes pass through. Screens use AuthGateWidget
      // to show an inline login prompt when needed.
      return null;
    },

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(MbeRoutes.feed);
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${state.uri}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(MbeRoutes.feed),
              child: const Text('Go to Feed'),
            ),
          ],
        ),
      ),
    ),
  );
}

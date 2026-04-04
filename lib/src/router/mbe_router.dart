import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_status.dart';
import '../config/mai_bhi_editor_initializer.dart';
import 'mbe_routes.dart';
import 'mbe_screen_builder.dart';

/// SDK-internal GoRouter with auth guards using [AuthProvider].
///
/// Use [MaiBhiEditor.router] to access this. The host app can use it
/// as its primary router (Mode A) or use [MbeScreens] for Mode B.
class MbeRouter {
  MbeRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'mbe_root');

  /// Routes that don't require authentication.
  static const _publicRoutes = <String>{
    '/onboarding',
    '/feed',
  };

  /// Route prefixes accessible without authentication.
  static const _publicPrefixes = <String>{'/feed/', '/stories/', '/creators/'};

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
    navigatorKey: _rootNavigatorKey,
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
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MbeScreens.storyDetail(id);
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
        builder: (context, state) {
          final draftId = state.uri.queryParameters['draftId'];
          return MbeScreens.submissionForm(draftId: draftId);
        },
      ),
      GoRoute(
        path: MbeRoutes.mySubmissions,
        name: 'mySubmissions',
        builder: (context, state) => MbeScreens.mySubmissions(),
      ),

      // ── AI Preview ────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.aiPreview,
        name: 'aiPreview',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MbeScreens.aiPreview(id);
        },
      ),

      // ── Editorial ───────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.editorialQueue,
        name: 'editorialQueue',
        builder: (context, state) => MbeScreens.editorialQueue(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'editorialReview',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MbeScreens.editorialReview(id);
            },
          ),
        ],
      ),

      // ── Editor Analytics ────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.editorAnalytics,
        name: 'editorAnalytics',
        builder: (context, state) => MbeScreens.editorAnalytics(),
      ),

      // ── Profile ─────────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.profile,
        name: 'profile',
        builder: (context, state) => MbeScreens.profile(),
      ),

      // ── KYC ─────────────────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.kycUpload,
        name: 'kycUpload',
        builder: (context, state) => MbeScreens.kycUpload(),
      ),

      // ── Creator public profile ──────────────────────────────────────
      GoRoute(
        path: MbeRoutes.creatorProfile,
        name: 'creatorProfile',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MbeScreens.creatorProfile(id);
        },
      ),

      // ── Blocked creators list ────────────────────────────────────
      GoRoute(
        path: MbeRoutes.blockedCreators,
        name: 'blockedCreators',
        builder: (context, state) => MbeScreens.blockedCreators(),
      ),

      // ── Notifications ──────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => MbeScreens.notifications(),
      ),

      // ── Settings ───────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.settings,
        name: 'settings',
        builder: (context, state) => MbeScreens.settings(),
      ),

      // ── Onboarding ─────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => MbeScreens.onboarding(),
      ),

      // ── Admin Dashboard ────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) => MbeScreens.adminDashboard(),
      ),

      // ── Admin Reports ──────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.adminReports,
        name: 'adminReports',
        builder: (context, state) => MbeScreens.adminReports(),
      ),

      // ── Admin Users ────────────────────────────────────────────
      GoRoute(
        path: MbeRoutes.adminUsers,
        name: 'adminUsers',
        builder: (context, state) => MbeScreens.adminUsers(),
      ),
    ],

    // ── Auth redirect ─────────────────────────────────────────────────
    redirect: (context, state) {
      final authStatus = MaiBhiEditor.authProvider.authStatus;
      final isAuthenticated = authStatus == AuthStatus.authenticated;
      final currentPath = state.uri.path;
      final isPublicRoute = _publicRoutes.contains(currentPath) ||
          _publicPrefixes.any(currentPath.startsWith);

      // If still loading auth state, don't redirect yet.
      if (authStatus == AuthStatus.unknown) {
        return null;
      }

      // Unauthenticated user trying to access a protected route.
      if (!isAuthenticated && !isPublicRoute) {
        return MbeRoutes.feed;
      }

      // Admin route guard.
      if (_adminRoutes.contains(currentPath) && isAuthenticated) {
        final user = MaiBhiEditor.authProvider.currentUser;
        if (user == null || !user.isAdmin) {
          return MbeRoutes.feed;
        }
      }

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

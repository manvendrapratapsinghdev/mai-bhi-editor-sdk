import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth/auth_status.dart';
import '../../config/mai_bhi_editor_initializer.dart';
import '../theme/app_colors.dart';

/// A widget that gates its [child] behind authentication.
///
/// Instead of redirecting unauthenticated users to `/feed`, this widget
/// shows an inline login prompt with a sign-in button. When the user
/// authenticates (via the host app), the widget automatically rebuilds
/// to show the protected [child].
///
/// Use this for "soft-gated" screens — pages that a logged-in user should
/// see normally, but that aren't meaningful without a user identity
/// (e.g. notifications, settings, my-submissions).
class AuthGateWidget extends StatefulWidget {
  /// The screen content to show when the user is authenticated.
  final Widget child;

  /// Title shown in the login prompt (e.g. "Notifications").
  final String featureTitle;

  /// Description shown below the title explaining why login is needed.
  final String? featureDescription;

  /// Icon shown in the login prompt.
  final IconData icon;

  const AuthGateWidget({
    super.key,
    required this.child,
    required this.featureTitle,
    this.featureDescription,
    this.icon = Icons.lock_outline,
  });

  @override
  State<AuthGateWidget> createState() => _AuthGateWidgetState();
}

class _AuthGateWidgetState extends State<AuthGateWidget> {
  StreamSubscription<AuthStatus>? _authSub;
  bool _isRequestingLogin = false;

  @override
  void initState() {
    super.initState();
    _authSub = MaiBhiEditor.authProvider.authStatusStream.listen((status) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  bool get _isAuthenticated =>
      MaiBhiEditor.authProvider.authStatus == AuthStatus.authenticated;

  Future<void> _requestLogin() async {
    setState(() => _isRequestingLogin = true);
    try {
      await MaiBhiEditor.authProvider.requestLogin();
    } finally {
      if (mounted) setState(() => _isRequestingLogin = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) return widget.child;

    final theme = Theme.of(context);
    final description = widget.featureDescription ??
        'Sign in to access ${widget.featureTitle.toLowerCase()}.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 72,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 20),
            Text(
              widget.featureTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: _isRequestingLogin ? null : _requestLogin,
                icon: _isRequestingLogin
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login),
                label: Text(_isRequestingLogin ? 'Signing in...' : 'Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You can browse stories without signing in',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.lightGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/auth_status.dart';
import '../../../../config/mai_bhi_editor_initializer.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../community/presentation/widgets/badge_collection_widget.dart';
import '../widgets/creator_badge_widget.dart';

/// User profile screen with creator badge display.
///
/// Now reads user data from [MaiBhiEditor.authProvider] instead of AuthBloc.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for auth changes to trigger UI updates.
    MaiBhiEditor.authProvider.authStatusStream.listen((status) {
      if (mounted) {
        if (status == AuthStatus.unauthenticated) {
          context.go(AppRoutes.feed);
        } else {
          setState(() {});
        }
      }
    });
  }

  UserProfile? _mapMbeUserToProfile(MbeUser? mbeUser) {
    if (mbeUser == null) return null;
    return UserProfile(
      id: mbeUser.id,
      name: mbeUser.name,
      email: mbeUser.email,
      avatarUrl: mbeUser.avatarUrl,
      city: mbeUser.city,
      creatorLevel: _parseCreatorLevel(mbeUser.creatorLevel),
      reputationPoints: mbeUser.reputationPoints,
      storiesPublished: mbeUser.storiesPublished,
      badges: mbeUser.badges,
    );
  }

  CreatorLevel _parseCreatorLevel(String level) {
    switch (level) {
      case 'ht_approved_creator':
        return CreatorLevel.htApprovedCreator;
      case 'trusted_reporter':
        return CreatorLevel.trustedReporter;
      default:
        return CreatorLevel.basicCreator;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = MaiBhiEditor.authProvider;
    final isAuthenticated = authProvider.authStatus == AuthStatus.authenticated;
    final user = _mapMbeUserToProfile(authProvider.currentUser);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('My Profile'),
        ),
      ),
      body: !isAuthenticated || user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: AppColors.mediumGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load profile',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => authProvider.requestLogin(),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            )
          : _ProfileContent(user: user),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserProfile user;

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        // Trigger a profile refresh via auth provider if supported.
        await Future<void>.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Avatar ──────────────────────────────────────────────
            Semantics(
              image: true,
              label: 'Profile picture for ${user.name}',
              child: CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.primaryRedLight,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(ApiConstants.resolveImageUrl(user.avatarUrl!))
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        _initials(user.name),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // ── Name ────────────────────────────────────────────────
            Semantics(
              header: true,
              child: Text(
                user.name,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),

            // ── Email ───────────────────────────────────────────────
            Text(
              user.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // ── Creator badge ───────────────────────────────────────
            CreatorBadgeWidget(
              level: user.creatorLevel,
              size: 28,
            ),
            const SizedBox(height: 24),

            // ── Stats cards ─────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_outline,
                    label: 'Reputation',
                    value: user.reputationPoints.toString(),
                    color: AppColors.badgeGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.article_outlined,
                    label: 'Published',
                    value: user.storiesPublished.toString(),
                    color: AppColors.statusPublished,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Details section ─────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.location_city_outlined,
                      label: 'City',
                      value: user.city ?? 'Not set',
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      icon: Icons.workspace_premium_outlined,
                      label: 'Level',
                      value: _creatorLevelDisplay(user.creatorLevel),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Badge collection ─────────────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Badges',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            BadgeCollectionWidget(badges: user.badges),
            const SizedBox(height: 24),

            // ── Settings ──────────────────────────────────────────────
            Semantics(
              button: true,
              label: 'Open settings',
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Settings'),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Blocked creators ─────────────────────────────────────
            Semantics(
              button: true,
              label: 'View blocked creators list',
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.blockedCreators),
                  icon: const Icon(Icons.block),
                  label: const Text('Blocked Creators'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mediumGrey,
                    side: const BorderSide(color: AppColors.lightGrey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Upgrade to Approved button (basic_creator only) ─────
            if (user.creatorLevel == CreatorLevel.basicCreator)
              Semantics(
                button: true,
                label: 'Upgrade to HT Approved Creator via KYC verification',
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.kycUpload),
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('Upgrade to Approved Creator'),
                ),
              ),

            if (user.creatorLevel == CreatorLevel.basicCreator)
              const SizedBox(height: 16),

            // ── Logout button ───────────────────────────────────────
            Semantics(
              button: true,
              label: 'Log out of your account',
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.statusRejected,
                    side: const BorderSide(color: AppColors.statusRejected),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _creatorLevelDisplay(CreatorLevel level) {
    switch (level) {
      case CreatorLevel.basicCreator:
        return 'Basic Creator';
      case CreatorLevel.htApprovedCreator:
        return 'HT Approved Creator';
      case CreatorLevel.trustedReporter:
        return 'Trusted Reporter';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await MaiBhiEditor.authProvider.logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.statusRejected,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

/// A card displaying a single stat with icon, value, and label.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$label: $value',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A row showing icon, label, and value for profile details.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$label: $value',
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.mediumGrey),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.mediumGrey,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/admin_bloc.dart';

/// Admin dashboard showing key stats and quick links.
///
/// Only accessible to users with admin role.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Admin Dashboard'),
        ),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.statusRejected,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.isLoadingStats) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = state.stats;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(const LoadDashboardStats());
              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats cards ──────────────────────────────────────
                  Semantics(
                    label: 'Dashboard statistics',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _StatCard(
                          icon: Icons.people_outline,
                          label: 'Total Users',
                          value: stats.totalUsers.toString(),
                          color: AppColors.statusUnderReview,
                        ),
                        _StatCard(
                          icon: Icons.article_outlined,
                          label: 'Total Stories',
                          value: stats.totalStories.toString(),
                          color: AppColors.statusPublished,
                        ),
                        _StatCard(
                          icon: Icons.upload_outlined,
                          label: 'Submissions Today',
                          value: stats.submissionsToday.toString(),
                          color: AppColors.statusInProgress,
                        ),
                        _StatCard(
                          icon: Icons.rate_review_outlined,
                          label: 'Pending Reviews',
                          value: stats.pendingReviews.toString(),
                          color: AppColors.actionCorrection,
                        ),
                        _StatCard(
                          icon: Icons.flag_outlined,
                          label: 'Active Reports',
                          value: stats.activeReports.toString(),
                          color: AppColors.statusRejected,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Quick links ──────────────────────────────────────
                  Text(
                    'Quick Links',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _QuickLinkTile(
                    icon: Icons.flag_outlined,
                    title: 'Reports Queue',
                    subtitle: '${stats.activeReports} pending reports',
                    onTap: () => context.push(AppRoutes.adminReports),
                    semanticHint: 'Navigate to reports queue',
                  ),
                  _QuickLinkTile(
                    icon: Icons.people_outline,
                    title: 'User Management',
                    subtitle: '${stats.totalUsers} registered users',
                    onTap: () => context.push(AppRoutes.adminUsers),
                    semanticHint: 'Navigate to user management',
                  ),
                  _QuickLinkTile(
                    icon: Icons.verified_user_outlined,
                    title: 'KYC Queue',
                    subtitle: 'Review pending KYC submissions',
                    onTap: () => context.push(AppRoutes.kycUpload),
                    semanticHint: 'Navigate to KYC queue',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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
    final cardWidth =
        (MediaQuery.of(context).size.width - 44) / 2; // 2 columns

    return Semantics(
      label: '$label: $value',
      child: SizedBox(
        width: cardWidth,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String semanticHint;

  const _QuickLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.semanticHint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      hint: semanticHint,
      button: true,
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: AppColors.primaryRed),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

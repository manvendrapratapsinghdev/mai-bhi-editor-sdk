import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_user.dart';
import '../bloc/admin_bloc.dart';

/// Admin user management screen with filters and action buttons.
class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  static const _filters = ['all', 'flagged', 'suspended', 'pending_deletion'];
  static const _filterLabels = {
    'all': 'All',
    'flagged': 'Flagged',
    'suspended': 'Suspended',
    'pending_deletion': 'Pending Deletion',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('User Management'),
        ),
      ),
      body: Column(
        children: [
          // ── Filter chips ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocBuilder<AdminBloc, AdminState>(
              buildWhen: (prev, curr) => prev.userFilter != curr.userFilter,
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected =
                          (state.userFilter ?? 'all') == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Semantics(
                          label:
                              '${_filterLabels[filter]} filter${isSelected ? ', selected' : ''}',
                          child: FilterChip(
                            label: Text(_filterLabels[filter]!),
                            selected: isSelected,
                            selectedColor: AppColors.primaryRedLight,
                            checkmarkColor: AppColors.primaryRed,
                            onSelected: (_) {
                              context.read<AdminBloc>().add(
                                    LoadUsers(
                                      filter:
                                          filter == 'all' ? null : filter,
                                    ),
                                  );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // ── User list ───────────────────────────────────────────
          Expanded(
            child: BlocConsumer<AdminBloc, AdminState>(
              listener: (context, state) {
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: AppColors.statusPublished,
                      ),
                    );
                }
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
                if (state.isLoadingUsers) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ExcludeSemantics(
                          child: Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.lightGrey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.mediumGrey,
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<AdminBloc>()
                        .add(LoadUsers(filter: state.userFilter));
                    await Future<void>.delayed(
                        const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return _UserCard(user: state.users[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final AdminUser user;

  const _UserCard({required this.user});

  String _creatorLevelLabel(String level) {
    switch (level) {
      case 'basic_creator':
        return 'Basic Creator';
      case 'ht_approved_creator':
        return 'HT Approved';
      case 'trusted_reporter':
        return 'Trusted Reporter';
      default:
        return level;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.statusPublished;
      case 'flagged':
        return AppColors.actionCorrection;
      case 'suspended':
        return AppColors.statusRejected;
      case 'pending_deletion':
        return AppColors.mediumGrey;
      default:
        return AppColors.mediumGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          '${user.name}, ${user.email}, ${_creatorLevelLabel(user.creatorLevel)}, reputation ${user.reputationPoints}, ${user.storiesCount} stories, status ${user.status}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + status badge row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      user.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Status: ${user.status}',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(user.status).withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.status.replaceAll('_', ' '),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _statusColor(user.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Email
              Text(
                user.email,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.mediumGrey,
                ),
              ),
              const SizedBox(height: 8),

              // Stats row
              Row(
                children: [
                  _UserStatChip(
                    icon: Icons.workspace_premium_outlined,
                    label: _creatorLevelLabel(user.creatorLevel),
                  ),
                  const SizedBox(width: 12),
                  _UserStatChip(
                    icon: Icons.star_outline,
                    label: '${user.reputationPoints} rep',
                  ),
                  const SizedBox(width: 12),
                  _UserStatChip(
                    icon: Icons.article_outlined,
                    label: '${user.storiesCount} stories',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Action buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Tooltip(
                    message: 'Warn this user',
                    child: OutlinedButton.icon(
                      onPressed: () => _showActionDialog(
                        context,
                        'warn',
                        'Send a warning to ${user.name}?',
                      ),
                      icon: const Icon(Icons.warning_amber_outlined,
                          size: 16),
                      label: const Text('Warn'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.actionCorrection,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Suspend this user',
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showSuspendDialog(context, user.name),
                      icon: const Icon(Icons.pause_circle_outline,
                          size: 16),
                      label: const Text('Suspend'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.statusRejected,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Ban this user permanently',
                    child: OutlinedButton.icon(
                      onPressed: () => _showActionDialog(
                        context,
                        'ban',
                        'Permanently ban ${user.name}? This cannot be undone.',
                      ),
                      icon: const Icon(Icons.block, size: 16),
                      label: const Text('Ban'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionDialog(
    BuildContext context,
    String action,
    String message,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Confirm: $action'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AdminBloc>().add(
                    ActionUser(userId: user.id, action: action),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.statusRejected,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(BuildContext context, String userName) {
    int selectedDays = 7;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Suspend User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Suspend $userName for:'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Suspension duration picker',
                  child: DropdownButtonFormField<int>(
                    initialValue: selectedDays,
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1 day')),
                      DropdownMenuItem(value: 3, child: Text('3 days')),
                      DropdownMenuItem(value: 7, child: Text('7 days')),
                      DropdownMenuItem(value: 14, child: Text('14 days')),
                      DropdownMenuItem(value: 30, child: Text('30 days')),
                      DropdownMenuItem(value: 90, child: Text('90 days')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedDays = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<AdminBloc>().add(
                        ActionUser(
                          userId: user.id,
                          action: 'suspend',
                          suspendDays: selectedDays,
                        ),
                      );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.statusRejected,
                ),
                child: const Text('Suspend'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UserStatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _UserStatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.mediumGrey),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.mediumGrey,
              ),
        ),
      ],
    );
  }
}

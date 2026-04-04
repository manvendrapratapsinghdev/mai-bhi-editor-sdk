import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../../../../config/mai_bhi_editor_initializer.dart';
import '../bloc/settings_bloc.dart';

/// Settings screen with notification preferences, language switcher,
/// data privacy section, and account deletion.
///
/// Accessible from the profile screen. Manages:
/// - Toggle switches for notification categories
/// - Language selector (English / Hindi)
/// - Data & Privacy section with consent status and withdrawal
/// - Delete Account with confirmation dialog
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Settings'),
        ),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
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
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // ── Notification Preferences ─────────────────────────
              const _SectionHeader(title: 'Notification Preferences'),
              const SizedBox(height: 4),
              _NotificationToggle(
                title: 'Story Updates',
                subtitle:
                    'Approved, rejected, and correction notifications',
                icon: Icons.article_outlined,
                value: state.preferences.storyUpdates,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleNotificationPreference(
                          category: 'story_updates',
                          value: value,
                        ),
                      );
                },
              ),
              _NotificationToggle(
                title: 'Milestones & Badges',
                subtitle: 'Achievement and level-up notifications',
                icon: Icons.workspace_premium_outlined,
                value: state.preferences.milestonesBadges,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleNotificationPreference(
                          category: 'milestones_badges',
                          value: value,
                        ),
                      );
                },
              ),
              _NotificationToggle(
                title: 'Trending Stories in My City',
                subtitle: 'When stories in your city are trending',
                icon: Icons.local_fire_department_outlined,
                value: state.preferences.trendingStories,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleNotificationPreference(
                          category: 'trending_stories',
                          value: value,
                        ),
                      );
                },
              ),
              _NotificationToggle(
                title: 'Community Activity',
                subtitle: 'Confirmations on your stories',
                icon: Icons.people_outline,
                value: state.preferences.communityActivity,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleNotificationPreference(
                          category: 'community_activity',
                          value: value,
                        ),
                      );
                },
              ),

              const Divider(height: 32),

              // ── Language ──────────────────────────────────────────
              const _SectionHeader(title: 'Language'),
              const SizedBox(height: 4),
              _LanguageSelector(
                currentLocale: state.locale,
                onChanged: (locale) {
                  context.read<SettingsBloc>().add(ChangeLocale(locale));
                },
              ),

              const Divider(height: 32),

              // ── Data & Privacy ────────────────────────────────────
              const _SectionHeader(title: 'Data & Privacy'),
              const SizedBox(height: 4),

              // Consent status
              Semantics(
                label: 'Consent status: granted',
                child: const ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: AppColors.statusPublished,
                  ),
                  title: Text('Consent Status'),
                  subtitle: Text('You have granted data processing consent'),
                ),
              ),

              // Withdraw Consent
              Semantics(
                button: true,
                hint: 'Withdrawing consent will trigger account deletion',
                child: ListTile(
                  leading: const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.actionCorrection,
                  ),
                  title: const Text('Withdraw Consent'),
                  subtitle: const Text(
                    'This will initiate account deletion',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ),

              // Download My Data
              Semantics(
                button: true,
                hint: 'Download a copy of your personal data',
                child: ListTile(
                  leading: const Icon(
                    Icons.download_outlined,
                    color: AppColors.statusUnderReview,
                  ),
                  title: const Text('Download My Data'),
                  subtitle: const Text('Get a copy of your data (coming soon)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Data export will be available in a future update.',
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // About Your Data
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: AppColors.extraLightGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 20,
                              color: AppColors.mediumGrey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'About Your Data',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mai Bhi Editor collects and processes the following data:\n\n'
                          '  - Account information (name, email, city)\n'
                          '  - Stories and submissions you create\n'
                          '  - Interaction data (likes, confirmations)\n'
                          '  - Device information for push notifications\n'
                          '  - Anonymous usage analytics to improve the app\n\n'
                          'Your data is processed in accordance with our privacy policy. '
                          'You can withdraw consent or request deletion at any time.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.darkGrey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(height: 32),

              // ── Delete Account ─────────────────────────────────────
              const _SectionHeader(title: 'Danger Zone'),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Semantics(
                  button: true,
                  label: 'Delete your account permanently',
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showDeleteAccountDialog(context),
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Delete Account'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.statusRejected,
                        side: const BorderSide(
                          color: AppColors.statusRejected,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── App info ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Mai Bhi Editor v1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();
    bool isDeleting = false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.statusRejected),
                SizedBox(width: 8),
                Text('Delete Account'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your account will be deleted after 30 days. '
                  'Log in during this period to cancel.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkGrey,
                      ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Enter your password to confirm deletion',
                  hint: 'Password field',
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter your password to confirm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed:
                    isDeleting ? null : () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        if (passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please enter your password'),
                            ),
                          );
                          return;
                        }

                        setState(() => isDeleting = true);

                        try {
                          final dio = sl<Dio>();
                          await dio.delete(
                            ApiConstants.deleteAccount,
                            data: {
                              'password': passwordController.text,
                            },
                          );

                          if (context.mounted) {
                            Navigator.of(dialogContext).pop();
                            // Logout the user via host AuthProvider.
                            await MaiBhiEditor.authProvider.logout();
                            // Show confirmation.
                            if (context.mounted) {
                              _showDeletionConfirmation(context);
                            }
                          }
                        } catch (e) {
                          setState(() => isDeleting = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to delete account. Please check your password and try again.',
                                ),
                                backgroundColor: AppColors.statusRejected,
                              ),
                            );
                          }
                        }
                      },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.statusRejected,
                ),
                child: isDeleting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Delete My Account'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeletionConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Account Deletion Scheduled'),
        content: const Text(
          'Your account has been scheduled for deletion in 30 days. '
          'If you change your mind, simply log back in during this period to cancel.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // After account deletion, auth provider stream will notify
              // the host app to handle navigation.
              context.go(AppRoutes.feed);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryRed,
              ),
        ),
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: '$title notification toggle',
      hint: subtitle,
      child: SwitchListTile(
        title: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.mediumGrey),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(subtitle),
        ),
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primaryRedLight,
        thumbColor: const WidgetStatePropertyAll(AppColors.primaryRed),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onChanged;

  const _LanguageSelector({
    required this.currentLocale,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LanguageTile(
          icon: Icons.language,
          title: 'English',
          subtitle: 'Default language',
          isSelected: currentLocale.languageCode == 'en',
          onTap: () => onChanged(const Locale('en')),
        ),
        _LanguageTile(
          icon: Icons.translate,
          title: 'Hindi',
          subtitle: '\u0939\u093F\u0928\u094D\u0926\u0940',
          isSelected: currentLocale.languageCode == 'hi',
          onTap: () => onChanged(const Locale('hi')),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title language option${isSelected ? ', selected' : ''}',
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppColors.primaryRed)
            : const Icon(
                Icons.radio_button_unchecked,
                color: AppColors.lightGrey,
              ),
        onTap: onTap,
      ),
    );
  }
}

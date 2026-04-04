import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/notifications/fcm_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_tile.dart';

/// Screen displaying the user's notification list.
///
/// Features:
/// - Pull-to-refresh
/// - Infinite scroll pagination
/// - Mark all as read
/// - Empty state
/// - Tap to mark read + navigate
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<NotificationBloc>();
      final state = bloc.state;
      if (!state.isLoadingMore && state.hasMore) {
        bloc.add(const LoadMoreNotifications());
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<NotificationBloc>().add(const LoadNotifications());
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  void _onNotificationTap(NotificationEntity notification) {
    // Mark as read.
    if (!notification.isRead) {
      context
          .read<NotificationBloc>()
          .add(MarkNotificationAsRead(notification.id));
    }

    // Navigate based on notification data.
    final route = NotificationRouter.routeFromData({
      'target_type': notification.targetType,
      'target_id': notification.targetId,
    });

    if (route != null) {
      context.push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            buildWhen: (p, c) => p.unreadCount != c.unreadCount,
            builder: (context, state) {
              if (state.unreadCount == 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () {
                  context
                      .read<NotificationBloc>()
                      .add(const MarkAllNotificationsAsRead());
                },
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          // Error state with no data.
          if (state.errorMessage != null && state.notifications.isEmpty) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: () => context
                  .read<NotificationBloc>()
                  .add(const LoadNotifications()),
            );
          }

          // Loading initial data.
          if (state.isLoading && state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty state.
          if (!state.isLoading && state.notifications.isEmpty) {
            return const _EmptyNotificationsView();
          }

          // Notification list.
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primaryRed,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: state.notifications.length +
                  (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == state.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                final notification = state.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () => _onNotificationTap(notification),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyNotificationsView extends StatelessWidget {
  const _EmptyNotificationsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_none,
              size: 80,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will see updates about your stories, milestones, and community activity here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.statusRejected,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

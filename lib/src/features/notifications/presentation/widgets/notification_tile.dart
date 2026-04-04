import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/relative_time.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_icon_widget.dart';

/// A single notification list tile.
///
/// Shows category icon, title, body, relative time, and unread indicator.
class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          '${notification.isRead ? "" : "Unread "}notification: ${notification.title}',
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: notification.isRead
              ? null
              : AppColors.statusUnderReviewBg.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category icon.
              NotificationIconWidget(category: notification.category),
              const SizedBox(width: 12),

              // Text content.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: notification.isRead
                            ? FontWeight.w400
                            : FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRelativeTime(notification.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.lightGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Unread indicator.
              if (!notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.unreadDot,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

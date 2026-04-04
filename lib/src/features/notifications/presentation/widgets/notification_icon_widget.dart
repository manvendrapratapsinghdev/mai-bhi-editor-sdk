import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';

/// Returns the appropriate icon and colour for a notification category.
class NotificationIconWidget extends StatelessWidget {
  final NotificationCategory category;
  final double size;

  const NotificationIconWidget({
    super.key,
    required this.category,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = _iconAndColor();

    return Container(
      width: size + 16,
      height: size + 16,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size),
    );
  }

  (IconData, Color) _iconAndColor() {
    switch (category) {
      case NotificationCategory.storyApproved:
        return (Icons.check_circle, AppColors.safetyGood);
      case NotificationCategory.storyRejected:
        return (Icons.cancel, AppColors.statusRejected);
      case NotificationCategory.correctionNeeded:
        return (Icons.edit_note, AppColors.actionCorrection);
      case NotificationCategory.milestone:
        return (Icons.star, AppColors.statusInProgress);
      case NotificationCategory.badge:
        return (Icons.workspace_premium, AppColors.badgePurple);
      case NotificationCategory.trending:
        return (Icons.local_fire_department, AppColors.secondary);
      case NotificationCategory.communityConfirmation:
        return (Icons.people, AppColors.primary);
      case NotificationCategory.general:
        return (Icons.notifications, AppColors.statusDraft);
    }
  }
}

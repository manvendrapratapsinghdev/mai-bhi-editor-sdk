import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../../core/theme/app_colors.dart';

/// Displays a creator level badge with color and icon per level.
///
/// - basic_creator: grey shield
/// - ht_approved_creator: blue verified checkmark
/// - trusted_reporter: gold star
class CreatorBadgeWidget extends StatelessWidget {
  final CreatorLevel level;
  final double size;
  final bool showLabel;

  const CreatorBadgeWidget({
    super.key,
    required this.level,
    this.size = 24,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _badgeConfig;

    return Semantics(
      label: 'Creator badge: ${config.label}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(size * 0.2),
            decoration: BoxDecoration(
              color: config.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(size * 0.3),
            ),
            child: Icon(
              config.icon,
              color: config.color,
              size: size,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                config.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: config.color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _BadgeConfig get _badgeConfig {
    switch (level) {
      case CreatorLevel.basicCreator:
        return const _BadgeConfig(
          icon: Icons.shield_outlined,
          color: AppColors.mediumGrey,
          label: 'Basic Creator',
        );
      case CreatorLevel.htApprovedCreator:
        return const _BadgeConfig(
          icon: Icons.verified,
          color: AppColors.primary, // HT Blue
          label: 'HT Approved Creator',
        );
      case CreatorLevel.trustedReporter:
        return const _BadgeConfig(
          icon: Icons.star,
          color: AppColors.badgeGold, // Gold
          label: 'Trusted Reporter',
        );
    }
  }
}

class _BadgeConfig {
  final IconData icon;
  final Color color;
  final String label;

  const _BadgeConfig({
    required this.icon,
    required this.color,
    required this.label,
  });
}

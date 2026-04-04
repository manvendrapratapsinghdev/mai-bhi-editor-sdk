import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A single page in the onboarding walkthrough.
///
/// Displays a large coloured icon, title, and description.
class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Illustration area ─────────────────────────────────────
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 48),

          // ── Title ─────────────────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // ── Description ───────────────────────────────────────────
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.mediumGrey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

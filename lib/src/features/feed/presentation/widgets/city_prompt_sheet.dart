import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'city_filter_sheet.dart';

/// First-time city selection prompt bottom sheet.
///
/// Shown once when the user first opens the feed. The result is
/// saved in preferences and used as the default city filter.
class CityPromptSheet extends StatelessWidget {
  const CityPromptSheet({super.key});

  /// Show the first-time city selection prompt.
  ///
  /// Returns the selected city name, or null if skipped.
  static Future<String?> show(BuildContext context) async {
    return showModalBottomSheet<String?>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CityPromptSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.85,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // ── Handle ───────────────────────────────────────────
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // ── Welcome text ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Icon(
                    Icons.newspaper,
                    size: 48,
                    color: AppColors.primaryRed,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome to News By You!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your city to see local news first.\nYou can change this anytime.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.mediumGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),

            // ── City list ────────────────────────────────────────
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  ...kAvailableCities.map(
                    (city) => ListTile(
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.mediumGrey,
                      ),
                      title: Text(city),
                      onTap: () => Navigator.of(context).pop(city),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Skip button ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(
                  'Skip - Show All Cities',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// List of major Indian cities for the city filter.
///
/// This can be expanded or fetched from the server in the future.
const List<String> kAvailableCities = [
  'Delhi',
  'Mumbai',
  'Bengaluru',
  'Chennai',
  'Hyderabad',
  'Kolkata',
  'Pune',
  'Ahmedabad',
  'Jaipur',
  'Lucknow',
  'Chandigarh',
  'Bhopal',
  'Patna',
  'Ranchi',
  'Dehradun',
  'Noida',
  'Gurgaon',
];

/// Bottom sheet for selecting a city filter.
///
/// Returns the selected city string, or null for "All Cities".
class CityFilterSheet extends StatelessWidget {
  /// The currently selected city, or null for "All Cities".
  final String? selectedCity;

  const CityFilterSheet({super.key, this.selectedCity});

  /// Show the city filter bottom sheet and return the selected city.
  ///
  /// Returns the selected city name, or null if "All Cities" is chosen.
  /// Returns the current selection unchanged if the sheet is dismissed.
  static Future<String?> show(
    BuildContext context, {
    String? currentCity,
  }) async {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CityFilterSheet(selectedCity: currentCity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // ── Handle ───────────────────────────────────────────
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // ── Title ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.location_city, color: AppColors.primaryRed),
                  const SizedBox(width: 8),
                  Text(
                    'Select City',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),

            // ── City list ────────────────────────────────────────
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  // "All Cities" option
                  _CityTile(
                    city: null,
                    label: 'All Cities',
                    icon: Icons.public,
                    isSelected: selectedCity == null,
                    onTap: () => Navigator.of(context).pop(null),
                  ),
                  const Divider(height: 1),

                  // City options
                  ...kAvailableCities.map((city) => _CityTile(
                        city: city,
                        label: city,
                        icon: Icons.location_on_outlined,
                        isSelected: selectedCity == city,
                        onTap: () => Navigator.of(context).pop(city),
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CityTile extends StatelessWidget {
  final String? city;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityTile({
    required this.city,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryRed : AppColors.mediumGrey,
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppColors.primaryRed : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primaryRed)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedTileColor: AppColors.primaryRedLight,
      selected: isSelected,
    );
  }
}

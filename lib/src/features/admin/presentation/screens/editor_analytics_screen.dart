import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/editor_analytics.dart';
import '../bloc/editor_analytics_bloc.dart';

/// Editor analytics dashboard showing queue metrics and city contributions.
///
/// Accessible from the editorial queue screen.
class EditorAnalyticsScreen extends StatelessWidget {
  const EditorAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Editor Analytics'),
        ),
      ),
      body: BlocConsumer<EditorAnalyticsBloc, EditorAnalyticsState>(
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

          final analytics = state.analytics;

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<EditorAnalyticsBloc>()
                  .add(const LoadEditorAnalytics());
              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── City filter ───────────────────────────────────
                  _CityFilterDropdown(
                    currentCity: state.cityFilter,
                    onChanged: (city) {
                      context
                          .read<EditorAnalyticsBloc>()
                          .add(FilterEditorAnalyticsByCity(city));
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Stats cards ───────────────────────────────────
                  Semantics(
                    label: 'Editor analytics statistics',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _MetricCard(
                          icon: Icons.inbox_outlined,
                          label: 'Pending Queue',
                          value: analytics.pendingQueueSize.toString(),
                          color: AppColors.statusInProgress,
                        ),
                        _MetricCard(
                          icon: Icons.timer_outlined,
                          label: 'Avg Time (Today)',
                          value:
                              '${analytics.avgApprovalTimeToday.toStringAsFixed(1)}h',
                          color: AppColors.statusUnderReview,
                        ),
                        _MetricCard(
                          icon: Icons.date_range_outlined,
                          label: 'Avg Time (Week)',
                          value:
                              '${analytics.avgApprovalTimeWeek.toStringAsFixed(1)}h',
                          color: AppColors.actionEdit,
                        ),
                        _MetricCard(
                          icon: Icons.thumb_down_outlined,
                          label: 'Rejection Rate',
                          value:
                              '${(analytics.rejectionRate * 100).toStringAsFixed(1)}%',
                          color: AppColors.statusRejected,
                        ),
                        _MetricCard(
                          icon: Icons.check_circle_outline,
                          label: 'Published Today',
                          value: analytics.publishedToday.toString(),
                          color: AppColors.statusPublished,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Top Contributing Cities ───────────────────────
                  Text(
                    'Top Contributing Cities',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (analytics.topCities.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No city data available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.mediumGrey,
                          ),
                        ),
                      ),
                    )
                  else
                    _CityBarChart(cities: analytics.topCities),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CityFilterDropdown extends StatelessWidget {
  final String? currentCity;
  final ValueChanged<String?> onChanged;

  const _CityFilterDropdown({
    required this.currentCity,
    required this.onChanged,
  });

  static const _cities = [
    'All Cities',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Filter analytics by city',
      child: DropdownButtonFormField<String>(
        initialValue: currentCity ?? 'All Cities',
        decoration: InputDecoration(
          labelText: 'City Filter',
          prefixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          isDense: true,
        ),
        items: _cities.map((city) {
          return DropdownMenuItem(
            value: city,
            child: Text(city),
          );
        }).toList(),
        onChanged: (value) {
          onChanged(value == 'All Cities' ? null : value);
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
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
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
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

/// Simple horizontal bar chart built with Container widths.
class _CityBarChart extends StatelessWidget {
  final List<CityContribution> cities;

  const _CityBarChart({required this.cities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxCount =
        cities.isEmpty ? 1 : cities.map((c) => c.count).reduce((a, b) => a > b ? a : b);

    return Column(
      children: cities.map((city) {
        final fraction = maxCount > 0 ? city.count / maxCount : 0.0;

        return Semantics(
          label: '${city.city}: ${city.count} contributions',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    city.city,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.extraLightGrey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 24,
                            width: constraints.maxWidth * fraction,
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withValues(
                                alpha: 0.8,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 36,
                  child: Text(
                    city.count.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

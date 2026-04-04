import 'package:equatable/equatable.dart';

/// Analytics data for the editor analytics dashboard.
class EditorAnalytics extends Equatable {
  final int pendingQueueSize;
  final double avgApprovalTimeToday; // in hours
  final double avgApprovalTimeWeek; // in hours
  final double rejectionRate; // 0.0 to 1.0
  final int publishedToday;
  final List<CityContribution> topCities;

  const EditorAnalytics({
    this.pendingQueueSize = 0,
    this.avgApprovalTimeToday = 0,
    this.avgApprovalTimeWeek = 0,
    this.rejectionRate = 0,
    this.publishedToday = 0,
    this.topCities = const [],
  });

  factory EditorAnalytics.fromJson(Map<String, dynamic> json) {
    final citiesJson = json['top_cities'] as List<dynamic>? ?? [];
    return EditorAnalytics(
      pendingQueueSize: json['pending_queue_size'] as int? ?? 0,
      avgApprovalTimeToday:
          (json['avg_approval_time_today'] as num?)?.toDouble() ?? 0,
      avgApprovalTimeWeek:
          (json['avg_approval_time_week'] as num?)?.toDouble() ?? 0,
      rejectionRate: (json['rejection_rate'] as num?)?.toDouble() ?? 0,
      publishedToday: json['published_today'] as int? ?? 0,
      topCities: citiesJson
          .map((c) =>
              CityContribution.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        pendingQueueSize,
        avgApprovalTimeToday,
        avgApprovalTimeWeek,
        rejectionRate,
        publishedToday,
        topCities,
      ];
}

/// A city with its contribution count for the bar chart.
class CityContribution extends Equatable {
  final String city;
  final int count;

  const CityContribution({required this.city, required this.count});

  factory CityContribution.fromJson(Map<String, dynamic> json) {
    return CityContribution(
      city: json['city'] as String? ?? 'Unknown',
      count: json['count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [city, count];
}

import 'package:equatable/equatable.dart';

/// Dashboard statistics for the admin panel.
class AdminStats extends Equatable {
  final int totalUsers;
  final int totalStories;
  final int submissionsToday;
  final int pendingReviews;
  final int activeReports;

  const AdminStats({
    this.totalUsers = 0,
    this.totalStories = 0,
    this.submissionsToday = 0,
    this.pendingReviews = 0,
    this.activeReports = 0,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['total_users'] as int? ?? 0,
      totalStories: json['total_stories'] as int? ?? 0,
      submissionsToday: json['submissions_today'] as int? ?? 0,
      pendingReviews: json['pending_reviews'] as int? ?? 0,
      activeReports: json['active_reports'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        totalUsers,
        totalStories,
        submissionsToday,
        pendingReviews,
        activeReports,
      ];
}

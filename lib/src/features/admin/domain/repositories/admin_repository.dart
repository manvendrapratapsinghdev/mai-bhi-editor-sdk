import '../entities/admin_report.dart';
import '../entities/admin_stats.dart';
import '../entities/admin_user.dart';
import '../entities/editor_analytics.dart';

/// Abstract contract for admin operations.
abstract class AdminRepository {
  /// Fetch admin dashboard stats.
  Future<AdminStats> getDashboardStats();

  /// Fetch pending reports.
  Future<List<AdminReport>> getReports({String? status});

  /// Perform an action on a report.
  Future<void> actionReport({
    required String reportId,
    required String action, // 'dismiss', 'remove_story', 'warn_creator', 'suspend_creator'
  });

  /// Fetch users with optional filter.
  Future<List<AdminUser>> getUsers({String? filter});

  /// Perform an admin action on a user.
  Future<void> actionUser({
    required String userId,
    required String action, // 'warn', 'suspend', 'ban'
    int? suspendDays,
  });

  /// Fetch editor analytics data.
  Future<EditorAnalytics> getEditorAnalytics({String? city});
}

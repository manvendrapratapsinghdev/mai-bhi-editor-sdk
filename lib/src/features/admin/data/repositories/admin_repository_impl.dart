import '../../domain/entities/admin_report.dart';
import '../../domain/entities/admin_stats.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/editor_analytics.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

/// Concrete implementation of [AdminRepository].
class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  const AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdminStats> getDashboardStats() =>
      remoteDataSource.getDashboardStats();

  @override
  Future<List<AdminReport>> getReports({String? status}) =>
      remoteDataSource.getReports(status: status);

  @override
  Future<void> actionReport({
    required String reportId,
    required String action,
  }) =>
      remoteDataSource.actionReport(reportId: reportId, action: action);

  @override
  Future<List<AdminUser>> getUsers({String? filter}) =>
      remoteDataSource.getUsers(filter: filter);

  @override
  Future<void> actionUser({
    required String userId,
    required String action,
    int? suspendDays,
  }) =>
      remoteDataSource.actionUser(
        userId: userId,
        action: action,
        suspendDays: suspendDays,
      );

  @override
  Future<EditorAnalytics> getEditorAnalytics({String? city}) =>
      remoteDataSource.getEditorAnalytics(city: city);
}

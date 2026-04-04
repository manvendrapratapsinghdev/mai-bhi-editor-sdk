part of 'admin_bloc.dart';

/// Events for the Admin BLoC.
abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

/// Load admin dashboard statistics.
class LoadDashboardStats extends AdminEvent {
  const LoadDashboardStats();
}

/// Load reports with optional status filter.
class LoadReports extends AdminEvent {
  final String? status;

  const LoadReports({this.status});

  @override
  List<Object?> get props => [status];
}

/// Perform an action on a report.
class ActionReport extends AdminEvent {
  final String reportId;
  final String action;

  const ActionReport({required this.reportId, required this.action});

  @override
  List<Object?> get props => [reportId, action];
}

/// Load users with optional filter.
class LoadUsers extends AdminEvent {
  final String? filter;

  const LoadUsers({this.filter});

  @override
  List<Object?> get props => [filter];
}

/// Perform an admin action on a user.
class ActionUser extends AdminEvent {
  final String userId;
  final String action;
  final int? suspendDays;

  const ActionUser({
    required this.userId,
    required this.action,
    this.suspendDays,
  });

  @override
  List<Object?> get props => [userId, action, suspendDays];
}

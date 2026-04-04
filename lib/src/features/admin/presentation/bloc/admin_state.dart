part of 'admin_bloc.dart';

/// State for the Admin BLoC.
class AdminState extends Equatable {
  final bool isLoadingStats;
  final bool isLoadingReports;
  final bool isLoadingUsers;
  final AdminStats stats;
  final List<AdminReport> reports;
  final List<AdminUser> users;
  final String? userFilter;
  final String? errorMessage;
  final String? successMessage;

  const AdminState({
    this.isLoadingStats = false,
    this.isLoadingReports = false,
    this.isLoadingUsers = false,
    this.stats = const AdminStats(),
    this.reports = const [],
    this.users = const [],
    this.userFilter,
    this.errorMessage,
    this.successMessage,
  });

  AdminState copyWith({
    bool? isLoadingStats,
    bool? isLoadingReports,
    bool? isLoadingUsers,
    AdminStats? stats,
    List<AdminReport>? reports,
    List<AdminUser>? users,
    String? userFilter,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
  }) {
    return AdminState(
      isLoadingStats: isLoadingStats ?? this.isLoadingStats,
      isLoadingReports: isLoadingReports ?? this.isLoadingReports,
      isLoadingUsers: isLoadingUsers ?? this.isLoadingUsers,
      stats: stats ?? this.stats,
      reports: reports ?? this.reports,
      users: users ?? this.users,
      userFilter: userFilter ?? this.userFilter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingStats,
        isLoadingReports,
        isLoadingUsers,
        stats,
        reports,
        users,
        userFilter,
        errorMessage,
        successMessage,
      ];
}

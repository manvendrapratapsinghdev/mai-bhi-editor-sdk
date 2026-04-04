import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/admin_report.dart';
import '../../domain/entities/admin_stats.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

/// BLoC managing the admin panel state: dashboard stats, reports, and users.
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _repository;

  AdminBloc({required AdminRepository repository})
      : _repository = repository,
        super(const AdminState()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
    on<LoadReports>(_onLoadReports);
    on<ActionReport>(_onActionReport);
    on<LoadUsers>(_onLoadUsers);
    on<ActionUser>(_onActionUser);
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isLoadingStats: true, clearError: true));
    try {
      final stats = await _repository.getDashboardStats();
      emit(state.copyWith(isLoadingStats: false, stats: stats));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoadingStats: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingStats: false,
        errorMessage: 'Failed to load dashboard stats',
      ));
    }
  }

  Future<void> _onLoadReports(
    LoadReports event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isLoadingReports: true, clearError: true));
    try {
      final reports = await _repository.getReports(status: event.status);
      emit(state.copyWith(isLoadingReports: false, reports: reports));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoadingReports: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingReports: false,
        errorMessage: 'Failed to load reports',
      ));
    }
  }

  Future<void> _onActionReport(
    ActionReport event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await _repository.actionReport(
        reportId: event.reportId,
        action: event.action,
      );
      // Remove the actioned report from the list.
      final updated = state.reports
          .where((r) => r.id != event.reportId)
          .toList();
      emit(state.copyWith(
        reports: updated,
        successMessage: 'Report ${event.action} successfully',
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to action report'));
    }
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingUsers: true,
      clearError: true,
      userFilter: event.filter,
    ));
    try {
      final users = await _repository.getUsers(filter: event.filter);
      emit(state.copyWith(isLoadingUsers: false, users: users));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoadingUsers: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingUsers: false,
        errorMessage: 'Failed to load users',
      ));
    }
  }

  Future<void> _onActionUser(
    ActionUser event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await _repository.actionUser(
        userId: event.userId,
        action: event.action,
        suspendDays: event.suspendDays,
      );
      emit(state.copyWith(
        successMessage: 'User ${event.action} successfully',
      ));
      // Reload users list.
      add(LoadUsers(filter: state.userFilter));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to action user'));
    }
  }
}

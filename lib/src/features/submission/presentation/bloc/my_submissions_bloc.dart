import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../data/local/draft_local_datasource.dart';
import '../../domain/entities/submission.dart';
import '../../domain/usecases/get_my_submissions_usecase.dart';

part 'my_submissions_event.dart';
part 'my_submissions_state.dart';

/// BLoC that manages the "Posted by You" dashboard state.
class MySubmissionsBloc
    extends Bloc<MySubmissionsEvent, MySubmissionsState> {
  final GetMySubmissionsUseCase _getMySubmissionsUseCase;
  final DraftLocalDataSource _draftLocalDataSource;

  MySubmissionsBloc({
    required GetMySubmissionsUseCase getMySubmissionsUseCase,
    required DraftLocalDataSource draftLocalDataSource,
  })  : _getMySubmissionsUseCase = getMySubmissionsUseCase,
        _draftLocalDataSource = draftLocalDataSource,
        super(const MySubmissionsState()) {
    on<LoadMySubmissions>(_onLoadMySubmissions);
    on<FilterByStatus>(_onFilterByStatus);
    on<LoadMoreSubmissions>(_onLoadMore);
    on<RefreshMySubmissions>(_onRefresh);
    on<DeleteDraftSubmission>(_onDeleteDraft);
  }

  Future<void> _onLoadMySubmissions(
    LoadMySubmissions event,
    Emitter<MySubmissionsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final submissions = await _getMySubmissionsUseCase(
        status: state.filterStatus,
        page: 1,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: submissions,
        isLoading: false,
        hasMore: submissions.length >= _pageSize,
        currentPage: 1,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load submissions.',
      ));
    }
  }

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<MySubmissionsState> emit,
  ) async {
    emit(state.copyWith(
      filterStatus: event.status,
      clearFilter: event.status == null,
      submissions: [],
      isLoading: true,
      clearError: true,
      currentPage: 1,
    ));

    try {
      final submissions = await _getMySubmissionsUseCase(
        status: event.status,
        page: 1,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: submissions,
        isLoading: false,
        hasMore: submissions.length >= _pageSize,
        currentPage: 1,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load submissions.',
      ));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreSubmissions event,
    Emitter<MySubmissionsState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final submissions = await _getMySubmissionsUseCase(
        status: state.filterStatus,
        page: nextPage,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: [...state.submissions, ...submissions],
        isLoadingMore: false,
        hasMore: submissions.length >= _pageSize,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(
    RefreshMySubmissions event,
    Emitter<MySubmissionsState> emit,
  ) async {
    try {
      final submissions = await _getMySubmissionsUseCase(
        status: state.filterStatus,
        page: 1,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: submissions,
        hasMore: submissions.length >= _pageSize,
        clearError: true,
        currentPage: 1,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to refresh submissions.',
      ));
    }
  }

  Future<void> _onDeleteDraft(
    DeleteDraftSubmission event,
    Emitter<MySubmissionsState> emit,
  ) async {
    await _draftLocalDataSource.deleteDraft(event.draftId);

    // Remove from current list.
    final updated = state.submissions
        .where((s) => s.id != event.draftId)
        .toList();
    emit(state.copyWith(submissions: updated));
  }

  static const int _pageSize = 20;
}

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
      final result = await _getMySubmissionsUseCase(
        status: state.filterStatus,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: result.items,
        isLoading: false,
        hasMore: result.hasMore,
        nextCursor: result.nextCursor,
        clearCursor: result.nextCursor == null,
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
      clearCursor: true,
    ));

    try {
      final result = await _getMySubmissionsUseCase(
        status: event.status,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: result.items,
        isLoading: false,
        hasMore: result.hasMore,
        nextCursor: result.nextCursor,
        clearCursor: result.nextCursor == null,
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
    if (!state.hasMore || state.isLoadingMore || state.nextCursor == null) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    try {
      final result = await _getMySubmissionsUseCase(
        status: state.filterStatus,
        cursor: state.nextCursor,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: [...state.submissions, ...result.items],
        isLoadingMore: false,
        hasMore: result.hasMore,
        nextCursor: result.nextCursor,
        clearCursor: result.nextCursor == null,
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
      final result = await _getMySubmissionsUseCase(
        status: state.filterStatus,
        limit: _pageSize,
      );
      emit(state.copyWith(
        submissions: result.items,
        hasMore: result.hasMore,
        nextCursor: result.nextCursor,
        clearCursor: result.nextCursor == null,
        clearError: true,
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

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/editorial_queue_item.dart';
import '../../domain/usecases/get_editorial_queue_usecase.dart';

part 'editorial_queue_event.dart';
part 'editorial_queue_state.dart';

/// BLoC managing the editor review queue.
///
/// Supports city filtering, sort-order toggling, infinite scroll pagination,
/// pull-to-refresh, and 30-second auto-refresh.
class EditorialQueueBloc
    extends Bloc<EditorialQueueEvent, EditorialQueueState> {
  final GetEditorialQueueUseCase _getEditorialQueueUseCase;

  Timer? _autoRefreshTimer;

  static const int _pageSize = 20;
  static const Duration _autoRefreshInterval = Duration(seconds: 30);

  EditorialQueueBloc({
    required GetEditorialQueueUseCase getEditorialQueueUseCase,
  })  : _getEditorialQueueUseCase = getEditorialQueueUseCase,
        super(const EditorialQueueState()) {
    on<LoadQueue>(_onLoadQueue);
    on<FilterByCity>(_onFilterByCity);
    on<ChangeSortOrder>(_onChangeSortOrder);
    on<LoadMore>(_onLoadMore);
    on<RefreshQueue>(_onRefresh);
    on<AutoRefreshQueue>(_onAutoRefresh);
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(_autoRefreshInterval, (_) {
      add(const AutoRefreshQueue());
    });
  }

  Future<void> _onLoadQueue(
    LoadQueue event,
    Emitter<EditorialQueueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, currentPage: 1));

    try {
      final items = await _getEditorialQueueUseCase(
        city: state.cityFilter,
        sortBy: state.sortByApiParam,
        page: 1,
      );

      final cities = _extractCities(items);

      emit(state.copyWith(
        items: items,
        isLoading: false,
        hasMore: items.length >= _pageSize,
        currentPage: 1,
        availableCities: cities,
      ));

      _startAutoRefresh();
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } on NetworkException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load editorial queue.',
      ));
    }
  }

  Future<void> _onFilterByCity(
    FilterByCity event,
    Emitter<EditorialQueueState> emit,
  ) async {
    emit(state.copyWith(
      cityFilter: event.city,
      clearCityFilter: event.city == null,
      items: [],
      isLoading: true,
      clearError: true,
      currentPage: 1,
    ));

    try {
      final items = await _getEditorialQueueUseCase(
        city: event.city,
        sortBy: state.sortByApiParam,
        page: 1,
      );

      emit(state.copyWith(
        items: items,
        isLoading: false,
        hasMore: items.length >= _pageSize,
        currentPage: 1,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to filter queue.',
      ));
    }
  }

  Future<void> _onChangeSortOrder(
    ChangeSortOrder event,
    Emitter<EditorialQueueState> emit,
  ) async {
    emit(state.copyWith(
      sortOrder: event.sortOrder,
      items: [],
      isLoading: true,
      clearError: true,
      currentPage: 1,
    ));

    try {
      final sortBy = state.sortByApiParam;
      final items = await _getEditorialQueueUseCase(
        city: state.cityFilter,
        sortBy: sortBy,
        page: 1,
      );

      emit(state.copyWith(
        items: items,
        isLoading: false,
        hasMore: items.length >= _pageSize,
        currentPage: 1,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to sort queue.',
      ));
    }
  }

  Future<void> _onLoadMore(
    LoadMore event,
    Emitter<EditorialQueueState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final items = await _getEditorialQueueUseCase(
        city: state.cityFilter,
        sortBy: state.sortByApiParam,
        page: nextPage,
      );

      emit(state.copyWith(
        items: [...state.items, ...items],
        isLoadingMore: false,
        hasMore: items.length >= _pageSize,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(
    RefreshQueue event,
    Emitter<EditorialQueueState> emit,
  ) async {
    try {
      final items = await _getEditorialQueueUseCase(
        city: state.cityFilter,
        sortBy: state.sortByApiParam,
        page: 1,
      );

      final cities = _extractCities(items);

      emit(state.copyWith(
        items: items,
        hasMore: items.length >= _pageSize,
        currentPage: 1,
        clearError: true,
        availableCities: cities,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to refresh queue.'));
    }
  }

  Future<void> _onAutoRefresh(
    AutoRefreshQueue event,
    Emitter<EditorialQueueState> emit,
  ) async {
    // Silent auto-refresh — no loading indicators.
    try {
      final items = await _getEditorialQueueUseCase(
        city: state.cityFilter,
        sortBy: state.sortByApiParam,
        page: 1,
      );

      final cities = _extractCities(items);

      emit(state.copyWith(
        items: items,
        hasMore: items.length >= _pageSize,
        currentPage: 1,
        availableCities: cities,
      ));
    } catch (_) {
      // Silently ignore auto-refresh failures.
    }
  }

  /// Extract unique city names from queue items for the city filter dropdown.
  List<String> _extractCities(List<EditorialQueueItem> items) {
    final existingCities = Set<String>.from(state.availableCities);
    for (final item in items) {
      if (item.submission.city.isNotEmpty) {
        existingCities.add(item.submission.city);
      }
    }
    final sorted = existingCities.toList()..sort();
    return sorted;
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }
}

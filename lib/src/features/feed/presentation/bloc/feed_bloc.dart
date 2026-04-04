import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/feed_item.dart';
import '../../domain/usecases/get_feed_usecase.dart';
import '../../domain/usecases/search_stories_usecase.dart';

part 'feed_event.dart';
part 'feed_state.dart';

/// BLoC managing the "News By You" feed.
///
/// Supports city filtering, infinite scroll pagination, pull-to-refresh,
/// and search with debounce.
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFeedUseCase _getFeedUseCase;
  final SearchStoriesUseCase _searchStoriesUseCase;

  Timer? _searchDebounce;

  static const int _pageSize = 20;
  static const Duration _searchDebounceDuration = Duration(milliseconds: 300);

  FeedBloc({
    required GetFeedUseCase getFeedUseCase,
    required SearchStoriesUseCase searchStoriesUseCase,
  })  : _getFeedUseCase = getFeedUseCase,
        _searchStoriesUseCase = searchStoriesUseCase,
        super(const FeedState()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMoreFeed>(_onLoadMore);
    on<FilterFeedByCity>(_onFilterByCity);
    on<RefreshFeed>(_onRefresh);
    on<SearchStories>(_onSearch);
    on<ClearSearch>(_onClearSearch);
    on<ToggleTrending>(_onToggleTrending);
  }

  Future<void> _onLoadFeed(
    LoadFeed event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearCursor: true,
    ));

    try {
      final response = await _getFeedUseCase(
        city: state.cityFilter,
        trending: state.isTrending ? true : null,
        limit: _pageSize,
      );

      emit(state.copyWith(
        stories: response.stories,
        isLoading: false,
        hasMore: response.stories.length >= _pageSize,
        nextCursor: response.nextCursor,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } on NetworkException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load feed.',
      ));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreFeed event,
    Emitter<FeedState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await _getFeedUseCase(
        city: state.cityFilter,
        trending: state.isTrending ? true : null,
        cursor: state.nextCursor,
        limit: _pageSize,
      );

      emit(state.copyWith(
        stories: [...state.stories, ...response.stories],
        isLoadingMore: false,
        hasMore: response.stories.length >= _pageSize,
        nextCursor: response.nextCursor,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFilterByCity(
    FilterFeedByCity event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(
      cityFilter: event.city,
      clearCityFilter: event.city == null,
      stories: [],
      isLoading: true,
      clearError: true,
      clearCursor: true,
    ));

    try {
      final response = await _getFeedUseCase(
        city: event.city,
        trending: state.isTrending ? true : null,
        limit: _pageSize,
      );

      emit(state.copyWith(
        stories: response.stories,
        isLoading: false,
        hasMore: response.stories.length >= _pageSize,
        nextCursor: response.nextCursor,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to filter feed.',
      ));
    }
  }

  Future<void> _onToggleTrending(
    ToggleTrending event,
    Emitter<FeedState> emit,
  ) async {
    final newTrending = !state.isTrending;
    emit(state.copyWith(
      isTrending: newTrending,
      stories: [],
      isLoading: true,
      clearError: true,
      clearCursor: true,
    ));

    try {
      final response = await _getFeedUseCase(
        city: state.cityFilter,
        trending: newTrending ? true : null,
        limit: _pageSize,
      );

      emit(state.copyWith(
        stories: response.stories,
        isLoading: false,
        hasMore: response.stories.length >= _pageSize,
        nextCursor: response.nextCursor,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load trending stories.',
      ));
    }
  }

  Future<void> _onRefresh(
    RefreshFeed event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final response = await _getFeedUseCase(
        city: state.cityFilter,
        trending: state.isTrending ? true : null,
        limit: _pageSize,
      );

      emit(state.copyWith(
        stories: response.stories,
        hasMore: response.stories.length >= _pageSize,
        nextCursor: response.nextCursor,
        clearError: true,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to refresh feed.'));
    }
  }

  Future<void> _onSearch(
    SearchStories event,
    Emitter<FeedState> emit,
  ) async {
    _searchDebounce?.cancel();

    final query = event.query.trim();
    if (query.isEmpty) {
      emit(state.copyWith(
        isSearching: false,
        searchQuery: '',
        searchResults: [],
        isSearchLoading: false,
      ));
      return;
    }

    emit(state.copyWith(
      isSearching: true,
      searchQuery: query,
      isSearchLoading: true,
    ));

    // Debounce: wait before actually hitting the API.
    final completer = Completer<void>();
    _searchDebounce = Timer(_searchDebounceDuration, completer.complete);

    try {
      await completer.future;
    } catch (_) {
      return;
    }

    try {
      final response = await _searchStoriesUseCase(query: query);

      // Only update if the query hasn't changed during the request.
      if (state.searchQuery == query) {
        emit(state.copyWith(
          searchResults: response.stories,
          isSearchLoading: false,
        ));
      }
    } on ServerException catch (e) {
      if (state.searchQuery == query) {
        emit(state.copyWith(
          isSearchLoading: false,
          errorMessage: e.message,
        ));
      }
    } catch (e) {
      if (state.searchQuery == query) {
        emit(state.copyWith(
          isSearchLoading: false,
          errorMessage: 'Search failed.',
        ));
      }
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<FeedState> emit,
  ) async {
    _searchDebounce?.cancel();
    emit(state.copyWith(
      isSearching: false,
      searchQuery: '',
      searchResults: [],
      isSearchLoading: false,
    ));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}

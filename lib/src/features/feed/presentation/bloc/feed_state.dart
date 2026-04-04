part of 'feed_bloc.dart';

/// State for the Feed BLoC.
class FeedState extends Equatable {
  /// List of feed stories.
  final List<FeedItem> stories;

  /// Whether the initial load is in progress.
  final bool isLoading;

  /// Whether more items are being loaded (pagination).
  final bool isLoadingMore;

  /// Whether there are more items available for pagination.
  final bool hasMore;

  /// Current city filter. Null means "All Cities".
  final String? cityFilter;

  /// Current cursor for pagination.
  final String? nextCursor;

  /// Error message, or null.
  final String? errorMessage;

  /// Whether search mode is active.
  final bool isSearching;

  /// Current search query.
  final String searchQuery;

  /// Search results (separate from main feed).
  final List<FeedItem> searchResults;

  /// Whether search is loading.
  final bool isSearchLoading;

  /// Whether trending filter is active.
  final bool isTrending;

  const FeedState({
    this.stories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.cityFilter,
    this.nextCursor,
    this.errorMessage,
    this.isSearching = false,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearchLoading = false,
    this.isTrending = false,
  });

  FeedState copyWith({
    List<FeedItem>? stories,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? cityFilter,
    bool clearCityFilter = false,
    String? nextCursor,
    bool clearCursor = false,
    String? errorMessage,
    bool clearError = false,
    bool? isSearching,
    String? searchQuery,
    List<FeedItem>? searchResults,
    bool? isSearchLoading,
    bool? isTrending,
  }) {
    return FeedState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      cityFilter:
          clearCityFilter ? null : (cityFilter ?? this.cityFilter),
      nextCursor:
          clearCursor ? null : (nextCursor ?? this.nextCursor),
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isTrending: isTrending ?? this.isTrending,
    );
  }

  /// Whether the feed is empty and not loading.
  bool get isEmpty => stories.isEmpty && !isLoading;

  @override
  List<Object?> get props => [
        stories,
        isLoading,
        isLoadingMore,
        hasMore,
        cityFilter,
        nextCursor,
        errorMessage,
        isSearching,
        searchQuery,
        searchResults,
        isSearchLoading,
        isTrending,
      ];
}

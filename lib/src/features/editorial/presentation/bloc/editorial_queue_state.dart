part of 'editorial_queue_bloc.dart';

/// Sort order options for the editorial queue.
enum QueueSortOrder {
  confidenceScore,
  recent,
  mostConfirmed,
}

/// State for the Editorial Queue BLoC.
class EditorialQueueState extends Equatable {
  /// List of queue items.
  final List<EditorialQueueItem> items;

  /// Whether the initial load is in progress.
  final bool isLoading;

  /// Whether more items are being loaded (pagination).
  final bool isLoadingMore;

  /// Whether there are more items available for pagination.
  final bool hasMore;

  /// Current city filter. Null means "All Cities".
  final String? cityFilter;

  /// Current sort order.
  final QueueSortOrder sortOrder;

  /// Current page for pagination.
  final int currentPage;

  /// Error message, or null.
  final String? errorMessage;

  /// Available cities extracted from queue items (for the dropdown).
  final List<String> availableCities;

  const EditorialQueueState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.cityFilter,
    this.sortOrder = QueueSortOrder.confidenceScore,
    this.currentPage = 1,
    this.errorMessage,
    this.availableCities = const [],
  });

  EditorialQueueState copyWith({
    List<EditorialQueueItem>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? cityFilter,
    bool clearCityFilter = false,
    QueueSortOrder? sortOrder,
    int? currentPage,
    String? errorMessage,
    bool clearError = false,
    List<String>? availableCities,
  }) {
    return EditorialQueueState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      cityFilter:
          clearCityFilter ? null : (cityFilter ?? this.cityFilter),
      sortOrder: sortOrder ?? this.sortOrder,
      currentPage: currentPage ?? this.currentPage,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      availableCities: availableCities ?? this.availableCities,
    );
  }

  /// Whether the queue is empty and not loading.
  bool get isEmpty => items.isEmpty && !isLoading;

  /// Sort order string to pass to the API.
  String get sortByApiParam {
    switch (sortOrder) {
      case QueueSortOrder.confidenceScore:
        return 'confidence_score';
      case QueueSortOrder.recent:
        return 'recent';
      case QueueSortOrder.mostConfirmed:
        return 'most_confirmed';
    }
  }

  @override
  List<Object?> get props => [
        items,
        isLoading,
        isLoadingMore,
        hasMore,
        cityFilter,
        sortOrder,
        currentPage,
        errorMessage,
        availableCities,
      ];
}

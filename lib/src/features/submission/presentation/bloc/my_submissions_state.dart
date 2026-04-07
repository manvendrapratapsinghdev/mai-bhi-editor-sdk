part of 'my_submissions_bloc.dart';

/// State for the "Posted by You" dashboard BLoC.
class MySubmissionsState extends Equatable {
  /// List of user's submissions.
  final List<Submission> submissions;

  /// Whether the initial load is in progress.
  final bool isLoading;

  /// Whether more items are being loaded (pagination).
  final bool isLoadingMore;

  /// Whether there are more items to load.
  final bool hasMore;

  /// Currently selected status filter, or null for all.
  final SubmissionStatus? filterStatus;

  /// Error message, or null.
  final String? errorMessage;

  /// Cursor for next page (ISO datetime from backend).
  final String? nextCursor;

  const MySubmissionsState({
    this.submissions = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.filterStatus,
    this.errorMessage,
    this.nextCursor,
  });

  MySubmissionsState copyWith({
    List<Submission>? submissions,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    SubmissionStatus? filterStatus,
    bool clearFilter = false,
    String? errorMessage,
    bool clearError = false,
    String? nextCursor,
    bool clearCursor = false,
  }) {
    return MySubmissionsState(
      submissions: submissions ?? this.submissions,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      filterStatus:
          clearFilter ? null : (filterStatus ?? this.filterStatus),
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      nextCursor:
          clearCursor ? null : (nextCursor ?? this.nextCursor),
    );
  }

  /// Whether the submissions list is empty and not loading.
  bool get isEmpty => submissions.isEmpty && !isLoading;

  @override
  List<Object?> get props => [
        submissions,
        isLoading,
        isLoadingMore,
        hasMore,
        filterStatus,
        errorMessage,
        nextCursor,
      ];
}

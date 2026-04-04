part of 'story_detail_bloc.dart';

/// State for the Story Detail BLoC.
class StoryDetailState extends Equatable {
  /// The full story detail, or null if not yet loaded.
  final StoryDetail? story;

  /// Whether the story is loading.
  final bool isLoading;

  /// Error message, or null.
  final String? errorMessage;

  /// Whether the current user has liked this story.
  final bool isLiked;

  /// Whether the current user has confirmed this story.
  final bool isConfirmed;

  /// Current likes count (may differ from story.likes during optimistic updates).
  final int likesCount;

  /// Current confirmations count.
  final int confirmationsCount;

  /// Whether a share action is in progress.
  final bool isSharing;

  /// The last fetched shareable URL, or null if not yet fetched.
  final String? shareUrl;

  const StoryDetailState({
    this.story,
    this.isLoading = false,
    this.errorMessage,
    this.isLiked = false,
    this.isConfirmed = false,
    this.likesCount = 0,
    this.confirmationsCount = 0,
    this.isSharing = false,
    this.shareUrl,
  });

  StoryDetailState copyWith({
    StoryDetail? story,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isLiked,
    bool? isConfirmed,
    int? likesCount,
    int? confirmationsCount,
    bool? isSharing,
    String? shareUrl,
    bool clearShareUrl = false,
  }) {
    return StoryDetailState(
      story: story ?? this.story,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      isLiked: isLiked ?? this.isLiked,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      likesCount: likesCount ?? this.likesCount,
      confirmationsCount: confirmationsCount ?? this.confirmationsCount,
      isSharing: isSharing ?? this.isSharing,
      shareUrl: clearShareUrl ? null : (shareUrl ?? this.shareUrl),
    );
  }

  @override
  List<Object?> get props => [
        story,
        isLoading,
        errorMessage,
        isLiked,
        isConfirmed,
        likesCount,
        confirmationsCount,
        isSharing,
        shareUrl,
      ];
}

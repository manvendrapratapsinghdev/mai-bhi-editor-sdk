part of 'creator_profile_bloc.dart';

/// State for the Creator Profile BLoC.
class CreatorProfileState extends Equatable {
  /// The creator's profile, or null if not yet loaded.
  final CreatorProfile? profile;

  /// Whether the profile is loading.
  final bool isLoading;

  /// Error message, or null.
  final String? errorMessage;

  /// List of stories published by this creator.
  final List<FeedItem> stories;

  /// Whether stories are loading.
  final bool isLoadingStories;

  /// Whether the current user has blocked this creator.
  final bool isBlocked;

  /// Whether a report was successfully submitted this session.
  final bool reportSubmitted;

  const CreatorProfileState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
    this.stories = const [],
    this.isLoadingStories = false,
    this.isBlocked = false,
    this.reportSubmitted = false,
  });

  CreatorProfileState copyWith({
    CreatorProfile? profile,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<FeedItem>? stories,
    bool? isLoadingStories,
    bool? isBlocked,
    bool? reportSubmitted,
  }) {
    return CreatorProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      stories: stories ?? this.stories,
      isLoadingStories: isLoadingStories ?? this.isLoadingStories,
      isBlocked: isBlocked ?? this.isBlocked,
      reportSubmitted: reportSubmitted ?? this.reportSubmitted,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        isLoading,
        errorMessage,
        stories,
        isLoadingStories,
        isBlocked,
        reportSubmitted,
      ];
}

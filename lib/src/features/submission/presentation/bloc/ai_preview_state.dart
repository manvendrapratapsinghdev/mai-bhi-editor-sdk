part of 'ai_preview_bloc.dart';

/// States for the AI Preview BLoC.
abstract class AiPreviewState extends Equatable {
  const AiPreviewState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class AiPreviewInitial extends AiPreviewState {
  const AiPreviewInitial();
}

/// Loading the submission detail from the API.
class AiPreviewLoading extends AiPreviewState {
  const AiPreviewLoading();
}

/// AI processing is currently in progress (triggered, waiting for result).
class AiPreviewProcessing extends AiPreviewState {
  final SubmissionDetail submissionDetail;

  const AiPreviewProcessing(this.submissionDetail);

  @override
  List<Object?> get props => [submissionDetail];
}

/// Submission detail loaded with AI review data available.
class AiPreviewLoaded extends AiPreviewState {
  final SubmissionDetail submissionDetail;
  final AIReviewResult aiReview;

  /// Currently selected tags (user can deselect).
  final Set<String> selectedTags;

  /// Currently selected category (user can override).
  final String? selectedCategory;

  const AiPreviewLoaded({
    required this.submissionDetail,
    required this.aiReview,
    required this.selectedTags,
    this.selectedCategory,
  });

  AiPreviewLoaded copyWith({
    SubmissionDetail? submissionDetail,
    AIReviewResult? aiReview,
    Set<String>? selectedTags,
    String? selectedCategory,
  }) {
    return AiPreviewLoaded(
      submissionDetail: submissionDetail ?? this.submissionDetail,
      aiReview: aiReview ?? this.aiReview,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
        submissionDetail,
        aiReview,
        selectedTags,
        selectedCategory,
      ];
}

/// An error occurred while loading or processing.
class AiPreviewError extends AiPreviewState {
  final String message;
  final String? submissionId;

  const AiPreviewError(this.message, {this.submissionId});

  @override
  List<Object?> get props => [message, submissionId];
}

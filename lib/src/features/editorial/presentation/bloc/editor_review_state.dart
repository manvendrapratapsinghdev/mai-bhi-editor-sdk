part of 'editor_review_bloc.dart';

/// States for the Editor Review BLoC.
abstract class EditorReviewState extends Equatable {
  const EditorReviewState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class EditorReviewInitial extends EditorReviewState {
  const EditorReviewInitial();
}

/// Loading the submission detail for review.
class EditorReviewLoading extends EditorReviewState {
  const EditorReviewLoading();
}

/// Submission detail loaded and ready for editor review.
class EditorReviewLoaded extends EditorReviewState {
  final SubmissionDetail submissionDetail;

  /// Working copy of the edited title (for inline editing).
  final String? editedTitle;

  /// Working copy of the edited description (for inline editing).
  final String? editedDescription;

  /// Whether the story has been flagged as false.
  final bool isFlaggedFalse;

  /// Whether a flag-false action is in progress.
  final bool isFlagging;

  const EditorReviewLoaded({
    required this.submissionDetail,
    this.editedTitle,
    this.editedDescription,
    this.isFlaggedFalse = false,
    this.isFlagging = false,
  });

  EditorReviewLoaded copyWith({
    SubmissionDetail? submissionDetail,
    String? editedTitle,
    bool clearEditedTitle = false,
    String? editedDescription,
    bool clearEditedDescription = false,
    bool? isFlaggedFalse,
    bool? isFlagging,
  }) {
    return EditorReviewLoaded(
      submissionDetail: submissionDetail ?? this.submissionDetail,
      editedTitle:
          clearEditedTitle ? null : (editedTitle ?? this.editedTitle),
      editedDescription: clearEditedDescription
          ? null
          : (editedDescription ?? this.editedDescription),
      isFlaggedFalse: isFlaggedFalse ?? this.isFlaggedFalse,
      isFlagging: isFlagging ?? this.isFlagging,
    );
  }

  @override
  List<Object?> get props => [
        submissionDetail,
        editedTitle,
        editedDescription,
        isFlaggedFalse,
        isFlagging,
      ];
}

/// An editor action is currently being submitted.
class EditorReviewSubmitting extends EditorReviewState {
  final SubmissionDetail submissionDetail;

  const EditorReviewSubmitting(this.submissionDetail);

  @override
  List<Object?> get props => [submissionDetail];
}

/// Editor action completed successfully.
class EditorReviewActionSuccess extends EditorReviewState {
  final String message;

  const EditorReviewActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Flag-false action completed successfully.
class EditorReviewFlagSuccess extends EditorReviewState {
  final SubmissionDetail submissionDetail;
  final String message;

  const EditorReviewFlagSuccess({
    required this.submissionDetail,
    required this.message,
  });

  @override
  List<Object?> get props => [submissionDetail, message];
}

/// An error occurred.
class EditorReviewError extends EditorReviewState {
  final String message;
  final String? submissionId;

  const EditorReviewError(this.message, {this.submissionId});

  @override
  List<Object?> get props => [message, submissionId];
}

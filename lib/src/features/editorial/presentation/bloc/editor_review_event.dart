part of 'editor_review_bloc.dart';

/// Events for the Editor Review BLoC.
abstract class EditorReviewEvent extends Equatable {
  const EditorReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Load the full submission detail for review.
class LoadReview extends EditorReviewEvent {
  final String submissionId;

  const LoadReview(this.submissionId);

  @override
  List<Object?> get props => [submissionId];
}

/// Perform an editor action (approve, edit, reject, mark_correction).
class PerformAction extends EditorReviewEvent {
  final EditorAction action;

  const PerformAction(this.action);

  @override
  List<Object?> get props => [action];
}

/// Update the editor's edited text fields (for the "Edit" action).
class UpdateEditedText extends EditorReviewEvent {
  final String? editedTitle;
  final String? editedDescription;

  const UpdateEditedText({this.editedTitle, this.editedDescription});

  @override
  List<Object?> get props => [editedTitle, editedDescription];
}

/// Flag the story as false news (S4-07).
class FlagAsFalse extends EditorReviewEvent {
  const FlagAsFalse();
}

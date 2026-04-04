part of 'submission_form_bloc.dart';

/// Events for the submission form BLoC.
abstract class SubmissionFormEvent extends Equatable {
  const SubmissionFormEvent();

  @override
  List<Object?> get props => [];
}

/// User changed the title field.
class SubmissionTitleChanged extends SubmissionFormEvent {
  final String title;

  const SubmissionTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

/// User changed the description field.
class SubmissionDescriptionChanged extends SubmissionFormEvent {
  final String description;

  const SubmissionDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

/// User selected a city.
class SubmissionCityChanged extends SubmissionFormEvent {
  final String city;

  const SubmissionCityChanged(this.city);

  @override
  List<Object?> get props => [city];
}

/// User picked a cover image from camera or gallery.
class SubmissionCoverImagePicked extends SubmissionFormEvent {
  final String imagePath;

  const SubmissionCoverImagePicked(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// User removed the cover image.
class SubmissionCoverImageRemoved extends SubmissionFormEvent {
  const SubmissionCoverImageRemoved();
}

/// User added an additional image.
class SubmissionAdditionalImageAdded extends SubmissionFormEvent {
  final String imagePath;

  const SubmissionAdditionalImageAdded(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// User removed an additional image by index.
class SubmissionAdditionalImageRemoved extends SubmissionFormEvent {
  final int index;

  const SubmissionAdditionalImageRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

/// User reordered additional images.
class SubmissionImagesReordered extends SubmissionFormEvent {
  final int oldIndex;
  final int newIndex;

  const SubmissionImagesReordered({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

/// User tapped the submit button.
class SubmissionFormSubmitted extends SubmissionFormEvent {
  const SubmissionFormSubmitted();
}

/// Load a draft for editing.
class SubmissionDraftLoaded extends SubmissionFormEvent {
  final String draftId;

  const SubmissionDraftLoaded(this.draftId);

  @override
  List<Object?> get props => [draftId];
}

/// Save the current form as a draft.
class SubmissionDraftSaveRequested extends SubmissionFormEvent {
  const SubmissionDraftSaveRequested();
}

/// Delete the current draft.
class SubmissionDraftDeleteRequested extends SubmissionFormEvent {
  const SubmissionDraftDeleteRequested();
}

/// Reset the form to initial state.
class SubmissionFormReset extends SubmissionFormEvent {
  const SubmissionFormReset();
}

part of 'my_submissions_bloc.dart';

/// Events for the "Posted by You" dashboard BLoC.
abstract class MySubmissionsEvent extends Equatable {
  const MySubmissionsEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load of submissions.
class LoadMySubmissions extends MySubmissionsEvent {
  const LoadMySubmissions();
}

/// Filter submissions by status. Pass null to show all.
class FilterByStatus extends MySubmissionsEvent {
  final SubmissionStatus? status;

  const FilterByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Load more submissions for infinite scroll.
class LoadMoreSubmissions extends MySubmissionsEvent {
  const LoadMoreSubmissions();
}

/// Pull-to-refresh.
class RefreshMySubmissions extends MySubmissionsEvent {
  const RefreshMySubmissions();
}

/// Delete a local draft.
class DeleteDraftSubmission extends MySubmissionsEvent {
  final String draftId;

  const DeleteDraftSubmission(this.draftId);

  @override
  List<Object?> get props => [draftId];
}

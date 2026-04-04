part of 'ai_preview_bloc.dart';

/// Events for the AI Preview BLoC.
abstract class AiPreviewEvent extends Equatable {
  const AiPreviewEvent();

  @override
  List<Object?> get props => [];
}

/// Load the AI preview for a submission.
///
/// Fetches submission detail. If AI review is already available, shows it.
/// Otherwise triggers AI processing automatically.
class LoadAiPreview extends AiPreviewEvent {
  final String submissionId;

  const LoadAiPreview(this.submissionId);

  @override
  List<Object?> get props => [submissionId];
}

/// Explicitly trigger AI processing on the submission.
class TriggerAiProcessing extends AiPreviewEvent {
  final String submissionId;

  const TriggerAiProcessing(this.submissionId);

  @override
  List<Object?> get props => [submissionId];
}

/// User accepts AI corrections and proceeds to the editorial queue.
class AcceptAndProceed extends AiPreviewEvent {
  const AcceptAndProceed();
}

/// User updates tag selection (toggle a suggested tag).
class ToggleTag extends AiPreviewEvent {
  final String tag;

  const ToggleTag(this.tag);

  @override
  List<Object?> get props => [tag];
}

/// User overrides the AI-suggested category.
class UpdateCategory extends AiPreviewEvent {
  final String category;

  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

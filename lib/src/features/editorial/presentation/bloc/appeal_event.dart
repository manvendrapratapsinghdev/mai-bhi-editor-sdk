part of 'appeal_bloc.dart';

/// Events for the Appeal BLoC.
abstract class AppealEvent extends Equatable {
  const AppealEvent();

  @override
  List<Object?> get props => [];
}

/// Load existing appeal status for a submission.
class LoadAppealStatus extends AppealEvent {
  final String submissionId;

  const LoadAppealStatus(this.submissionId);

  @override
  List<Object?> get props => [submissionId];
}

/// Submit a new appeal for a rejected submission.
class SubmitAppealEvent extends AppealEvent {
  final String submissionId;
  final String justification;

  const SubmitAppealEvent({
    required this.submissionId,
    required this.justification,
  });

  @override
  List<Object?> get props => [submissionId, justification];
}

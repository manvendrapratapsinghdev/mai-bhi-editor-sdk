part of 'appeal_bloc.dart';

/// States for the Appeal BLoC.
abstract class AppealState extends Equatable {
  const AppealState();

  @override
  List<Object?> get props => [];
}

/// Initial state, no appeal data loaded.
class AppealInitial extends AppealState {
  const AppealInitial();
}

/// Loading the appeal status.
class AppealLoading extends AppealState {
  const AppealLoading();
}

/// No appeal exists yet — user can file one.
class AppealNotFiled extends AppealState {
  final String? rejectionReason;

  const AppealNotFiled({this.rejectionReason});

  @override
  List<Object?> get props => [rejectionReason];
}

/// Appeal has been submitted and is pending review.
class AppealPending extends AppealState {
  final Appeal appeal;

  const AppealPending(this.appeal);

  @override
  List<Object?> get props => [appeal];
}

/// Appeal has been reviewed (approved or rejected).
class AppealReviewed extends AppealState {
  final Appeal appeal;

  const AppealReviewed(this.appeal);

  @override
  List<Object?> get props => [appeal];
}

/// Appeal submission is in progress.
class AppealSubmitting extends AppealState {
  const AppealSubmitting();
}

/// Appeal submitted successfully.
class AppealSubmitted extends AppealState {
  final Appeal appeal;

  const AppealSubmitted(this.appeal);

  @override
  List<Object?> get props => [appeal];
}

/// An error occurred.
class AppealError extends AppealState {
  final String message;

  const AppealError(this.message);

  @override
  List<Object?> get props => [message];
}

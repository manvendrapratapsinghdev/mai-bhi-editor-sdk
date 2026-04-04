import '../entities/ai_review_result.dart';
import '../repositories/submission_repository.dart';

/// Use case: Trigger AI processing on a submission.
class TriggerAiProcessingUseCase {
  final SubmissionRepository _repository;

  const TriggerAiProcessingUseCase(this._repository);

  Future<AIReviewResult> call(String submissionId) {
    return _repository.triggerAiReview(submissionId);
  }
}

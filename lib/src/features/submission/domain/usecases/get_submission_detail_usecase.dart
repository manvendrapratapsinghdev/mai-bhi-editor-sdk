import '../entities/submission_detail.dart';
import '../repositories/submission_repository.dart';

/// Use case: Fetch full details for a single submission.
class GetSubmissionDetailUseCase {
  final SubmissionRepository _repository;

  const GetSubmissionDetailUseCase(this._repository);

  Future<SubmissionDetail> call(String id) {
    return _repository.getSubmissionDetail(id);
  }
}

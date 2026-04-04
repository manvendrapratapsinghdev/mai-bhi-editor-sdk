import '../entities/submission.dart';
import '../repositories/submission_repository.dart';

/// Use case: Fetch the current user's list of submissions.
class GetMySubmissionsUseCase {
  final SubmissionRepository _repository;

  const GetMySubmissionsUseCase(this._repository);

  Future<List<Submission>> call({
    SubmissionStatus? status,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getMySubmissions(
      status: status,
      page: page,
      limit: limit,
    );
  }
}

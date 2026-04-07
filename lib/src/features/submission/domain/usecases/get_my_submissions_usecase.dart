import '../../data/datasources/submission_remote_datasource.dart'
    show PaginatedResult;
import '../entities/submission.dart';
import '../repositories/submission_repository.dart';

/// Use case: Fetch the current user's list of submissions.
class GetMySubmissionsUseCase {
  final SubmissionRepository _repository;

  const GetMySubmissionsUseCase(this._repository);

  Future<PaginatedResult<Submission>> call({
    SubmissionStatus? status,
    String? cursor,
    int limit = 20,
  }) {
    return _repository.getMySubmissions(
      status: status,
      cursor: cursor,
      limit: limit,
    );
  }
}

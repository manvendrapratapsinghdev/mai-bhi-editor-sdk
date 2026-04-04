import '../entities/appeal.dart';
import '../repositories/editorial_repository.dart';

/// Use case: Fetch the appeal for a specific submission (creator view).
class GetAppealUseCase {
  final EditorialRepository _repository;

  const GetAppealUseCase(this._repository);

  Future<Appeal?> call(String submissionId) {
    return _repository.getAppealForSubmission(submissionId);
  }
}

import '../entities/appeal.dart';
import '../repositories/editorial_repository.dart';

/// Use case: Submit an appeal for a rejected submission (creator view).
class SubmitAppealUseCase {
  final EditorialRepository _repository;

  const SubmitAppealUseCase(this._repository);

  Future<Appeal> call({
    required String submissionId,
    required String justification,
  }) {
    return _repository.submitAppeal(
      submissionId: submissionId,
      justification: justification,
    );
  }
}

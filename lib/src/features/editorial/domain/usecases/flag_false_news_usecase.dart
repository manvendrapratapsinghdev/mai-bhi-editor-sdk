import '../repositories/editorial_repository.dart';

/// Use case: Flag a published story as false news.
class FlagFalseNewsUseCase {
  final EditorialRepository _repository;

  const FlagFalseNewsUseCase(this._repository);

  Future<void> call(String submissionId) {
    return _repository.flagFalseNews(submissionId);
  }
}

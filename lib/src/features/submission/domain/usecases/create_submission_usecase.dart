import '../../data/models/submission_create_model.dart';
import '../entities/submission.dart';
import '../repositories/submission_repository.dart';

/// Use case: Create a new citizen news submission.
class CreateSubmissionUseCase {
  final SubmissionRepository _repository;

  const CreateSubmissionUseCase(this._repository);

  Future<Submission> call({
    required SubmissionCreate data,
    required String coverImagePath,
    List<String> additionalImagePaths = const [],
  }) {
    return _repository.createSubmission(
      data: data,
      coverImagePath: coverImagePath,
      additionalImagePaths: additionalImagePaths,
    );
  }
}

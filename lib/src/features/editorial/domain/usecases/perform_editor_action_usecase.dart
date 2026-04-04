import '../../../submission/domain/entities/submission.dart';
import '../../data/models/editor_action_model.dart';
import '../repositories/editorial_repository.dart';

/// Use case: Perform an editor action on a submission.
class PerformEditorActionUseCase {
  final EditorialRepository _repository;

  const PerformEditorActionUseCase(this._repository);

  Future<Submission> call({
    required String submissionId,
    required EditorAction action,
  }) {
    return _repository.performAction(
      submissionId: submissionId,
      action: action,
    );
  }
}

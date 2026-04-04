import '../../../submission/domain/entities/submission.dart';
import '../../../submission/domain/entities/submission_detail.dart';
import '../../domain/entities/appeal.dart';
import '../../domain/entities/editorial_queue_item.dart';
import '../../domain/repositories/editorial_repository.dart';
import '../datasources/editorial_remote_datasource.dart';
import '../models/editor_action_model.dart';

/// Concrete implementation of [EditorialRepository].
///
/// Delegates all calls to [EditorialRemoteDataSource].
class EditorialRepositoryImpl implements EditorialRepository {
  final EditorialRemoteDataSource _remoteDataSource;

  const EditorialRepositoryImpl({
    required EditorialRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<EditorialQueueItem>> getQueue({
    String? city,
    String? sortBy,
    int page = 1,
  }) {
    return _remoteDataSource.getQueue(
      city: city,
      sortBy: sortBy,
      page: page,
    );
  }

  @override
  Future<SubmissionDetail> getSubmissionDetail(String submissionId) {
    return _remoteDataSource.getSubmissionDetail(submissionId);
  }

  @override
  Future<Submission> performAction({
    required String submissionId,
    required EditorAction action,
  }) {
    return _remoteDataSource.performAction(
      submissionId: submissionId,
      action: action,
    );
  }

  @override
  Future<void> flagFalseNews(String submissionId) {
    return _remoteDataSource.flagFalseNews(submissionId);
  }

  @override
  Future<List<Appeal>> getAppeals() {
    return _remoteDataSource.getAppeals();
  }

  @override
  Future<Appeal> reviewAppeal({
    required String appealId,
    required bool approve,
    String? notes,
  }) {
    return _remoteDataSource.reviewAppeal(
      appealId: appealId,
      approve: approve,
      notes: notes,
    );
  }

  @override
  Future<Appeal> submitAppeal({
    required String submissionId,
    required String justification,
  }) {
    return _remoteDataSource.submitAppeal(
      submissionId: submissionId,
      justification: justification,
    );
  }

  @override
  Future<Appeal?> getAppealForSubmission(String submissionId) {
    return _remoteDataSource.getAppealForSubmission(submissionId);
  }
}

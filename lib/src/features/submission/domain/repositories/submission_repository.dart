import '../entities/submission.dart';
import '../entities/submission_detail.dart';
import '../entities/ai_review_result.dart';
import '../../data/datasources/submission_remote_datasource.dart';
import '../../data/models/submission_create_model.dart';

/// Abstract contract for submission operations.
abstract class SubmissionRepository {
  /// Create a new submission with multipart image upload.
  Future<Submission> createSubmission({
    required SubmissionCreate data,
    required String coverImagePath,
    List<String> additionalImagePaths,
  });

  /// Fetch the current user's submissions, optionally filtered by status.
  Future<PaginatedResult<Submission>> getMySubmissions({
    SubmissionStatus? status,
    String? cursor,
    int limit = 20,
  });

  /// Fetch a single submission's full details.
  Future<SubmissionDetail> getSubmissionDetail(String id);

  /// Trigger AI processing on a submission.
  Future<AIReviewResult> triggerAiReview(String id);
}

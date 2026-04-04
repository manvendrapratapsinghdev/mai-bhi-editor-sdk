import '../../../submission/domain/entities/submission.dart';
import '../../../submission/domain/entities/submission_detail.dart';
import '../entities/appeal.dart';
import '../entities/editorial_queue_item.dart';
import '../../data/models/editor_action_model.dart';

/// Abstract contract for editorial operations.
abstract class EditorialRepository {
  /// Fetch the editor review queue.
  ///
  /// Supports optional [city] filter, [sortBy] ordering, and pagination
  /// via [page].
  Future<List<EditorialQueueItem>> getQueue({
    String? city,
    String? sortBy,
    int page = 1,
  });

  /// Fetch full detail for a single submission (for editor review).
  Future<SubmissionDetail> getSubmissionDetail(String submissionId);

  /// Perform an editor action (approve, edit, reject, mark_correction).
  Future<Submission> performAction({
    required String submissionId,
    required EditorAction action,
  });

  /// Flag a published story as false news.
  Future<void> flagFalseNews(String submissionId);

  /// Fetch pending appeals (editor view).
  Future<List<Appeal>> getAppeals();

  /// Review an appeal (editor action).
  Future<Appeal> reviewAppeal({
    required String appealId,
    required bool approve,
    String? notes,
  });

  /// Submit an appeal for a rejected submission (creator view).
  Future<Appeal> submitAppeal({
    required String submissionId,
    required String justification,
  });

  /// Get the appeal for a specific submission (creator view).
  Future<Appeal?> getAppealForSubmission(String submissionId);
}

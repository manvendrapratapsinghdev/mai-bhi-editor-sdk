import '../../domain/entities/ai_review_result.dart';
import '../../domain/entities/submission.dart';
import '../../domain/entities/submission_detail.dart';
import '../../domain/repositories/submission_repository.dart';
import '../datasources/submission_remote_datasource.dart'
    show PaginatedResult, SubmissionRemoteDataSource;
import '../local/draft_local_datasource.dart';
import '../models/submission_create_model.dart';

/// Concrete implementation of [SubmissionRepository].
///
/// Orchestrates between remote API calls and local draft storage.
class SubmissionRepositoryImpl implements SubmissionRepository {
  final SubmissionRemoteDataSource _remoteDataSource;
  final DraftLocalDataSource _draftLocalDataSource;

  const SubmissionRepositoryImpl({
    required SubmissionRemoteDataSource remoteDataSource,
    required DraftLocalDataSource draftLocalDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _draftLocalDataSource = draftLocalDataSource;

  @override
  Future<Submission> createSubmission({
    required SubmissionCreate data,
    required String coverImagePath,
    List<String> additionalImagePaths = const [],
  }) async {
    final submission = await _remoteDataSource.createSubmission(
      data: data,
      coverImagePath: coverImagePath,
    );

    // Upload additional images if any.
    if (additionalImagePaths.isNotEmpty) {
      await _remoteDataSource.uploadAdditionalImages(
        submissionId: submission.id,
        imagePaths: additionalImagePaths,
      );
    }

    return submission;
  }

  @override
  Future<PaginatedResult<Submission>> getMySubmissions({
    SubmissionStatus? status,
    String? cursor,
    int limit = 20,
  }) async {
    final statusString = status != null ? _statusToString(status) : null;

    // Fetch remote submissions.
    final result = await _remoteDataSource.getMySubmissions(
      status: statusString,
      cursor: cursor,
      limit: limit,
    );

    // Merge local drafts on the first page (no cursor) if no status
    // filter, or if filtering for drafts.
    if (cursor == null &&
        (status == null || status == SubmissionStatus.draft)) {
      final drafts = await _draftLocalDataSource.getAllDrafts();
      final draftSubmissions = drafts.map((d) => d.toSubmission()).toList();

      if (status == SubmissionStatus.draft) {
        return PaginatedResult(items: draftSubmissions);
      }
      // Prepend drafts to the first page.
      return PaginatedResult(
        items: [...draftSubmissions, ...result.items],
        nextCursor: result.nextCursor,
        hasMore: result.hasMore,
      );
    }

    return result;
  }

  @override
  Future<SubmissionDetail> getSubmissionDetail(String id) {
    return _remoteDataSource.getSubmissionDetail(id);
  }

  @override
  Future<AIReviewResult> triggerAiReview(String id) {
    return _remoteDataSource.triggerAiProcessing(id);
  }

  String _statusToString(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.draft:
        return 'draft';
      case SubmissionStatus.inProgress:
        return 'in_progress';
      case SubmissionStatus.underReview:
        return 'under_review';
      case SubmissionStatus.published:
        return 'published';
      case SubmissionStatus.rejected:
        return 'rejected';
    }
  }
}

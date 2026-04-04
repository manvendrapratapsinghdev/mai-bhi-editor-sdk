import '../repositories/community_repository.dart';

/// Use case: report a creator or story.
class ReportUseCase {
  final CommunityRepository _repository;

  const ReportUseCase(this._repository);

  /// Submit a report for a target (creator or story).
  ///
  /// [targetType] is either 'creator' or 'story'.
  /// [targetId] is the ID of the entity being reported.
  /// [reason] is the selected category (e.g. 'misinformation').
  /// [details] is the optional free-text explanation.
  Future<void> call({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
  }) {
    return _repository.report(
      targetType: targetType,
      targetId: targetId,
      reason: reason,
      details: details,
    );
  }
}

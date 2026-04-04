import '../repositories/community_repository.dart';

/// Use case: block or unblock a creator.
class BlockCreatorUseCase {
  final CommunityRepository _repository;

  const BlockCreatorUseCase(this._repository);

  /// Toggle block status for a creator. Returns `true` if now blocked.
  Future<bool> call(String creatorId) {
    return _repository.blockCreator(creatorId);
  }
}

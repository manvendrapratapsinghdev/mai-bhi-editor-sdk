import '../entities/creator_profile.dart';
import '../repositories/community_repository.dart';

/// Use case: fetch the list of blocked creators.
class GetBlockedCreatorsUseCase {
  final CommunityRepository _repository;

  const GetBlockedCreatorsUseCase(this._repository);

  Future<List<CreatorProfile>> call() {
    return _repository.getBlockedCreators();
  }
}

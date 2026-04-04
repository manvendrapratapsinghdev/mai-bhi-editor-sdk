import '../entities/creator_profile.dart';
import '../repositories/community_repository.dart';

/// Use case: fetch a creator's public profile by ID.
class GetCreatorProfileUseCase {
  final CommunityRepository _repository;

  const GetCreatorProfileUseCase(this._repository);

  Future<CreatorProfile> call(String creatorId) {
    return _repository.getCreatorProfile(creatorId);
  }
}

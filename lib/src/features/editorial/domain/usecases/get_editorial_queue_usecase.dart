import '../entities/editorial_queue_item.dart';
import '../repositories/editorial_repository.dart';

/// Use case: Fetch the editorial review queue.
class GetEditorialQueueUseCase {
  final EditorialRepository _repository;

  const GetEditorialQueueUseCase(this._repository);

  Future<List<EditorialQueueItem>> call({
    String? city,
    String? sortBy,
    int page = 1,
  }) {
    return _repository.getQueue(
      city: city,
      sortBy: sortBy,
      page: page,
    );
  }
}

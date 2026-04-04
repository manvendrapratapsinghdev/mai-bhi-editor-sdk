import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Use case: Fetch paginated notifications for the current user.
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  const GetNotificationsUseCase(this._repository);

  Future<List<NotificationEntity>> call({
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getNotifications(page: page, limit: limit);
  }
}

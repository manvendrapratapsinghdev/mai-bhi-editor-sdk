import '../repositories/notification_repository.dart';

/// Use case: Register a device token for push notifications.
class RegisterDeviceUseCase {
  final NotificationRepository _repository;

  const RegisterDeviceUseCase(this._repository);

  Future<void> call({
    required String token,
    required String platform,
  }) {
    return _repository.registerDevice(token: token, platform: platform);
  }
}

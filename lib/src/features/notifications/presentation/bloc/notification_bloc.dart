import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/register_device_usecase.dart';
import '../../domain/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

/// BLoC that manages notification list state.
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final RegisterDeviceUseCase _registerDeviceUseCase;
  final NotificationRepository _repository;

  NotificationBloc({
    required GetNotificationsUseCase getNotificationsUseCase,
    required RegisterDeviceUseCase registerDeviceUseCase,
    required NotificationRepository repository,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _registerDeviceUseCase = registerDeviceUseCase,
        _repository = repository,
        super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
    on<LoadMoreNotifications>(_onLoadMore);
    on<RegisterDeviceToken>(_onRegisterDevice);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final notifications = await _getNotificationsUseCase(page: 1);
      final unreadCount =
          notifications.where((n) => !n.isRead).length;
      emit(state.copyWith(
        isLoading: false,
        notifications: notifications,
        unreadCount: unreadCount,
        currentPage: 1,
        hasMore: notifications.length >= 20,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load notifications',
      ));
    }
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.markAsRead(event.notificationId);
      final updated = state.notifications.map((n) {
        if (n.id == event.notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      final unreadCount = updated.where((n) => !n.isRead).length;
      emit(state.copyWith(
        notifications: updated,
        unreadCount: unreadCount,
      ));
    } on ServerException {
      // Best-effort; don't disrupt the UX.
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.markAllAsRead();
      final updated =
          state.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(state.copyWith(
        notifications: updated,
        unreadCount: 0,
      ));
    } on ServerException {
      // Best-effort.
    }
  }

  Future<void> _onLoadMore(
    LoadMoreNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.currentPage + 1;
      final moreNotifications =
          await _getNotificationsUseCase(page: nextPage);
      final allNotifications = [
        ...state.notifications,
        ...moreNotifications,
      ];
      final unreadCount =
          allNotifications.where((n) => !n.isRead).length;
      emit(state.copyWith(
        isLoadingMore: false,
        notifications: allNotifications,
        currentPage: nextPage,
        hasMore: moreNotifications.length >= 20,
        unreadCount: unreadCount,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Failed to load more notifications',
      ));
    }
  }

  Future<void> _onRegisterDevice(
    RegisterDeviceToken event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _registerDeviceUseCase(
        token: event.token,
        platform: event.platform,
      );
    } catch (_) {
      // Device registration is best-effort.
    }
  }
}

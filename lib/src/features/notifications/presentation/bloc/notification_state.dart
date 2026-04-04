part of 'notification_bloc.dart';

/// State for the notification BLoC.
class NotificationState extends Equatable {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final bool isLoadingMore;
  final int unreadCount;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.unreadCount = 0,
    this.hasMore = true,
    this.currentPage = 0,
    this.errorMessage,
  });

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    bool? isLoadingMore,
    int? unreadCount,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        isLoading,
        isLoadingMore,
        unreadCount,
        hasMore,
        currentPage,
        errorMessage,
      ];
}

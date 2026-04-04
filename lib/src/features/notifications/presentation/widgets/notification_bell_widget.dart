import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_bloc.dart';

/// Notification bell icon with unread count badge.
///
/// Listens to [NotificationBloc] to display the current unread count.
/// Designed to be placed in an app bar's actions list.
class NotificationBellWidget extends StatelessWidget {
  final VoidCallback onTap;

  const NotificationBellWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (p, c) => p.unreadCount != c.unreadCount,
      builder: (context, state) {
        return IconButton(
          icon: Badge(
            isLabelVisible: state.unreadCount > 0,
            label: Text(
              state.unreadCount > 99 ? '99+' : state.unreadCount.toString(),
              style: const TextStyle(fontSize: 10),
            ),
            child: const Icon(Icons.notifications_outlined),
          ),
          tooltip: 'Notifications',
          onPressed: onTap,
        );
      },
    );
  }
}

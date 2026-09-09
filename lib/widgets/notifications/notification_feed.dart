import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/notification.dart';
import 'package:mage_nagoftam/widgets/notifications/notification_item.dart';

class NotificationFeed extends StatelessWidget {
  final List<AppNotification> notifications;
  final VoidCallback? onRefresh;
  final Future<void> Function()? onRefreshAsync;

  const NotificationFeed({
    super.key,
    required this.notifications,
    this.onRefresh,
    this.onRefreshAsync,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefreshAsync ?? () async {},
      child: ListView.builder(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 24,
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationItem(
            notification: notifications[index],
          );
        },
      ),
    );
  }
}
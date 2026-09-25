import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/notification.dart';
import 'package:mage_nagoftam/style/color.dart';
import 'package:mage_nagoftam/style/typography.dart';
import 'package:mage_nagoftam/widgets/notifications/notification_item.dart';

class NotificationFeed extends StatelessWidget {
  final List<AppNotification> notifications;
  final Future<void> Function()? onRefresh;

  const NotificationFeed({
    super.key,
    required this.notifications,
    this.onRefresh,
  });

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(
      const Duration(days: 1),
    );

    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  String _dateTitle(DateTime date) {
    if (_isToday(date)) {
      return 'امروز';
    }

    if (_isYesterday(date)) {
      return 'دیروز';
    }

    return '${date.year}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Map<DateTime, List<AppNotification>> _groupNotifications() {
    final grouped = <DateTime, List<AppNotification>>{};

    for (final notification in notifications) {
      final date = _dateOnly(notification.createdAt);

      grouped.putIfAbsent(date, () => []);

      grouped[date]!.add(notification);
    }

    final entries = grouped.entries.toList();

    entries.sort(
      (a, b) => b.key.compareTo(a.key),
    );

    for (final entry in entries) {
      entry.value.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
    }

    return Map.fromEntries(entries);
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotifications();

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 24,
        ),
        children: [
          for (final entry in groupedNotifications.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.gray4,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Text(
                      _dateTitle(entry.key),
                      style: AppTypography.h9.copyWith(
                        color: AppColors.gray2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Divider(
                      color: AppColors.gray4,
                    ),
                  ),
                ],
              ),
            ),

            for (final notification in entry.value)
              NotificationItem(
                notification: notification,
              ),
          ],
        ],
      ),
    );
  }
}
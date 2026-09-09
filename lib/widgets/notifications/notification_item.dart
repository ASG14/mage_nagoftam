import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/notification.dart';
import 'package:mage_nagoftam/style/color.dart';
import 'package:mage_nagoftam/style/typography.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
  });

  String _timeText() {
    final difference =
        DateTime.now().difference(notification.createdAt);

    if (difference.isNegative) {
      return 'همین الان';
    }

    if (difference.inMinutes < 1) {
      return 'همین الان';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقیقه پیش';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} ساعت پیش';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} روز پیش';
    }

    final date = notification.createdAt;

    return '${date.year}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.transparent
              : AppColors.white1,
          border: Border(
            bottom: BorderSide(
              color: AppColors.gray4,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Text(
                    notification.title,
                    textAlign: TextAlign.right,
                    style: AppTypography.h8.copyWith(
                      color: AppColors.gray1,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),

                  if (notification.message.isNotEmpty) ...[
                    const SizedBox(height: 4),

                    Text(
                      notification.message,
                      textAlign: TextAlign.right,
                      style: AppTypography.h9.copyWith(
                        color: AppColors.gray1,
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: 5),

                  Text(
                    _timeText(),
                    textAlign: TextAlign.left,
                    style: AppTypography.h10.copyWith(
                      color: AppColors.gray2,
                    ),
                  ),
                ],
              ),
            ),

            if (!notification.isRead)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(
                  left: 8,
                  top: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green1,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
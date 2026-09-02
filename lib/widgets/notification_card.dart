import 'package:flutter/material.dart';

import 'package:begir/models/notification.dart';
import 'package:begir/style/color.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData _iconForType() {
    switch (notification.type) {
      case 'order_created':
        return Icons.add_shopping_cart_outlined;

      case 'order_reserved':
        return Icons.shopping_cart_checkout_outlined;

      case 'order_completed':
        return Icons.check_circle_outline;

      case 'member_added':
        return Icons.person_add_alt_1_outlined;

      case 'member_joined':
        return Icons.group_add_outlined;

      case 'member_removed':
        return Icons.person_remove_outlined;

      default:
        return Icons.notifications_none_outlined;
    }
  }

  Color _iconColor() {
    switch (notification.type) {
      case 'order_completed':
        return AppColors.green1;

      case 'order_reserved':
        return AppColors.orange1;

      case 'member_removed':
        return AppColors.red1;

      default:
        return AppColors.gray1;
    }
  }

  String _timeText() {
    final difference =
        DateTime.now().difference(notification.createdAt);

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

    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _iconColor();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      color: notification.isRead
          ? Colors.transparent
          : AppColors.gray4,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _iconForType(),
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                        ),

                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.red1,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray1,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _timeText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
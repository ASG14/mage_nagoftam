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
    final date = notification.createdAt;

    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _actorText() {
    final name = notification.actorName.trim();

    return name.isEmpty ? 'نامشخص' : name;
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            '$label: ',
            textAlign: TextAlign.right,
            style: AppTypography.h10.copyWith(
              color: AppColors.gray2,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.h10.copyWith(
                color: AppColors.gray1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
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

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // تیتر اعلان
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

                  const SizedBox(height: 3),

                  // کاربر
                  _infoRow(
                    'کاربر',
                    _actorText(),
                  ),

                  // سفارش
                  if (notification.orderTitle != null &&
                      notification.orderTitle!.trim().isNotEmpty)
                    _infoRow(
                      'سفارش',
                      notification.orderTitle!.trim(),
                    ),

                  // گروه
                  if (notification.groupTitle != null &&
                      notification.groupTitle!.trim().isNotEmpty)
                    _infoRow(
                      'گروه',
                      notification.groupTitle!.trim(),
                    ),

                  const SizedBox(height: 4),

                  // فقط ساعت — سمت چپ کارت
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
          ],
        ),
      ),
    );
  }
}
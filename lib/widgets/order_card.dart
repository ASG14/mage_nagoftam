import 'package:flutter/material.dart';

import 'package:begir/models/order.dart';
import 'package:begir/style/color.dart';
import 'package:begir/style/typography.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  final VoidCallback? onReserve;
  final VoidCallback? onComplete;

  const OrderCard({
    super.key,
    required this.order,
    this.onReserve,
    this.onComplete,
  });

  // --------------------------------------------------
  // Priority Text
  // --------------------------------------------------

  String _priorityText(
    Priority priority,
  ) {
    switch (priority) {
      case Priority.low:
        return 'کم';

      case Priority.medium:
        return 'عادی';

      case Priority.high:
        return 'زیاد';
    }
  }

  // --------------------------------------------------
  // Status Text
  // --------------------------------------------------

  String _statusText(
    Status status,
  ) {
    switch (status) {
      case Status.pending:
        return 'در انتظار خرید';

      case Status.reserved:
        return 'در حال خرید';

      case Status.completed:
        return 'خریداری شده';

      case Status.cancelled:
        return 'لغو شده';
    }
  }

  // --------------------------------------------------
  // Build
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white2,

        borderRadius:
            BorderRadius.circular(10),

        border: Border.all(
          color: AppColors.gray4,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,

        children: [
          // --------------------------------------------------
          // Title + Priority
          // --------------------------------------------------

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Text(
                  order.title,

                  style: AppTypography.h5.copyWith(
                    color: AppColors.gray1,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: AppColors.gray4,

                  borderRadius:
                      BorderRadius.circular(5),
                ),

                child: Text(
                  'اولویت: '
                  '${_priorityText(order.priority)}',

                  style: AppTypography.h9.copyWith(
                    color: AppColors.orange1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // --------------------------------------------------
          // Quantity
          // --------------------------------------------------

          Text(
            'مقدار: '
            '${order.quantity ?? 'مشخص نشده'}',

            style: AppTypography.h8.copyWith(
              color: AppColors.gray1,
            ),
          ),

          const SizedBox(height: 4),

          // --------------------------------------------------
          // Status
          // --------------------------------------------------

          Text(
            'وضعیت: '
            '${_statusText(order.status)}',

            style: AppTypography.h8.copyWith(
              color: AppColors.gray1,
            ),
          ),

          const SizedBox(height: 16),

          // --------------------------------------------------
          // Pending
          // --------------------------------------------------

          if (order.status == Status.pending)
            FilledButton(
              onPressed: onReserve,
              child: const Text(
                'بسپرش به من',
              ),
            ),

          // --------------------------------------------------
          // Reserved
          // --------------------------------------------------

          if (order.status == Status.reserved)
            OutlinedButton(
              onPressed: onComplete,
              child: const Text(
                'گرفتم',
              ),
            ),

          const SizedBox(height: 12),

          // --------------------------------------------------
          // Created Time
          // --------------------------------------------------

          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,

            children: [
              const Icon(
                Icons.check,
                size: 14,
                color: AppColors.gray2,
              ),

              const SizedBox(width: 4),

              Text(
                _formatTime(
                  order.createdAt,
                ),

                style:
                    AppTypography.h10.copyWith(
                  color: AppColors.gray2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Format Time
  // --------------------------------------------------

  String _formatTime(
    DateTime dateTime,
  ) {
    final hour =
        dateTime.hour.toString().padLeft(2, '0');

    final minute =
        dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
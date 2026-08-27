import 'package:flutter/material.dart';
import 'package:begir/models/order.dart';
import 'package:begir/style/color.dart';
import 'package:begir/style/typography.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  final VoidCallback? onReserve;
  final VoidCallback? onComplete;

  const OrderCard({
    super.key,
    required this.order,
    this.onReserve,
    this.onComplete,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String _priorityText(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'کم';
      case Priority.medium:
        return 'عادی';
      case Priority.high:
        return 'زیاد';
    }
  }

  String _statusText(Status status) {
    switch (status) {
      case Status.pending:
        return 'در انتظار خرید';
      case Status.reserved:
        return 'در حال خرید';
      case Status.complete:
        return 'خریداری شده';
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gray4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  order.getTitle(),
                  style: AppTypography.h5.copyWith(
                    color: AppColors.gray1,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray4,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'اولویت: ${_priorityText(order.getItemPriority())}',
                  style: AppTypography.h9.copyWith(
                    color: AppColors.orange1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'مقدار: ${order.getQuantity()}',
            style: AppTypography.h8.copyWith(
              color: AppColors.gray1,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'وضعیت: ${_statusText(order.getItemStatus())}',
            style: AppTypography.h8.copyWith(
              color: AppColors.gray1,
            ),
          ),

          const SizedBox(height: 16),

          if (order.getItemStatus() == Status.pending)
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: widget.onReserve,
                    child: const Text('بسپرش به من'),
                  ),
                ),
              ],
            ),

          if (order.getItemStatus() == Status.reserved)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onComplete,
                    child: const Text('گرفتم'),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.check,
                size: 14,
                color: AppColors.gray2,
              ),

              const SizedBox(width: 4),

              Text(
                _formatTime(order.getCreatedAt()),
                style: AppTypography.h10.copyWith(
                  color: AppColors.gray2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
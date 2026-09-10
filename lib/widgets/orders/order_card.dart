import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/order.dart';
import 'package:mage_nagoftam/style/color.dart';
import 'package:mage_nagoftam/style/typography.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  final int? currentUserId;

  final VoidCallback? onReserve;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final VoidCallback? onCancelReserve;

  const OrderCard({
    super.key,
    required this.order,
    this.currentUserId,
    this.onReserve,
    this.onComplete,
    this.onDelete,
    this.onCancelReserve,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool get _isCurrentUserAssigned {
    return widget.currentUserId != null &&
        widget.order.assignment != null &&
        widget.currentUserId == widget.order.assignment!.userId;
  }

  bool get _isCurrentUserCreator {
    return widget.currentUserId != null &&
        widget.currentUserId == widget.order.createdBy;
  }

  bool get _hasAssignedUser {
    return widget.order.assignment != null;
  }

  String _priorityText(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'کم';

      case Priority.medium:
        return 'عادی';

      case Priority.high:
        return 'فوری';
    }
  }

  Color _priorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return AppColors.green2;

      case Priority.medium:
        return AppColors.orange1;

      case Priority.high:
        return AppColors.red1;
    }
  }

  String _assignedText() {
    final assignment = widget.order.assignment;

    if (assignment == null) {
      return 'هنوز کسی مسئولیت سفارش را به عهده نگرفته است.';
    }

    if (_isCurrentUserAssigned) {
      return 'شما مسئولیت سفارش را به عهده گرفته‌اید.';
    }

    return 'کاربر ${assignment.userId} مسئولیت سفارش را به عهده گرفته است.';
  }

  Future<void> _confirmDelete() async {
    if (widget.onDelete == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف سفارش'),
          content: const Text('آیا از حذف این سفارش مطمئن هستید؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      widget.onDelete!();
    }
  }

  Widget _buildPriority() {
    final color = _priorityColor(widget.order.priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        _priorityText(widget.order.priority),
        style: AppTypography.h9.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final order = widget.order;

    // سفارش هنوز مسئول ندارد
    if (order.status == Status.pending && !_hasAssignedUser) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onReserve,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('قبول مسئولیت'),
            ),
          ),
        ],
      );
    }

    // سفارش در اختیار کاربر فعلی است
    if (order.status == Status.reserved && _isCurrentUserAssigned) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onCancelReserve,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('لغو مسئولیت'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              onPressed: widget.onComplete,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('تکمیل سفارش'),
            ),
          ),
        ],
      );
    }

    // شخص دیگری مسئول سفارش است
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final bool isCompleted = order.status == Status.completed;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: AppColors.white2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gray4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // عنوان سفارش + حذف
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.title,
                      textAlign: TextAlign.right,
                      style: AppTypography.h5.copyWith(
                        color: AppColors.gray1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isCurrentUserCreator)
                    IconButton(
                      onPressed: _confirmDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: const Icon(Icons.delete_outline, size: 22),
                      color: AppColors.red1,
                      tooltip: 'حذف سفارش',
                    ),
                ],
              ),

              const SizedBox(height: 6),

              // مقدار + اولویت
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'مقدار: ${order.quantity ?? 'مشخص نشده'}',
                      textAlign: TextAlign.right,
                      style: AppTypography.h8.copyWith(color: AppColors.gray1),
                    ),
                  ),
                  _buildPriority(),
                ],
              ),

              const SizedBox(height: 6),

              // زمان ایجاد
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ساعت ${_formatTime(order.createdAt)}',
                  style: AppTypography.h10.copyWith(color: AppColors.gray2),
                ),
              ),

              const SizedBox(height: 8),

              Divider(height: 1, color: AppColors.gray4),

              const SizedBox(height: 8),

              // وضعیت مسئولیت
              Text(
                _assignedText(),
                textAlign: TextAlign.right,
                style: AppTypography.h8.copyWith(color: AppColors.gray1),
              ),

              // دکمه‌های عملیات
              if (!isCompleted) ...[
                const SizedBox(height: 10),
                _buildActionButtons(),
              ],
            ],
          ),
        ),

        // Overlay سفارش تکمیل‌شده
        if (isCompleted)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.gray1.withValues(alpha: 0.72),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_circle,
                    size: 64,
                    color: AppColors.green3,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

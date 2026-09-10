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
        widget.currentUserId ==
            widget.order.assignment!.userId;
  }

  bool get _isCurrentUserCreator {
    return widget.currentUserId != null &&
        widget.currentUserId ==
            widget.order.createdBy;
  }

  bool get _hasAssignedUser {
    return widget.order.assignment != null;
  }

  bool get _isCompleted {
    return widget.order.status == Status.completed;
  }

  bool get _isAssignedToOtherUser {
    return _hasAssignedUser &&
        !_isCurrentUserAssigned;
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
          content: const Text(
            'آیا از حذف این سفارش مطمئن هستید؟',
          ),
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
    final color = _priorityColor(
      widget.order.priority,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
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

    // ----------------------------------------------
    // سفارش بدون مسئول
    // ----------------------------------------------

    if (order.status == Status.pending &&
        !_hasAssignedUser) {
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
              child: const Text(
                'بسپارش به من',
              ),
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
              child: const Text(
                'انجام شد',
              ),
            ),
          ),
        ],
      );
    }

    // ----------------------------------------------
    // سفارش در اختیار کاربر فعلی
    // ----------------------------------------------

    if (order.status == Status.reserved &&
        _isCurrentUserAssigned) {
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
              child: const Text(
                'لغو مسئولیت',
              ),
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
              child: const Text(
                'انجام شد',
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCardContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gray4,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          // عنوان سفارش + حذف
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.order.title,
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
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 22,
                  ),
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
                  'مقدار: ${widget.order.quantity ?? 'مشخص نشده'}',
                  textAlign: TextAlign.right,
                  style: AppTypography.h8.copyWith(
                    color: AppColors.gray1,
                  ),
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
              'ساعت ${_formatTime(widget.order.createdAt)}',
              style: AppTypography.h10.copyWith(
                color: AppColors.gray2,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Divider(
            height: 1,
            color: AppColors.gray4,
          ),

          const SizedBox(height: 8),

          // وضعیت مسئولیت
          Text(
            _assignedText(),
            textAlign: TextAlign.right,
            style: AppTypography.h8.copyWith(
              color: AppColors.gray1,
            ),
          ),

          // دکمه‌ها
          if (!_isCompleted &&
              !_isAssignedToOtherUser) ...[
            const SizedBox(height: 10),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildDisabledOverlay({
    required IconData icon,
    required Color iconColor,
  }) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: AppColors.gray1.withValues(
            alpha: 0.72,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 64,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled =
        _isCompleted || _isAssignedToOtherUser;

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isDisabled,
          child: _buildCardContent(),
        ),

        // ------------------------------------------
        // سفارش تکمیل‌شده
        // ------------------------------------------

        if (_isCompleted)
          _buildDisabledOverlay(
            icon: Icons.check_circle,
            iconColor: AppColors.green3,
          ),

        // ------------------------------------------
        // سفارش در اختیار کاربر دیگر
        // ------------------------------------------

        if (_isAssignedToOtherUser &&
            !_isCompleted)
          _buildDisabledOverlay(
            icon: Icons.person_outline,
            iconColor: AppColors.gray4,
          ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour
        .toString()
        .padLeft(2, '0');

    final minute = dateTime.minute
        .toString()
        .padLeft(2, '0');

    return '$hour:$minute';
  }
}
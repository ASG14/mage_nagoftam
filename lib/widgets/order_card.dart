import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/order.dart';
import 'package:mage_nagoftam/style/color.dart';
import 'package:mage_nagoftam/style/typography.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  final int? currentUserId;

  final VoidCallback? onReserve;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const OrderCard({
    super.key,
    required this.order,
    this.currentUserId,
    this.onReserve,
    this.onComplete,
    this.onDelete,
  });

  String _priorityText(
    Priority priority,
  ) {
    switch (priority) {
      case Priority.low:
        return 'کم';

      case Priority.medium:
        return 'متوسط';

      case Priority.high:
        return 'فوری';
    }
  }

  Color _priorityColor(
    Priority priority,
  ) {
    switch (priority) {
      case Priority.low:
        return Colors.green;

      case Priority.medium:
        return Colors.orange;

      case Priority.high:
        return Colors.red;
    }
  }

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

  bool get _isCurrentUserAssigned {
    return currentUserId != null &&
        order.assignedUserId != null &&
        currentUserId == order.assignedUserId;
  }

  bool get _isCurrentUserCreator {
    return currentUserId != null &&
        currentUserId == order.createdBy;
  }

  String _assignedUserText() {
    if (order.assignedUserName != null &&
        order.assignedUserName!.trim().isNotEmpty) {
      return order.assignedUserName!;
    }

    if (order.assignedUserId != null) {
      return 'کاربر ${order.assignedUserId}';
    }

    return 'هنوز کسی مسئول نشده';
  }

  Future<void> _confirmDelete(
    BuildContext context,
  ) async {
    if (onDelete == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'حذف سفارش',
          ),
          content: const Text(
            'آیا از حذف این سفارش مطمئن هستید؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(
                'انصراف',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text(
                'حذف',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      onDelete!();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final isCompleted =
        order.status == Status.completed;

    return Stack(
      children: [
        Container(
          padding:
              const EdgeInsets.all(16),
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
              // Title + Priority + Delete
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.title,
                      style:
                          AppTypography.h5.copyWith(
                        color:
                            AppColors.gray1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration:
                        BoxDecoration(
                      color: _priorityColor(
                        order.priority,
                      ).withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                    child: Text(
                      _priorityText(
                        order.priority,
                      ),
                      style:
                          AppTypography.h9.copyWith(
                        color:
                            _priorityColor(
                          order.priority,
                        ),
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isCurrentUserCreator &&
                      !isCompleted) ...[
                    const SizedBox(
                      width: 4,
                    ),
                    IconButton(
                      onPressed: () =>
                          _confirmDelete(context),
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      tooltip: 'حذف سفارش',
                      color: AppColors.red1,
                    ),
                  ],
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              // Quantity
              Text(
                'مقدار: '
                '${order.quantity ?? 'مشخص نشده'}',
                style:
                    AppTypography.h8.copyWith(
                  color: AppColors.gray1,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              // Status
              Text(
                'وضعیت: '
                '${_statusText(order.status)}',
                style:
                    AppTypography.h8.copyWith(
                  color: AppColors.gray1,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              // Assigned User
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: AppColors.gray2,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      'مسئول خرید: '
                      '${_assignedUserText()}',
                      style:
                          AppTypography.h8.copyWith(
                        color:
                            AppColors.gray1,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              // Pending
              if (order.status ==
                  Status.pending)
                FilledButton(
                  onPressed: onReserve,
                  child: const Text(
                    'بسپرش به من',
                  ),
                ),

              // Reserved + Current User
              if (order.status ==
                      Status.reserved &&
                  _isCurrentUserAssigned)
                OutlinedButton(
                  onPressed: onComplete,
                  child: const Text(
                    'گرفتم',
                  ),
                ),

              const SizedBox(
                height: 12,
              ),

              // Created Time
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.gray2,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    _formatTime(
                      order.createdAt,
                    ),
                    style:
                        AppTypography.h10.copyWith(
                      color:
                          AppColors.gray2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Completed Overlay
        if (isCompleted)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.55,
                  ),
                  alignment:
                      Alignment.center,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.black.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'خریداری شده',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatTime(
    DateTime dateTime,
  ) {
    final hour = dateTime.hour
        .toString()
        .padLeft(2, '0');

    final minute = dateTime.minute
        .toString()
        .padLeft(2, '0');

    return '$hour:$minute';
  }
}
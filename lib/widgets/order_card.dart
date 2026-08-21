import 'package:flutter/material.dart';
import 'package:begir/style/color.dart';
import 'package:begir/style/typography.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
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
          // عنوان و فوریت
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'عنوان سفارش',
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
                  'عادی',
                  style: AppTypography.h9.copyWith(
                    color: AppColors.gray2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'فوریت: عادی',
            style: AppTypography.h8.copyWith(
              color: AppColors.gray2,
            ),
          ),

          const SizedBox(height: 16),

          // دکمه‌های سفارش
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // TODO: من می‌گیرم
                  },
                  child: const Text('من می‌گیرم'),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: من گرفتم
                  },
                  child: const Text('من گرفتم'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // زمان ثبت سفارش
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.gray2,
              ),

              const SizedBox(width: 4),

              Text(
                '22:30',
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
}
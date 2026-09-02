import 'package:flutter/material.dart';

import 'package:begir/models/order.dart';
import 'package:begir/widgets/order_card.dart';

class OrdersList extends StatelessWidget {
  final List<Order> orders;

  final int? currentUserId;

  final void Function(Order order)? onReserve;
  final void Function(Order order)? onComplete;

  const OrdersList({
    super.key,
    required this.orders,
    this.currentUserId,
    this.onReserve,
    this.onComplete,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'هنوز سفارشی ثبت نشده است',
        ),
      );
    }

    return ListView.separated(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding:
          const EdgeInsets.only(bottom: 80),
      itemCount: orders.length,
      separatorBuilder:
          (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder:
          (context, index) {
        final order = orders[index];

        return OrderCard(
          order: order,
          currentUserId:
              currentUserId,
          onReserve: () {
            onReserve?.call(order);
          },
          onComplete: () {
            onComplete?.call(order);
          },
        );
      },
    );
  }
}


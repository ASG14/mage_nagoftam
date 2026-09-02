import 'package:flutter/material.dart';

import 'package:begir/models/order.dart';
import 'package:begir/widgets/order_card.dart';

class OrdersList extends StatelessWidget {
  final List<Order> orders;

  final void Function(Order order)? onReserve;
  final void Function(Order order)? onComplete;

  const OrdersList({
    super.key,
    required this.orders,
    this.onReserve,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
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
      itemCount: orders.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final order = orders[index];

        return OrderCard(
          order: order,
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
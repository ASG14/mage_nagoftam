import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/order.dart';
import 'package:mage_nagoftam/widgets/orders/order_card.dart';

class OrdersList extends StatelessWidget {
  final List<Order> orders;

  final int? currentUserId;

  final void Function(Order order)? onReserve;

  final void Function(Order order)? onComplete;

  final void Function(Order order)? onDelete;

  final void Function(Order order)? onCancelReserve;

  const OrdersList({
    super.key,
    required this.orders,
    this.currentUserId,
    this.onReserve,
    this.onComplete,
    this.onDelete,
    this.onCancelReserve,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        children: const [
          SizedBox(height: 250),

          Center(child: Text('هنوز سفارشی ثبت نشده است.')),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),

      itemCount: orders.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },

      itemBuilder: (context, index) {
        final order = orders[index];

        return OrderCard(
          order: order,

          currentUserId: currentUserId,

          onReserve: onReserve == null
              ? null
              : () {
                  onReserve!(order);
                },

          onComplete: onComplete == null
              ? null
              : () {
                  onComplete!(order);
                },

          onDelete: onDelete == null
              ? null
              : () {
                  onDelete!(order);
                },

          onCancelReserve: onCancelReserve == null
              ? null
              : () {
                  onCancelReserve!(order);
                },
        );
      },
    );
  }
}

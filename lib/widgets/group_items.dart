import 'package:flutter/material.dart';
import 'package:begir/models/order.dart';
import 'package:begir/widgets/order_card.dart';

class GroupItems extends StatefulWidget {
  final List<Order> orders;

  final void Function(Order order)? onReserve;
  final void Function(Order order)? onComplete;

  const GroupItems({
    super.key,
    required this.orders,
    this.onReserve,
    this.onComplete,
  });

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return const Center(
        child: Text('هنوز سفارشی ثبت نشده است'),
      );
    }

    return ListView.separated(
      itemCount: widget.orders.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = widget.orders[index];

        return OrderCard(
          order: order,
          onReserve: () {
            widget.onReserve?.call(order);
          },
          onComplete: () {
            widget.onComplete?.call(order);
          },
        );
      },
    );
  }
}
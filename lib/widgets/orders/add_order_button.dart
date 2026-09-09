import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/order.dart';
import 'package:mage_nagoftam/widgets/add_order.dart';

class AddOrderButton
    extends StatelessWidget {
  final int groupId;

  final void Function(Order order)
      onOrderCreated;

  const AddOrderButton({
    super.key,
    required this.groupId,
    required this.onOrderCreated,
  });

  Future<void> _openDialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,

      builder: (context) {
        return AddOrder(
          groupId: groupId,

          onOrderCreated:
              onOrderCreated,
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return FloatingActionButton.extended(
      onPressed: () {
        _openDialog(context);
      },

      icon: const Icon(
        Icons.add,
      ),

      label: const Text(
        'افزودن سفارش',
      ),
    );
  }
}
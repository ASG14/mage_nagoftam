import 'package:flutter/material.dart';

class AddOrderButton extends StatelessWidget {
  const AddOrderButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // بعداً AddOrder Dialog
      },
      icon: const Icon(Icons.add),
      label: const Text('افزودن سفارش'),
    );
  }
}
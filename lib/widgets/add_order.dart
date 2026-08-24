import 'package:flutter/material.dart';
import 'package:begir/models/order.dart';
import 'package:begir/models/user.dart';
import 'package:begir/style/color.dart';

class AddOrder extends StatefulWidget {
  final User user;
  final Function(Order order) onOrderCreated;

  const AddOrder({
    super.key,
    required this.user,
    required this.onOrderCreated,
  });

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _quantityController =
      TextEditingController();

  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();

    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final quantity = _quantityController.text.trim();

    if (title.isEmpty || quantity.isEmpty) {
      return;
    }

    final now = DateTime.now();

    final order = Order(
      itemId: DateTime.now().microsecondsSinceEpoch.toString(),
      createdBy: widget.user,
      title: title,
      quantity: quantity,
      createdAt: now,
      deadline: now.add(const Duration(days: 1)),
      itemPriority: _priority,
    );

    widget.onOrderCreated(order);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('افزودن سفارش جدید'),

      content: SizedBox(
        width: 300,

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان سفارش',
                  hintText: 'مثلاً شیر کم‌چرب',
                  prefixIcon: Icon(Icons.shopping_cart),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'تعداد / مقدار',
                  hintText: 'مثلاً ۲ بطری',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'اولویت',
                ),
                items: const [
                  DropdownMenuItem(
                    value: Priority.low,
                    child: Text('کم'),
                  ),
                  DropdownMenuItem(
                    value: Priority.medium,
                    child: Text('عادی'),
                  ),
                  DropdownMenuItem(
                    value: Priority.high,
                    child: Text('زیاد'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.red1,
          ),
          child: const Text('انصراف'),
        ),

        FilledButton(
          onPressed: _submit,
          child: const Text('ثبت سفارش'),
        ),
      ],
    );
  }
}
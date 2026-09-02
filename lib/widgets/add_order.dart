import 'package:flutter/material.dart';

import 'package:begir/models/order.dart';
import 'package:begir/services/order_service.dart';
import 'package:begir/style/color.dart';
import 'package:begir/style/typography.dart';

class AddOrder extends StatefulWidget {
  final int groupId;
  final void Function(Order order) onOrderCreated;

  const AddOrder({
    super.key,
    required this.groupId,
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

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final quantity = _quantityController.text.trim();

    if (title.isEmpty) {
      _showMessage('نام سفارش را وارد کنید');
      return;
    }

    if (quantity.isEmpty) {
      _showMessage('مقدار سفارش را وارد کنید');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final order = await OrderService.createOrder(
        groupId: widget.groupId,
        title: title,
        quantity: quantity,
        priority: _priority,
      );

      if (!mounted) return;

      widget.onOrderCreated(order);

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'ثبت سفارش انجام نشد',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'افزودن سفارش',
        style: AppTypography.h5.copyWith(
          color: AppColors.gray1,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              enabled: !_isLoading,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'نام کالا',
                hintText: 'مثلاً شیر',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _quantityController,
              enabled: !_isLoading,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'مقدار',
                hintText: 'مثلاً ۲ عدد',
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
              onChanged: _isLoading
                  ? null
                  : (value) {
                      if (value == null) return;

                      setState(() {
                        _priority = value;
                      });
                    },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),

        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('ثبت سفارش'),
        ),
      ],
    );
  }
}
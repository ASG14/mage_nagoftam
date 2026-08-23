import 'package:begir/objects/order_item.dart';
import 'package:begir/objects/user.dart';
import 'package:begir/objects/group.dart';
import 'package:begir/style/color.dart';
import 'package:flutter/material.dart';


class AddOrder extends StatefulWidget {
  const AddOrder({super.key});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  // کنترلرها برای مدیریت مقادیر ورودی فیلدها
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان سفارش',
                  hintText: 'مثلا: نان سنگک',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'تعداد / مقدار',
                  hintText: 'مثلا: 2 عدد',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'توضیحات',
                  hintText: 'مثلا: اگر نبود بربری بگیر',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // بستن دیالوگ
          }, 
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.white1,
            foregroundColor: AppColors.red1,
            side: const BorderSide(color: AppColors.red1, width: 1),
            
          ),
          child: const Text('انصراف',style: TextStyle(color: AppColors.red1,)),
        ),
        const SizedBox(height: 8), 
        TextButton(
          onPressed: () {
            final title = _titleController.text;
            final quantity = _quantityController.text;
            var testtime = DateTime(2004,02,29);
            User testuser = User(id: 'عنوان کاربر', phoneNumber: 2, registeredAt: testtime);
            Group testgroup = Group(id: '11', creator: testuser, createdAt: testtime, groupTitle: 'عنوان گروه تست');
            OrderItem testitem = OrderItem(itemId: 'آیدی تست', createdBy: testuser, title: title, quantity: quantity, createdAt: testtime, deadline: testtime);
            testgroup.addOrderItem(testitem);
            Navigator.pop(context); 
          },
          child: const Text('تایید و ثبت'),
        ),
      ],
    );
  }
}

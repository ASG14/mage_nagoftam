import 'package:flutter/material.dart';

class AddOrder extends StatelessWidget {
  const AddOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          Text('برای افزودن سفارش جدید مقادیر زیر را پر کنید.'),
          TextFormField(),
          TextFormField(),
          TextFormField(),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                FilledButton(onPressed: (){}, child: Text('انصراف'),),
                FilledButton(onPressed: (){}, child: Text('تایید'),),
              ],
          ),
        ],
        
      ),
    );
  }
}
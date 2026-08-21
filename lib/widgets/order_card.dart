import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('عنوان سفارش'),
          Text('فوریت: عادی'),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: TextButton(onPressed: (){}, child: Text('من میگیرم'),),),
              SizedBox(width: 5,),
              Expanded(child: TextButton(onPressed: (){}, child: Text('من گرفتم'),)),
            ],
          ),
          Text('22:30', textAlign: TextAlign.end,),

        ],
      )
      
    );
  }
}
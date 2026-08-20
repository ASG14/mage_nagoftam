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
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8),),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
              Expanded(child: TextButton(onPressed: (){},style:ButtonStyle(backgroundColor:WidgetStateProperty.all<Color>(const Color.fromARGB(255, 98, 130, 199)) ), child: Text('من میگیرم'),)),
              SizedBox(width: 5,),
              Expanded(child: TextButton(onPressed: (){},style:ButtonStyle(backgroundColor:WidgetStateProperty.all<Color>(const Color.fromARGB(255, 58, 168, 124)) ), child: Text('من گرفتم'),)),
            ],
          ),
          Text('22:30', textAlign: TextAlign.end,),

        ],
      )
      
    );
  }
}
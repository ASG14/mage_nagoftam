import 'package:begir/models/order.dart';
import 'package:begir/tempDB/manager.dart';
import 'package:flutter/material.dart';
import 'package:begir/widgets/order_card.dart';

class GroupItems extends StatefulWidget {
  const GroupItems({super.key});
  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  List<Order> Orders =   [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = Orders.length - 1; i >= 0; i--) OrderCard(),
        ],
      ),
    );
  }
}

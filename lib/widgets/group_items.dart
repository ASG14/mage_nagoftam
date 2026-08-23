import 'package:flutter/material.dart';
import 'package:begir/widgets/order_card.dart';

class GroupItems extends StatefulWidget {
  const GroupItems({super.key});

  @override
  State<GroupItems> createState() => _GroupItemsState();
}

class _GroupItemsState extends State<GroupItems> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [OrderCard(), OrderCard(), OrderCard()]));
  }
}

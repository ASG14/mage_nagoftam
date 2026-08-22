// نوار بالای صفحه خانه برای تعویض گروه درحال نمایش

import 'package:flutter/material.dart';

class GroupsBar extends StatefulWidget {
  const GroupsBar({super.key});

  @override
  State<GroupsBar> createState() => _GroupsBarState();
}

class _GroupsBarState extends State<GroupsBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_left)),
          ),
          Expanded(
            flex: 8,
            child: Text('عنوان گروه فعلی', textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
          ),
        ],
      ),
    );
  }
}

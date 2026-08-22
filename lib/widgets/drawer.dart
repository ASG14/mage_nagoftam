import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Text('هدر کشو')),
          ListTile(
            title: Text('تنظیمات'),
            onTap: () {
              // عمل مورد نظر برای گزینه 1
              Navigator.pop(context); // بستن کشو
            },
          ),
          ListTile(
            title: Text('آموزش و سوالات متداول'),
            onTap: () {
              // عمل مورد نظر برای گزینه 2
              Navigator.pop(context); // بستن کشو
            },
          ),
          ListTile(
            title: Text('قوانین و شرایط استفاده'),
            onTap: () {
              // عمل مورد نظر برای گزینه 3
              Navigator.pop(context); // بستن کشو
            },
          ),
        ],
      ),
    );
  }
}

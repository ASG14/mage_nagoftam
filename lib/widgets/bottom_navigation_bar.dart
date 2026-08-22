import 'package:flutter/material.dart';

import '../core/app_routes.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({
    super.key,
  });

  @override
  State<MyBottomNavigationBar> createState() =>
      _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState
    extends State<MyBottomNavigationBar> {

  int _getCurrentIndex() {
    final routeName = ModalRoute.of(context)?.settings.name;

    switch (routeName) {
      case AppRoutes.home:
        return 0;

      case AppRoutes.groups:
        return 1;

      case AppRoutes.notifications:
        return 2;

      default:
        return 0;
    }
  }

  void _onItemSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.groups,
        );
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.notifications,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(),

      onTap: _onItemSelected,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'خانه',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: 'گروه‌ها',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'اعلان‌ها',
        ),
      ],
    );
  }
}
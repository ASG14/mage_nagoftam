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
    final routeName =
        ModalRoute.of(context)?.settings.name;

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
    String route;

    switch (index) {
      case 0:
        route = AppRoutes.home;
        break;

      case 1:
        route = AppRoutes.groups;
        break;

      case 2:
        route = AppRoutes.notifications;
        break;

      default:
        return;
    }

    if (ModalRoute.of(context)?.settings.name == route) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      route,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      
      selectedIndex: _getCurrentIndex(),

      onDestinationSelected: _onItemSelected,

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'خانه',
        ),

        NavigationDestination(
          icon: Icon(Icons.groups_outlined),
          selectedIcon: Icon(Icons.groups),
          label: 'گروه‌ها',
        ),

        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications),
          label: 'اعلان‌ها',
        ),
      ],
    );
  }
}
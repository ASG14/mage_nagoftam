import 'package:flutter/material.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/services/notification_service.dart';

class MyBottomNavigationBar
    extends StatefulWidget {
  const MyBottomNavigationBar({
    super.key,
  });

  @override
  State<MyBottomNavigationBar> createState() =>
      _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState
    extends State<MyBottomNavigationBar> {
  int _unreadCount = 0;

  bool _isLoadingUnreadCount = true;

  @override
  void initState() {
    super.initState();

    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    final routeName =
        ModalRoute.of(context)?.settings.name;

    if (routeName ==
        AppRoutes.notifications) {
      if (mounted) {
        setState(() {
          _unreadCount = 0;
          _isLoadingUnreadCount = false;
        });
      }

      return;
    }

    try {
      final result =
          await NotificationService.getNotifications();

      if (!mounted) {
        return;
      }

      setState(() {
        _unreadCount = result.unreadCount;
        _isLoadingUnreadCount = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _unreadCount = 0;
        _isLoadingUnreadCount = false;
      });
    }
  }

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

    if (ModalRoute.of(context)?.settings.name ==
        route) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      route,
    );
  }

  Widget _notificationIcon({
    required bool selected,
  }) {
    final icon = Icon(
      selected
          ? Icons.notifications
          : Icons.notifications_outlined,
    );

    if (_isLoadingUnreadCount ||
        _unreadCount <= 0) {
      return icon;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,

        Positioned(
          right: -10,
          top: -8,
          child: Container(
            constraints:
                const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .error,
              shape: BoxShape.rectangle,
              borderRadius:
                  BorderRadius.circular(9),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .surface,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _unreadCount > 99
                  ? '99+'
                  : _unreadCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _getCurrentIndex(),

      onDestinationSelected:
          _onItemSelected,

      destinations: [
        const NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home,
          ),
          label: 'خانه',
        ),

        const NavigationDestination(
          icon: Icon(
            Icons.groups_outlined,
          ),
          selectedIcon: Icon(
            Icons.groups,
          ),
          label: 'گروه‌ها',
        ),

        NavigationDestination(
          icon: _notificationIcon(
            selected: false,
          ),
          selectedIcon: _notificationIcon(
            selected: true,
          ),
          label: 'اعلان‌ها',
        ),
      ],
    );
  }
}
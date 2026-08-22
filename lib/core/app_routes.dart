// lib/core/routes/app_routes.dart

import 'package:flutter/material.dart';
import 'package:begir/screens/home.dart';
import 'package:begir/screens/notifications.dart';
import 'package:begir/screens/groups.dart';
import 'package:begir/screens/settings.dart';

class AppRoutes {
  static const String home = '/';
  static const String groups = '/groups';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case AppRoutes.groups:
        return MaterialPageRoute(builder: (_) => const GroupsScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('صفحه پیدا نشد'))),
        );
    }
  }
}

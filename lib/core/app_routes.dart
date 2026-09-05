import 'package:flutter/material.dart';

import 'package:mage_nagoftam/screens/notifications.dart';
import 'package:mage_nagoftam/screens/home.dart';
import 'package:mage_nagoftam/screens/groups.dart';
import 'package:mage_nagoftam/screens/settings.dart';
import 'package:mage_nagoftam/screens/login.dart';
import 'package:mage_nagoftam/screens/splash.dart';
import 'package:mage_nagoftam/screens/register.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String splash = '/splash';
  static const String groups = '/groups';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String register = '/register';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case AppRoutes.notifications:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NotificationsScreen(),
        );

      case AppRoutes.groups:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const GroupsScreen(),
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Login(),
        );

      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Register(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: Center(child: Text('صفحه پیدا نشد'))),
        );
    }
  }
}

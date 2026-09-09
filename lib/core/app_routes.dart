import 'package:flutter/material.dart';

import 'package:mage_nagoftam/screens/notifications.dart';
import 'package:mage_nagoftam/screens/account.dart';
import 'package:mage_nagoftam/screens/groups.dart';
import 'package:mage_nagoftam/screens/settings.dart';
import 'package:mage_nagoftam/screens/login.dart';
import 'package:mage_nagoftam/screens/splash.dart';
import 'package:mage_nagoftam/screens/register.dart';
import 'package:mage_nagoftam/screens/join_group.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String splash = '/splash';
  static const String groups = '/groups';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String register = '/register';
  static const String join = '/join';

  static String joinGroup(
    String token,
  ) {
    return '$join/$token';
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    final routeName = settings.name ?? '';

    if (routeName.startsWith('${AppRoutes.join}/')) {
      final token = routeName
          .substring('${AppRoutes.join}/'.length)
          .trim();

      if (token.isNotEmpty) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => JoinGroupScreen(
            token: token,
          ),
        );
      }
    }

    switch (routeName) {
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AccountScreen(),
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
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'صفحه پیدا نشد',
              ),
            ),
          ),
        );
    }
  }
}
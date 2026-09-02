// lib/core/routes/app_routes.dart

import 'package:flutter/material.dart';
import 'package:begir/screens/home.dart';
import 'package:begir/screens/notifications.dart';
import 'package:begir/screens/groups.dart';
import 'package:begir/screens/settings.dart';
import 'package:begir/screens/login.dart';
import 'package:begir/screens/splash.dart';
import 'package:begir/screens/register.dart';


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
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case AppRoutes.groups:
        return MaterialPageRoute(builder: (_) => const GroupsScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const Login());

      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const Register());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('صفحه پیدا نشد'))),
        );
    }
  }
}

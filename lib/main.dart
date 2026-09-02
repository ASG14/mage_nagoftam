import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:begir/core/app_routes.dart';
import 'package:begir/screens/groups.dart';
import 'package:begir/screens/home.dart';
import 'package:begir/screens/login.dart';
import 'package:begir/screens/notifications.dart';
import 'package:begir/screens/register.dart';
import 'package:begir/screens/settings.dart';
import 'package:begir/screens/splash.dart';

import 'package:begir/style/theme.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      locale: const Locale(
        'fa',
        'IR',
      ),

      theme: AppTheme.lightTheme,

      title: 'بگیر',

      supportedLocales: const [
        Locale(
          'fa',
          'IR',
        ),
        Locale(
          'en',
          'US',
        ),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute:
          AppRoutes.splash,

      routes: {
        AppRoutes.splash:
            (context) =>
                const SplashScreen(),

        AppRoutes.login:
            (context) =>
                const Login(),

        AppRoutes.register:
            (context) =>
                const Register(),

        AppRoutes.home:
            (context) =>
                const HomeScreen(),

        AppRoutes.groups:
            (context) =>
                const GroupsScreen(),

        AppRoutes.notifications:
            (context) =>
                const NotificationsScreen(),

        AppRoutes.settings:
            (context) =>
                const SettingsScreen(),
      },

      debugShowCheckedModeBanner:
          false,
    );
  }
}
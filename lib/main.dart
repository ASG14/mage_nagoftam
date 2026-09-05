import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/screens/groups.dart';
import 'package:mage_nagoftam/screens/home.dart';
import 'package:mage_nagoftam/screens/login.dart';
import 'package:mage_nagoftam/screens/notifications.dart';
import 'package:mage_nagoftam/screens/register.dart';
import 'package:mage_nagoftam/screens/settings.dart';
import 'package:mage_nagoftam/screens/splash.dart';

import 'package:mage_nagoftam/style/theme.dart';

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
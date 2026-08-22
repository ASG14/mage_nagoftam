import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:begir/style/theme.dart';
import 'package:begir/core/app_routes.dart';
import 'package:begir/screens/groups.dart';
import 'package:begir/screens/home.dart';
import 'package:begir/screens/notifications.dart';
import 'package:begir/screens/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('fa', 'IR'),
      theme: AppTheme.lightTheme,
      title: 'بگیر',

      supportedLocales: [
        Locale('fa', 'IR'), // فارسی
        Locale('en', 'US'), // انگلیسی
      ],

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.groups: (context) => const GroupsScreen(),
        AppRoutes.notifications: (context) => const NotificationsScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },

      debugShowCheckedModeBanner: false,
    );
  }
}

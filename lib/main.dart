import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mage_nagoftam/core/app_routes.dart';

import 'package:mage_nagoftam/style/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('fa', 'IR'),

      theme: AppTheme.lightTheme,

      title: 'مگه نگفتم',

      supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      onGenerateInitialRoutes: (String initialRoute) {
        final uri = Uri.base;

        final path = uri.path;

        if (path.startsWith('/join/')) {
          final token = path.substring('/join/'.length).trim();

          if (token.isNotEmpty) {
            return [
              RouteGenerator.generateRoute(
                RouteSettings(name: AppRoutes.joinGroup(token)),
              ),
            ];
          }
        }

        return [
          RouteGenerator.generateRoute(
            const RouteSettings(name: AppRoutes.splash),
          ),
        ];
      },

      onGenerateRoute: RouteGenerator.generateRoute,

      debugShowCheckedModeBanner: false,
    );
  }
}

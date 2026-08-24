import 'package:flutter/material.dart';

import '../core/app_routes.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void _navigateTo(String route) {
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      route,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('خانه'),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home,
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.groups_outlined),
                    title: const Text('گروه‌های من'),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.groups,
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.notifications_outlined,
                    ),
                    title: const Text('اعلان‌ها'),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.notifications,
                      );
                    },
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                    ),
                    title: const Text('تنظیمات'),
                    onTap: () {
                      _navigateTo(
                        AppRoutes.settings,
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.help_outline,
                    ),
                    title: const Text(
                      'آموزش و سوالات متداول',
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      _showInfoDialog(
                        title: 'آموزش',
                        message:
                            'راهنمای استفاده از برنامه در این بخش قرار می‌گیرد.',
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.description_outlined,
                    ),
                    title: const Text(
                      'قوانین و شرایط استفاده',
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      _showInfoDialog(
                        title: 'قوانین و شرایط',
                        message:
                            'قوانین و شرایط استفاده از برنامه در این بخش قرار می‌گیرد.',
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('خروج از حساب'),
              onTap: () {
                Navigator.pop(context);

                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,

      currentAccountPicture: const CircleAvatar(
        child: Icon(
          Icons.person,
          size: 32,
        ),
      ),

      accountName: const Text(
        'علی احمدی',
      ),

      accountEmail: const Text(
        '0912 000 0000',
      ),

      onDetailsPressed: () {
        _navigateTo(
          AppRoutes.settings,
        );
      },
    );
  }

  void _showInfoDialog({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),

          content: Text(message),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('باشه'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('خروج از حساب'),

          content: const Text(
            'آیا مطمئن هستید که می‌خواهید از حساب خود خارج شوید؟',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('انصراف'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(context);

                // فعلاً فقط برای تست UI است.
              },
              child: const Text('خروج'),
            ),
          ],
        );
      },
    );
  }
}
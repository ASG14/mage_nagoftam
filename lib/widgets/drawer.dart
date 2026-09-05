import 'package:flutter/material.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/services/auth_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() =>
      _MyDrawerState();
}

class _MyDrawerState
    extends State<MyDrawer> {
  // --------------------------------------------------
  // Navigation
  // --------------------------------------------------

  void _navigateTo(
    String route,
  ) {
    Navigator.pop(context);

    Navigator.pushReplacementNamed(
      context,
      route,
    );
  }

  // --------------------------------------------------
  // Logout
  // --------------------------------------------------

  Future<void> _logout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  // --------------------------------------------------
  // Logout Confirmation
  // --------------------------------------------------

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'خروج از حساب',
          ),

          content: const Text(
            'آیا مطمئن هستید که می‌خواهید '
            'از حساب خود خارج شوید؟',
          ),

          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                      );
                    },
                    child: const Text(
                      'انصراف',
                    ),
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                      );

                      _logout();
                    },
                    child: const Text(
                      'خروج',
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------
  // Help
  // --------------------------------------------------

  void _showHelpDialog() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'آموزش استفاده',
          ),

          content: const SingleChildScrollView(
            child: Text(
              'برای استفاده از (مگه نگفتم) ابتدا یک گروه ایجاد کنید. '
              'سپس می‌توانید سفارش‌های موردنیاز را در گروه ثبت کنید.\n\n'
              'اعضای گروه می‌توانند سفارش‌های موجود را مشاهده کنند '
              'و مسئولیت خرید یک سفارش را بر عهده بگیرند.\n\n'
              'پس از انجام خرید، سفارش توسط فرد مسئول تکمیل می‌شود.',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'باشه',
              ),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------
  // Terms
  // --------------------------------------------------

  void _showTermsDialog() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'قوانین و شرایط استفاده',
          ),

          content:
              const SingleChildScrollView(
            child: Text(
              'استفاده از برنامه (مگه نگفتم) به معنای پذیرش قوانین '
              'و شرایط استفاده از برنامه است.\n\n'
              'کاربران مسئول اطلاعاتی هستند که در گروه‌ها و '
              'سفارش‌های خود ثبت می‌کنند.\n\n'
              'هر کاربر باید از حساب کاربری خود محافظت کند '
              'و اطلاعات ورود خود را در اختیار دیگران قرار ندهد.',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'باشه',
              ),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------
  // Build
  // --------------------------------------------------

  @override
  Widget build(
    BuildContext context,
  ) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const Divider(
              height: 1,
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.home_outlined,
                    ),
                    title: const Text(
                      'خانه',
                    ),
                    onTap: () {
                      _navigateTo(
                        AppRoutes.home,
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.groups_outlined,
                    ),
                    title: const Text(
                      'گروه‌های من',
                    ),
                    onTap: () {
                      _navigateTo(
                        AppRoutes.groups,
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.notifications_outlined,
                    ),
                    title: const Text(
                      'اعلان‌ها',
                    ),
                    onTap: () {
                      _navigateTo(
                        AppRoutes.notifications,
                      );
                    },
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                    ),
                    title: const Text(
                      'تنظیمات',
                    ),
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
                    onTap:
                        _showHelpDialog,
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.description_outlined,
                    ),
                    title: const Text(
                      'قوانین و شرایط استفاده',
                    ),
                    onTap:
                        _showTermsDialog,
                  ),
                ],
              ),
            ),

            const Divider(
              height: 1,
            ),

            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text(
                'خروج از حساب',
              ),
              onTap:
                  _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Header
  // --------------------------------------------------

  Widget _buildHeader() {
    return FutureBuilder<int?>(
      future: AuthService.getUserId(),
      builder: (
        context,
        snapshot,
      ) {
        final userId =
            snapshot.data;

        return UserAccountsDrawerHeader(
          margin: EdgeInsets.zero,

          currentAccountPicture:
              const CircleAvatar(
            child: Icon(
              Icons.person,
              size: 32,
            ),
          ),

          accountName: const Text(
            'حساب کاربری',
          ),

          accountEmail: Text(
            userId == null
                ? 'شناسه کاربر'
                : 'شناسه کاربر: $userId',
          ),

          onDetailsPressed: () {
            Navigator.pop(context);

            Navigator.pushReplacementNamed(
              context,
              AppRoutes.settings,
            );
          },
        );
      },
    );
  }
}
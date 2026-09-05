import 'package:flutter/material.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/widgets/drawer.dart';

class SettingsScreen
    extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  Future<int?> _getUserId() {
    return AuthService.getUserId();
  }

  Future<void> _logout(
    BuildContext context,
  ) async {
    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  void _showLogoutConfirmation(
    BuildContext context,
  ) {
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
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'انصراف',
              ),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                _logout(context);
              },
              child: const Text(
                'خروج',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تنظیمات',
          ),
        ),

        drawer: const MyDrawer(),

        body: ListView(
          padding:
              const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      child: Icon(
                        Icons.person,
                        size: 40,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    const Text(
                      'حساب کاربری',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    FutureBuilder<int?>(
                      future: _getUserId(),
                      builder:
                          (context, snapshot) {
                        if (snapshot
                                .connectionState ==
                            ConnectionState
                                .waiting) {
                          return const Center(
                            child:
                                SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            ),
                          );
                        }

                        final userId =
                            snapshot.data;

                        return Text(
                          userId == null
                              ? 'اطلاعات حساب در دسترس نیست'
                              : 'شناسه کاربر: $userId',
                          textAlign:
                              TextAlign.center,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(
                      Icons.person_outline,
                    ),
                    title:
                        const Text(
                      'حساب کاربری',
                    ),
                    subtitle:
                        const Text(
                      'اطلاعات حساب کاربری',
                    ),
                  ),

                  const Divider(
                    height: 1,
                  ),

                  ListTile(
                    leading:
                        const Icon(
                      Icons.info_outline,
                    ),
                    title:
                        const Text(
                      'درباره بگیر',
                    ),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName:
                            'بگیر',
                        applicationVersion:
                            '1.0.0',
                        applicationIcon:
                            const Icon(
                          Icons.shopping_cart,
                        ),
                        children: const [
                          Text(
                            'بگیر یک برنامه برای مدیریت '
                            'خریدهای خانوادگی و گروهی است.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            FilledButton.icon(
              onPressed: () {
                _showLogoutConfirmation(
                  context,
                );
              },
              icon: const Icon(
                Icons.logout,
              ),
              label: const Text(
                'خروج از حساب',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
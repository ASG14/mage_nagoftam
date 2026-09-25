import 'package:flutter/material.dart';

import 'package:mage_nagoftam/core/app_routes.dart';
import 'package:mage_nagoftam/models/user.dart';
import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/services/user_service.dart';
import 'package:mage_nagoftam/style/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? _user;
  bool _isLoading = true;
  bool _isUpdatingProfile = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(_errorMessage(e));
    }
  }

  Future<void> _editProfile() async {
    final user = _user;

    if (user == null || _isUpdatingProfile) {
      return;
    }

    final firstNameController = TextEditingController(
      text: user.firstName ?? '',
    );

    final lastNameController = TextEditingController(text: user.lastName ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('ویرایش اطلاعات شخصی'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'نام'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'نام خانوادگی'),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.red1,
                    ),
                    child: const Text('انصراف'),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: FilledButton(
                    onPressed: () {
                      final firstName = firstNameController.text.trim();

                      final lastName = lastNameController.text.trim();

                      if (firstName.isEmpty || lastName.isEmpty) {
                        return;
                      }

                      Navigator.pop(dialogContext, true);
                    },
                    child: const Text('ذخیره'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    firstNameController.dispose();
    lastNameController.dispose();

    if (result != true || firstName.isEmpty || lastName.isEmpty) {
      return;
    }

    setState(() {
      _isUpdatingProfile = true;
    });

    try {
      await AuthService.updateProfile(firstName: firstName, lastName: lastName);

      await _loadUser();

      _showMessage('اطلاعات حساب با موفقیت به‌روزرسانی شد.');
    } catch (e) {
      _showMessage(_errorMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingProfile = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('خروج از حساب'),
          content: const Text(
            'آیا مطمئن هستید که می‌خواهید '
            'از حساب خود خارج شوید؟',
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.gray3,
                    ),
                    child: const Text('انصراف'),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _logout();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.red1,
                    ),
                    child: const Text('خروج'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('آموزش استفاده'),
          content: const SingleChildScrollView(
            child: Text(
              'برای شروع، یک گروه ایجاد کنید یا به یک گروه '
              'بپیوندید.\n\n'
              'در هر گروه می‌توانید سفارش‌های مشترک را ثبت کنید. '
              'اعضای گروه سفارش‌ها را می‌بینند و می‌توانند '
              'مسئولیت خرید هر سفارش را بر عهده بگیرند.\n\n'
              'پس از انجام خرید، سفارش توسط فرد مسئول تکمیل می‌شود.',
            ),
          ),
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

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('قوانین و شرایط استفاده'),
          content: const SingleChildScrollView(
            child: Text(
              'کاربران مسئول اطلاعاتی هستند که در گروه‌ها و '
              'سفارش‌های خود ثبت می‌کنند.\n\n'
              'هر کاربر باید از حساب خود محافظت کند و اطلاعات '
              'ورود خود را در اختیار دیگران قرار ندهد.\n\n'
              'استفاده از برنامه به معنای پذیرش قوانین و شرایط '
              'استفاده است.',
            ),
          ),
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

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'مگه نگفتم؟',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.shopping_cart),
      children: const [
        Text(
          'مگه نگفتم؟ یک برنامه برای مدیریت '
          'خریدهای خانوادگی و گروهی است.',
        ),
      ],
    );
  }

  String _errorMessage(Object error) {
    final message = error.toString();

    if (message.contains('unauthorized')) {
      return 'نشست شما منقضی شده است.';
    }

    if (message.contains('server_error')) {
      return 'خطا در ارتباط با سرور.';
    }

    return message.replaceFirst('Exception: ', '');
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('تنظیمات')),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = _user;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _buildProfileCard(user),

        const SizedBox(height: 20),

        _buildSection(
          title: 'حساب کاربری',
          children: [
            _buildSettingTile(
              icon: Icons.person_outline,
              title: 'اطلاعات شخصی',
              subtitle: 'ویرایش نام و نام خانوادگی',
              onTap: _editProfile,
              trailing: _isUpdatingProfile
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
          ],
        ),

        const SizedBox(height: 16),

        _buildSection(
          title: 'برنامه',
          children: [
            _buildSettingTile(
              icon: Icons.groups_outlined,
              title: 'گروه‌های من',
              subtitle: 'مشاهده و مدیریت گروه‌ها',
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.groups);
              },
            ),

            _buildSettingTile(
              icon: Icons.notifications_outlined,
              title: 'اعلان‌ها',
              subtitle: 'مشاهده اعلان‌های گروه‌ها',
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.notifications,
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        _buildSection(
          title: 'راهنما و اطلاعات',
          children: [
            _buildSettingTile(
              icon: Icons.help_outline,
              title: 'آموزش استفاده',
              subtitle: 'نحوه کار با گروه‌ها و سفارش‌ها',
              onTap: _showHelp,
            ),

            _buildSettingTile(
              icon: Icons.description_outlined,
              title: 'قوانین و شرایط',
              subtitle: 'شرایط استفاده از برنامه',
              onTap: _showTerms,
            ),

            _buildSettingTile(
              icon: Icons.info_outline,
              title: 'درباره برنامه',
              subtitle: 'مگه نگفتم؟',
              onTap: _showAbout,
            ),
          ],
        ),

        const SizedBox(height: 20),

        OutlinedButton.icon(
          onPressed: _showLogoutConfirmation,
          icon: const Icon(Icons.logout, color: AppColors.red1),
          label: const Text('خروج از حساب'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.red1,
            side: const BorderSide(color: AppColors.red1),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(User? user) {
    final fullName = user?.fullName ?? 'حساب کاربری';

    final phone = user?.phone ?? 'اطلاعات حساب در دسترس نیست';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green3.withValues(alpha: 0.25),
                border: Border.all(color: AppColors.green3, width: 2),
              ),
              child: const Icon(
                Icons.person,
                size: 34,
                color: AppColors.green1,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    phone,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            IconButton(
              tooltip: 'ویرایش',
              onPressed: _isUpdatingProfile ? null : _editProfile,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.gray1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Card(child: Column(children: children)),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.green1),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_left),
      onTap: onTap,
    );
  }
}

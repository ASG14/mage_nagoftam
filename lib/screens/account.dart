import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/user.dart';

import 'package:mage_nagoftam/screens/group_orders.dart';

import 'package:mage_nagoftam/services/group_service.dart';
import 'package:mage_nagoftam/services/user_service.dart';

import 'package:mage_nagoftam/style/color.dart';

import 'package:mage_nagoftam/widgets/bottom_navigation_bar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? _user;

  List<Group> _groups = [];

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadAccount();
  }

  // ==================================================
  // Load Account
  // ==================================================

  Future<void> _loadAccount() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final results = await Future.wait([
        UserService.getCurrentUser(),
        GroupService.getGroups(),
      ]);

      if (!mounted) return;

      setState(() {
        _user = results[0] as User;
        _groups = results[1] as List<Group>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e);
      });
    }
  }

  // ==================================================
  // Open Group
  // ==================================================

  void _openGroup(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GroupOrdersScreen(group: group)),
    );
  }

  // ==================================================
  // Error
  // ==================================================

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('unauthorized')) {
      return 'نشست شما منقضی شده است.';
    }

    if (message.contains('server_error')) {
      return 'خطا در ارتباط با سرور.';
    }

    return 'دریافت اطلاعات حساب با خطا مواجه شد.';
  }

  // ==================================================
  // Build
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }

  // ==================================================
  // App Bar
  // ==================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      titleSpacing: 16,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person, size: 24),
          const SizedBox(width: 8),
          const Text('حساب من'),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'تنظیمات',
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }

  // ==================================================
  // Body
  // ==================================================

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      onRefresh: _loadAccount,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              _buildProfileSection(),

              const SizedBox(height: 24),

              _buildSectionTitle('گروه‌های شما'),

              const SizedBox(height: 8),

              _buildGroupsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // Profile
  // ==================================================

  Widget _buildProfileSection() {
    final user = _user!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAvatar(),

          const SizedBox(height: 12),

          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            user.phone,
            textDirection: TextDirection.ltr,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray2),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gray4,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_groups.length} گروه',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.gray1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // Avatar
  // ==================================================

  Widget _buildAvatar() {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.green3.withValues(alpha: 0.35),
        border: Border.all(color: AppColors.green3, width: 3),
      ),
      child: const CircleAvatar(
        backgroundColor: AppColors.white2,
        child: Icon(Icons.person, size: 46, color: AppColors.gray2),
      ),
    );
  }

  // ==================================================
  // Section Title
  // ==================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.gray1,
        ),
      ),
    );
  }

  // ==================================================
  // Groups
  // ==================================================

  Widget _buildGroupsSection() {
    if (_groups.isEmpty) {
      return _buildEmptyGroupsState();
    }

    return Column(
      children: _groups.map((group) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildGroupCard(group),
        );
      }).toList(),
    );
  }

  // ==================================================
  // Group Card
  // ==================================================

  Widget _buildGroupCard(Group group) {
    return Material(
      color: AppColors.white2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _openGroup(group);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray4),
          ),
          child: Row(
            children: [
              _buildGroupAvatar(),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'مشاهده سفارش‌های گروه',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.gray2),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(Icons.chevron_left, color: AppColors.gray2),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // Group Avatar
  // ==================================================

  Widget _buildGroupAvatar() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.green3.withValues(alpha: 0.25),
      ),
      child: const Icon(Icons.groups, color: AppColors.green1, size: 25),
    );
  }

  // ==================================================
  // Empty Groups
  // ==================================================

  Widget _buildEmptyGroupsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray4),
      ),
      child: Column(
        children: [
          const Icon(Icons.groups_outlined, size: 48, color: AppColors.gray2),

          const SizedBox(height: 12),

          Text(
            'هنوز عضو هیچ گروهی نیستید.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.gray1,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'با ایجاد یا پیوستن به یک گروه، خریدهای مشترک خود را مدیریت کنید.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.gray2),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // Error State
  // ==================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56),

            const SizedBox(height: 16),

            Text(_errorMessage!, textAlign: TextAlign.center),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _loadAccount,
              icon: const Icon(Icons.refresh),
              label: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }
}

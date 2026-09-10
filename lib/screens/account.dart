import 'package:flutter/material.dart';

import 'package:mage_nagoftam/style/color.dart';
import 'package:mage_nagoftam/widgets/bottom_navigation_bar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ==================================================
  // Mock Data
  // ==================================================

  final String _userName = 'مریم حسینی';
  final String _username = '@maryam_h1350';

  final List<_GroupStatusData> _groups = [
    _GroupStatusData(
      name: 'دوستان',
      totalPending: 18,
      myPending: 3,
      progress: 0.22,
      avatarIcon: Icons.groups,
    ),
    _GroupStatusData(
      name: 'خانواده',
      totalPending: 18,
      myPending: 3,
      progress: 0.22,
      avatarIcon: Icons.home,
    ),
  ];

  final int _completedOrders = 1128;
  final int _createdOrders = 743;

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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            _buildHeroSection(),

            const SizedBox(height: 12),

            _buildAnnouncementSection(),

            const SizedBox(height: 24),

            _buildSectionTitle('وضعیت گروه‌ها'),

            const SizedBox(height: 8),

            _buildGroupsStatus(),

            const SizedBox(height: 24),

            _buildSectionTitle('آمار کلی'),

            const SizedBox(height: 8),

            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // Hero
  // ==================================================

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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

          const SizedBox(height: 8),

          Text(
            _userName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 2),

          Text(
            _username,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.gray2),
            textDirection: TextDirection.ltr,
          ),

          const SizedBox(height: 10),

          Text(
            '👏 این هفته ۱۲ خرید رو انجام دادی',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.gray1,
              fontWeight: FontWeight.w600,
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
  // Announcement
  // ==================================================

  Widget _buildAnnouncementSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray4),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: AppColors.orange1,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'قابلیت جدید: حالا می‌تونی اعضای خانواده رو راحت‌تر دعوت کنی.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.gray1),
            ),
          ),
        ],
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
  // Groups Status
  // ==================================================

  Widget _buildGroupsStatus() {
    return Column(
      children: _groups.map((group) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildGroupStatusCard(group),
        );
      }).toList(),
    );
  }

  Widget _buildGroupStatusCard(_GroupStatusData group) {
    return Material(
      color: AppColors.white2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          //
          // Navigate to group orders.
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray4),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildGroupAvatar(group.avatarIcon),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${group.totalPending} سفارش ناتمام، سهم شما ${group.myPending} تا',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: group.progress,
                  minHeight: 5,
                  backgroundColor: AppColors.gray4,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.green2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // Group Avatar
  // ==================================================

  Widget _buildGroupAvatar(IconData icon) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.green3.withValues(alpha: 0.25),
      ),
      child: Icon(icon, color: AppColors.green1, size: 25),
    );
  }

  // ==================================================
  // Statistics
  // ==================================================

  Widget _buildStatistics() {
    return Column(
      children: [
        _buildStatisticCard(
          value: _completedOrders,
          label: 'سفارش تکمیل‌شده توسط شما تا کنون',
          icon: Icons.check_circle_outline,
        ),

        const SizedBox(height: 8),

        _buildStatisticCard(
          value: _createdOrders,
          label: 'سفارش ایجادشده توسط شما تا کنون',
          icon: Icons.playlist_add_check,
        ),
      ],
    );
  }

  Widget _buildStatisticCard({
    required int value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray4),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gray4,
            ),
            child: Icon(icon, size: 21, color: AppColors.green1),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.gray2),
            ),
          ),

          const SizedBox(width: 8),

          Text(
            _formatNumber(value),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray1,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // Number Formatter
  // ==================================================

  String _formatNumber(int number) {
    final value = number.toString();

    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        buffer.write(',');
      }

      buffer.write(value[i]);
    }

    return buffer.toString();
  }
}

// ==================================================
// Group Status Model
// ==================================================

class _GroupStatusData {
  final String name;
  final int totalPending;
  final int myPending;
  final double progress;
  final IconData avatarIcon;

  const _GroupStatusData({
    required this.name,
    required this.totalPending,
    required this.myPending,
    required this.progress,
    required this.avatarIcon,
  });
}

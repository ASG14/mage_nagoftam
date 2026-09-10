import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';

import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/services/group_service.dart';

import 'package:mage_nagoftam/style/color.dart';

import 'package:mage_nagoftam/widgets/bottom_navigation_bar.dart';
import 'package:mage_nagoftam/widgets/groups/group_card.dart';

import 'package:mage_nagoftam/screens/group_orders.dart';

import 'members.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<Group> _groups = [];

  int? _currentUserId;

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  // ==================================================
  // Initialize
  // ==================================================

  Future<void> _initialize() async {
    _currentUserId = await AuthService.getUserId();

    if (!mounted) return;

    await _loadGroups();
  }

  // ==================================================
  // Load Groups
  // ==================================================

  Future<void> _loadGroups() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final groups = await GroupService.getGroups();

      if (!mounted) return;

      setState(() {
        _groups = groups;
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
  // Create Group
  // ==================================================

  Future<void> _createGroup() async {
    final title = await _showGroupTitleDialog(
      title: 'ایجاد گروه',
      confirmText: 'ایجاد',
    );

    if (title == null || title.trim().isEmpty) {
      return;
    }

    try {
      await GroupService.createGroup(title: title.trim());

      if (!mounted) return;

      await _loadGroups();

      if (!mounted) return;

      _showMessage('گروه با موفقیت ایجاد شد.');
    } catch (e) {
      if (!mounted) return;

      _showMessage(_getErrorMessage(e));
    }
  }

  // ==================================================
  // Edit Group
  // ==================================================

  Future<void> _editGroup(Group group) async {
    final title = await _showGroupTitleDialog(
      title: 'ویرایش گروه',
      initialValue: group.title,
      confirmText: 'ذخیره',
    );

    if (title == null || title.trim().isEmpty) {
      return;
    }

    try {
      await GroupService.updateGroup(groupId: group.id, title: title.trim());

      if (!mounted) return;

      await _loadGroups();

      if (!mounted) return;

      _showMessage('گروه با موفقیت ویرایش شد.');
    } catch (e) {
      if (!mounted) return;

      _showMessage(_getErrorMessage(e));
    }
  }

  // ==================================================
  // Delete Group
  // ==================================================

  Future<void> _confirmDeleteGroup(Group group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف گروه'),
          content: Text(
            'آیا از حذف گروه «${group.title}» '
            'مطمئن هستید؟\n\n'
            'تمام اطلاعات مربوط به این گروه نیز حذف خواهد شد.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.red1),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _deleteGroup(group);
  }

  Future<void> _deleteGroup(Group group) async {
    try {
      await GroupService.deleteGroup(groupId: group.id);

      if (!mounted) return;

      setState(() {
        _groups.removeWhere((item) => item.id == group.id);
      });

      _showMessage('گروه با موفقیت حذف شد.');
    } catch (e) {
      if (!mounted) return;

      _showMessage(_getErrorMessage(e));
    }
  }

  // ==================================================
  // Open Members
  // ==================================================

  void _openMembers(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MembersScreen(group: group)),
    );
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
  // Group Title Dialog
  // ==================================================

  Future<String?> _showGroupTitleDialog({
    required String title,
    required String confirmText,
    String initialValue = '',
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 150,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'نام گروه',
              hintText: 'مثلاً خانواده',
            ),
            onSubmitted: (_) {
              final value = controller.text.trim();

              if (value.isNotEmpty) {
                Navigator.pop(context, value);
              }
            },
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
                final value = controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(context, value);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
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

    if (message.contains('not allowed')) {
      return 'شما اجازه انجام این عملیات را ندارید.';
    }

    if (message.contains('not found')) {
      return 'گروه موردنظر پیدا نشد.';
    }

    return 'عملیات با خطا مواجه شد.';
  }

  // ==================================================
  // Message
  // ==================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ==================================================
  // Build
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 16,

          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.groups_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('گروه‌ها'),
            ],
          ),

          actions: [
            IconButton(
              tooltip: 'جستجو',
              onPressed: _showSearchMessage,
              icon: const Icon(Icons.search),
            ),
            const SizedBox(width: 4),
          ],
        ),

        body: _buildBody(),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: _createGroup,
          icon: const Icon(Icons.add),
          label: const Text('افزودن گروه'),
        ),

        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
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

    if (_groups.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadGroups,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GroupCard(
              group: group,
              index: index,
              isOwner: group.creatorId == _currentUserId,
              onTap: () {
                _openGroup(group);
              },
              onMembers: () {
                _openMembers(group);
              },
              onEdit: () {
                _editGroup(group);
              },
              onDelete: () {
                _confirmDeleteGroup(group);
              },
            ),
          );
        },
      ),
    );
  }

  // ==================================================
  // Empty State
  // ==================================================

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _loadGroups,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'هنوز گروهی نداری',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'یک گروه بساز و خریدهای مشترک را با دیگران مدیریت کن.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _createGroup,
                      icon: const Icon(Icons.add),
                      label: const Text('افزودن گروه'),
                    ),
                  ],
                ),
              ),
            ),
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
              onPressed: _loadGroups,
              icon: const Icon(Icons.refresh),
              label: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // Search
  // ==================================================

  void _showSearchMessage() {
    _showMessage('جستجو را در مرحله بعد اضافه می‌کنیم.');
  }
}

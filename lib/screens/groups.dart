import 'package:begir/models/group.dart';
import 'package:begir/services/group_service.dart';
import 'package:begir/style/color.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<Group> _groups = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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

  String _getErrorMessage(Object error) {
    if (error.toString().contains('unauthorized')) {
      return 'نشست شما منقضی شده است. لطفاً دوباره وارد شوید.';
    }

    if (error.toString().contains('server_error')) {
      return 'خطا در ارتباط با سرور.';
    }

    return 'دریافت گروه‌ها با خطا مواجه شد.';
  }

  void _showAddGroupDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ایجاد گروه جدید'),

          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'نام گروه',
              hintText: 'مثلاً خانواده',
              prefixIcon: Icon(Icons.groups),
            ),
          ),

          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.gray3,
                    ),
                    child: const Text('انصراف'),
                  ),
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final title = controller.text.trim();

                      if (title.isEmpty) {
                        return;
                      }

                      // فعلاً فقط بستن Dialog
                      // اتصال Create در مرحله بعد انجام می‌شود.
                      Navigator.pop(context);
                    },
                    child: const Text('ایجاد گروه'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  void _showGroupDetails(Group group) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  group.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 12),

                Text(
                  'شناسه گروه: ${group.id}',
                ),

                const SizedBox(height: 12),

                Text(
                  'این گروه در تاریخ ${group.createdAt} ایجاد شده است.',
                ),

                const SizedBox(height: 24),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);

                    _showDeleteConfirmation(group);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red1,
                    iconColor: AppColors.red1,
                    side: const BorderSide(
                      color: AppColors.gray4,
                      width: 1,
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text(
                    'حذف گروه',
                    style: TextStyle(
                      color: AppColors.red1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(Group group) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف گروه'),

          content: Text(
            'آیا از حذف گروه «${group.title}» مطمئن هستید؟',
          ),

          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.gray3,
                    ),
                    child: const Text('انصراف'),
                  ),
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // اتصال Delete در مرحله بعد انجام می‌شود.
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.red1,
                    ),
                    child: const Text('حذف'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('گروه‌های من'),
        ),

        body: _buildBody(),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddGroupDialog,
          icon: const Icon(Icons.add),
          label: const Text('گروه جدید'),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_groups.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadGroups,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final group = _groups[index];

          return _GroupCard(
            group: group,
            onTap: () {
              _showGroupDetails(group);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
            ),

            const SizedBox(height: 16),

            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),

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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.groups_outlined,
              size: 64,
            ),

            const SizedBox(height: 16),

            const Text(
              'هنوز عضو هیچ گروهی نیستید',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              'برای شروع، یک گروه جدید ایجاد کنید.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _showAddGroupDialog,
              icon: const Icon(Icons.add),
              label: const Text('ایجاد گروه'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const _GroupCard({
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        leading: const CircleAvatar(
          child: Icon(Icons.groups),
        ),

        title: Text(group.title),

        subtitle: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text('گروه خرید'),
        ),

        trailing: const Icon(
          Icons.chevron_left,
        ),
      ),
    );
  }
}
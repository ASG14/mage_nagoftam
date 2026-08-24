import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<_TestGroup> _groups = [
    _TestGroup(
      id: '1',
      title: 'خانواده احمدی',
      memberCount: 4,
      description: 'سبد خرید اعضای خانواده',
    ),
    _TestGroup(
      id: '2',
      title: 'خانه',
      memberCount: 3,
      description: 'خریدهای مربوط به خانه',
    ),
    _TestGroup(
      id: '3',
      title: 'خوابگاه',
      memberCount: 5,
      description: 'خریدهای مشترک خوابگاه',
    ),
  ];

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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('انصراف'),
            ),

            FilledButton(
              onPressed: () {
                final title = controller.text.trim();

                if (title.isEmpty) {
                  return;
                }

                setState(() {
                  _groups.add(
                    _TestGroup(
                      id: DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                      title: title,
                      memberCount: 1,
                      description: 'گروه جدید',
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('ایجاد گروه'),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  void _deleteGroup(_TestGroup group) {
    setState(() {
      _groups.remove(group);
    });
  }

  void _showGroupDetails(_TestGroup group) {
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

                Text(group.description),

                const SizedBox(height: 12),

                Text(
                  '${group.memberCount} عضو',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);

                    _showDeleteConfirmation(group);
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('حذف گروه'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(_TestGroup group) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف گروه'),

          content: Text(
            'آیا از حذف گروه «${group.title}» مطمئن هستید؟',
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
                _deleteGroup(group);
                Navigator.pop(context);
              },
              child: const Text('حذف'),
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

        body: _groups.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _groups.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
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

        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddGroupDialog,
          icon: const Icon(Icons.add),
          label: const Text('گروه جدید'),
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
  final _TestGroup group;
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

        leading: CircleAvatar(
          child: const Icon(Icons.groups),
        ),

        title: Text(group.title),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${group.memberCount} عضو • ${group.description}',
          ),
        ),

        trailing: const Icon(
          Icons.chevron_left,
        ),
      ),
    );
  }
}

class _TestGroup {
  final String id;
  final String title;
  final int memberCount;
  final String description;

  const _TestGroup({
    required this.id,
    required this.title,
    required this.memberCount,
    required this.description,
  });
}
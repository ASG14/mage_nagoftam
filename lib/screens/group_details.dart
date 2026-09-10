import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/group_member.dart';

import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/services/group_service.dart';

import 'package:mage_nagoftam/style/color.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  const GroupDetailsScreen({super.key, required this.group});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  List<GroupMember> _members = [];

  int? _currentUserId;

  late String _groupTitle;

  bool _isLoading = true;
  bool _isDeleting = false;
  bool _isGeneratingInvite = false;

  String? _errorMessage;
  String? _inviteLink;

  bool get _isOwner {
    return widget.group.creatorId == _currentUserId;
  }

  @override
  void initState() {
    super.initState();

    _groupTitle = widget.group.title;

    _initialize();
  }

  // ==================================================
  // Initialize
  // ==================================================

  Future<void> _initialize() async {
    _currentUserId = await AuthService.getUserId();

    if (!mounted) return;

    await _loadMembers();
  }

  // ==================================================
  // Load Members
  // ==================================================

  Future<void> _loadMembers() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final members = await GroupService.getMembers(groupId: widget.group.id);

      if (!mounted) return;

      setState(() {
        _members = members;
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
  // Edit Group
  // ==================================================

  Future<void> _editGroupName() async {
    if (!_isOwner) {
      return;
    }

    final controller = TextEditingController(text: _groupTitle);

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ویرایش نام گروه'),

          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 150,
            textInputAction: TextInputAction.done,

            decoration: const InputDecoration(labelText: 'نام گروه'),
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
              child: const Text('ذخیره'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newTitle == null ||
        newTitle.trim().isEmpty ||
        newTitle.trim() == _groupTitle) {
      return;
    }

    try {
      await GroupService.updateGroup(
        groupId: widget.group.id,
        title: newTitle.trim(),
      );

      if (!mounted) return;

      setState(() {
        _groupTitle = newTitle.trim();
      });

      _showMessage('نام گروه با موفقیت تغییر کرد.');
    } catch (e) {
      if (!mounted) return;

      _showMessage(_getErrorMessage(e));
    }
  }

  // ==================================================
  // Invite Link
  // ==================================================

  Future<void> _createInvite() async {
    if (_inviteLink != null) {
      await _copyInvite();

      return;
    }

    setState(() {
      _isGeneratingInvite = true;
    });

    try {
      final token = await GroupService.createInvite(groupId: widget.group.id);

      if (token.trim().isEmpty) {
        throw Exception('invalid_invite_token');
      }

      final link = 'https://magenagoftam.ir/join/${token.trim()}';

      if (!mounted) return;

      setState(() {
        _inviteLink = link;
        _isGeneratingInvite = false;
      });

      await Clipboard.setData(ClipboardData(text: link));

      if (!mounted) return;

      _showMessage('لینک دعوت ایجاد و کپی شد.');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isGeneratingInvite = false;
      });

      _showMessage(_getErrorMessage(e));
    }
  }

  Future<void> _copyInvite() async {
    if (_inviteLink == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _inviteLink!));

    if (!mounted) return;

    _showMessage('لینک دعوت کپی شد.');
  }

  // ==================================================
  // Remove Member
  // ==================================================

  Future<void> _removeMember(GroupMember member) async {
    if (!_isOwner) {
      return;
    }

    if (member.id == _currentUserId) {
      _showMessage('صاحب گروه نمی‌تواند خودش را حذف کند.');

      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف عضو'),

          content: Text(
            'آیا از حذف «${member.fullName}» '
            'از گروه مطمئن هستید؟',
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

              child: const Text('حذف عضو'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await GroupService.removeMember(
        groupId: widget.group.id,
        memberId: member.id,
      );

      if (!mounted) return;

      setState(() {
        _members.removeWhere((item) => item.id == member.id);
      });

      _showMessage('عضو از گروه حذف شد.');
    } catch (e) {
      if (!mounted) return;

      _showMessage(_getErrorMessage(e));
    }
  }

  // ==================================================
  // Delete Group
  // ==================================================

  Future<void> _deleteGroup() async {
    if (!_isOwner || _isDeleting) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف گروه'),

          content: const Text(
            'با حذف گروه، اطلاعات آن برای اعضای گروه نیز '
            'در دسترس نخواهد بود.\n\n'
            'آیا مطمئن هستید؟',
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

              child: const Text('حذف گروه'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await GroupService.deleteGroup(groupId: widget.group.id);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      _showMessage(_getErrorMessage(e));
    }
  }

  // ==================================================
  // Error
  // ==================================================

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('unauthorized')) {
      return 'نشست شما منقضی شده است.';
    }

    if (message.contains('not the owner')) {
      return 'فقط صاحب گروه می‌تواند این عملیات را انجام دهد.';
    }

    if (message.contains('server_error')) {
      return 'خطا در ارتباط با سرور.';
    }

    if (message.contains('invalid_invite_token')) {
      return 'توکن دعوت نامعتبر دریافت شد.';
    }

    if (message.contains('not found')) {
      return 'گروه یا عضو موردنظر پیدا نشد.';
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
          title: Text('مشخصات گروه $_groupTitle'),

          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            icon: const Icon(Icons.arrow_back),
          ),

          actions: [
            if (_isOwner)
              IconButton(
                tooltip: 'ویرایش نام گروه',
                onPressed: _editGroupName,
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
        ),

        body: _buildBody(),
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
      return _buildError();
    }

    return RefreshIndicator(
      onRefresh: _loadMembers,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),

        children: [
          _buildGroupHeader(),

          const SizedBox(height: 10),

          _buildInviteCard(),

          const SizedBox(height: 20),

          Text(
            'اعضای گروه',
            textAlign: TextAlign.right,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.gray1,
            ),
          ),

          const SizedBox(height: 10),

          ..._members.map((member) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),

              child: _buildMemberCard(member),
            );
          }),

          const SizedBox(height: 24),

          _buildDangerSection(),
        ],
      ),
    );
  }

  // ==================================================
  // Group Header
  // ==================================================

  Widget _buildGroupHeader() {
    return _SectionCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.green3,

            child: const Icon(Icons.groups, size: 28, color: AppColors.white2),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  _groupTitle,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray1,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${_members.length} عضو',

                  style: const TextStyle(fontSize: 13, color: AppColors.gray2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // Invite Card
  // ==================================================

  Widget _buildInviteCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Row(
            children: [
              const Icon(Icons.link, color: AppColors.green2),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'دعوت اعضای جدید',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'لینک دعوت گروه را برای اعضای خانواده بفرستید.',
                      style: TextStyle(fontSize: 12, color: AppColors.gray2),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (_inviteLink != null) ...[
            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: AppColors.gray4,

                borderRadius: BorderRadius.circular(6),
              ),

              child: SelectableText(
                _inviteLink!,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 8),
          ],

          FilledButton.icon(
            onPressed: _isGeneratingInvite ? null : _createInvite,

            icon: _isGeneratingInvite
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_inviteLink == null ? Icons.link : Icons.copy),

            label: Text(
              _inviteLink == null ? 'ایجاد لینک دعوت' : 'کپی لینک دعوت',
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // Member Card
  // ==================================================

  Widget _buildMemberCard(GroupMember member) {
    final bool isOwner = member.id == widget.group.creatorId;

    final bool canRemove = _isOwner && member.id != _currentUserId;

    return _SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: ListTile(
        contentPadding: EdgeInsets.zero,

        leading: CircleAvatar(
          backgroundColor: AppColors.green3,

          child: const Icon(Icons.person, color: AppColors.white2),
        ),

        title: Text(
          member.fullName,
          textAlign: TextAlign.right,

          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        subtitle: Text(
          member.phone,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,

          style: const TextStyle(fontSize: 12, color: AppColors.gray2),
        ),

        trailing: isOwner
            ? const Chip(label: Text('مالک'))
            : canRemove
            ? IconButton(
                tooltip: 'حذف عضو',

                onPressed: () {
                  _removeMember(member);
                },

                icon: const Icon(Icons.delete_outline, color: AppColors.red1),
              )
            : null,
      ),
    );
  }

  // ==================================================
  // Danger Section
  // ==================================================

  Widget _buildDangerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        if (_isOwner)
          OutlinedButton.icon(
            onPressed: _isDeleting ? null : _deleteGroup,

            icon: _isDeleting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline, color: AppColors.red1),

            label: const Text(
              'حذف گروه',
              style: TextStyle(color: AppColors.red1),
            ),

            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.red1),
            ),
          ),

        if (!_isOwner)
          OutlinedButton.icon(
            onPressed: () {
              _showMessage('قابلیت ترک گروه در مرحله بعد اضافه می‌شود.');
            },

            icon: const Icon(Icons.logout, color: AppColors.red1),

            label: const Text(
              'ترک گروه',
              style: TextStyle(color: AppColors.red1),
            ),

            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.red1),
            ),
          ),
      ],
    );
  }

  // ==================================================
  // Error
  // ==================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.red1),

            const SizedBox(height: 16),

            Text(_errorMessage!, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _loadMembers,

              icon: const Icon(Icons.refresh),

              label: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// Section Card
// ==================================================

class _SectionCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;

  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: padding,

      decoration: BoxDecoration(
        color: AppColors.white2,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: AppColors.gray4),
      ),

      child: child,
    );
  }
}

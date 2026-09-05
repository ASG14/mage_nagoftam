import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/group_member.dart';

import 'package:mage_nagoftam/services/auth_service.dart';
import 'package:mage_nagoftam/services/group_service.dart';

import 'package:mage_nagoftam/style/color.dart';

class MembersScreen extends StatefulWidget {
  final Group group;

  const MembersScreen({super.key, required this.group});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<GroupMember> _members = [];

  int? _currentUserId;

  bool _isLoading = true;
  bool _isGeneratingInvite = false;

  String? _errorMessage;
  String? _inviteLink;

  bool get _isOwner => widget.group.creatorId == _currentUserId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _currentUserId = await AuthService.getUserId();

    if (!mounted) return;

    await _loadMembers();
  }

  // --------------------------------------------------
  // Load Members
  // --------------------------------------------------

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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

  // --------------------------------------------------
  // Invite Link
  // --------------------------------------------------

  String _buildInviteLink(String token) {
    return 'mage_nagoftam://join/$token';
  }

  Future<void> _loadInviteLink() async {
    if (_inviteLink != null) {
      await _copyInviteLink();
      return;
    }

    setState(() {
      _isGeneratingInvite = true;
    });

    try {
      final token = await GroupService.createInvite(groupId: widget.group.id);

      if (!mounted) return;

      if (token.trim().isEmpty) {
        throw Exception('invalid_invite_token');
      }

      final link = _buildInviteLink(token.trim());

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

  Future<void> _copyInviteLink() async {
    final link = _inviteLink;

    if (link == null || link.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: link));

    if (!mounted) return;

    _showMessage('لینک دعوت کپی شد.');
  }

  // --------------------------------------------------
  // Remove Member
  // --------------------------------------------------

  Future<void> _confirmRemoveMember(GroupMember member) async {
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
            'از این گروه مطمئن هستید؟',
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

    if (confirmed != true || !mounted) {
      return;
    }

    await _removeMember(member);
  }

  Future<void> _removeMember(GroupMember member) async {
    try {
      await GroupService.removeMember(
        groupId: widget.group.id,
        memberId: member.id,
      );

      if (!mounted) return;

      setState(() {
        _members.removeWhere((item) => item.id == member.id);
      });

      _showMessage('عضو با موفقیت حذف شد.');
    } catch (e) {
      if (!mounted) return;

      _showMessage(_getErrorMessage(e));
    }
  }

  // --------------------------------------------------
  // Error
  // --------------------------------------------------

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('unauthorized')) {
      return 'نشست شما منقضی شده است.';
    }

    if (message.contains('server_error')) {
      return 'خطا در ارتباط با سرور.';
    }

    if (message.contains('invalid_invite_token')) {
      return 'توکن دعوت نامعتبر دریافت شد.';
    }

    if (message.contains('You are not a member')) {
      return 'شما عضو این گروه نیستید.';
    }

    if (message.contains('not the owner')) {
      return 'فقط صاحب گروه می‌تواند این عملیات را انجام دهد.';
    }

    if (message.contains('not found')) {
      return 'عضو موردنظر پیدا نشد.';
    }

    if (message.contains('creator cannot')) {
      return 'صاحب گروه نمی‌تواند خودش را حذف کند.';
    }

    return 'عملیات با خطا مواجه شد.';
  }

  // --------------------------------------------------
  // Message
  // --------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // --------------------------------------------------
  // Build
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('اعضای ${widget.group.title}')),
        body: _buildBody(),
      ),
    );
  }

  // --------------------------------------------------
  // Body
  // --------------------------------------------------

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      onRefresh: _loadMembers,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _buildInviteCard(),

          const SizedBox(height: 20),

          Text('اعضای گروه', style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 12),

          if (_members.isEmpty)
            _buildNoMembers()
          else
            ..._members.map(
              (member) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MemberCard(
                  member: member,
                  isOwner: member.id == widget.group.creatorId,
                  canRemove: _isOwner && member.id != _currentUserId,
                  onRemove: () {
                    _confirmRemoveMember(member);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Invite Card
  // --------------------------------------------------

  Widget _buildInviteCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.link)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'لینک دعوت گروه',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'لینک را کپی کنید و برای اعضای جدید بفرستید.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (_inviteLink != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gray3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _inviteLink!,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: _isGeneratingInvite ? null : _loadInviteLink,
              icon: _isGeneratingInvite
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_inviteLink == null ? Icons.link : Icons.copy),
              label: Text(
                _inviteLink == null ? 'نمایش و کپی لینک دعوت' : 'کپی لینک دعوت',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // No Members
  // --------------------------------------------------

  Widget _buildNoMembers() {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Text(
          'عضوی در این گروه وجود ندارد.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Error State
  // --------------------------------------------------

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
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
// Member Card
// ==================================================

class _MemberCard extends StatelessWidget {
  final GroupMember member;
  final bool isOwner;
  final bool canRemove;
  final VoidCallback onRemove;

  const _MemberCard({
    required this.member,
    required this.isOwner,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(member.fullName),
        subtitle: Text(member.phone, textDirection: TextDirection.ltr),
        trailing: isOwner
            ? const Chip(label: Text('مالک'))
            : canRemove
            ? IconButton(
                tooltip: 'حذف عضو',
                onPressed: onRemove,
                icon: const Icon(
                  Icons.person_remove_outlined,
                  color: AppColors.red1,
                ),
              )
            : null,
      ),
    );
  }
}

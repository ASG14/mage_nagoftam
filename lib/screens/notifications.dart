import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/notification.dart';
import 'package:mage_nagoftam/services/group_service.dart';
import 'package:mage_nagoftam/services/notification_service.dart';
import 'package:mage_nagoftam/widgets/bottom_navigation_bar.dart';
import 'package:mage_nagoftam/widgets/notifications/notification_feed.dart';
import 'package:mage_nagoftam/widgets/notifications/notification_filter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];
  List<Group> _groups = [];

  int? _selectedGroupId;

  bool _isLoading = true;
  String? _errorMessage;

  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        NotificationService.getNotifications(),
        GroupService.getGroups(),
      ]);

      if (!mounted) {
        return;
      }

      final notificationResult = results[0] as NotificationResult;

      final groups = results[1] as List<Group>;

      setState(() {
        _notifications = notificationResult.notifications;

        _unreadCount = notificationResult.unreadCount;

        _groups = groups;

        _isLoading = false;
      });

      if (_unreadCount > 0) {
        await NotificationService.markAllAsRead();

        if (!mounted) {
          return;
        }

        setState(() {
          _unreadCount = 0;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = _messageFromError(e);
      });
    }
  }

  Future<void> _refresh() async {
    try {
      final results = await Future.wait([
        NotificationService.getNotifications(),
        GroupService.getGroups(),
      ]);

      if (!mounted) {
        return;
      }

      final notificationResult = results[0] as NotificationResult;

      final groups = results[1] as List<Group>;

      setState(() {
        _notifications = notificationResult.notifications;

        _unreadCount = notificationResult.unreadCount;

        _groups = groups;
      });

      if (_unreadCount > 0) {
        await NotificationService.markAllAsRead();

        if (!mounted) {
          return;
        }

        setState(() {
          _unreadCount = 0;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_messageFromError(e))));
    }
  }

  String _messageFromError(Object error) {
    final message = error.toString();

    if (message.contains('unauthorized')) {
      return 'نشست شما منقضی شده است. دوباره وارد شوید.';
    }

    if (message.contains('server_error')) {
      return 'خطا در ارتباط با سرور.';
    }

    if (message.contains('invalid_response')) {
      return 'پاسخ نامعتبر از سرور دریافت شد.';
    }

    return 'خطا در دریافت اعلان‌ها.';
  }

  List<AppNotification> get _filteredNotifications {
    if (_selectedGroupId == null) {
      return _notifications;
    }

    return _notifications
        .where((notification) => notification.groupId == _selectedGroupId)
        .toList();
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'اعلانی ندارید',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'وقتی اتفاق مهمی در گروه‌های '
                      'شما رخ دهد، اعلان آن را '
                      'اینجا خواهید دید.',
                      textAlign: TextAlign.center,
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

  Widget _buildNoFilterResult() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: const Center(
              child: Text(
                'اعلانی برای این گروه وجود ندارد.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: _loadData,
              child: const Text('تلاش دوباره'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    final notifications = _filteredNotifications;

    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    if (notifications.isEmpty) {
      return _buildNoFilterResult();
    }

    return NotificationFeed(notifications: notifications, onRefresh: _refresh);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('اعلان‌ها')),

        body: Column(
          children: [
            if (_groups.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: NotificationFilter(
                  groups: _groups,
                  selectedGroupId: _selectedGroupId,
                  onChanged: (groupId) {
                    setState(() {
                      _selectedGroupId = groupId;
                    });
                  },
                ),
              ),

            Expanded(child: _buildBody()),
          ],
        ),

        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}

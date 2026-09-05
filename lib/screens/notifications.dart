import 'package:flutter/material.dart';

import 'package:mage_nagoftam/models/notification.dart';
import 'package:mage_nagoftam/services/notification_service.dart';
import 'package:mage_nagoftam/widgets/bottom_navigation_bar.dart';
import 'package:mage_nagoftam/widgets/drawer.dart';
import 'package:mage_nagoftam/widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result =
          await NotificationService.getNotifications();

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = result.notifications;
        _isLoading = false;
      });

      await NotificationService.markAllAsRead();
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

  Future<void> _refreshNotifications() async {
    try {
      final result =
          await NotificationService.getNotifications();

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = result.notifications;
      });

      await NotificationService.markAllAsRead();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _messageFromError(e),
          ),
        ),
      );
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

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                    0.65,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 80,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    const Text(
                      'اعلانی ندارید',
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

                    const Text(
                      'وقتی اتفاق مهمی در گروه‌های '
                      'شما رخ دهد، اعلان آن را '
                      'در اینجا خواهید دید.',
                      textAlign:
                          TextAlign.center,
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .error,
            ),

            const SizedBox(height: 16),

            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: _loadNotifications,
              child: const Text(
                'تلاش دوباره',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: ListView.builder(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 24,
        ),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(
            notification: _notifications[index],
          );
        },
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

    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    return _buildNotificationsList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'اعلان‌ها',
          ),
        ),

        drawer: const MyDrawer(),

        body: _buildBody(),

        bottomNavigationBar:
            const MyBottomNavigationBar(),
      ),
    );
  }
}
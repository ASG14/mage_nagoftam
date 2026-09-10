import 'dart:convert';

import 'package:mage_nagoftam/models/notification.dart';

import 'api_client.dart';

class NotificationService {
  static Future<NotificationResult> getNotifications() async {
    final response = await ApiClient.get('notifications/list.php');

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در دریافت اعلان‌ها',
      );
    }

    final notificationsData = result['data']?['notifications'];

    if (notificationsData is! List) {
      throw Exception('invalid_response');
    }

    final notifications = notificationsData
        .map(
          (item) =>
              AppNotification.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();

    final unreadCount = int.parse(
      result['data']?['unread_count']?.toString() ?? '0',
    );

    return NotificationResult(
      notifications: notifications,
      unreadCount: unreadCount,
    );
  }

  static Future<void> markAsRead({required int notificationId}) async {
    final response = await ApiClient.post(
      'notifications/read.php',
      body: {'notification_id': notificationId},
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(result['message']?.toString() ?? 'خطا در خواندن اعلان');
    }
  }

  static Future<void> markAllAsRead() async {
    final response = await ApiClient.post('notifications/mark_all_read.php');

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در خواندن اعلان‌ها',
      );
    }
  }

  static void _handleUnauthorized(int statusCode) {
    if (statusCode == 401) {
      throw Exception('unauthorized');
    }
  }

  static String _errorFromResponse(
    dynamic response, {
    required String fallback,
  }) {
    try {
      final result = jsonDecode(response.body);

      if (result is Map && result['message'] != null) {
        return result['message'].toString();
      }
    } catch (_) {}

    return fallback;
  }
}

class NotificationResult {
  final List<AppNotification> notifications;

  final int unreadCount;

  const NotificationResult({
    required this.notifications,
    required this.unreadCount,
  });
}

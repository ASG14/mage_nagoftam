import 'dart:convert';

import 'package:mage_nagoftam/models/order.dart';
import 'package:mage_nagoftam/services/api_client.dart';

class OrderService {
  // --------------------------------------------------
  // Get Orders
  // --------------------------------------------------

  static Future<List<Order>> getOrders({required int groupId}) async {
    final response = await ApiClient.get('orders/list.php?group_id=$groupId');

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode == 403) {
      throw Exception('forbidden');
    }

    if (response.statusCode != 200) {
      throw Exception('server_error');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(result['message'] ?? 'خطا در دریافت سفارش‌ها');
    }

    final orders = result['data']['orders'];

    return (orders as List)
        .map((json) => Order.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // --------------------------------------------------
  // Create Order
  // --------------------------------------------------

  static Future<Order> createOrder({
    required int groupId,
    required String title,
    String? quantity,
    required Priority priority,
    DateTime? deadline,
  }) async {
    final response = await ApiClient.post(
      'orders/create.php',
      body: {
        'group_id': groupId,
        'title': title,
        'quantity': quantity,
        'priority': _priorityToString(priority),
        'deadline': deadline != null ? _formatDateTime(deadline) : null,
      },
    );

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode == 403) {
      throw Exception('forbidden');
    }

    if (response.statusCode != 200) {
      throw Exception('server_error');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(result['message'] ?? 'خطا در ایجاد سفارش');
    }

    return Order.fromJson(result['data']['order'] as Map<String, dynamic>);
  }

  // --------------------------------------------------
  // Assign Order
  // --------------------------------------------------

  static Future<void> assignOrder({required int orderId}) async {
    final response = await ApiClient.postForm(
      'orders/assign.php',
      body: {'order_id': orderId.toString()},
    );

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode == 403) {
      throw Exception('forbidden');
    }

    if (response.statusCode == 404) {
      throw Exception('not_found');
    }

    if (response.statusCode == 409) {
      throw Exception('already_assigned');
    }

    if (response.statusCode != 200) {
      throw Exception('server_error');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(result['message'] ?? 'خطا در سپردن سفارش');
    }
  }

  // --------------------------------------------------
  // Complete Order
  // --------------------------------------------------

  static Future<void> completeOrder({required int orderId}) async {
    final response = await ApiClient.postForm(
      'orders/complete.php',
      body: {'order_id': orderId.toString()},
    );

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode == 403) {
      throw Exception('forbidden');
    }

    if (response.statusCode != 200) {
      throw Exception('server_error');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(result['message'] ?? 'خطا در تکمیل سفارش');
    }
  }

  // --------------------------------------------------
  // Delete Order
  // --------------------------------------------------

  static Future<void> deleteOrder({required int orderId}) async {
    final response = await ApiClient.postForm(
      'orders/delete.php',
      body: {'order_id': orderId.toString()},
    );

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode == 403) {
      throw Exception('forbidden');
    }

    if (response.statusCode == 404) {
      throw Exception('not_found');
    }

    if (response.statusCode != 200) {
      throw Exception('server_error');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(result['message'] ?? 'خطا در حذف سفارش');
    }
  }

  // --------------------------------------------------
  // Helpers
  // --------------------------------------------------

  static String _priorityToString(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'low';

      case Priority.medium:
        return 'medium';

      case Priority.high:
        return 'high';
    }
  }

  static String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');

    final month = dateTime.month.toString().padLeft(2, '0');

    final day = dateTime.day.toString().padLeft(2, '0');

    final hour = dateTime.hour.toString().padLeft(2, '0');

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final second = dateTime.second.toString().padLeft(2, '0');

    return '$year-$month-$day '
        '$hour:$minute:$second';
  }
}

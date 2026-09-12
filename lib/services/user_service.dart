import 'dart:convert';

import 'package:mage_nagoftam/models/user.dart';

import 'api_client.dart';

class UserService {
  static Future<User> getCurrentUser() async {
    final response = await ApiClient.get('auth/me.php');

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode != 200) {
      throw Exception('server_error');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در دریافت اطلاعات کاربر',
      );
    }

    final userData = result['data']?['user'];

    if (userData is! Map) {
      throw Exception('invalid_response');
    }

    final data = Map<String, dynamic>.from(userData);

    return User(
      id: int.tryParse(data['id'].toString()) ?? 0,
      phone: data['phone']?.toString() ?? '',
      firstName: data['first_name']?.toString(),
      lastName: data['last_name']?.toString(),
      registeredAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
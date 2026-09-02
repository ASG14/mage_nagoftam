import 'dart:convert';

import 'package:begir/models/group.dart';
import 'package:begir/services/api_client.dart';

class GroupService {
  static Future<List<Group>> getGroups() async {
    final response = await ApiClient.get(
      'groups/list.php',
    );

    if (response.statusCode == 401) {
      throw Exception('unauthorized');
    }

    if (response.statusCode != 200) {
      throw Exception('server_error');
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message'] ?? 'خطا در دریافت گروه‌ها',
      );
    }

    final groups = result['data']['groups'];

    return (groups as List)
        .map(
          (json) => Group.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
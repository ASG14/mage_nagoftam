import 'dart:convert';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/group_member.dart';

import 'api_client.dart';

class GroupService {
  // Get Groups
  static Future<List<Group>> getGroups() async {
    final response = await ApiClient.get('groups/list.php');

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در دریافت گروه‌ها',
      );
    }

    final groupsData = result['data']?['groups'];

    if (groupsData is! List) {
      throw Exception('invalid_response');
    }

    return groupsData
        .map((item) => Group.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // Create Group
  static Future<Group> createGroup({required String title}) async {
    final response = await ApiClient.post(
      'groups/create.php',
      body: {'title': title},
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در ایجاد گروه',
      );
    }

    final groupId = result['data']?['group']?['id'];

    if (groupId == null) {
      throw Exception('invalid_response');
    }

    final groups = await getGroups();

    try {
      return groups.firstWhere(
        (group) => group.id == int.parse(groupId.toString()),
      );
    } catch (_) {
      throw Exception('invalid_response');
    }
  }

  // Update Group
  static Future<void> updateGroup({
    required int groupId,
    required String title,
  }) async {
    final response = await ApiClient.post(
      'groups/update.php',
      body: {'group_id': groupId, 'title': title},
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در ویرایش گروه',
      );
    }
  }

  // Delete Group
  static Future<void> deleteGroup({required int groupId}) async {
    final response = await ApiClient.delete(
      'groups/delete.php?group_id=$groupId',
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در حذف گروه',
      );
    }
  }

  // Get Members
  static Future<List<GroupMember>> getMembers({
    required int groupId,
  }) async {
    final response = await ApiClient.get(
      'groups/members.php?group_id=$groupId',
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در دریافت اعضای گروه',
      );
    }

    final membersData = result['data']?['members'];

    if (membersData is! List) {
      throw Exception('invalid_response');
    }

    return membersData
        .map(
          (item) =>
              GroupMember.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  // Remove Member
  static Future<void> removeMember({
    required int groupId,
    required int memberId,
  }) async {
    final response = await ApiClient.post(
      'groups/remove_member.php',
      body: {'group_id': groupId, 'member_id': memberId},
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در حذف عضو',
      );
    }
  }

  // Leave Group
  static Future<void> leaveGroup({
    required int groupId,
  }) async {
    final response = await ApiClient.post(
      'groups/leave.php',
      body: {'group_id': groupId},
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(
        _errorFromResponse(
          response,
          fallback: 'server_error',
        ),
      );
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در ترک گروه',
      );
    }
  }

  // Create Invite
  static Future<String> createInvite({required int groupId}) async {
    final response = await ApiClient.post(
      'groups/create_invite.php',
      body: {'group_id': groupId},
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response, fallback: 'server_error'));
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در ایجاد لینک دعوت',
      );
    }

    final token = result['data']?['token'];

    if (token == null || token.toString().isEmpty) {
      throw Exception('invalid_response');
    }

    final tokenString = token.toString().trim();

    if (!_isValidInviteToken(tokenString)) {
      throw Exception('invalid_invite_token');
    }

    return tokenString;
  }

  // Join Group
  static Future<Group> joinGroup({required String token}) async {
    final cleanToken = token.trim();

    if (!_isValidInviteToken(cleanToken)) {
      throw Exception('invalid_invite_token');
    }

    final response = await ApiClient.postForm(
      'groups/join.php',
      body: {'token': cleanToken},
    );

    _handleUnauthorized(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception(
        _errorFromResponse(response, fallback: 'server_error'),
      );
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ?? 'خطا در عضویت در گروه',
      );
    }

    final groupId = result['data']?['group_id'];

    if (groupId == null) {
      throw Exception('invalid_response');
    }

    final groups = await getGroups();

    try {
      return groups.firstWhere(
        (group) => group.id == int.parse(groupId.toString()),
      );
    } catch (_) {
      throw Exception('invalid_response');
    }
  }

  static bool _isValidInviteToken(String token) {
    return RegExp(r'^[A-HJ-NP-Za-hj-km-z2-9]{8}$').hasMatch(token);
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
    } catch (_) {
      // Ignore invalid JSON.
    }

    return fallback;
  }
}
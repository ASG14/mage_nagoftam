import 'dart:convert';

import 'package:mage_nagoftam/models/group.dart';
import 'package:mage_nagoftam/models/group_member.dart';

import 'api_client.dart';

class GroupService {
  // ==================================================
  // Get Groups
  // ==================================================

  static Future<List<Group>> getGroups() async {
    final response = await ApiClient.get(
      'groups/list.php',
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در دریافت گروه‌ها',
      );
    }

    final groupsData =
        result['data']?['groups'];

    if (groupsData is! List) {
      throw Exception(
        'invalid_response',
      );
    }

    return groupsData
        .map(
          (item) => Group.fromJson(
            Map<String, dynamic>.from(
              item as Map,
            ),
          ),
        )
        .toList();
  }

  // ==================================================
  // Create Group
  // ==================================================

  static Future<Group> createGroup({
    required String title,
  }) async {
    final response = await ApiClient.post(
      'groups/create.php',
      body: {
        'title': title,
      },
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در ایجاد گروه',
      );
    }

    /*
     * create.php اطلاعات created_at را
     * برنمی‌گرداند؛ بنابراین پاسخ را مستقیماً
     * به Group تبدیل نمی‌کنیم.
     *
     * بعد از ساخت گروه، لیست گروه‌ها را
     * دوباره از سرور می‌گیریم تا Group کامل
     * همراه با createdAt ساخته شود.
     */

    final groups = await getGroups();

    final createdGroupId = int.parse(
      result['data']['group']['id'].toString(),
    );

    try {
      return groups.firstWhere(
        (group) =>
            group.id == createdGroupId,
      );
    } catch (_) {
      throw Exception(
        'invalid_response',
      );
    }
  }

  // ==================================================
  // Update Group
  // ==================================================

  static Future<void> updateGroup({
    required int groupId,
    required String title,
  }) async {
    final response = await ApiClient.post(
      'groups/update.php',
      body: {
        'group_id': groupId,
        'title': title,
      },
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در ویرایش گروه',
      );
    }
  }

  // ==================================================
  // Delete Group
  // ==================================================

  static Future<void> deleteGroup({
    required int groupId,
  }) async {
    final response = await ApiClient.delete(
      'groups/delete.php?group_id=$groupId',
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در حذف گروه',
      );
    }
  }

  // ==================================================
  // Get Members
  // ==================================================

  static Future<List<GroupMember>>
      getMembers({
    required int groupId,
  }) async {
    final response = await ApiClient.get(
      'groups/members.php?group_id=$groupId',
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در دریافت اعضای گروه',
      );
    }

    final membersData =
        result['data']?['members'];

    if (membersData is! List) {
      throw Exception(
        'invalid_response',
      );
    }

    return membersData
        .map(
          (item) => GroupMember.fromJson(
            Map<String, dynamic>.from(
              item as Map,
            ),
          ),
        )
        .toList();
  }

  // ==================================================
  // Remove Member
  // ==================================================

  static Future<void> removeMember({
    required int groupId,
    required int memberId,
  }) async {
    final response = await ApiClient.post(
      'groups/remove_member.php',
      body: {
        'group_id': groupId,
        'member_id': memberId,
      },
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در حذف عضو',
      );
    }
  }

  // ==================================================
  // Create / Get Stable Invite
  // ==================================================

  static Future<String> createInvite({
    required int groupId,
  }) async {
    final response = await ApiClient.post(
      'groups/create_invite.php',
      body: {
        'group_id': groupId,
      },
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در ایجاد لینک دعوت',
      );
    }

    final token =
        result['data']?['token'];

    if (token == null ||
        token.toString().isEmpty) {
      throw Exception(
        'invalid_response',
      );
    }

    return token.toString();
  }

  // ==================================================
  // Join Group
  // ==================================================

  static Future<Group> joinGroup({
    required String token,
  }) async {
    final response = await ApiClient.postForm(
      'groups/join.php',
      body: {
        'token': token,
      },
    );

    _handleUnauthorized(
      response.statusCode,
    );

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
        result['message']?.toString() ??
            'خطا در عضویت در گروه',
      );
    }

    /*
     * join.php فقط group_id و group_title
     * برمی‌گرداند و created_at / creator_id
     * ندارد.
     *
     * بنابراین بعد از Join، لیست نهایی
     * گروه‌های کاربر را از سرور می‌گیریم
     * و Group کامل را برمی‌گردانیم.
     */

    final groupId = int.parse(
      result['data']['group_id'].toString(),
    );

    final groups = await getGroups();

    try {
      return groups.firstWhere(
        (group) =>
            group.id == groupId,
      );
    } catch (_) {
      throw Exception(
        'invalid_response',
      );
    }
  }

  // ==================================================
  // Unauthorized
  // ==================================================

  static void _handleUnauthorized(
    int statusCode,
  ) {
    if (statusCode == 401) {
      throw Exception(
        'unauthorized',
      );
    }
  }

  // ==================================================
  // API Error
  // ==================================================

  static String _errorFromResponse(
    dynamic response, {
    required String fallback,
  }) {
    try {
      final result =
          jsonDecode(response.body);

      if (result is Map &&
          result['message'] != null) {
        return result['message']
            .toString();
      }
    } catch (_) {
      // Ignore invalid JSON.
    }

    return fallback;
  }
}
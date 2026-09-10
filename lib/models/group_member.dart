enum GroupMemberRole { admin, member }

enum GroupMemberStatus { active, pending, removed }

class GroupMember {
  final int id;
  final int groupId;
  final String phone;
  final String firstName;
  final String lastName;
  final GroupMemberRole role;
  final GroupMemberStatus status;
  final DateTime joinedAt;

  const GroupMember({
    required this.id,
    required this.groupId,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    required this.joinedAt,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();

    return name.isEmpty ? 'کاربر $id' : name;
  }

  bool get isAdmin => role == GroupMemberRole.admin;

  bool get isMember => role == GroupMemberRole.member;

  bool get isActive => status == GroupMemberStatus.active;

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: int.parse(json['id'].toString()),
      groupId: int.parse(json['group_id'].toString()),
      phone: json['phone']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      role: _roleFromString(json['role']?.toString()),
      status: _statusFromString(json['status']?.toString()),
      joinedAt: DateTime.parse(json['joined_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'role': role.name,
      'status': status.name,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  GroupMember copyWith({
    int? id,
    int? groupId,
    String? phone,
    String? firstName,
    String? lastName,
    GroupMemberRole? role,
    GroupMemberStatus? status,
    DateTime? joinedAt,
  }) {
    return GroupMember(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  static GroupMemberRole _roleFromString(String? value) {
    return GroupMemberRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => GroupMemberRole.member,
    );
  }

  static GroupMemberStatus _statusFromString(String? value) {
    return GroupMemberStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => GroupMemberStatus.active,
    );
  }
}

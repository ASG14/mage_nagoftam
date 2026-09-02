class GroupMember {
  final int id;
  final String phone;
  final String firstName;
  final String lastName;
  final DateTime joinedAt;

  const GroupMember({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.joinedAt,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();

    if (name.isEmpty) {
      return 'کاربر $id';
    }

    return name;
  }

  factory GroupMember.fromJson(
    Map<String, dynamic> json,
  ) {
    return GroupMember(
      id: int.parse(
        json['id'].toString(),
      ),
      phone: json['phone']?.toString() ?? '',
      firstName:
          json['first_name']?.toString() ?? '',
      lastName:
          json['last_name']?.toString() ?? '',
      joinedAt: DateTime.parse(
        json['joined_at'].toString(),
      ),
    );
  }
}
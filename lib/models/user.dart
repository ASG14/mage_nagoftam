class User {
  final int id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final DateTime registeredAt;

  const User({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    required this.registeredAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _parseInt(json['id']) ?? 0,
      phone: json['phone']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      registeredAt:
          _parseDate(json['registered_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'registered_at': registeredAt.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? phone,
    String? firstName,
    String? lastName,
    DateTime? registeredAt,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }

  String get fullName {
    final name = '$firstName $lastName'.trim();

    if (name.isEmpty) {
      return 'کاربر $id';
    }

    return name;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    return int.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}

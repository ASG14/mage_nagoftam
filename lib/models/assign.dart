enum AssignmentStatus { active, cancelled, completed }

class Assign {
  final int orderId;
  final int userId;
  final AssignmentStatus status;
  final DateTime assignedAt;

  const Assign({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.assignedAt,
  });

  factory Assign.fromJson(Map<String, dynamic> json) {
    return Assign(
      orderId: _parseInt(json['order_id']) ?? 0,
      userId: _parseInt(json['user_id']) ?? 0,
      status: _statusFromString(json['status']?.toString()),
      assignedAt:
          _parseDate(json['assigned_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'status': status.name,
      'assigned_at': assignedAt.toIso8601String(),
    };
  }

  Assign copyWith({
    int? orderId,
    int? userId,
    AssignmentStatus? status,
    DateTime? assignedAt,
  }) {
    return Assign(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    return int.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }

  static AssignmentStatus _statusFromString(String? value) {
    return AssignmentStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => AssignmentStatus.active,
    );
  }
}

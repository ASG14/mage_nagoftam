import 'assign.dart';

enum Status { pending, reserved, completed, cancelled }

enum Priority { low, medium, high }

class Order {
  final int id;
  final int groupId;
  final int createdBy;

  final String title;
  final String? quantity;

  final Priority priority;
  final Status status;

  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime? updatedAt;

  final Assign? assignment;

  const Order({
    required this.id,
    required this.groupId,
    required this.createdBy,
    required this.title,
    this.quantity,
    required this.priority,
    required this.status,
    this.deadline,
    required this.createdAt,
    this.updatedAt,
    this.assignment,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final assignedUserId = _parseInt(json['assigned_user_id']);

    Assign? assignment;

    if (assignedUserId != null) {
      assignment = Assign(
        orderId: _parseInt(json['id']) ?? 0,
        userId: assignedUserId,
        status: AssignmentStatus.active,
        assignedAt:
            _parseDate(json['updated_at']) ??
            _parseDate(json['created_at']) ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );
    }

    return Order(
      id: _parseInt(json['id']) ?? 0,
      groupId: _parseInt(json['group_id']) ?? 0,
      createdBy: _parseInt(json['created_by']) ?? 0,
      title: json['title']?.toString() ?? '',
      quantity: json['quantity']?.toString(),
      priority: _priorityFromString(json['priority']?.toString()),
      status: _statusFromString(json['status']?.toString()),
      deadline: _parseDate(json['deadline']),
      createdAt:
          _parseDate(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _parseDate(json['updated_at']),
      assignment: assignment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'created_by': createdBy,
      'title': title,
      'quantity': quantity,
      'priority': priority.name,
      'status': status.name,
      'deadline': deadline?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'assigned_user_id': assignment?.userId,
      'assigned_user_name': null,
    };
  }

  Order copyWith({
    int? id,
    int? groupId,
    int? createdBy,
    String? title,
    String? quantity,
    Priority? priority,
    Status? status,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    Assign? assignment,
  }) {
    return Order(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      createdBy: createdBy ?? this.createdBy,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignment: assignment ?? this.assignment,
    );
  }

  bool isPending() {
    return status == Status.pending;
  }

  bool isReserved() {
    return status == Status.reserved;
  }

  bool isCompleted() {
    return status == Status.completed;
  }

  bool isCancelled() {
    return status == Status.cancelled;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    return int.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }

  static Priority _priorityFromString(String? value) {
    return Priority.values.firstWhere(
      (priority) => priority.name == value,
      orElse: () => Priority.medium,
    );
  }

  static Status _statusFromString(String? value) {
    return Status.values.firstWhere(
      (status) => status.name == value,
      orElse: () => Status.pending,
    );
  }
}

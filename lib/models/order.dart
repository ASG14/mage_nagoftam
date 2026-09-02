enum Status {
  pending,
  reserved,
  completed,
  cancelled,
}

enum Priority {
  low,
  medium,
  high,
}

class Order {
  final int id;
  final int groupId;
  final int createdBy;

  String title;
  String? quantity;

  Priority priority;
  Status status;

  DateTime? deadline;
  final DateTime createdAt;
  DateTime? updatedAt;

  int? assignedUserId;
  String? assignedUserName;

  Order({
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
    this.assignedUserId,
    this.assignedUserName,
  });

  factory Order.fromJson(
    Map<String, dynamic> json,
  ) {
    return Order(
      id: int.parse(
        json['id'].toString(),
      ),
      groupId: int.parse(
        json['group_id'].toString(),
      ),
      createdBy: int.parse(
        json['created_by'].toString(),
      ),
      title: json['title'].toString(),
      quantity: json['quantity']?.toString(),
      priority: _priorityFromString(
        json['priority'].toString(),
      ),
      status: _statusFromString(
        json['status'].toString(),
      ),
      deadline: _parseDate(
        json['deadline'],
      ),
      createdAt: DateTime.parse(
        json['created_at'].toString(),
      ),
      updatedAt: _parseDate(
        json['updated_at'],
      ),
      assignedUserId:
          json['assigned_user_id'] != null
              ? int.parse(
                  json['assigned_user_id'].toString(),
                )
              : null,
      assignedUserName:
          json['assigned_user_name']?.toString(),
    );
  }

  static DateTime? _parseDate(
    dynamic value,
  ) {
    if (value == null ||
        value.toString().isEmpty) {
      return null;
    }

    return DateTime.parse(
      value.toString(),
    );
  }

  static Priority _priorityFromString(
    String value,
  ) {
    switch (value) {
      case 'low':
        return Priority.low;

      case 'high':
        return Priority.high;

      default:
        return Priority.medium;
    }
  }

  static Status _statusFromString(
    String value,
  ) {
    switch (value) {
      case 'reserved':
        return Status.reserved;

      case 'completed':
        return Status.completed;

      case 'cancelled':
        return Status.cancelled;

      default:
        return Status.pending;
    }
  }

  bool get isPending =>
      status == Status.pending;

  bool get isReserved =>
      status == Status.reserved;

  bool get isCompleted =>
      status == Status.completed;

  bool get isCancelled =>
      status == Status.cancelled;
}
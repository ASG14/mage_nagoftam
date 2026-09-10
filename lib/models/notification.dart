class AppNotification {
  final int id;
  final String type;
  final String title;
  final String message;
  final int? groupId;
  final int? orderId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.groupId,
    this.orderId,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: int.parse(json['id'].toString()),
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      groupId: _parseInt(json['group_id']),
      orderId: _parseInt(json['order_id']),
      isRead: _parseBool(json['is_read']),
      createdAt: DateTime.parse(json['created_at'].toString()),
      readAt: _parseDate(json['read_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'group_id': groupId,
      'order_id': orderId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  AppNotification copyWith({
    int? id,
    String? type,
    String? title,
    String? message,
    int? groupId,
    int? orderId,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      groupId: groupId ?? this.groupId,
      orderId: orderId ?? this.orderId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return null;
    }

    return int.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    return value == true ||
        value == 1 ||
        value.toString().toLowerCase() == 'true' ||
        value.toString() == '1';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }
}

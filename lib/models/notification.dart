class AppNotification {
  final int id;

  final int? actorUserId;
  final String actorName;

  final String type;
  final String title;
  final String message;

  final int? groupId;
  final String? groupTitle;

  final int? orderId;
  final String? orderTitle;

  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const AppNotification({
    required this.id,
    required this.actorUserId,
    required this.actorName,
    required this.type,
    required this.title,
    required this.message,
    required this.groupId,
    required this.groupTitle,
    required this.orderId,
    required this.orderTitle,
    required this.isRead,
    required this.createdAt,
    required this.readAt,
  });

  factory AppNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppNotification(
      id: _parseInt(json['id']) ?? 0,

      actorUserId: _parseInt(json['actor_user_id']),
      actorName: json['actor_name']?.toString() ?? '',

      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',

      groupId: _parseInt(json['group_id']),
      groupTitle: json['group_title']?.toString(),

      orderId: _parseInt(json['order_id']),
      orderTitle: json['order_title']?.toString(),

      isRead: _parseBool(json['is_read']),

      createdAt:
          _parseDate(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),

      readAt: _parseDate(json['read_at']),
    );
  }

  AppNotification copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id,
      actorUserId: actorUserId,
      actorName: actorName,
      type: type,
      title: title,
      message: message,
      groupId: groupId,
      groupTitle: groupTitle,
      orderId: orderId,
      orderTitle: orderTitle,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
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

    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
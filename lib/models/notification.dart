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
    required this.groupId,
    required this.orderId,
    required this.isRead,
    required this.createdAt,
    required this.readAt,
  });

  factory AppNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppNotification(
      id: int.parse(json['id'].toString()),
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      groupId: json['group_id'] != null
          ? int.parse(json['group_id'].toString())
          : null,
      orderId: json['order_id'] != null
          ? int.parse(json['order_id'].toString())
          : null,
      isRead: json['is_read'] == true ||
          json['is_read'].toString() == '1',
      createdAt: DateTime.parse(
        json['created_at'].toString(),
      ),
      readAt: json['read_at'] != null
          ? DateTime.parse(
              json['read_at'].toString(),
            )
          : null,
    );
  }

  AppNotification copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      groupId: groupId,
      orderId: orderId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}
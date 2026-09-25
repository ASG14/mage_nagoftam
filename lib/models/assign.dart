class Assign {
  final int orderId;
  final int userId;

  const Assign({
    required this.orderId,
    required this.userId,
  });

  factory Assign.fromJson(Map<String, dynamic> json) {
    return Assign(
      orderId: _parseInt(json['order_id']) ?? 0,
      userId: _parseInt(json['user_id']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
    };
  }

  Assign copyWith({
    int? orderId,
    int? userId,
  }) {
    return Assign(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}
class Group {
  final int id;
  final String title;
  final int creatorId;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.title,
    required this.creatorId,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: int.parse(json['id'].toString()),
      title: json['title']?.toString() ?? '',
      creatorId: int.parse(json['creator_id'].toString()),
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'creator_id': creatorId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Group copyWith({
    int? id,
    String? title,
    int? creatorId,
    DateTime? createdAt,
  }) {
    return Group(
      id: id ?? this.id,
      title: title ?? this.title,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

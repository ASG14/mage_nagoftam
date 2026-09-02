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
      title: json['title'].toString(),
      creatorId: int.parse(json['creator_id'].toString()),
      createdAt: DateTime.parse(
        json['created_at'].toString(),
      ),
    );
  }
}
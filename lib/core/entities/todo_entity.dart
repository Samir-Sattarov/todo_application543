class TodoEntity {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isDone;

  TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isDone,
  });

  factory TodoEntity.empty() {
    return TodoEntity(
      title: "",
      description: "",
      createdAt: DateTime.now(),
      isDone: false,
      id: DateTime.now().millisecondsSinceEpoch,
    );
  }

  TodoEntity copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isDone,
  }) {
    return TodoEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
    );
  }

  factory TodoEntity.fromJson(Map<String, dynamic> json) {
    return TodoEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      isDone: json['isDone'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['createdAt'] = createdAt.toIso8601String();
    data['isDone'] = isDone;

    return data;
  }
}

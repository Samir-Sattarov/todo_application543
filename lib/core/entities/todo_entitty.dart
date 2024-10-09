class TodoEntity {
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isDone;

  TodoEntity({
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
    );
  }

  TodoEntity copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isDone,
  }) {
    return TodoEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}

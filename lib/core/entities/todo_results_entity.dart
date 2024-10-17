import 'package:todo_application/core/entities/todo_entity.dart';

class TodoResultsEntity {
  final List<TodoEntity> listTodo;

  TodoResultsEntity({required this.listTodo});

  factory TodoResultsEntity.fromJson(List<dynamic> data) {
    return TodoResultsEntity(
      listTodo: data.map((element) => TodoEntity.fromJson(Map<String, dynamic>.from(element))).toList(),
    );
  }
}

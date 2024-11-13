part of 'load_todo_cubit.dart';

@immutable
sealed class LoadTodoState {}

final class LoadTodoInitial extends LoadTodoState {}

final class LoadTodoLoading extends LoadTodoState {}

final class LoadTodoError extends LoadTodoState {
  final String message;

  LoadTodoError(this.message);
}

final class LoadTodoLoaded extends LoadTodoState {
  final List<TodoEntity> listTodo;

  LoadTodoLoaded(this.listTodo);
}

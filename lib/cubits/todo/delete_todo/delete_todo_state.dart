part of 'delete_todo_cubit.dart';

@immutable
sealed class DeleteTodoState {}

final class DeleteTodoInitial extends DeleteTodoState {}

final class DeleteTodoLoading extends DeleteTodoState {}

final class DeleteTodoError extends DeleteTodoState {
  final String message;

  DeleteTodoError(this.message);
}

final class DeleteTodoSuccess extends DeleteTodoState {
  final TodoEntity todo;

  DeleteTodoSuccess(this.todo);
}

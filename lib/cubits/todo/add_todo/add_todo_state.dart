part of 'add_todo_cubit.dart';

@immutable
sealed class AddTodoState {}

final class AddTodoInitial extends AddTodoState {}

final class AddTodoLoading extends AddTodoState {}

final class AddTodoError extends AddTodoState {
  final String message;

  AddTodoError(this.message);
}

final class AddTodoSuccess extends AddTodoState {
  final TodoEntity todo;

  AddTodoSuccess(this.todo);
}

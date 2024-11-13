part of 'edit_todo_cubit.dart';

@immutable
sealed class EditTodoState {}

final class EditTodoInitial extends EditTodoState {}

final class EditTodoLoading extends EditTodoState {}

final class EditTodoError extends EditTodoState {
  final String message;

  EditTodoError(this.message);
}

final class EditTodoSuccess extends EditTodoState {
  final TodoEntity todo;

  EditTodoSuccess(this.todo);
}

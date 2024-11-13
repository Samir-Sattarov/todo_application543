import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_application/core/api/firebase_api_client.dart';
import 'package:todo_application/core/api/firebase_api_contants.dart';

import '../../../core/entities/todo_entity.dart';

part 'edit_todo_state.dart';

class EditTodoCubit extends Cubit<EditTodoState> {
  final FirebaseApiClient client;
  EditTodoCubit(this.client) : super(EditTodoInitial());

  edit(TodoEntity todo) async {
    emit(EditTodoLoading());

    try {
      await client.update(FirebaseApiContants.tTodos, todo.toJson());
      emit(EditTodoSuccess(todo));
    } catch (error) {
      emit(EditTodoError(error.toString()));
    }
  }
}

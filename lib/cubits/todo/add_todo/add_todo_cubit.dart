import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_application/core/api/firebase_api_contants.dart';

import '../../../core/api/firebase_api_client.dart';
import '../../../core/entities/todo_entity.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  final FirebaseApiClient client;

  AddTodoCubit(this.client) : super(AddTodoInitial());

  add(TodoEntity todo) async {
    emit(AddTodoLoading());
    try {
      await client.post(FirebaseApiContants.tTodos, todo.toJson());

      emit(AddTodoSuccess(todo));
    } catch (error) {
      emit(AddTodoError(error.toString()));
    }
  }
}

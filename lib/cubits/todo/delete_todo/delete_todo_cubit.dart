import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import '../../../core/api/firebase_api_client.dart';
import '../../../core/api/firebase_api_contants.dart';
import '../../../core/entities/todo_entity.dart';

part 'delete_todo_state.dart';

class DeleteTodoCubit extends Cubit<DeleteTodoState> {
  final FirebaseApiClient client;

  DeleteTodoCubit(this.client) : super(DeleteTodoInitial());

  delete(TodoEntity entity) async {
    emit(DeleteTodoLoading());

    try {
      await client.delete(FirebaseApiContants.tTodos, entity.id.toString());

      emit(DeleteTodoSuccess(entity));
    } catch (error) {
      emit(DeleteTodoError(error.toString()));
    }
  }
}

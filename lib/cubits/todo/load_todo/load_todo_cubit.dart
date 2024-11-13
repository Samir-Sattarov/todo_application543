import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_application/core/api/firebase_api_client.dart';
import 'package:todo_application/core/api/firebase_api_contants.dart';

import '../../../core/entities/todo_entity.dart';

part 'load_todo_state.dart';

class LoadTodoCubit extends Cubit<LoadTodoState> {
  final FirebaseApiClient client;
  LoadTodoCubit(this.client) : super(LoadTodoInitial());


  bool isDoneLocal = false;

  load({bool isDone = false}) async {
    isDoneLocal = isDone;
    emit(LoadTodoLoading());
    try {
      final List<FirebaseFilterEntity> filters = [
        FirebaseFilterEntity(
          field: "isDone",
          operator: FirebaseApiFilterType.isEqualTo,
          value: isDoneLocal,
        ),
      ];

      final listJson = await client.getAll(
        FirebaseApiContants.tTodos,
        filters: filters,
      );

      final List<TodoEntity> listTodo =
          List.from(listJson).map((json) => TodoEntity.fromJson(json)).toList();

      emit(LoadTodoLoaded(listTodo));
    } catch (error) {
      emit(LoadTodoError(error.toString()));
    }
  }

  search({String query = ""}) async {
    try {
      final List<FirebaseFilterEntity> filters = [
        FirebaseFilterEntity(
          field: "isDone",
          operator: FirebaseApiFilterType.isEqualTo,
          value: isDoneLocal,
        ),
        FirebaseFilterEntity(
          field: "title",
          operator: FirebaseApiFilterType.isEqualTo,
          value: query,
        ),
      ];

      final listJson = await client.getAll(
        FirebaseApiContants.tTodos,
        filters: filters,
      );

      final List<TodoEntity> listTodo =
          List.from(listJson).map((json) => TodoEntity.fromJson(json)).toList();

      emit(LoadTodoLoaded(listTodo));
    } catch (error) {
      emit(LoadTodoError(error.toString()));
    }
  }
}

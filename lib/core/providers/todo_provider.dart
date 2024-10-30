import 'package:flutter/cupertino.dart';
import 'package:todo_application/core/api/firebase_api_client.dart';
import 'package:todo_application/core/api/firebase_api_contants.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/core/utils/use_debounce.dart';

import '../entities/todo_entity.dart';
import '../entities/todo_results_entity.dart';

class TodoProvider extends ChangeNotifier {
  final FirebaseApiClient client;
  final UseDebounce useDebounce;

  TodoProvider(this.client, this.useDebounce);

  List<TodoEntity> _listTodo = [];

  List<TodoEntity> get listTodo => _listTodo;

  String _collection = FirebaseApiContants.tTodos;

  set collection(String data) => _collection = data;

  load({int limit = 10, String query = "", bool isDone = false}) async {
    final List<FirebaseFilterEntity> filters = [
      FirebaseFilterEntity(
          field: "isDone",
          operator: FirebaseApiFilterType.isEqualTo,
          value: isDone)
    ];
    _listTodo.clear();

    if (query.isNotEmpty) {
      filters.add(FirebaseFilterEntity(
          field: "title",
          operator: FirebaseApiFilterType.isEqualTo,
          value: query));
    }
    final listJson = await client.getAll(_collection, filters: filters);

    _listTodo =
        List.from(listJson).map((json) => TodoEntity.fromJson(json)).toList();

    notifyListeners();
  }

  search(String text) async {
    load(query: text);
  }

  onDone(TodoEntity entity) async {
    final newData = entity.copyWith(isDone: true);

    await client.update(_collection, newData.toJson());
    _listTodo.remove(entity);
    load();
    notifyListeners();
  }

  add(TodoEntity entity) async {
    await client.post(_collection, entity.toJson());
    _listTodo.insert(0, entity);

    notifyListeners();
  }

  edit(TodoEntity entity) async {
    await client.update(_collection, entity.toJson());

    final index = _listTodo.indexWhere((element) => element.id == entity.id);
    _listTodo[index] = entity;
    notifyListeners();
  }

  delete(TodoEntity entity) async {
    await client.delete(_collection, entity.id.toString());
    _listTodo.remove(entity);
    notifyListeners();
  }
}

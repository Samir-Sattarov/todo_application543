import 'package:flutter/cupertino.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/core/utils/use_debounce.dart';

import '../entities/todo_entity.dart';
import '../entities/todo_results_entity.dart';

class TodoProvider extends ChangeNotifier {
  final StorageService storageService;
  final UseDebounce useDebounce;

  TodoProvider(this.storageService, this.useDebounce);

  List<TodoEntity> _listTodo = [];

  List<TodoEntity> get listTodo => _listTodo;

  Future<TodoResultsEntity> _loadDataFromBox(String key,
      {int limit = 10}) async {
    final response = await storageService.getDataFromBox(key, count: limit);

    final results = TodoResultsEntity.fromJson(List.from(response));

    return results;
  }

  load(String key, {int limit = 10}) async {
    final results = await _loadDataFromBox(key, limit: limit);
    _listTodo = results.listTodo;

    notifyListeners();
  }

  search(String key, String text) {
    if (text.isEmpty) {
      load(key);
      return;
    }

    useDebounce.run(
      () async {
        final results = await _loadDataFromBox(key);

        final formattedData = results.listTodo
            .where((element) => element.title.contains(text))
            .toList();

        _listTodo = formattedData;
        notifyListeners();
      },
    );
  }

  onDone(TodoEntity entity, {bool isAlreadyDone = false}) async {

    final String completedList = StorageKeys.kCompletedTodoList;
    final String todoList = StorageKeys.kTodoList;

    await storageService.add(
      isAlreadyDone ? todoList : completedList,
      value: entity.toJson(),
    );

    _listTodo.removeWhere((element) => element.id == entity.id);

    await storageService.delete(
      isAlreadyDone ? completedList : todoList,
      entity.id.toString(),
    );

    notifyListeners();
  }

  add(TodoEntity entity) async {
    _listTodo.insert(0, entity);

    await storageService.add(
      StorageKeys.kTodoList,
      value: entity.toJson(),
    );

    notifyListeners();
  }

  edit(TodoEntity entity) async {
    await storageService.edit(
      StorageKeys.kTodoList,
      value: entity.toJson(),
    );

    // TODO: change data inside List!!!

    notifyListeners();

  }

    delete(TodoEntity entity) async {
    await storageService.delete(
      StorageKeys.kTodoList,
      entity.id.toString(),
    );

    _listTodo.remove(entity);

    notifyListeners();
  }
}

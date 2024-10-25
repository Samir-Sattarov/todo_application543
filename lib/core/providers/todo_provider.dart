import 'package:flutter/cupertino.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/core/utils/use_debounce.dart';

import '../entities/todo_entity.dart';
import '../entities/todo_results_entity.dart';
import 'package:collection/collection.dart';

class TodoProvider extends ChangeNotifier {
  final StorageService storageService;
  final UseDebounce useDebounce;

  TodoProvider(this.storageService, this.useDebounce);

  List<TodoEntity> _listTodo = [];

  List<TodoEntity> get listTodo => _listTodo;

  String _boxKey = StorageKeys.kTodoList;

  set boxKey(String data) => _boxKey = data;

  Future<TodoResultsEntity> _loadDataFromBox({int limit = 10}) async {
    final response = await storageService.getDataFromBox(_boxKey, count: limit);

    final results = TodoResultsEntity.fromJson(List.from(response));

    return results;
  }

  load({int limit = 10}) async {
    final results = await _loadDataFromBox(limit: limit);
    _listTodo = results.listTodo;

    notifyListeners();
  }

  search(String text) {
    if (text.isEmpty) {
      load();
      return;
    }

    useDebounce.run(
      () async {
        final results = await _loadDataFromBox();

        final formattedData = results.listTodo
            .where((element) => element.title.contains(text))
            .toList();

        _listTodo = formattedData;
        notifyListeners();
      },
    );
  }

  onDone(TodoEntity entity, {required String from, required String to}) async {
    await storageService.add(
      to,
      value: entity.toJson(),
    );

    _listTodo.removeWhere((element) => element.id == entity.id);

    await storageService.delete(
      from,
      entity.id.toString(),
    );

    notifyListeners();
  }

  add(TodoEntity entity) async {
    _listTodo.insert(0, entity);

    await storageService.add(
      _boxKey,
      value: entity.toJson(),
    );

    notifyListeners();
  }

  edit(TodoEntity entity) async {
    await storageService.edit(
      _boxKey,
      value: entity.toJson(),
    );

    final index = _listTodo.indexWhere((element) => element.id == entity.id);
    _listTodo[index] = entity;

    notifyListeners();
  }

  delete(TodoEntity entity) async {
    await storageService.delete(
      _boxKey,
      entity.id.toString(),
    );

    _listTodo.remove(entity);

    notifyListeners();
  }
}

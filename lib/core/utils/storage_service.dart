import 'dart:developer';

import 'package:hive/hive.dart';

abstract class StorageService {
  Future<dynamic> get(String boxName, String key);
  Future<dynamic> delete(String boxName, String key);
  Future<void> put(
    String boxName, {
    required String key,
    required dynamic value,
  });

  Future<void> add(
    String boxName, {
    required dynamic value,
  });

  Future<void> edit(
    String boxName, {
    required dynamic value,
  });

  Future<void> deleteFromDisk(String boxName);

  Future<List<dynamic>> getDataFromBox(String boxName, {int? count = 10});
}

class StorageServiceImpl extends StorageService {
  StorageServiceImpl() {
    print("Hello");
  }

  Future<Box> _initBox(String boxName) async {
    final box = await Hive.openBox(boxName);

    return box;
  }

  @override
  get(String boxName, String key) async {
    log("Get data from box: $boxName, key $key", name: "STORAGE SERVICE");
    final box = await _initBox(boxName);

    final data = await box.get(key);

    return data;
  }

  @override
  put(
    String boxName, {
    required String key,
    required dynamic value,
  }) async {
    final box = await _initBox(boxName);
    log("Put data to $boxName key: $key, value: $value");
    await box.put(key, value);
  }

  @override
  Future delete(String boxName, String key) async {
    final box = await _initBox(boxName);
    await box.delete(key);
  }

  @override
  Future<void> deleteFromDisk(String boxName) async {
    final box = await _initBox(boxName);

    await box.deleteFromDisk();
  }

  @override
  Future<void> add(String boxName, {required value}) async {
    final box = await _initBox(boxName);

    log("Add data to box $boxName,\nvalue: $value");

    await box.put(value['id'].toString(), value);
  }

  @override
  Future<List> getDataFromBox(String boxName, {int? count = 10}) async {
    final box = await _initBox(boxName);

    final listData = box.values.toList();

    log(box.keys.toList().toString(), name: "All keys from box $boxName");
    print("All keys from box $boxName ${box.keys.toList()}");

    return listData;
  }

  @override
  Future<void> edit(String boxName, {required value}) async {
    await put(boxName, key: value['id'].toString(), value: value);
  }
}

import 'dart:developer';

import 'package:hive/hive.dart';

abstract class StorageService {
  Future<dynamic> get(String boxName, String key);
  Future<dynamic> delete(String boxName, String key);
  Future<void> put(
    String boxName, {
    required String key,
    required String value,
  });

  Future<void> deleteFromDisk(String boxName);
}

class StorageServiceImpl extends StorageService {
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
    required String value,
  }) async {
    final box = await _initBox(boxName);

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

    box.deleteFromDisk();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';

class ThemeHelper extends ChangeNotifier{
  final StorageService storageService;
  ThemeHelper(this.storageService) {
    load();
  }

  bool _isDark = false;

  bool get isDark => _isDark;

  load() async {
    final databaseTheme = await storageService.get(StorageKeys.kApp, "theme");
    print("load theme from box $databaseTheme");
    if (databaseTheme == null) {
      return;
    }

    _isDark = databaseTheme;
  }

  toggle() async {
    _isDark = !_isDark;
notifyListeners();
    await storageService.put(StorageKeys.kApp, key: "theme", value: _isDark);
  }
}

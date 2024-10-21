import 'package:get_it/get_it.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/core/utils/theme_helper.dart';

final GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(),
  );

  locator.registerLazySingleton(
    () => ThemeHelper(locator()),
  );
}

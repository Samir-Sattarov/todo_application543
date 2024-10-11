import 'package:get_it/get_it.dart';
import 'package:todo_application/core/utils/storage_service.dart';

import 'core/utils/test_service.dart';

final locator = GetIt.I;

void setup() {
  locator.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(),
  );

  locator.registerLazySingleton(
    () => TestService(storageService: locator()),
  );
}

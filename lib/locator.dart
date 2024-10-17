import 'package:get_it/get_it.dart';
import 'package:todo_application/core/utils/storage_service.dart';

final GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(),
  );
}

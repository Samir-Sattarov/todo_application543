import 'package:get_it/get_it.dart';
import 'package:todo_application/core/providers/todo_provider.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/core/utils/use_debounce.dart';

final GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(),
  );


  locator.registerLazySingleton(
        () => UseDebounce(milliseconds: 250),
  );



  locator.registerLazySingleton(
        () => TodoProvider(locator(),locator())
  );
}

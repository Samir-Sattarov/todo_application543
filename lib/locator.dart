import 'package:get_it/get_it.dart';
import 'package:todo_application/core/providers/todo_provider.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/core/utils/use_debounce.dart';
import 'package:todo_application/cubits/todo/delete_todo/delete_todo_cubit.dart';

import 'core/api/firebase_api_client.dart';
import 'cubits/todo/add_todo/add_todo_cubit.dart';
import 'cubits/todo/edit_todo/edit_todo_cubit.dart';
import 'cubits/todo/load_todo/load_todo_cubit.dart';

final GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(),
  );

  locator.registerLazySingleton(
    () => UseDebounce(milliseconds: 250),
  );

  locator.registerLazySingleton(() => TodoProvider(locator(), locator()));

  locator.registerLazySingleton<FirebaseApiClient>(
    () => FirebaseApiClientImpl(),
  );

  locator.registerFactory(() => DeleteTodoCubit(locator()));
  locator.registerFactory(() => AddTodoCubit(locator()));
  locator.registerFactory(() => EditTodoCubit(locator()));
  locator.registerFactory(() => LoadTodoCubit(locator()));
}

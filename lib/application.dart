import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/core/providers/todo_provider.dart';
import 'package:todo_application/cubits/todo/delete_todo/delete_todo_cubit.dart';
import 'package:todo_application/screens/home_screen.dart';

import 'cubits/todo/add_todo/add_todo_cubit.dart';
import 'cubits/todo/edit_todo/edit_todo_cubit.dart';
import 'cubits/todo/load_todo/load_todo_cubit.dart';
import 'locator.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late TodoProvider todoProvider;
  late DeleteTodoCubit deleteTodoCubit;
  late AddTodoCubit addTodoCubit;
  late EditTodoCubit editTodoCubit;
  late LoadTodoCubit loadTodoCubit;

  @override
  void initState() {
    todoProvider = locator();
    deleteTodoCubit = locator();
    addTodoCubit = locator();
    editTodoCubit = locator();
    loadTodoCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: todoProvider),
        BlocProvider.value(value: deleteTodoCubit),
        BlocProvider.value(value: addTodoCubit),
        BlocProvider.value(value: editTodoCubit),
        BlocProvider.value(value: loadTodoCubit),
      ],
      child: ScreenUtilInit(
        designSize: Size(414, 896),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black45,
              useMaterial3: false,
            ),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

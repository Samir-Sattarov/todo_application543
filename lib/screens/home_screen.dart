import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/core/api/firebase_api_client.dart';
import 'package:todo_application/core/api/firebase_api_contants.dart';
import 'package:todo_application/core/providers/todo_provider.dart';
import 'package:todo_application/core/utils/app_colors.dart';
import 'package:todo_application/core/utils/assets.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/widgets/success_flush_bar.dart';
import 'package:todo_application/cubits/todo/add_todo/add_todo_cubit.dart';
import 'package:todo_application/cubits/todo/delete_todo/delete_todo_cubit.dart';
import 'package:todo_application/cubits/todo/edit_todo/edit_todo_cubit.dart';
import 'package:todo_application/cubits/todo/load_todo/load_todo_cubit.dart';
import 'package:todo_application/screens/completed_todo_screen.dart';
import 'package:todo_application/widgets/text_form_field_widget.dart';
import 'package:todo_application/widgets/todo_card_widget.dart';

import '../core/entities/todo_entity.dart';
import '../locator.dart';
import 'edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  final TextEditingController controllerSearch = TextEditingController();
  late FirebaseApiClient apiClient;

  List<TodoEntity> listTodo = [];

  @override
  void initState() {
    load();
    super.initState();
  }

  load() {
    context.read<LoadTodoCubit>().load();
  }

  _delete(TodoEntity todo) {
    context.read<DeleteTodoCubit>().delete(todo);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          title: Text("TODO APP 543"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditTodoScreen(
                      onSave: (TodoEntity entity) async {
                        BlocProvider.of<AddTodoCubit>(context).add(entity);
                      },
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: load,
            ),
            IconButton(
              icon: Icon(Icons.check_box),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletedTodoScreen(),
                  ),
                );
              },
            )
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AddTodoCubit, AddTodoState>(
              listener: (context, state) {
                if (state is AddTodoError) {
                  print('Error ${state.message}');
                }

                if (state is AddTodoSuccess) {
                  SuccessFlushBar("Успешно добавленно!!!! ${state.todo.title}")
                      .show(context);
                  listTodo.add(state.todo);

                  if (mounted) {
                    Future.delayed(
                      Duration.zero,
                      () {
                        setState(() {});
                      },
                    );
                  }
                }
              },
            ),
            BlocListener<DeleteTodoCubit, DeleteTodoState>(
              listener: (context, state) async {
                if (state is DeleteTodoError) {
                  print("Error delete todo ${state.message}");
                }

                if (state is DeleteTodoSuccess) {
                  SuccessFlushBar("Успешно удалено!! ${state.todo.title}")
                      .show(context);
                  listTodo.remove(state.todo);
                  if (mounted) {
                    Future.delayed(
                      Duration.zero,
                      () {
                        setState(() {});
                      },
                    );
                  }
                }
              },
            ),
            BlocListener<EditTodoCubit, EditTodoState>(
              listener: (context, state) {
                if (state is EditTodoError) {
                  print('Error ${state.message}');
                }

                if (state is EditTodoSuccess) {
                  final todo = state.todo;
                  SuccessFlushBar("Успешно измененно!!!! ${todo.title}")
                      .show(context);
                  final index =
                      listTodo.indexWhere((element) => element.id == todo.id);
                  if (index != -1) {
                    listTodo[index] = todo;
                    if (mounted) {
                      Future.delayed(
                        Duration.zero,
                        () {
                          setState(() {});
                        },
                      );
                    }
                  }
                }
              },
            ),
          ],
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormFieldWidget(
                    controller: controllerSearch,
                    hintText: "Search by title",
                    onChanged: (text) {
                      context.read<LoadTodoCubit>().search(query: text);
                    },
                  ),
                ),
                Expanded(
                  child: BlocConsumer<LoadTodoCubit, LoadTodoState>(
                    listener: (context, state) async {
                      if (state is LoadTodoError) {
                        print("Load todo error ${state.message}");
                      }
                  
                      if (state is LoadTodoLoaded) {
                        listTodo = state.listTodo;
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadTodoLoading) {
                        return Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      return listTodo.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Добавьте задачу!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: Lottie.asset(
                                      Assets.kEmpty,
                                      frameRate: FrameRate(120),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: listTodo.length,
                              padding: EdgeInsets.all(10.r),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 15.h),
                              itemBuilder: (context, index) {
                                final todo = listTodo[index];
                                return Slidable(
                                  key: const ValueKey(0),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    dismissible: DismissiblePane(
                                        onDismissed: () => _delete(todo)),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                        onPressed: (BuildContext context) =>
                                            _delete(todo),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    child: TodoCardWidget(
                                      entity: todo,
                                      onDone: (todoEntity) {
                                        print(
                                            "todo on done state ${todoEntity.isDone}");
                                        BlocProvider.of<EditTodoCubit>(context)
                                            .edit(todoEntity);
                                        listTodo.remove(todo);
                                        setState(() {});
                                      },
                                      onDelete: () {
                                        _delete(todo);
                                      },
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditTodoScreen(
                                            onSave:
                                                (TodoEntity editedTodo) async {
                                              context
                                                  .read<EditTodoCubit>()
                                                  .edit(editedTodo);
                                            },
                                            entity: todo,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

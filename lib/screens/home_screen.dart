import 'package:flutter/material.dart';
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

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    context.read<TodoProvider>().collection = FirebaseApiContants.tTodos;
    load();
  }

  load() {
    context.read<TodoProvider>().load();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.read<TodoProvider>();
    final listTodo = context.watch<TodoProvider>().listTodo;
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
                        todoProvider.add(entity);
                      },
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                load();
              },
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
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormFieldWidget(
                controller: controllerSearch,
                hintText: "Search by title",
                onChanged: (text) {
                  todoProvider.search(text);
                },
              ),
            ),
            Expanded(
              child: listTodo.isEmpty
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
                            dismissible: DismissiblePane(onDismissed: () {
                              todoProvider.delete(todo);
                            }),
                            children: [
                              SlidableAction(
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (BuildContext context) {
                                  todoProvider.delete(todo);
                                },
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            child: TodoCardWidget(
                              entity: todo,
                              onDone: (todoEntity) {
                                todoProvider.onDone(todo);
                              },
                              onDelete: () {
                                todoProvider.delete(todo);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTodoScreen(
                                    onSave: (TodoEntity editedTodo) async {
                                      todoProvider.edit(editedTodo);
                                    },
                                    entity: todo,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        )),
      ),
    );
  }
}

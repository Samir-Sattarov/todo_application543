import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:todo_application/core/utils/app_colors.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/widgets/todo_card_widget.dart';

import '../core/entities/todo_entitty.dart';
import '../locator.dart';
import 'edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  final List<TodoEntity> listTodo = [];

  @override
  void initState() {
    initialize();
    _generateSampleTodos();
    super.initState();
  }

  initialize() async {
    await locator<StorageService>().put("testbox", key: "test", value: "TEST1");

    await Future.delayed(
      Duration(seconds: 5),
      () async {
        final data = await locator<StorageService>().get("testbox", "test");
        print(data);
      },
    );
  }

  void _generateSampleTodos() {
    final random = Random();
    for (int i = 1; i <= 10; i++) {
      listTodo.add(
        TodoEntity(
          title: 'Todo Task $i',
          description: 'Description for Todo Task $i',
          createdAt:
              DateTime.now().subtract(Duration(days: random.nextInt(10))),
          isDone: random.nextBool(),
          id: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onSave: (TodoEntity entity) {
                      listTodo.insert(0, entity);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: listTodo.length,
          padding: EdgeInsets.all(10.r),
          separatorBuilder: (context, index) => SizedBox(height: 15.h),
          itemBuilder: (context, index) {
            final todo = listTodo[index];
            return GestureDetector(
              child: TodoCardWidget(entity: todo),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTodoScreen(
                      onSave: (TodoEntity editedTodo) {
                        listTodo.insert(0, editedTodo);

                        setState(() {});
                      },
                      entity: todo,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

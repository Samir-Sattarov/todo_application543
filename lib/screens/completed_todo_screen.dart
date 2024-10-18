import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:todo_application/core/entities/todo_results_entity.dart';
import 'package:todo_application/core/utils/app_colors.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/widgets/todo_card_widget.dart';

import '../core/entities/todo_entity.dart';
import '../locator.dart';
import 'edit_todo_screen.dart';

class CompletedTodoScreen extends StatefulWidget {
  const CompletedTodoScreen({super.key});

  @override
  State<CompletedTodoScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CompletedTodoScreen> {
  late List<TodoEntity> listTodo = [];
  late StorageService storageService;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    storageService = locator();

    await load();
  }

  load() async {
    final response =
        await storageService.getDataFromBox(StorageKeys.kCompletedTodoList);

    final results = TodoResultsEntity.fromJson(List.from(response));

    listTodo = results.listTodo;
    setState(() {});
  }

  onDelete(TodoEntity entity) async {
    await storageService.delete(
      StorageKeys.kCompletedTodoList,
      entity.id.toString(),
    );
    listTodo.remove(entity);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentTwo,
        title: Text("Completed TODO"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await load();
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
            return Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  onDelete(todo);
                }),
                children: [
                  SlidableAction(
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    onPressed: (BuildContext context) {
                      onDelete(todo);
                    },
                  ),
                ],
              ),
              child: TodoCardWidget(
                entity: todo,
                onDelete: () async {
                  onDelete(todo);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/core/entities/todo_results_entity.dart';
import 'package:todo_application/core/providers/todo_provider.dart';
import 'package:todo_application/core/utils/app_colors.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/widgets/todo_card_widget.dart';

import '../core/entities/todo_entity.dart';
import '../core/utils/assets.dart';
import '../locator.dart';

class CompletedTodoScreen extends StatefulWidget {
  const CompletedTodoScreen({super.key});

  @override
  State<CompletedTodoScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CompletedTodoScreen> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    context.read<TodoProvider>().boxKey = StorageKeys.kCompletedTodoList;
    load();
  }

  load() {
    context.read<TodoProvider>().load();
  }

  onDelete(TodoEntity todo) {
    context.read<TodoProvider>().delete(todo);
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.read<TodoProvider>();
    final listTodo = context.watch<TodoProvider>().listTodo;
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
                        fontWeight: FontWeight.w800,
                      ),
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
                      onDone: (todoEntity) {
                        todoProvider.onDone(
                          todo,
                          from: StorageKeys.kCompletedTodoList,
                          to: StorageKeys.kTodoList,
                        );
                      },
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

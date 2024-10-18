
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_application/core/entities/todo_results_entity.dart';
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

  onDone(TodoEntity entity) async {
    await storageService.add(
      StorageKeys.kTodoList,
      value: entity.toJson(),
    );
    listTodo.removeWhere((element) => element.id == entity.id);
    await storageService.delete(
      StorageKeys.kCompletedTodoList,
      entity.id.toString(),
    );
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
                      onDone: (todoEntity) => onDone(todoEntity),
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

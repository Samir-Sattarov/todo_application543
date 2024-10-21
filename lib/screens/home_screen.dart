import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_application/core/entities/todo_results_entity.dart';
import 'package:todo_application/core/utils/app_colors.dart';
import 'package:todo_application/core/utils/assets.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/core/utils/use_debounce.dart';
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
  late List<TodoEntity> listTodo = [];
  late StorageService storageService;
  late UseDebounce useDebounce;
  final TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    useDebounce.dispose();
    super.dispose();
  }

  initialize() async {
    useDebounce = UseDebounce(milliseconds: 500);
    storageService = locator();

    await load();
  }

  load() async {
    final response =
        await storageService.getDataFromBox(StorageKeys.kTodoList, count: 10);

    final results = TodoResultsEntity.fromJson(List.from(response));

    listTodo = results.listTodo;
    setState(() {});
  }

  search(String text) async {
    if (text.isEmpty) {
      load();
      return;
    }

    useDebounce.run(
      () async {
        final response =
            await storageService.getDataFromBox(StorageKeys.kTodoList);

        final results = TodoResultsEntity.fromJson(List.from(response));

        final formattedData = results.listTodo
            .where((element) => element.title.contains(text))
            .toList();
        listTodo = formattedData;
        setState(() {});
      },
    );
  }

  onDelete(TodoEntity entity) async {
    await storageService.delete(
      StorageKeys.kTodoList,
      entity.id.toString(),
    );
    listTodo.remove(entity);
    setState(() {});
  }

  onDone(TodoEntity entity) async {
    await storageService.add(
      StorageKeys.kCompletedTodoList,
      value: entity.toJson(),
    );
    listTodo.removeWhere((element) => element.id == entity.id);
    await storageService.delete(
      StorageKeys.kTodoList,
      entity.id.toString(),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark =  true;
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
                        listTodo.insert(0, entity);
      
                        await storageService.add(
                          StorageKeys.kTodoList,
                          value: entity.toJson(),
                        );
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await load();
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
                onChanged: (text) => search(text),
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
                          child: GestureDetector(
                            child: TodoCardWidget(
                              entity: todo,
                              onDone: (todoEntity) => onDone(todoEntity),
                              onDelete: () => onDelete(todo),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTodoScreen(
                                    onSave: (TodoEntity editedTodo) async {
                                      await storageService.edit(
                                        StorageKeys.kTodoList,
                                        value: editedTodo.toJson(),
                                      );
                                      await load();
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/core/entities/todo_results_entity.dart';
import 'package:todo_application/core/providers/todo_provider.dart';
import 'package:todo_application/core/utils/app_colors.dart';
import 'package:todo_application/core/utils/storage_keys.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/cubits/todo/delete_todo/delete_todo_cubit.dart';
import 'package:todo_application/cubits/todo/load_todo/load_todo_cubit.dart';
import 'package:todo_application/widgets/todo_card_widget.dart';

import '../core/entities/todo_entity.dart';
import '../core/utils/assets.dart';
import '../cubits/todo/edit_todo/edit_todo_cubit.dart';
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
    load();
  }

  load() {
    context.read<LoadTodoCubit>().load(isDone: true);
  }

  onDelete(TodoEntity todo) {
    context.read<DeleteTodoCubit>().delete(todo);
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
        child: BlocBuilder<LoadTodoCubit, LoadTodoState>(
          builder: (context, state) {
            if (state is LoadTodoLoading) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,

                ),
              );
            }
            if (state is LoadTodoLoaded) {
              final listTodo = state.listTodo;
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
                          child: TodoCardWidget(
                            entity: todo,
                            onDone: (todoEntity) {
                              BlocProvider.of<EditTodoCubit>(context)
                                  .edit(todoEntity);
                              listTodo.remove(todo);
                              setState(() {

                              });
                            },
                            onDelete: () async {
                              onDelete(todo);
                            },
                          ),
                        );
                      },
                    );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}

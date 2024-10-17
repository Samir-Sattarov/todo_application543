import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_application/core/utils/storage_service.dart';
import 'package:todo_application/widgets/button_widget.dart';
import 'package:todo_application/widgets/text_form_field_widget.dart';

import '../core/entities/todo_entity.dart';
import '../core/utils/app_colors.dart';
import '../locator.dart';

class EditTodoScreen extends StatefulWidget {
  final TodoEntity? entity;
  final Function(TodoEntity entity) onSave;
  const EditTodoScreen({super.key, required this.onSave, this.entity});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();



  TodoEntity entity = TodoEntity.empty();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    if (widget.entity == null) return;

    controllerTitle.text = widget.entity!.title;
    controllerDescription.text = widget.entity!.description;

    entity = widget.entity!;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.accent,
          title: Text("Create Todo"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                TextFormFieldWidget(
                  controller: controllerTitle,
                  hintText: "Title",
                ),
                SizedBox(height: 10.h),
                TextFormFieldWidget(
                  controller: controllerDescription,
                  hintText: "Description",
                ),
                SizedBox(height: 50.h),
                ButtonWidget(
                  onTap: () {
                    final todo = entity.copyWith(
                      title: controllerTitle.text,
                      description: controllerDescription.text,
                    );

                    widget.onSave.call(todo);
                    Navigator.pop(context);
                  },
                  title: "Save",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

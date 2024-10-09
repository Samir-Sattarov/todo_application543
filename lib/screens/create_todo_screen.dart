import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_application/widgets/button_widget.dart';
import 'package:todo_application/widgets/text_form_field_widget.dart';

import '../core/entities/todo_entitty.dart';
import '../core/utils/app_colors.dart';

class CreateTodoScreen extends StatefulWidget {
  final Function(TodoEntity entity) onSave;
  const CreateTodoScreen({super.key, required this.onSave});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  TodoEntity entity = TodoEntity.empty();

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

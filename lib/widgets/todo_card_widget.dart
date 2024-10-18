import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/core/utils/app_colors.dart';

import '../core/entities/todo_entity.dart';

class TodoCardWidget extends StatefulWidget {
  final TodoEntity entity;

  final Function() onDelete;

  final Function(TodoEntity entity)? onDone;
  const TodoCardWidget(
      {super.key, required this.entity, required this.onDelete, this.onDone});

  @override
  State<TodoCardWidget> createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  bool isDone = false;

  @override
  void initState() {
    isDone = widget.entity.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.todoCardColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              ),
              FittedBox(
                child: Text(
                  widget.entity.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Spacer(),
              Checkbox(
                value: isDone,
                onChanged: (value) {
                  isDone = true;
                  final todoEntity = widget.entity.copyWith(isDone: true);
                  widget.onDone?.call(todoEntity);
                  setState(() {});
                },
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            widget.entity.description,
            style: TextStyle(
              color: Colors.white60,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 3.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat('dd/MM/yyyy').format(widget.entity.createdAt),
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

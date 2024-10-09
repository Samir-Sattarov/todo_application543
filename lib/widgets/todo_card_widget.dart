import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/core/utils/app_colors.dart';

import '../core/entities/todo_entitty.dart';

class TodoCardWidget extends StatelessWidget {
  final TodoEntity entity;
  const TodoCardWidget({super.key, required this.entity});

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
              FittedBox(
                child: Text(
                  entity.title,
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
                value: entity.isDone,
                onChanged: null,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            entity.description,
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
              DateFormat('dd/MM/yyyy').format(entity.createdAt),
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

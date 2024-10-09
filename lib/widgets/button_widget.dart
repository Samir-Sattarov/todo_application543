import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_application/core/utils/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onTap;
  final String title;

  const ButtonWidget({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.r);

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Ink(
        width: 1.sw,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

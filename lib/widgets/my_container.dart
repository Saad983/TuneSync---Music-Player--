import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/utils/app_colors.dart' show AppColors;

class MyContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isPressed;

  const MyContainer({
    super.key,
    required this.child,
    this.isPressed = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow:
            isPressed
                ? [
                  BoxShadow(
                    color: AppColors.blurColor,
                    offset: Offset(2.w, 2.h),
                    blurRadius: 5.r,
                    spreadRadius: 1.r,
                  ),
                  BoxShadow(
                    color: AppColors.blurColor,
                    offset: Offset(-2.w, -2.h),
                    blurRadius: 5.r,
                    spreadRadius: 1.r,
                  ),
                ]
                : [
                  BoxShadow(
                    color: AppColors.blurColor,
                    offset: Offset(8.w, 8.h),
                    blurRadius: 5.r,
                    spreadRadius: 1.r,
                  ),
                  BoxShadow(
                    color: AppColors.blurColor,
                    offset: Offset(-8.w, -8.h),
                    blurRadius: 5.r,
                    spreadRadius: 1.r,
                  ),
                ],
      ),
      child: child,
    );
  }
}

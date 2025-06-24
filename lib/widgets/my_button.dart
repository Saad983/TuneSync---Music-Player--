import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/utils/app_colors.dart' show AppColors;

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPress;
  final EdgeInsetsGeometry? padding;
  final bool isPressed;
  final Color btnBackGround;
  final Color blurFirstColor;
  final Color blurSecondColor;

  const MyButton({
    super.key,
    required this.child,
    required this.onPress,
    this.padding,
    this.isPressed = false,
    this.blurFirstColor = const Color(0xffA3B1C6),
    this.blurSecondColor = AppColors.white,
    this.btnBackGround = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: padding ?? EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: btnBackGround,
          boxShadow:
              isPressed
                  ? [
                    BoxShadow(
                      color: blurFirstColor,
                      offset: Offset(-2.w, -2.h),
                      blurRadius: 5.r,
                      spreadRadius: 1.r,
                    ),
                    BoxShadow(
                      color: blurFirstColor,
                      offset: Offset(6.w, 6.h),
                      blurRadius: 5.r,
                      spreadRadius: 1.r,
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: blurFirstColor,
                      offset: Offset(-6.w, -6.h),
                      blurRadius: 5.r,
                      spreadRadius: 1.r,
                    ),
                    BoxShadow(
                      color: blurFirstColor,
                      offset: Offset(-2.w, -2.h),
                      blurRadius: 5.r,
                      spreadRadius: 1.r,
                    ),
                  ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

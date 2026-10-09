import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';

Widget topButton({
  required String title,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(14.r),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.sp),
          WidthSpace(8),
          Text(title, style: AppStyles.black45Bold.copyWith(fontSize: 13.sp)),
        ],
      ),
    ),
  );
}

Widget bottomButton({
  
  required String title,
  required VoidCallback onPressed,
  required Color backgroundColor,
  required Color textColor,
  IconData? icon,
}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(12.r),
    child: Container(
      width: 140.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 18.sp),
              SizedBox(width: 6.w),
            ],
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:etudiant/core/assets/images.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Planningerrors extends StatelessWidget {
  final String title1;
  final String title2;
  const Planningerrors({super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeightSpace(45),
          Text(
            title1,
            textAlign: TextAlign.center,
            style: AppStyles.blue14w700.copyWith(
              fontSize: 19.sp,
              color: const Color(0xFF454545),
            ),
          ),
          HeightSpace(10),
          Text(
            title2,
            textAlign: TextAlign.center,
            style: AppStyles.grey14w600.copyWith(fontSize: 19.sp),
          ),
          HeightSpace(20),
          Image.asset(
            Images.rafiki,
            width: 391.w,
            height: 291.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

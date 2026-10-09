import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_effect/shimmer_effect.dart';
import 'package:etudiant/core/styling/app_colors.dart';

class ShimmerHeaderCard extends StatelessWidget {
  const ShimmerHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: AppColors.greyColor,
      highlightColor: AppColors.lightGreyColor,
      child: Row(
        children: [
          Container(
            width: 70.sp,
            height: 70.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35.r),
            ),
          ),
          SizedBox(width: 10.w),

          // Name and Group shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 80.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),

          // Notification icon placeholder
          Container(
            width: 30.sp,
            height: 30.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerProfileCard extends StatelessWidget {
  const ShimmerProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: AppColors.greyColor,
      highlightColor: AppColors.lightGreyColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Avatar shimmer
            SizedBox(height: 20.h),
            Center(
              child: Container(
                width: 120.sp,
                height: 120.sp,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Name shimmer
            Container(
              width: 150.w,
              height: 21.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 40.h),

            // Info card shimmer (Ecole)
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 5.h),

            // Info card shimmer (Date de naissance)
            Container(
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 5.h),

            // Info card shimmer (Place de naissance)
            Container(
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 10.h),

            // Level section shimmer
            Container(
              width: 390.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

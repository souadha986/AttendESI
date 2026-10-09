import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String sender;

  final String time;
  final void Function()? onTap;

  // Constructeur pour passer les données
  const NotificationCard({
    super.key,
    required this.title,
    required this.sender,

    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 26.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFE4EEFA),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.campaign_outlined,
                color: AppColors.blueColorA,
                size: 20.sp,
              ),
              WidthSpace(8),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.blue14w700.copyWith(
                    fontSize: 18.sp,
                    color: const Color(0xFF454545),
                  ),
                ),
              ),
            ],
          ),
          HeightSpace(8),
          Text(
            "From: $sender",
            style: AppStyles.grey14w600.copyWith(
              fontSize: 17.sp,
              color: const Color(0xFF454545),
            ),
          ),

          HeightSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: AppStyles.blue14w700.copyWith(fontSize: 17.sp)),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Voir la notification",
                  style: AppStyles.blue14w700.copyWith(
                    color: Color(0xFF3E5E93),
                    fontSize: 15.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';

class NotificationDetails extends StatefulWidget {
  final String title;
  final String sender;
  final String date;
  final String message;

  const NotificationDetails({
    super.key,
    required this.title,
    required this.sender,

    required this.date,
    required this.message,
  });

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails", style: AppStyles.blueA20w700),
        centerTitle: true,
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
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
                        size: 24.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: AppStyles.blue14w700.copyWith(
                            fontSize: 18.sp,
                            color: const Color(0xFF454545),
                          ),
                        ),
                      ),
                    ],
                  ),
                  HeightSpace(15),
                  Text(
                    "From: ${widget.sender}",
                    style: AppStyles.grey14w600.copyWith(
                      fontSize: 17.sp,
                      color: const Color(0xFF454545),
                    ),
                  ),

                  HeightSpace(8),
                  Text(
                    "Date: ${widget.date}",
                    style: AppStyles.grey14w600.copyWith(
                      fontSize: 17.sp,
                      color: const Color(0xFF454545),
                    ),
                  ),
                  HeightSpace(20),
                  Divider(
                    color: const Color(0xFF1A3B70).withOpacity(0.3),
                    thickness: 1,
                  ),
                  HeightSpace(20),
                  Center(
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: AppStyles.grey14w600.copyWith(
                        fontSize: 15.sp,
                        color: const Color(0xFF454545),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

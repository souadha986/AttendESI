import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/notification_model.dart';

class NotificationDetailView extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onBack;
  final VoidCallback onRepondre;

  const NotificationDetailView({
    super.key,
    required this.notification,
    required this.onBack,
    required this.onRepondre,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0969BB).withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.senderName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff454545),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 30.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  /// Buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 55.h,
                        width: 120.w,
                        child: TextButton(
                          onPressed: onBack,
                          style: TextButton.styleFrom(),
                          child: Text(
                            "Retour",
                            style: TextStyle(
                              color: Color(0xFF1065FB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: onRepondre,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1065FB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                          ),
                          child: Text(
                            'Répondre',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/features/home/cubit/alerts_cubit.dart';
import 'package:etudiant/features/home/models/alerte_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertPopup extends StatelessWidget {
  final List<AlertModel> alerts;

  const AlertPopup({super.key, required this.alerts});

  static Future<void> show(BuildContext context, List<AlertModel> alerts) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<AlertCubit>(),
        child: AlertPopup(alerts: alerts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  "Alertes d'absence",
                  style: AppStyles.black15w700.copyWith(
                    color: AppColors.blueColorA,
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            Divider(color: AppColors.verygreyColor, thickness: 1),

            SizedBox(height: 10.h),

            // ── Alert list ───────────────────────────────────────
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 320.h),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: alerts.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  final isExceeded = alert.currentAbsences >= alert.maxAllowed;

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isExceeded
                          ? AppColors.redColor.withOpacity(0.07)
                          : AppColors.bleuColorF.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isExceeded
                            ? AppColors.redColor.withOpacity(0.3)
                            : AppColors.bleuColor2.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Module name
                        Row(
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 14.sp,
                              color: isExceeded
                                  ? AppColors.redColor
                                  : AppColors.bleuColor2,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                alert.matiereName,
                                style: AppStyles.black13w500.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blueColorA,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 6.h),

                        // Message
                        Text(
                          alert.message,
                          style: AppStyles.black12w300.copyWith(
                            color: isExceeded
                                ? AppColors.redColor
                                : AppColors.bleuColor2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: LinearProgressIndicator(
                            value: (alert.currentAbsences / alert.maxAllowed)
                                .clamp(0.0, 1.0),
                            minHeight: 7.h,
                            backgroundColor: AppColors.verygreyColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isExceeded
                                  ? AppColors.redColor
                                  : AppColors.bleuColor2,
                            ),
                          ),
                        ),

                        SizedBox(height: 5.h),

                        // Count label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${alert.currentAbsences} / ${alert.maxAllowed} absences',
                              style: AppStyles.grey14w600.copyWith(
                                fontSize: 11.sp,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: isExceeded
                                    ? AppColors.redColor
                                    : AppColors.bleuColor2,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                isExceeded ? 'Dépassé' : 'Attention',
                                style: AppStyles.white15w700.copyWith(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),

            // ── Button ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueColorA,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                ),
                onPressed: () async {
                  for (final alert in alerts) {
                    await context.read<AlertCubit>().markAsRead(alert.alertId);
                  }
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Text("J'ai compris", style: AppStyles.white15w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

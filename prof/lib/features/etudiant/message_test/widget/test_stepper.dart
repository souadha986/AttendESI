import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';

class TestStepper extends StatelessWidget {
  final int currentStep;

  const TestStepper({super.key, required this.currentStep});

  static const steps = [
    ('1', 'Niveau et\nspécialité'),
    ('2', 'Groupe'),
    ('3', 'Module et\nSalle'),
    ('4', 'Date et\nL’heure'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Expanded(
              child: Container(height: 2, color: AppColors.blueColorA),
            );
          }

          int stepIndex = index ~/ 2;
          int stepNumber = stepIndex + 1;

          bool isActive = stepNumber == currentStep;
          bool isDone = stepNumber < currentStep;

          return Column(
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: AppColors.blueColorA,
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.blueColorA.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isDone
                      ? Icon(Icons.check, color: Colors.white, size: 25.sp)
                      : Text(steps[stepIndex].$1, style: AppStyles.white24w600),
                ),
              ),

              HeightSpace(6),

              SizedBox(
                width: 70,
                child: Text(
                  steps[stepIndex].$2,
                  textAlign: TextAlign.center,
                  style: AppStyles.black15w600.copyWith(
                    fontSize: 13.sp,
                    color: AppColors.blueColorA,
                  ),
                ),
              ),

              if (isActive)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 30,
                  color: AppColors.blueColorA,
                ),
            ],
          );
        }),
      ),
    );
  }
}
